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

			create initial_operands.make (0, a_vars.count - 1)
			from
				i := 0
				a_vars.start
			until
				a_vars.after
			loop
				initial_operands.put (a_vars.item_for_iteration, i)
				i := i + 1
				a_vars.forth
			end
			create operand_candidates.make (100)
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

	initial_operands: ARRAY [detachable ITP_VARIABLE]
			-- Initial operands as candidates
			-- Index in `initial_operands' is 0-based.

	last_evaluated_operands: like initial_operands
			-- Operands used to evaluate the precondition of `feature_'
			-- Index in `last_evaluated_operands' is 0-based, the first item is the target of the feature call.

	operand_candidates: DS_ARRAYED_LIST [like initial_operands]
			-- Queue for operand candidcate to execute `feature_'

	partial_candidate: detachable like initial_operands
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
			-- Does `last_evaluated_operands' satisfy the precondition of `feature_'?

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

					-- Evaluate precondition satisfaction on `initial_operands'.
				if not has_linear_solvable_precondition then
					evaluate_precondition (initial_operands)
				else
						-- In case that `feature_' has linearly solvable constraints, we always
						-- use the constraint solver.
					is_last_precondition_evaluation_satisfied := False
				end

				if is_last_precondition_evaluation_satisfied then
						-- The initially assigned operands satisfy the precondition of `feature_'.					
					steps_completed := True
				else
						-- `initial_operands' DO NOT satisfy the precondition of `feature_',
						-- new search is needed.
					load_candidates
					steps_completed := operand_candidates.is_empty
				end
			else
					-- If no precondition evaluation is enabled, we assume that `initial_operands'
					-- satisfy the precondition.
				is_last_precondition_evaluation_satisfied := True
				steps_completed := True
				last_evaluated_operands := initial_operands
			end

			if steps_completed then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end
		ensure then
			time_valid_if_finished: steps_completed implies (end_time >= start_time)
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
					-- Get the next candidate from `operand_candidates',
					-- store the candidate in `last_evaluated_operands'.
					-- Those arguments in the candidate should already satisfy all normal preconditions.
				random.forth
				l_candidate_index := random.item \\ untried_candidate_count + 1
				last_evaluated_operands := operand_candidates.item (l_candidate_index)
				operand_candidates.swap (l_candidate_index, untried_candidate_count)
				untried_candidate_count := untried_candidate_count - 1

					-- Check if linearly solvable arguments have solution.
				if has_linear_solvable_precondition then
					solve_linear_constraint
					l_satisfied := last_linear_constraint_solving_successful
				else
					l_satisfied := True
				end

				if l_satisfied then
					is_last_precondition_evaluation_satisfied := constraint.is_constraint_operand_bound (last_evaluated_operands)
					steps_completed := is_last_precondition_evaluation_satisfied
				end
			end

			if not has_next_step then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end

			if steps_completed then
				if is_last_precondition_evaluation_satisfied then
					interpreter.increase_suggested_precondition_count
				elseif partial_candidate /= Void then
					interpreter.increase_suggested_precondition_count_partial
				end
			end
		ensure then
			time_valid_if_finished: steps_completed implies (end_time >= start_time)
		end

	cancel
			-- Cancel task.
		do
			steps_completed := True
			set_end_time (interpreter.duration_until_now.millisecond_count)
		ensure then
			time_valid_if_finished: end_time >= start_time
		end

feature{NONE} -- Implementation

	untried_candidate_count: INTEGER
			-- Number of candidates that have not been tried in `operand_candidates'.

	to_be_retrieved_candidate_count: INTEGER is
			-- Max number of candidates that are to be retrieved.
			-- The actual retrieved candidates can be fewer than this.
		do
			Result := interpreter.configuration.max_candidate_count
		ensure
			good_result: Result = interpreter.configuration.max_candidate_count
		end

	load_candidates is
			-- Load candidate operands satisfying preconditions of `feature_'
			-- into `operand_candidates'.
		require
			precondition_to_be_evaluated: interpreter.configuration.is_precondition_checking_enabled
		local
			l_list: DS_LINKED_LIST [like initial_operands]
		do
				-- Every candidate in `operand_candidates' should contain all operands needed to call `feature_',
				-- except for linearly constrained operands.
			predicate_pool.generate_candidates (constraint, to_be_retrieved_candidate_count)
			l_list := predicate_pool.last_candidates
			create operand_candidates.make (l_list.count)
			operand_candidates.append_last (l_list)
			untried_candidate_count := operand_candidates.count
			partial_candidate := predicate_pool.last_partial_candidate
		end

	evaluate_precondition (a_operands: like initial_operands) is
			-- Evalute precondition of `feature_' on `a_operands'.
			-- Set `is_last_precondition_evaluation_satisfied',
			-- and put operands that satisfied the precondition into
			-- `last_evaluated_operands'.
		require
			a_operands_attached: a_operands /= Void
			no_liear_solvable_preconditions: not has_linear_solvable_precondition
		local
			l_satisfied: BOOLEAN
		do
			last_evaluated_operands := a_operands.twin

				-- Evaluate normal preconditions using predicate pool
			if has_normal_precondition then
				-- Check if `a_operands' satisfy `normal_preconditions'.
				l_satisfied := predicate_pool.is_candidate_satisfied (constraint, last_evaluated_operands)
			else
				l_satisfied := True
			end

				-- Check if all arguments are assigned.
			if l_satisfied then
				is_last_precondition_evaluation_satisfied := not last_evaluated_operands.has (Void)
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

feature{NONE} -- Linear constraint solving

	last_linear_constraint_solving_successful: BOOLEAN
			-- Is last linear constraint solving successfult?

	solve_linear_constraint is
			-- Solve linear constraints defined in `linear_solvable_preconditions'.
			-- If there is a solution, update `last_evaluated_operands' and set
			-- `last_linear_constraint_solving_successful' to True,
			-- otherwise, don't change `last_evaluated_operands' and set
			-- `last_linear_constraint_solving_successful' to False.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_smt_generator: AUT_CONSTRAINT_SOLVER_GENERATOR
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
			l_pattern_table: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]

			l_solver: AUT_LINEAR_CONSTRAINT_SOLVER
		do
				-- Ask for states of the target object.
				-- the value of constraining queries are in the retrieved states.
			if last_evaluated_operands.item (0) /= Void then
				l_state := interpreter.object_state (last_evaluated_operands.item (0))
			else
				create l_state.make (0)
			end

				-- Solve linear constraints.
			create l_solver.make (feature_, linear_solvable_preconditions, l_state)
			l_solver.solve
			last_linear_constraint_solving_successful := l_solver.has_last_solution

			if last_linear_constraint_solving_successful then
				insert_integers_in_pool (l_solver.last_solution)
			end
		end

	insert_integers_in_pool (a_integers: DS_HASH_TABLE [INTEGER, INTEGER]) is
			-- Insert linearly solved integers in `a_integers' into object pool.
			-- Update arguments in `last_evaluated_operands' accordingly.
		require
			a_integers_attached: a_integers /= Void
		local
			l_constant: ITP_CONSTANT
			l_variable: detachable ITP_VARIABLE
			l_constant_pool: like constant_pool
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			l_constant_pool := constant_pool
			from
				l_cursor := a_integers.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_constant.make (l_cursor.item)
				l_variable := l_constant_pool.variable (l_constant)
				if l_variable = Void then
					l_variable := interpreter.variable_table.new_variable
					interpreter.assign_expression (l_variable, l_constant)
					l_constant_pool.put (l_constant, l_variable)
				end
				last_evaluated_operands.put (l_variable, l_cursor.key)

				l_cursor.forth
			end
		end

invariant
	normal_preconditions_attached: normal_preconditions /= Void
	linear_solvable_preconditions_attached: linear_solvable_preconditions /= Void
	candicate_queue_attached: operand_candidates /= Void

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
