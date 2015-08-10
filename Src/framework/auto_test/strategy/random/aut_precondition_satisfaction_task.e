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

	make (a_feature: like feature_; a_vars: DS_LIST [ITP_VARIABLE]; a_interpreter: like interpreter)
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

	system: SYSTEM_I
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

	linear_solvable_preconditions: like normal_preconditions
			-- Linearly solvable precondition predicates for `feature_'

	full_preconditions: like normal_preconditions
			-- All precondition predicates, including `normal_preconditions' and `linear_solvable_preconditions'

	initial_operands: ARRAY [detachable ITP_VARIABLE]
			-- Initial operands as candidates
			-- Index in `initial_operands' is 0-based.

	last_evaluated_operands: like initial_operands
			-- Operands used to evaluate the precondition of `feature_'
			-- Index in `last_evaluated_operands' is 0-based, the first item is the target of the feature call.

	operand_candidates: DS_ARRAYED_LIST [TUPLE [operands: ARRAY [ITP_VARIABLE]; constraints: DS_HASH_TABLE [INTEGER, INTEGER]]]
			-- Queue for operand candidcate to execute `feature_'

	start_time: INTEGER
			-- Start time (in millisecond) when current precondition evaluation starts

	end_time: INTEGER
			-- End time (in millisecond) when current precondition evauation ends.

	normal_constraint: AUT_PREDICATE_CONSTRAINT
			-- Constraint for argument mapping for `normal_preconditions'

	full_constraint: like normal_constraint
			-- Constraint for argument mapping for `full_preconditions'

	tried_count: INTEGER
			-- Number of object combinations that were tried so far
			-- to satisfying the precondition of `feature_'

	worst_case_search_count: INTEGER
			-- Number of object combinations that need to be
			-- tried out in the worst case

	configuration: TEST_GENERATOR
			-- Configuration from `interpreter'
		do
			Result := interpreter.configuration
		ensure
			good_result: Result = interpreter.configuration
		end

feature -- Status report

	has_precondition: BOOLEAN
			-- Does `feature_' have precondition?
		do
			Result := has_normal_precondition or has_linear_solvable_precondition
		ensure
			good_result: Result = has_normal_precondition or has_linear_solvable_precondition
		end

	has_normal_precondition: BOOLEAN
			-- Does `feature_' have normal precondition?
		do
			Result := not normal_preconditions.is_empty
		end

	has_linear_solvable_precondition: BOOLEAN
			-- Does `feature_' have linear solvable precondition?
		do
			Result := not linear_solvable_preconditions.is_empty
		end

	set_last_precondition_satisfaction_level (a_level: INTEGER)
			-- Set `last_precondition_satisfaction_level' with `a_leve'.
		require
			a_level_valid: is_valid_precondition_satisfaction_level (a_level)
		do
			last_precondition_satisfaction_level := a_level
		ensure
			last_precondition_satisfaction_level_set: last_precondition_satisfaction_level = a_level
		end

feature -- Constants

	precondition_satisfaction_not_satisfied: INTEGER = 0
			-- Flag to indicate that `last_evaluated_operands' does not satisfy `feature_''s precondition

	precondition_satisfaction_satisfied: INTEGER = 1
			-- Flag to indicate that `last_evaluated_operands' satisfy `feature_''s precondition

	precondition_satisfaction_partially_satisfied: INTEGER = 2
			-- Flag to indicate that `last_evaluated_operands' partially satisfy `feature_''s precondition

	last_precondition_satisfaction_level: INTEGER
			-- To which level `last_evaluated_operands' satisfy `feature_''s precondition.

feature -- Status

	steps_completed: BOOLEAN
			-- Has all steps completed?

	has_next_step: BOOLEAN
			-- Is there a next step to execute?
		do
			Result := interpreter.is_running and interpreter.is_ready and not steps_completed
		end

	is_valid_precondition_satisfaction_level (a_level: INTEGER): BOOLEAN
			-- Is `a_level' a valid precondition satisfaction level?
		do
			Result :=
				a_level = precondition_satisfaction_not_satisfied or
				a_level = precondition_satisfaction_partially_satisfied or
				a_level = precondition_satisfaction_satisfied
		end

	is_lp_linear_solvable_model_correct: BOOLEAN
			-- Is the generated linearly solvable model of correct format?
			-- This is introduced because for the moment, the we only generated models
			-- for lpsolver in a simple form. This means that there are cases where the model cannot
			-- be handled by lpsolve while it can be handled by SMT based solver.

feature -- Setting

	set_start_time (a_start_time: INTEGER)
			-- Set `start_time' with `a_start_time'.
		do
			start_time := a_start_time
		ensure
			start_time_set: start_time = a_start_time
		end

	set_end_time (a_end_time: INTEGER)
			-- Set `end_time' with `a_end_time'.
		do
			end_time := a_end_time
		ensure
			end_time_set: end_time = a_end_time
		end

feature -- Execution

	should_use_precondition_satisfaction: BOOLEAN
			-- Should precondition satisfaction be used for `feature_'?
		local
			l_rate: DOUBLE
			l_set_rate: INTEGER
			l_second_until_now: INTEGER
		do
			if enforce_precondition_satisfaction then
				Result := True
			else
				l_set_rate := configuration.object_selection_for_precondition_satisfaction_rate
				if l_set_rate = 100 then
						-- Always use precondition satisfaction
					Result := True
				else
					l_rate := l_set_rate.to_double / 100
					if feature_invalid_test_case_rate.has (feature_) and then attached feature_invalid_test_case_rate.item (feature_) as l_invalid_rate then
						l_second_until_now := interpreter.duration_until_now.second_count
						l_rate := (l_second_until_now - l_invalid_rate.last_tested_time).to_double / l_second_until_now * l_rate
					end
					Result := is_within_probability (l_rate)
				end
			end
		end

	should_use_constraint_solver: BOOLEAN
			-- Is constraint solver be used for linearly solvable preconditions of `feature_'?
		local
			l_invalid_rate: TUPLE [failed_times: INTEGER; all_times: INTEGER; last_tested_time: INTEGER]
			l_rate: DOUBLE
			l_set_rate: INTEGER
			l_second_until_now: INTEGER
		do
			if configuration.is_linear_constraint_solving_enabled and then not linear_solvable_preconditions.is_empty then
				l_set_rate := configuration.object_selection_for_precondition_satisfaction_rate
				l_rate := l_set_rate.to_double / 100
				feature_invalid_test_case_rate.search (feature_)
				if feature_invalid_test_case_rate.found then
					l_invalid_rate := feature_invalid_test_case_rate.found_item
				end
				if l_invalid_rate = Void or else l_invalid_rate.all_times - l_invalid_rate.failed_times = 0 then
						-- If `feature_' has not been tested
					Result := True
				else
					if linear_solvable_preconditions.for_all (
						agent (a_pattern: AUT_PREDICATE_ACCESS_PATTERN): BOOLEAN
							do
								Result := predicate_pool.has_valuation (a_pattern.predicate)
							end)
					then
						l_second_until_now := interpreter.duration_until_now.second_count
						l_rate := (l_second_until_now - l_invalid_rate.last_tested_time).to_double / l_second_until_now * l_rate
						Result := is_within_probability (l_rate)
					else
						Result := True
					end
				end
			end
		end

	is_precondition_satisfaction_performed: BOOLEAN
			-- Is precondition satisfaction performed the last when `start' is called?

	start
			-- <Precursor>
		do
			set_start_time (interpreter.duration_until_now.millisecond_count)

			if
				features_under_test.has (feature_) and then
				configuration.is_precondition_checking_enabled and then
				has_precondition and then
				should_use_precondition_satisfaction
			then
				is_precondition_satisfaction_performed := True

					-- Evaluate precondition satisfaction on `initial_operands'.
				if not has_linear_solvable_precondition then
					evaluate_precondition (initial_operands, True)
				else
					if configuration.is_linear_constraint_solving_enabled then
							-- In case that `feature_' has linearly solvable constraints and constraint solving is enabled, we always
							-- use the constraint solver.			
						set_last_precondition_satisfaction_level (precondition_satisfaction_not_satisfied)
					else
							-- We only evaluate normal preconditions ASSUMING that linearly constraint prconditions are satisfied.
						evaluate_precondition (initial_operands, True)
					end
				end

				if last_precondition_satisfaction_level = precondition_satisfaction_satisfied then
						-- The initially assigned operands satisfy the precondition of `feature_'.					
					steps_completed := True
				else
						-- `initial_operands' DO NOT satisfy the precondition of `feature_',
						-- new search is needed.
					load_candidates
					steps_completed := operand_candidates.is_empty
				end
			else
					-- If `feature_' is not marked as under test or
					-- precondition evaluation is not enabled, we assume that `initial_operands'
					-- satisfy the precondition.
				is_precondition_satisfaction_performed := False
				last_precondition_satisfaction_level := precondition_satisfaction_satisfied
				steps_completed := True
				last_evaluated_operands := initial_operands
			end

			if steps_completed then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end

			is_lp_linear_solvable_model_correct := True
		ensure then
			time_valid_if_finished: steps_completed implies (end_time >= start_time)
		end

	step
			-- <Precursor>
		local
			l_candidate_index: INTEGER
			l_solved_arguments: detachable DS_HASH_TABLE [INTEGER, INTEGER]
		do
			if untried_candidate_count = 0 then
				steps_completed := True
			else
					-- Get the next candidate from `operand_candidates',
					-- store the candidate in `last_evaluated_operands'.
					-- Those arguments in the candidate should already satisfy all normal preconditions.
				random.forth
				l_candidate_index := random.item \\ untried_candidate_count + 1
				last_evaluated_operands := operand_candidates.item (l_candidate_index).operands
				l_solved_arguments := operand_candidates.item (l_candidate_index).constraints
				operand_candidates.swap (l_candidate_index, untried_candidate_count)
				untried_candidate_count := untried_candidate_count - 1

					-- There is a solution for constraint arguments, we need to update `last_evaluated_operands'.
				if l_solved_arguments /= Void then
					insert_integers_in_pool (l_solved_arguments)
				end

				if normal_constraint.is_constraint_operand_bound (last_evaluated_operands) then
					last_precondition_satisfaction_level := precondition_satisfaction_satisfied
					steps_completed := True
				else
					last_precondition_satisfaction_level := precondition_satisfaction_not_satisfied
					steps_completed := False
				end
			end

			if not has_next_step then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end

			if steps_completed then
				if last_precondition_satisfaction_level = precondition_satisfaction_satisfied then
					interpreter.increase_suggested_precondition_count
				elseif partial_candidate /= Void then
					last_precondition_satisfaction_level := precondition_satisfaction_partially_satisfied
					last_evaluated_operands := partial_candidate
					interpreter.increase_suggested_precondition_count_partial
				else
					last_precondition_satisfaction_level := precondition_satisfaction_not_satisfied
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

	to_be_retrieved_candidate_count: INTEGER
			-- Max number of candidates that are to be retrieved.
			-- The actual retrieved candidates can be fewer than this.
		do
			Result := configuration.max_candidate_count
		ensure
			good_result: Result = configuration.max_candidate_count
		end

	load_candidates
			-- Load candidate operands satisfying preconditions of `feature_'
			-- into `operand_candidates'.
		require
			precondition_to_be_evaluated: configuration.is_precondition_checking_enabled
		local
			l_list: DS_LINKED_LIST [TUPLE [operands: ARRAY [ITP_VARIABLE]; constraints: detachable DS_HASH_TABLE [INTEGER, INTEGER]]]
			l_should_use_constraint_solver: BOOLEAN
		do
				-- Every candidate in `operand_candidates' should contain all operands needed to call `feature_',
				-- except for linearly constrained operands.
			if should_use_constraint_solver then
				predicate_pool.generate_candidates (normal_constraint, to_be_retrieved_candidate_count, initial_operands, feature_, linear_solvable_preconditions, interpreter)
			else
				predicate_pool.generate_candidates (full_constraint, to_be_retrieved_candidate_count, initial_operands, feature_, create {like normal_preconditions}.make, interpreter)
			end
			l_list := predicate_pool.last_candidates

				-- It is possible that a feature only has linearly solvable preconditions,
				-- in that case, we use the initial assigned operands and try to solve the constraints on
				-- those operands.
			if l_list.is_empty then
				create operand_candidates.make (0)
			else
				create operand_candidates.make (l_list.count)
				operand_candidates.append_last (l_list)
			end

			untried_candidate_count := operand_candidates.count
			partial_candidate := predicate_pool.last_partial_candidate
		end

	evaluate_precondition (a_operands: like initial_operands; a_ignore_linearly_constraint_predicates: BOOLEAN)
			-- Evalute precondition of `feature_' on `a_operands'.
			-- Set `is_last_precondition_evaluation_satisfied',
			-- and put operands that satisfied the precondition into
			-- `last_evaluated_operands'.
			-- If `a_ignore_linearly_constraint_predicates' is True, ignore all linearly constraint predicates, assuming that
			-- they evaluates to True.
		require
			a_operands_attached: a_operands /= Void
		local
			l_satisfied: BOOLEAN
			l_veto_function: detachable PREDICATE [ANY, TUPLE [AUT_PREDICATE]]
		do
			last_evaluated_operands := a_operands.twin

				-- Evaluate normal preconditions using predicate pool
			if has_normal_precondition then
				-- Check if `a_operands' satisfy `normal_preconditions'.
				if a_ignore_linearly_constraint_predicates then
					l_veto_function := agent (a_pred: AUT_PREDICATE): BOOLEAN do Result := not a_pred.is_linear_solvable end
				end
				l_satisfied := predicate_pool.is_candidate_satisfied (normal_constraint, last_evaluated_operands, l_veto_function)
			else
				l_satisfied := True
			end

				-- Check if all arguments are assigned.
			if l_satisfied then
				if not last_evaluated_operands.has (Void) then
					last_precondition_satisfaction_level := precondition_satisfaction_satisfied
				else
					last_precondition_satisfaction_level := precondition_satisfaction_not_satisfied
				end
			end
		end

	setup_precondition_predicates
			-- Set `normal_preconditions' and `linear_solvable_preconditions' for `feature_'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
			l_predicate_pattern: AUT_PREDICATE_ACCESS_PATTERN
			l_constraint_solving_enabled: BOOLEAN
		do
			create normal_preconditions.make
			create linear_solvable_preconditions.make
			create full_preconditions.make

			if configuration.is_precondition_checking_enabled and then precondition_access_pattern.has (feature_) then
				l_constraint_solving_enabled := configuration.is_linear_constraint_solving_enabled
				from
					l_cursor := precondition_access_pattern.item (feature_).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_predicate_pattern := l_cursor.item

					if l_predicate_pattern.predicate.is_linear_solvable and then l_constraint_solving_enabled then
						linear_solvable_preconditions.force_last (l_predicate_pattern)
					else
						normal_preconditions.force_last (l_predicate_pattern)
					end
					full_preconditions.force_last (l_predicate_pattern)
					l_cursor.forth
				end

				create normal_constraint.make_with_precondition (feature_, normal_preconditions)
				create full_constraint.make_with_precondition (feature_, full_preconditions)
			end
		ensure
			normal_preconditions_attached: normal_preconditions /= Void
			linear_solvable_preconditions_attached: linear_solvable_preconditions /= Void
		end

	update_last_evaluated_operands_with_initial_operands
			-- Update unassigned operands in `last_evaluated_operands' with corresponding ones in `initial_operands'.
		local
			i: INTEGER
			l_upper: INTEGER
			l_initial_operands: like initial_operands
			l_last_operands: like last_evaluated_operands
		do
			l_initial_operands := initial_operands
			l_last_operands := last_evaluated_operands
			from
				i := l_initial_operands.lower
				l_upper := l_initial_operands.upper
			until
				i > l_upper
			loop
				if l_last_operands.item (i) = Void and then l_initial_operands.item (i) /= Void then
					l_last_operands.put (l_initial_operands.item (i), i)
				end
				i := i + 1
			end
		end

	partial_candidate: detachable like initial_operands
			-- Partial candidate

feature{NONE} -- Linear constraint solving

	insert_integers_in_pool (a_integers: DS_HASH_TABLE [INTEGER, INTEGER])
			-- Insert linearly solved integers in `a_integers' into object pool.
			-- Update arguments in `last_evaluated_operands' accordingly.
		require
			a_integers_attached: a_integers /= Void
			not_a_integers_is_empty: not a_integers.is_empty
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

				-- Store `a_integers' as used values.
			if not a_integers.is_empty then
				store_used_values (a_integers)
			end
		end

	max_used_value_cache: INTEGER = 30
			-- Max number of cached used integer values for a linearly solvable operand
			-- of a feature.

	store_used_values (a_integers: DS_HASH_TABLE [INTEGER, INTEGER])
			-- Store `a_integers' as used values for `feature_'.
		require
			a_integers_attached: a_integers /= Void
			not_a_integers_is_empty: not a_integers.is_empty
		local
			l_operand_indexes: DS_ARRAYED_LIST [INTEGER]
			l_sorter: DS_QUICK_SORTER [INTEGER]
			l_single_value_set: AUT_UNARY_INTEGER_VALUE_SET
			l_multi_value_set: AUT_MULTI_INTEGER_VALUE_SET
			l_values: ARRAY [INTEGER]
		do
			if a_integers.count = 1 then
				if not used_integer_values.has (feature_) then
					create l_single_value_set.make
					used_integer_values.force_last (l_single_value_set, feature_)
				else
					l_single_value_set ?= used_integer_values.item (feature_)
				end
				if l_single_value_set.count = max_used_value_cache then
					l_single_value_set.wipe_out
				end
				a_integers.start
				l_single_value_set.put (<<a_integers.item_for_iteration>>)

			else
				create l_operand_indexes.make (a_integers.count)
				a_integers.keys.do_all (agent l_operand_indexes.force_last)
				create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [INTEGER]}.make (agent (a, b: INTEGER): BOOLEAN do Result := a < b end))
				l_sorter.sort (l_operand_indexes)

				create l_values.make (1, a_integers.count)
				from
					l_operand_indexes.start
				until
					l_operand_indexes.after
				loop
					l_values.put (a_integers.item (l_operand_indexes.item_for_iteration), l_operand_indexes.index)
					l_operand_indexes.forth
				end

				if not used_integer_values.has (feature_) then
					create l_multi_value_set.make (a_integers.count)
					used_integer_values.force_last (l_multi_value_set, feature_)
				else
					l_multi_value_set ?= used_integer_values.item (feature_)
				end
				if l_multi_value_set.count = max_used_value_cache then
					l_multi_value_set.wipe_out
				end
				l_multi_value_set.put (l_values)
			end
		end

invariant
	interpreter_attached: interpreter /= Void
	normal_preconditions_attached: normal_preconditions /= Void
	linear_solvable_preconditions_attached: linear_solvable_preconditions /= Void
	candicate_queue_attached: operand_candidates /= Void
	last_precondition_satisfaction_level_valid: is_valid_precondition_satisfaction_level (last_precondition_satisfaction_level)

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
