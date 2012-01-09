note
	description: "Summary description for {AFX_PROGRAM_STATE_STATIC_DISTANCE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_STATIC_DISTANCE_CALCULATOR

inherit
	AFX_SHARED_SESSION

create
	default_create

feature -- Access

	last_relevances: TUPLE [control_relevance: INTEGER; data_relevance: REAL_64]
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
			l_control_relevance: INTEGER
			l_data_relevance: REAL_64
			l_failing_assertion: EPA_EXPRESSION
		do
			l_control_relevance := exception_recipient_feature.control_distances_to_exception_point (a_target.bp_index)

			l_failing_assertion := exception_signature.exception_condition_in_recipient
--			create l_failing_program_state.make_with_text (exception_spot.recipient_class_, exception_spot.recipient_, l_failing_assertion.text, exception_spot.recipient_written_class, exception_spot.failing_assertion_break_point_slot)
			l_data_relevance := relevance_to_expression (l_failing_assertion, a_target.expression)

			last_relevances := [l_control_relevance, l_data_relevance]
		end

feature{NONE} -- Implementation

	sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Shared sub-expression collector.
		once
			create Result
		end

	sub_expressions_table_cache: DS_HASH_TABLE [EPA_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			-- Hash table caching sub-expressions of expressions.
			-- Key: expressions
			-- Val: sub-expressions of a key expression
		once
			create Result.make_equal (30)
		end

	sub_expressions_of (a_expression: EPA_EXPRESSION): EPA_HASH_SET [EPA_EXPRESSION]
			-- Set of sub-expressions of `a_expression'.
		require
			expression_attached: a_expression /= Void
		local
			l_context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
		do
			if not sub_expressions_table_cache.has (a_expression) then
				create l_context_feature.make (a_expression.feature_, a_expression.class_)
				sub_expression_collector.collect_from_expression_text (l_context_feature, a_expression.text)
				sub_expressions_table_cache.force (sub_expression_collector.last_sub_expressions, a_expression)
			end
			Result := sub_expressions_table_cache.item (a_expression)
		end


	relevance_to_expression (a_expression: EPA_EXPRESSION; a_other_expression: EPA_EXPRESSION): REAL_64
			-- The relevance of `a_other_expression' to `a_expression'.
			-- The relevance is computed as the number of common sub-expressions shared between `a_expression' and `a_other_expression'.
		require
			expr_attached: a_expression /= Void
			other_expr_attached: a_other_expression /= Void
		local
			l_common, l_total: INTEGER
			l_sub_expressions1, l_sub_expressions2: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_sub_expressions1 := sub_expressions_of (a_expression)
			l_sub_expressions2 := sub_expressions_of (a_other_expression)

			Result := l_sub_expressions1.intersection (l_sub_expressions2).count
		end


end
