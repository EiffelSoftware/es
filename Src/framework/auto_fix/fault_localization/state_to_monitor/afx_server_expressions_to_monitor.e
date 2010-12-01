note
	description: "Summary description for {AFX_SERVER_EXPRESSIONS_TO_MONITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SERVER_EXPRESSIONS_TO_MONITOR

inherit

	AFX_SHARED_SERVER_EXPRESSIONS_FROM_FEATURE

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

	EPA_UTILITY

	AFX_SHARED_SESSION

feature -- Access

	set_of_expressions_to_monitor_with_bp_index (a_class: CLASS_C; a_feature: FEATURE_I): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Set of expressions to monitor regarding `a_feature' from `a_class'.
			-- Expressions with different bp-indexes are considered as being DIFFERENT.
		local
			l_class_id: INTEGER
			l_feature_id: INTEGER
		do
			l_class_id := a_class.class_id
			l_feature_id := a_feature.feature_id

			if attached bp_index_specific_expressions.value_set (l_feature_id, l_class_id) as lt_set then
				Result := lt_set
			else
				add_expressions_to_monitor (a_class, a_feature)
				Result := bp_index_specific_expressions.value_set (l_feature_id, l_class_id)
			end
		ensure
			result_attached: Result /= Void
		end

	set_of_expressions_to_monitor_without_bp_index (a_class: CLASS_C; a_feature: FEATURE_I): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Set of expressions to monitor regarding `a_feature' from `a_class'.
			-- Expressions with different bp-indexes are considered as being the SAME.
		local
			l_class_id: INTEGER
			l_feature_id: INTEGER
			l_set: DS_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			l_class_id := a_class.class_id
			l_feature_id := a_feature.feature_id

			if attached bp_index_unspecific_expressions.value_set (l_feature_id, l_class_id) as lt_set then
				Result := lt_set
			else
				add_expressions_to_monitor (a_class, a_feature)
				Result := bp_index_unspecific_expressions.value_set (l_feature_id, l_class_id)
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Access

	bp_index_unspecific_expressions: EPA_NESTED_HASH_TABLE [AFX_PROGRAM_STATE_EXPRESSION, INTEGER, INTEGER]
			-- Breakpoint index unspecific expressions that are to be monitored.
			-- Key: feature_id <- class_id
			-- Val: expressions
		do
			if bp_index_unspecific_expressions_cache = Void then
				create bp_index_unspecific_expressions_cache.make (10)
			end

			Result := bp_index_unspecific_expressions_cache
		end

	bp_index_specific_expressions: EPA_NESTED_HASH_TABLE [AFX_PROGRAM_STATE_EXPRESSION, INTEGER, INTEGER]
			-- Breakpoint index specific expressions that are to be monitored.
			-- Key: feature_id <- class_id
			-- Val: expressions
		do
			if bp_index_specific_expressions_cache = Void then
				create bp_index_specific_expressions_cache.make (10)
			end

			Result := bp_index_specific_expressions_cache
		end

feature{NONE} -- Implementation

	add_expressions_to_monitor (a_context_class: CLASS_C; a_context_feature: FEATURE_I)
			-- Add expressions to monitor to the server.
		require
			context_class_attached: a_context_class /= VOid
			context_feature_attached: a_context_feature /= Void
		local
			l_expressions: like expressions_from_feature
			l_expr_cursor: DS_HASH_SET_CURSOR[AFX_PROGRAM_STATE_EXPRESSION]
			l_expressions_in_context: like expressions_from_feature
			l_expr, l_expr_in_context: AFX_PROGRAM_STATE_EXPRESSION
			l_collector: AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR
			l_feature_id, l_class_id: INTEGER
			l_bp_unspecific_expressions_set, l_bp_specific_expressions_set: like expressions_from_feature
		do
			l_feature_id := a_context_feature.feature_id
			l_class_id := a_context_class.class_id

			-- Collect expressions from the feature in the written class.
			l_expressions := expressions_from_feature (a_context_class, a_context_feature)

			-- Collect expressions to monitor, breakpoint index specific.
			-- Expressions are collected in the written class.
			create l_collector
			l_collector.collect_from (l_expressions)
			l_expressions := l_collector.expressions_to_monitor

			-- Transform the expressions in the context class.
			-- Maintain references to those in the written class.
			from
				create l_expressions_in_context.make (l_expressions.count)
				l_expressions_in_context.set_equality_tester (Breakpoint_unspecific_equality_tester)
				l_expr_cursor := l_expressions.new_cursor
				l_expr_cursor.start
			until
				l_expr_cursor.after
			loop
				l_expr := l_expr_cursor.item
				create l_expr_in_context.make_with_text (a_context_class, l_expr.feature_, l_expr.text_in_context (a_context_class), l_expr.feature_.written_class, l_expr.breakpoint_slot)
				if l_expr_in_context.type /= Void then
					l_expr_in_context.set_originate_expression (l_expr)
					l_expressions_in_context.force (l_expr_in_context)
				end

				l_expr_cursor.forth
			end

			-- Register breakpoint index unspecific expressions.
			create l_bp_unspecific_expressions_set.make (l_expressions.count)
			l_bp_unspecific_expressions_set.set_equality_tester (Breakpoint_unspecific_equality_tester)
			l_expressions.do_all (agent l_bp_unspecific_expressions_set.force)
			bp_index_unspecific_expressions.put_value_set (l_bp_unspecific_expressions_set, l_feature_id, l_class_id)

			-- Register breakpoint index specific expressions.
			create l_bp_specific_expressions_set.make (l_expressions.count)
			l_bp_specific_expressions_set.set_equality_tester (Breakpoint_specific_equality_tester)
			l_expressions.do_all (agent l_bp_specific_expressions_set.force)
			bp_index_specific_expressions.put_value_set (l_bp_unspecific_expressions_set, l_feature_id, l_class_id)
		end

	expressions_from_feature (a_context_class: CLASS_C; a_context_feature: FEATURE_I): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expressions that appear in `a_context_feature' from `a_context_class'.
		require
			context_class_attached: a_context_class /= VOid
			context_feature_attached: a_context_feature /= Void
		do
			Result := server_expressions_from_feature.expressions_from_feature (a_context_class, a_context_feature)
		end

feature{NONE} -- Cache

	bp_index_unspecific_expressions_cache: like bp_index_unspecific_expressions
			-- Cache for `bp_index_unspecific_expressions'.

	bp_index_specific_expressions_cache: like bp_index_specific_expressions
			-- Cache for `bp_index_specific_expressions'.


end
