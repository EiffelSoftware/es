note
	description: "Summary description for {AUT_LINEAR_CONSTRAINT_SOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_LINEAR_CONSTRAINT_SOLVER

inherit
	SHARED_WORKBENCH

	AUT_PREDICATE_UTILITY

	AUT_SHARED_RANDOM

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_linear_solvable_predicates: like linear_solvable_predicates; a_context_queries: like context_queries) is
			-- Initialize.
		require
			a_feature_attached: a_feature /= Void
			a_linear_solvable_predicates_attached: a_linear_solvable_predicates /= Void
			not_a_linear_solvable_predicates_is_empty: not a_linear_solvable_predicates.is_empty
			a_context_queries_attached: a_context_queries /= Void
		do
			feature_ := a_feature
			linear_solvable_predicates := a_linear_solvable_predicates
			context_queries := a_context_queries
		ensure
			feature__set: feature_ = a_feature
			linear_solvable_predicates_set: linear_solvable_predicates = a_linear_solvable_predicates
			constraining_queries_set: context_queries = a_context_queries
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature for which the linear constraint is solved

	linear_solvable_predicates: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			-- Linear solvable predicates associated with their access patterns

	context_queries: HASH_TABLE [STRING, STRING]
			-- Table of contraining queries and their values
			-- [Query value, query name]

	last_solution: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Table of last linearly sovled operands
			-- [operand value, operand index]
			-- Operand index is 0-based, but in here the operand is already larger than 0,
			-- because linear constraint solving for target operand is not supported.
			-- Only has effect if `has_last_solution' is True

feature -- Status report

	has_last_solution: BOOLEAN
			-- Does last call to `solve' generated a solution?

feature -- Basic operations

	solve is
			-- Try to solve constraints defined in `linear_solvable_predicates' and `context_queries'.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_smt_generator: AUT_CONSTRAINT_SOLVER_GENERATOR
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
			l_smt_generator.generate_smtlib (feature_, linear_solvable_predicates)
			linear_solvable_argument_names := l_smt_generator.constrained_arguments
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

--			if has_last_solution then
--				insert_integers_in_pool
--			end
		end

feature{NONE} -- Implementation

	linear_solvable_argument_names: DS_HASH_SET [STRING]
			-- Names of linearly solvable arguments

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
			l_model_loader: AUT_SOLVED_LINEAR_MODEL_LOADER
			l_stream: KL_STRING_INPUT_STREAM
			l_valuation: HASH_TABLE [INTEGER, STRING]
			l_arg_name: STRING
		do
			create l_prc_factory
			create last_solver_output.make (1024)
			l_prc := l_prc_factory.process_launcher_with_command_line (linear_constraint_solver_command (smtlib_file_path), Void)
			l_prc.redirect_output_to_agent (agent append_solver_output)
			l_prc.redirect_error_to_same_as_output
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
				last_solver_output.replace_substring_all ("%R", "")
				create l_stream.make (last_solver_output)
				l_model_loader := sovled_linear_model_loader
				l_model_loader.set_constrained_arguments (linear_solvable_argument_names)
				l_model_loader.set_input_stream (l_stream)
				l_model_loader.load_model
				has_last_solution := l_model_loader.has_model

					-- We found a model for the constrained arguments.
					-- Store that model in `last_solved_operands'.
				if has_last_solution then
					l_valuation := l_model_loader.valuation
--					if l_valuation.count = 1 then
--						l_valuation.start
--						random.forth
--						l_valuation.replace (random.item.abs + 1, l_valuation.key_for_iteration)
--					end

					create last_solution.make (l_valuation.count)
					from
						l_valuation.start
					until
						l_valuation.after
					loop
						l_arg_name := l_valuation.key_for_iteration.twin
						l_arg_name.replace_substring_all (normalized_argument_name_prefix, "")

						last_solution.force_last (l_valuation.item_for_iteration, l_arg_name.to_integer)
						l_valuation.forth
					end
				end
			else
				has_last_solution := False
			end
		end

	last_solver_output: STRING
			-- Output from last launched solver

	append_solver_output (a_string: STRING) is
			-- Append `a_string' at the end of `last_solver_output'.
		do
			last_solver_output.append (a_string)
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

