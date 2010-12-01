note
	description: "Summary description for {AFX_PROGRAM_STATE_STATIC_DISTANCE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_STATIC_DISTANCE_CALCULATOR

inherit
	AFX_SHARED_SESSION

	AFX_SHARED_STATIC_ANALYSIS_REPORT

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	default_create

feature -- Access

	last_relevances: TUPLE [control_relevance: INTEGER; data_relevance: INTEGER]
			-- Relevances of a fixing target to the failure under fixing.
			-- Result of `calculate_relevance'.

feature -- Basic operation

	calculate_relevance (a_target: AFX_FIXING_TARGET)
			-- Calculate the static relevance between `a_target' and the failure.
			-- Make the result available in `last_relevances'.
		require
			target_attached: a_target /= Void
		local
			l_report: AFX_CONTROL_DISTANCE_REPORT
			l_control_relevance, l_data_relevance: INTEGER
			l_failing_assertion: EPA_EXPRESSION
			l_failing_program_state: AFX_PROGRAM_STATE_EXPRESSION
		do
			l_report := control_distance_report
			check report_attached: l_report /= Void end
			l_control_relevance := l_report.distance_from (a_target.bp_index)

			l_failing_assertion := exception_spot.failing_assertion
			create l_failing_program_state.make_with_text (exception_spot.recipient_class_, exception_spot.recipient_, l_failing_assertion.text, exception_spot.recipient_written_class, exception_spot.failing_assertion_break_point_slot)
			l_data_relevance := relevance_to_expression (l_failing_program_state, a_target.expressions)

			last_relevances := [l_control_relevance, l_data_relevance]
		end

feature{NONE} -- Implementation

	relevance_to_expression (a_expression: AFX_PROGRAM_STATE_EXPRESSION; a_expr_set: DS_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]): INTEGER
			-- The relevance of `a_expr_set' to `a_expression'.
			-- The relevance is computed as the number of common sub-expressions shared between `a_expression' and `a_expr_set'.
		require
			expr_attached: a_expression /= Void
			expr_set_attached: a_expr_set /= Void
			from_same_context: True -- the expressions are from the same context and written classes.
		local
			l_sub_expressions1, l_sub_expressions2: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			l_sub_expressions1 := a_expression.sub_expressions

			create l_sub_expressions2.make (10)
			l_sub_expressions2.set_equality_tester (Breakpoint_unspecific_equality_tester)
			a_expr_set.do_all (
					agent (a_expr: AFX_PROGRAM_STATE_EXPRESSION; a_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION])
						do
							a_set.append (a_expr.sub_expressions)
						end (?, l_sub_expressions2))

			Result := l_sub_expressions1.intersection (l_sub_expressions2).count
		end


end
