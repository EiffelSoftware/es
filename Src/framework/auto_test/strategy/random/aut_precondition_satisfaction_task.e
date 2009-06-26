note
	description: "Summary description for {AUT_PREDICATE_SATISFACTION_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_SATISFACTION_TASK

inherit
	AUT_TASK

	ERL_G_TYPE_ROUTINES

	AUT_SHARED_RANDOM

	AUT_PREDICATE_UTILITY
		undefine
			system
		end

	AUT_SHARED_PREDICATE_CONTEXT
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_vars: DS_LIST [ITP_VARIABLE]; a_interpreter: like interpreter) is
			-- Initialize current.
		require
			a_feature_attached: a_feature /= Void
			a_vars_attached: a_vars /= Void
		local
			i: INTEGER
		do
			feature_ := a_feature
			interpreter := a_interpreter
			steps_completed := True

			create initial_variables.make (0, a_vars.count - 1)
			from
				i := 0
				a_vars.start
			until
				a_vars.after
			loop
				initial_variables.put (a_vars.item_for_iteration, i)
				i := i + 1
				a_vars.forth
			end
			create candidate_variables.make (100)
			setup_precondition_predicates
		end

feature -- Access

	system: SYSTEM_I is
			-- Current system
		do
			Result := interpreter.system
		end

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter to execute test cases

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose precondition is to be evaluated

	normal_preconditions: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			-- Normal precondition predicates for `feature_'

	linear_solvable_preconditions: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			-- Linearly solvable precondition predicates for `feature_'

	initial_variables: ARRAY [detachable ITP_VARIABLE]
			-- Initial variables as candidates
			-- Index in `initial_variables' is 0-based.

	last_evaluated_variables: like initial_variables
			-- Variables used to evaluate the precondition of `feature_'
			-- Index in `last_evaluated_variables' is 0-based, the first item is the target of the feature call.

	candidate_variables: DS_ARRAYED_LIST [like initial_variables]
			-- Queue for variable candidcate to execute `feature_'

	partial_candidate: detachable like initial_variables
			-- Partial candidate

	start_time: INTEGER
			-- Start time (in millisecond) when current precondition evaluation starts

	end_time: INTEGER
			-- End time (in millisecond) when current precondition evauation ends.

	constraint: AUT_PREDICATE_CONSTRAINT
			-- Constraint for argument mapping

	tried_count: INTEGER
			-- Number of object combinations that were tried so far
			-- to satisfying the precondition of `feature_'

	worst_case_search_count: INTEGER
			-- Number of object combinations that need to be
			-- tried out in the worst case

feature -- Status report

	has_precondition: BOOLEAN is
			-- Does `feature_' have precondition?
		do
			Result := has_normal_precondition or has_linear_solvable_precondition
		ensure
			good_result: Result = has_normal_precondition or has_linear_solvable_precondition
		end

	has_normal_precondition: BOOLEAN is
			-- Does `feature_' have normal precondition?
		do
			Result := not normal_preconditions.is_empty
		end

	has_linear_solvable_precondition: BOOLEAN is
			-- Does `feature_' have linear solvable precondition?
		do
			Result := not linear_solvable_preconditions.is_empty
		end

	is_last_precondition_evaluation_satisfied: BOOLEAN
			-- Does `last_evaluated_variables' satisfy the precondition of `feature_'?

feature -- Status

	steps_completed: BOOLEAN
			-- Has all steps completed?

	has_next_step: BOOLEAN is
			-- Is there a next step to execute?
		do
			Result := interpreter.is_running and interpreter.is_ready and not steps_completed
		end

feature -- Setting

	set_start_time (a_start_time: INTEGER) is
			-- Set `start_time' with `a_start_time'.
		do
			start_time := a_start_time
		ensure
			start_time_set: start_time = a_start_time
		end

	set_end_time (a_end_time: INTEGER) is
			-- Set `end_time' with `a_end_time'.
		do
			end_time := a_end_time
		ensure
			end_time_set: end_time = a_end_time
		end

feature -- Execution

	start is
			-- <Precursor>
		do
			set_start_time (interpreter.duration_until_now.millisecond_count)

			if interpreter.configuration.is_precondition_checking_enabled and then has_precondition then

					-- Evaluate precondition satisfaction on `initial_variables'.
				evaluate_precondition (initial_variables)

				if is_last_precondition_evaluation_satisfied then
						-- The initial assigned variables satisfy the precondition of `feature_'.					
					steps_completed := True
					set_end_time (interpreter.duration_until_now.millisecond_count)
				else
						-- `initial_variables' DO NOT satisfy the precondition of `feature_',
						-- new search is needed.
					load_candidates
					steps_completed := candidate_variables.is_empty
				end
			else
					-- If no precondition evaluation is enabled, we assume that `initial_variables'
					-- satisfy the precondition.
				is_last_precondition_evaluation_satisfied := True
				steps_completed := True
				last_evaluated_variables := initial_variables
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end
		end

	step is
			-- <Precursor>
		local
			l_candidate_index: INTEGER
			l_satisfied: BOOLEAN
		do
			if untried_candidate_count = 0 then
				steps_completed := True
			else
					-- Get the next candidate from `candidate_variables',
					-- store the candidate in `last_evaluated_variables'.
					-- Those arguments in the candidate should already satisfy all normal preconditions.
				random.forth
				l_candidate_index := random.item \\ untried_candidate_count + 1
				last_evaluated_variables := candidate_variables.item (l_candidate_index)
				candidate_variables.swap (l_candidate_index, untried_candidate_count)
				untried_candidate_count := untried_candidate_count - 1

					-- Check if linearly solvable arguments have solution.
				if has_linear_solvable_precondition then
					choose_constraint_arguments
					l_satisfied := has_constraint_model
				else
					l_satisfied := True
				end

				if l_satisfied then
					is_last_precondition_evaluation_satisfied := constraint.is_constraint_operand_bound (last_evaluated_variables)
					steps_completed := is_last_precondition_evaluation_satisfied
				end
			end

			if not has_next_step then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end

			if is_last_precondition_evaluation_satisfied then
				interpreter.increase_suggested_precondition_count
			end
		end

	cancel
			-- Cancel task.
		do
			steps_completed := True
			set_end_time (interpreter.duration_until_now.millisecond_count)
		end

feature{NONE} -- Implementation

	untried_candidate_count: INTEGER
			-- Number of candidates that have not been tried in `candidate_variables'.

	to_be_retrieved_candidate_count: INTEGER is 100
			-- Max number of candidates that are to be retrieved.
			-- The actual retrieved candidates can be fewer than this.

	load_candidates is
			-- Load candidate variables satisfying preconditions of `feature_'
			-- into `candidate_variables'.
		require
			precondition_to_be_evaluated: interpreter.configuration.is_precondition_checking_enabled
		local
			l_list: DS_LINKED_LIST [like initial_variables]
		do
				-- Every candidate in `candidate_variables' should contain all variables needed to call `feature_',
				-- except for linearly constrained variables.
			predicate_pool.generate_candidates (constraint, to_be_retrieved_candidate_count)
			l_list := predicate_pool.last_candidates
			create candidate_variables.make (l_list.count)
			candidate_variables.append_last (l_list)
			untried_candidate_count := candidate_variables.count
			partial_candidate := predicate_pool.last_partial_candidate
		end

	evaluate_precondition (a_variables: like initial_variables) is
			-- Evalute precondition of `feature_' on `a_variables'.
			-- Set `is_last_precondition_evaluation_satisfied',
			-- and put variable that satisfied the precondition into
			-- `last_evaluated_variables'.
		require
			a_variables_attached: a_variables /= Void
		local
			l_satisfied: BOOLEAN
		do
			last_evaluated_variables := a_variables.twin

				-- Evaluate normal preconditions using predicate pool
			if has_normal_precondition then
				-- Check if `a_variables' satisfy `normal_preconditions'.
				l_satisfied := predicate_pool.is_candidate_satisfied (constraint, last_evaluated_variables)
			end

				-- Check if linearly solvable arguments has solutions.
			if l_satisfied and then has_linear_solvable_precondition then
					-- Check if `a_variables' satisfy `linear_solvable_preconditions'.
				choose_constraint_arguments
				l_satisfied := has_constraint_model
			end

				-- Check if all arguments are assigned.
			if l_satisfied then
				is_last_precondition_evaluation_satisfied := not last_evaluated_variables.has (Void)
			end
		end

	setup_precondition_predicates is
			-- Set `normal_preconditions' and `linear_solvable_preconditions' for `feature_'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
			l_predicate_pattern: AUT_PREDICATE_ACCESS_PATTERN
		do
			create normal_preconditions.make
			create linear_solvable_preconditions.make

			if interpreter.configuration.is_precondition_checking_enabled and then precondition_access_pattern.has (feature_) then
				from
					l_cursor := precondition_access_pattern.item (feature_).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_predicate_pattern := l_cursor.item

					if l_predicate_pattern.predicate.is_linear_solvable then
						linear_solvable_preconditions.force_last (l_predicate_pattern)
					else
						normal_preconditions.force_last (l_predicate_pattern)
					end
					l_cursor.forth
				end

				create constraint.make_with_precondition (feature_, normal_preconditions)
			end
		ensure
			normal_preconditions_attached: normal_preconditions /= Void
			linear_solvable_preconditions_attached: linear_solvable_preconditions /= Void
		end

	choose_constraint_arguments is
			-- Choose values for constraint arguments.
			-- Set those arguments directly in `last_evaluated_variables'.
			-- If there is no model for the constraint arguments,
			-- set `has_constraint_model' to True, other set it to False.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_smt_generator: AUT_CONSTRAINT_SOLVER_GENERATOR
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
			l_pattern_table: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]
		do
				-- Ask for states of the target object.
				-- the value of constraining queries are in the retrieved states.
			if last_evaluated_variables.item (0) /= Void then
				l_state := interpreter.object_state (last_evaluated_variables.item (0))
				has_constraint_model := not l_state.is_empty
			else
				create l_state.make (0)
				has_constraint_model := True
			end

				-- Generate linear constraint solving proof obligation.
			if has_constraint_model then
				create l_smt_generator
				l_smt_generator.generate_smtlib (feature_, linear_solvable_preconditions)
				linear_solvable_argument_names := l_smt_generator.constrained_arguments
				check l_smt_generator.has_linear_constraints end
				l_proof_obligation := l_smt_generator.last_smtlib.twin

					-- Replace constraining queires by their actual value.
				from
					l_constraining_queries := l_smt_generator.constraining_queries
					l_constraining_queries.start
				until
					l_constraining_queries.after or else not has_constraint_model
				loop
					l_query_name := l_state.item (l_constraining_queries.item_for_iteration)
					if l_query_name = Void then
							-- If the value of some constraining query cannot be retrieved,
							-- the model for constrained arguments doesn't exist.
						has_constraint_model := False
					else
						l_new_query_name := "$" + l_constraining_queries.item_for_iteration + "$"
						l_proof_obligation.replace_substring_all (l_new_query_name, l_query_name)
					end
					l_constraining_queries.forth
				end
			end

				-- Launch constraint solver to solve constrained arguments.
			if has_constraint_model then
				generate_smtlib_file (l_proof_obligation)
				solve_arguments
			end

			if has_constraint_model then
				insert_integers_in_pool
			end
		end

	has_constraint_model: BOOLEAN
			-- It there is model for constraint arguments?

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
				has_constraint_model := l_model_loader.has_model

					-- We found a model for the constrained arguments.
					-- Store that model in `last_solved_arguments'.
				if has_constraint_model then
					l_valuation := l_model_loader.valuation
--					if l_valuation.count = 1 then
--						l_valuation.start
--						random.forth
--						l_valuation.replace (random.item.abs + 1, l_valuation.key_for_iteration)
--					end
					create last_solved_arguments.make (l_valuation.count)
					from
						l_valuation.start
					until
						l_valuation.after
					loop
						l_arg_name := l_valuation.key_for_iteration.twin
						l_arg_name.replace_substring_all (normalized_argument_name_prefix, "")

						last_solved_arguments.force (l_valuation.item_for_iteration, l_arg_name.to_integer)
						l_valuation.forth
					end
				end
			else
				has_constraint_model := False
			end
		end

	insert_integers_in_pool is
			-- Insert model in `last_solved_arguments' in object pool.
			-- Update arguments in `last_evaluated_variables' accordingly.
		local
			l_constant: ITP_CONSTANT
			l_variable: ITP_VARIABLE
		do
			from
				last_solved_arguments.start
			until
				last_solved_arguments.after
			loop
				create l_constant.make (last_solved_arguments.item_for_iteration)
				l_variable := interpreter.variable_table.new_variable
				interpreter.assign_expression (l_variable, l_constant)
				last_evaluated_variables.put (l_variable, last_solved_arguments.key_for_iteration)

				last_solved_arguments.forth
			end
		end

	last_solver_output: STRING
			-- Output from last launched solver

	append_solver_output (a_string: STRING) is
			-- Append `a_string' at the end of `last_solver_output'.
		do
			last_solver_output.append (a_string)
		end

	last_solved_arguments: HASH_TABLE [INTEGER, INTEGER]
			-- Table of last linearly sovled arguments
			-- [argument value, argument index]
			-- Argument index is 1-based.

	bounded_variable_count (a_variables: like last_evaluated_variables): INTEGER is
			-- Number of bounded variables in `a_variables'.
		require
			a_variables_attached: a_variables /= Void
		local
			i: INTEGER
			l_count: INTEGER
		do
			from
				i := a_variables.lower
				l_count := a_variables.upper
			until
				i > l_count
			loop
				if a_variables.item (i) /= Void then
					Result := Result + 1
				end
				i := i + 1
			end
		end

invariant
	normal_preconditions_attached: normal_preconditions /= Void
	linear_solvable_preconditions_attached: linear_solvable_preconditions /= Void
	candicate_queue_attached: candidate_variables /= Void

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
