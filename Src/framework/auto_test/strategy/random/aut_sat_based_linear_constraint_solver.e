note
	description: "Linear constraint solver based on SAT solver"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SAT_BASED_LINEAR_CONSTRAINT_SOLVER

inherit
	AUT_LINEAR_CONSTRAINT_SOLVER

	AUT_SHARED_PREDICATE_CONTEXT

create
	make

feature -- Status report

	should_avoid_used_values: BOOLEAN
			-- Should used values be avoided when trying to solve
			-- linear constraints for the same feature?

feature -- Access

	use_predefined_value_rate: DOUBLE
			-- Possibility to use predefined values

	enforce_used_value_rate: DOUBLE
			-- Possibility to enforce generation of used values

feature -- Setting

	set_use_predefined_value_rate (a_rate: INTEGER) is
			-- Set `use_predefined_value_rate'.
		do
			use_predefined_value_rate := a_rate.to_double / 100
		end

	set_enforce_used_value_rate (a_rate: INTEGER) is
			-- Set `enforce_used_value_rate' with `a_rate'.
		do
			enforce_used_value_rate := a_rate.to_double / 100
		end

feature -- Basic operations

	solve is
			-- Try to solve constraints defined in `linear_solvable_predicates' and `context_queries'.
		local
			l_value_set: detachable AUT_INTEGER_VALUE_SET
		do
			has_last_solution := False

				-- Try to solve constraints within used values.			
			l_value_set := used_integer_values.item (feature_)

			if is_within_probability (enforce_used_value_rate) and then l_value_set /= Void then
				internal_solve (l_value_set, True)
			else
				if l_value_set /= Void then
					internal_solve (l_value_set, False)
				else
					internal_solve (empty_used_value_set, False)
				end
			end
		end

feature{NONE} -- Implementation

	smtlib_file_path: FILE_NAME is
			-- Full path for the generated SMT-LIB file
		do
			create Result.make_from_string (universe.project_location.workbench_path)
			Result.set_file_name ("linear.smt")
		end

	generate_smtlib_file (a_content: STRING) is
			-- Generate SMT-LIB file with `a_content'
			-- at location `smtlib_file_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (smtlib_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	solve_arguments is
			-- Solve linear constraints for constrained argument.
			-- Store result in `last_solver_output'.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
			l_model_loader: AUT_SAT_BASED_LINEAR_MODEL_LOADER
			l_valuation: HASH_TABLE [INTEGER, STRING]
			l_arg_name: STRING
		do
				-- Launch external constraint solver process.
			create l_prc_factory
			create last_solver_output.make (1024)
			l_prc := l_prc_factory.process_launcher_with_command_line (linear_constraint_solver_command (smtlib_file_path), Void)
			l_prc.redirect_output_to_agent (agent append_solver_output)
			l_prc.redirect_error_to_same_as_output
			l_prc.launch

			if l_prc.launched then
				l_prc.wait_for_exit
				last_solver_output.replace_substring_all ("%R", "")
				l_model_loader := sovled_linear_model_loader (linear_solvable_operands, create {KL_STRING_INPUT_STREAM}.make (last_solver_output))
				l_model_loader.load_model
				has_last_solution := l_model_loader.has_model

					-- We found a model for the constrained arguments.
					-- Store that model in `last_solved_operands'.
				if has_last_solution then
					set_last_solution (l_model_loader.valuation)
				end
			else
				has_last_solution := False
			end

			fixme ("We assume that the input file for SMT based solve is always of the correct format. Change this by take the output of the SMT solver into account. Jason 2009.8.4.")
			is_input_format_correct := True
		end

	last_solver_output: STRING
			-- Output from last launched solver

	append_solver_output (a_string: STRING) is
			-- Append `a_string' at the end of `last_solver_output'.
		do
			last_solver_output.append (a_string)
		end

	sovled_linear_model_loader (a_operands: DS_HASH_SET [STRING]; a_stream: KL_STRING_INPUT_STREAM): AUT_SAT_BASED_LINEAR_MODEL_LOADER is
			-- Loader of a solved linear model
		require
			a_operands_attached: a_operands /= Void
			a_stream_attached: a_stream /= Void
		do
			if {PLATFORM}.is_windows then
				create {AUT_Z3_LINEAR_MODEL_LOADER} Result.make (a_operands, a_stream)
			else
				create {AUT_CVC3_LINEAR_MODEL_LOADER} Result.make (a_operands, a_stream)
			end
		end

	linear_constraint_solver_command (a_smtlib_file_path: STRING): STRING is
			-- Command to sovle linear constraints, with input file `a_smtlib_file_path'
		do
			if {PLATFORM}.is_windows then
				Result := "z3 /m /smt " + a_smtlib_file_path
			else
				Result := "/bin/sh -c %"cvc3 +model -lang smt " + a_smtlib_file_path + "%""
			end
		end

	internal_solve (a_used_values: AUT_INTEGER_VALUE_SET; a_enforce_used_values: BOOLEAN) is
			-- Solve linear constraints.
			-- `a_used_values' are used values for `feature_'.
			-- If `a_enforce_used_values' is True, the generated solution only contains values from `a_used_values',
			-- otherwise, the generated solution doesn't contain values from `a_used_values'.			
		require
			a_used_values_attached: a_used_values /= Void
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_smt_generator: AUT_SMTLIB_CONSTRAINT_SOLVER_GENERATOR
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
			l_pattern_table: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]
		do
			has_last_solution := True
			l_state := context_queries

				-- Generate linear constraint solving proof obligation.
			create l_smt_generator
			l_smt_generator.set_used_values (a_used_values)
			l_smt_generator.set_is_used_value_enforced (a_enforce_used_values)
			l_smt_generator.set_use_predefined_values_rate (use_predefined_value_rate)

			l_smt_generator.generate_smtlib (feature_, linear_solvable_predicates)
			check l_smt_generator.has_linear_constraints end
			l_proof_obligation := l_smt_generator.last_smtlib.twin

				-- Replace constraining queires by their actual value.
			from
				l_constraining_queries := l_smt_generator.constraining_queries
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
					l_new_query_name := "$" + l_constraining_queries.item_for_iteration + "$"
					l_proof_obligation.replace_substring_all (l_new_query_name, l_query_name)
				end
				l_constraining_queries.forth
			end

				-- Launch constraint solver to solve constrained arguments.
			if has_last_solution then
				generate_smtlib_file (l_proof_obligation)
				solve_arguments
			end
		end

	empty_used_value_set: AUT_INTEGER_VALUE_SET
			-- Emtpy used value set
		once
			create {AUT_UNARY_INTEGER_VALUE_SET} Result.make
		ensure
			good_result: Result /= Void
		end

invariant
	feature__attached: feature_ /= Void
	linear_solvable_predicates_attached: linear_solvable_predicates /= Void
	not_linear_solvable_predicates_is_empty: not linear_solvable_predicates.is_empty
	constraining_queries_attached: context_queries /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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

