note
	description: "Summary description for {AFX_PROGRAM_STATE_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE

inherit

	LINKED_LIST [AFX_PROGRAM_EXECUTION_STATE]
		rename make as make_list
		redefine out
		end

create
	make

feature -- Initialization

	make (a_tc: EPA_TEST_CASE_INFO)
			-- Initialize an execution trace for `a_tc'.
		do
			make_list
			test_case := a_tc
		end

feature -- Access

	test_case: EPA_TEST_CASE_INFO
			-- Test case of the trace.

	execution_status: NATURAL
			-- Status of the execution related with current trace.

	exception_signature: AFX_EXCEPTION_SIGNATURE assign set_exception_signature
			-- Exception signature in case of a failing execution.

feature -- Trace interpretation

	derived_compound_trace (a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]; a_use_aspect: BOOLEAN): AFX_PROGRAM_EXECUTION_TRACE
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_feature: AFX_FEATURE_TO_MONITOR
			l_name: STRING
		do
			create Result.make (test_case)
			if is_passing then
				Result.set_status_as_passing
			elseif is_failing then
				Result.set_status_as_failing
			end

			from start
			until after
			loop
				l_state := item_for_iteration
				Result.force (l_state.derived_state (a_map, a_use_aspect))

				forth
			end
		end

	update_values_of_old_expressions (a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING])
		local
			l_state_cursor: LINKED_LIST_ITERATION_CURSOR [AFX_PROGRAM_EXECUTION_STATE]
			l_state, l_pre_state, l_current_state: AFX_PROGRAM_EXECUTION_STATE
			l_bp, l_pre_bp: INTEGER
			l_feature_name, l_pre_feature_name: STRING
			l_feature: AFX_FEATURE_TO_MONITOR
			l_stack: DS_ARRAYED_STACK[AFX_PROGRAM_EXECUTION_STATE]
			l_evaluation, l_pre_evaluation: EPA_STATE
			l_equation: EPA_EQUATION
			l_expression_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_old_expression_evaluator: AFX_OLD_EXPRESSION_EVALUATOR
		do
			from
				create l_stack.make_equal (count)
				create l_old_expression_evaluator
				l_state_cursor := new_cursor
				l_state_cursor.start
			until
				l_state_cursor.after
			loop
				l_state := l_state_cursor.item

				l_feature_name := l_state.location.context.qualified_feature_name
				l_feature := a_map.item (l_feature_name)
				l_bp := l_state.location.breakpoint_index
				l_evaluation := l_state.state


					-- FIXME: direct recursive calls are not handled.
				if l_feature.should_monitor_contracts then
					if l_bp = l_feature.breakpoint_to_evaluate_precondition then
						if l_stack.is_empty or else l_stack.item.location.context.qualified_feature_name /~ l_feature_name then
							l_stack.force (l_state)
						end
					else
							-- 'l_state' should be in the same routine as 'l_stack.item'.
							-- Pop items from 'l_stack' until this is the case.
							--
							-- This is necessary because pre- and post-conditions being 'True' will take breakpoint slots
							--     but not get executed, so some items on 'l_stack' don't get popped when their features return.
						if not l_stack.is_empty then
							from
								l_current_state := l_stack.item
							until
								l_stack.is_empty or else l_current_state.location.context.qualified_feature_name ~ l_state.location.context.qualified_feature_name
							loop
								l_stack.remove
								if not l_stack.is_empty then
									l_current_state := l_stack.item
								end
							end
						end

						if l_bp = l_feature.breakpoint_to_evaluate_postcondition then
							check not l_stack.is_empty then
									-- Exit state of feature
								l_pre_state := l_stack.item
								l_pre_evaluation := l_pre_state.state
								l_pre_bp := l_pre_state.location.breakpoint_index
								l_pre_feature_name := l_pre_state.location.context.qualified_feature_name

								check l_pre_feature_name ~ l_feature_name and l_pre_bp = l_feature.breakpoint_to_evaluate_precondition then
										-- Matching entry state available
									from l_evaluation.start
									until l_evaluation.after
									loop
										l_equation := l_evaluation.item_for_iteration
										l_expression_text := l_equation.expression.text
										if l_expression_text.has_substring ("old") and then l_equation.value.is_nonsensical then
											l_old_expression_evaluator.evaluate (l_feature, l_expression_text, l_evaluation, l_pre_evaluation)
											l_value := l_old_expression_evaluator.last_value
											if l_value /= Void and then not l_value.is_nonsensical then
												l_equation.set_value (l_value)
											end
										end

										l_evaluation.forth
									end
									l_stack.remove
								end
							end
						end
					end
				end

				l_state_cursor.forth
			end
		end

feature -- Statistic

	statistics: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistic based on current execution trace.
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_statistic: AFX_EXECUTION_TRACE_STATISTICS
		do
			create Result.make_trace_specific (30, Current)
			from start
			until after
			loop
				l_state := item_for_iteration

				l_statistic := l_state.statistics
				Result.merge (l_statistic, {AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

				forth
			end
		end

feature -- Status report

	is_passing: BOOLEAN
			-- Is current trace corresponding to a passing test case?
		do
			Result := execution_status = Execution_passing
		end

	is_failing: BOOLEAN
			-- Is current trace corresponding to a failing test case?
		do
			Result := execution_status = Execution_failing
		end

	out: STRING
		local
		do
			if out_cache = Void then
				create out_cache.make (1024)
				out_cache.append ("================================%N")
				out_cache.append ("Test case: " + test_case.name + "%N")
				out_cache.append ("Execution successful: " + (execution_status = Execution_passing).out + "%N")
				if exception_signature /= Void then
					out_cache.append ("Exception signature: " + exception_signature.id + "%N")
				end
				from start
				until after
				loop
					out_cache.append ("----------------------------%N")
					out_cache.append (item_for_iteration.out + "%N")
					forth
				end
			end
			Result := out_cache
		end

	out_cache: STRING

feature -- Status set

	set_status_as_failing
			-- Set the trace status as failing.
		do
			execution_status := Execution_failing
		end

	set_status_as_passing
			-- Set the trace status as passing.
		do
			execution_status := Execution_passing
		end

	set_exception_signature (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `exception_signature'.
		do
			exception_signature := a_signature
		end

feature -- Constant

	Execution_unknown: NATURAL = 0
	Execution_passing: NATURAL = 1
	Execution_failing: NATURAL = 2

end
