note
	description: "Linear constraint solver based on lp_solve"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_LP_BASED_LINEAR_CONSTRAINT_SOLVER

inherit
	AUT_LINEAR_CONSTRAINT_SOLVER
	AUT_SHARED_RANDOM

create
	make

feature -- Basic operations

	solve is
			-- Try to solve constraints defined in `linear_solvable_predicates' and `context_queries'.
			-- If there is a solution, set `has_last_solution' to True and put that solution into
			-- `last_solution'. Otherwise, set `has_last_solution' to False.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_lpsolve_generator: AUT_LPSOLVE_CONSTRAINT_SOLVER_GENERATOR
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
			l_pattern_table: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]
			l_iter_operand: STRING

			l_valuation: HASH_TABLE[INTEGER, STRING]
			l_abstract_integer: AUT_ABSTRACT_INTEGER
			l_concrete_integer: INTEGER
			l_lower_bound: REAL_64
			l_upper_bound: REAL_64
		do
			has_last_solution := True
			is_input_format_correct := True
			l_state := context_queries

				-- Generate linear constraint solving proof obligation.
			create l_lpsolve_generator
			l_lpsolve_generator.generate_lpsolve (feature_, linear_solvable_predicates, configuration)
			is_input_format_correct := not l_lpsolve_generator.has_unsupported_expression
			if is_input_format_correct then
				check l_lpsolve_generator.has_linear_constraints end
				l_proof_obligation := l_lpsolve_generator.last_lpsolve.twin

					-- Replace constraining queries by their actual value.
				from
					l_constraining_queries := l_lpsolve_generator.constraining_queries
					l_constraining_queries.start
				until
					l_constraining_queries.after or else not has_last_solution
				loop
					l_query_name := l_state.item (l_constraining_queries.item_for_iteration)
					if l_query_name = Void then
							-- If the value of some constraining query cannot be retrieved,
							-- the model for constrained arguments doesn't exist.
						has_last_solution := False
					else
						l_new_query_name := l_constraining_queries.item_for_iteration
						l_proof_obligation.replace_substring_all (l_new_query_name, l_query_name)
					end
					l_constraining_queries.forth
				end

					-- Launch constraint solver to solve constrained arguments
					-- and put them into `last_solution' solver solution.
				if has_last_solution then
					create l_valuation.make (l_lpsolve_generator.constrained_operands.count)

					from
						l_lpsolve_generator.constrained_operands.start
					until
						l_lpsolve_generator.constrained_operands.after or else not has_last_solution
					loop
						l_iter_operand := l_lpsolve_generator.constrained_operands.item_for_iteration

							-- compute lower bound of variable
						solve_argument ("min: " + l_iter_operand + ";%N%N" + l_proof_obligation)
						if has_last_solver_solution then
							l_lower_bound := last_solver_solution
						else
							has_last_solution := False
						end

							-- compute upper bound of variable
						solve_argument ("max: " + l_iter_operand + ";%N%N" + l_proof_obligation)
						if has_last_solver_solution then
							l_upper_bound := last_solver_solution
						else
							has_last_solution := False
						end

							-- insert random integer between lower and upper into valuation list
							-- and set the variable to its concrete value in the proof obligation
						if has_last_solution then
							create l_abstract_integer.make (l_lower_bound.truncated_to_integer, l_upper_bound.truncated_to_integer)
							l_concrete_integer := l_abstract_integer.random_element
							l_valuation.put (l_concrete_integer, l_iter_operand)
							l_proof_obligation.replace_substring_all (
									"/*placeholder_" + l_iter_operand + "*/",
									l_iter_operand + "=" + l_concrete_integer.out + ";")

							fixme ("remove this output?")
							io.put_string ("lpsolve: " + l_iter_operand + "=[" + l_abstract_integer.lower_bound.out + "," + l_abstract_integer.upper_bound.out + "]:" + l_concrete_integer.out + "%N")
						end

						l_lpsolve_generator.constrained_operands.forth
					end

					set_last_solution (l_valuation)
				end
			else
				has_last_solution := False
			end
		end

feature{NONE} -- Implementation

	lpsolve_file_path: FILE_NAME is
			-- Full path for the generated lpsolve file
		do
			create Result.make_from_string (universe.project_location.workbench_path)
			Result.set_file_name ("lpsolve.lp")
		end

	generate_lpsolve_file (a_content: STRING) is
			-- Generate lpsolve file with `a_content'
			-- at location `lpsolve_file_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (lpsolve_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	solve_argument (a_proof_obligation: STRING) is
			-- Solve linear constraints for constrained argument.
		local
			c_filename: C_STRING
			c_out_solution: MANAGED_POINTER
			l_return_value: INTEGER
		do
			create c_filename.make (lpsolve_file_path)
			create c_out_solution.make (8)

			generate_lpsolve_file (a_proof_obligation)

			l_return_value := get_lpsolve_solution (c_filename.item, c_out_solution.item)
			if l_return_value = -1 then
				is_input_format_correct := False
			elseif l_return_value = 0 then
				last_solver_solution := c_out_solution.read_real_64 (0)
				has_last_solver_solution := True
			else
				has_last_solver_solution := False
			end
		end

	get_lpsolve_solution (a_filename, a_out_solution: POINTER): INTEGER is
			-- Call to external lp_solve API.
			-- Reads `a_filename' into model, solves it and writes solution to `a_out_solution'
			-- Return value:
			--  -1 if there is something wrong with the format of the input file or something wrong when reading the input file.
			--  0  if there is a solved solution.
			--  1  if there is no solution.
		external
			"C inline use %"lp_lib.h%""
		alias
			"[
			  {
				lprec *lp;
				
				/* read LP model */
				lp = read_LP ((char *)$a_filename, NEUTRAL, NULL);
				if (lp == NULL) {
					return (-1);
				}

				/* solve the model */
				if (solve(lp) != OPTIMAL) {
					delete_lp (lp);
					return (1);
				}

				/* write result in `a_out_solution' */
				*((REAL *)$a_out_solution) = get_objective (lp);

				delete_lp (lp);
				return (0);
			  }
			]"
		end

	last_solver_solution: REAL_64
			-- Solution from last launched solver

	has_last_solver_solution: BOOLEAN
			-- Did the last launched solver have a solution?

invariant
	feature__attached: feature_ /= Void
	linear_solvable_predicates_attached: linear_solvable_predicates /= Void
	not_linear_solvable_predicates_is_empty: not linear_solvable_predicates.is_empty
	constraining_queries_attached: context_queries /= Void

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
