note
	description: "Class to access relationships between expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_RELATION

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

feature -- Access

	relevant_expressions (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT; a_should_merge: BOOLEAN): DS_HASH_SET [EPA_EXPRESSION]
			-- Returns a set of expressions which are relevant to `a_expr' in `a_context'.
			-- If no expressions are relevant to `a_expr' then an empty set is returned.
			-- `a_expr' is the expression for which relevant expressions should be found.
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- `a_should_merge' indicates if the found sets shall be merged. If `a_should_merge' is True,
			-- expression sets (containing subexpressions from binary operations)
			-- with common expressions get merged into a single set.
		require
			a_exp_not_void: a_expr /= Void
			a_context_not_void: a_context /= Void
		local
			i, l_count: INTEGER
			l_empty_set, l_set: EPA_HASH_SET [EPA_EXPRESSION]
			l_relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			l_finder: EPA_RELEVANT_EXPRESSION_FINDER
			l_merger: EPA_RELEVANT_EXPRESSION_MERGER
		do
			create l_finder.make (a_context)
			l_finder.find
			l_relevant_expression_sets := l_finder.relevant_expression_sets

			if
				a_should_merge
			then
				create l_merger.make (l_relevant_expression_sets)
				l_merger.merge
				l_relevant_expression_sets := l_merger.relevant_expression_sets
			end

			-- Set Result
			create l_empty_set.make_default
			Result := l_empty_set
			Result.set_equality_tester (expression_equality_tester)
			from
				i := 1
				l_count := l_relevant_expression_sets.count
			until
				i > l_count
			loop
				l_set := l_relevant_expression_sets.i_th (i)
				if
					l_set /= Void and then
					l_set.has (a_expr)
				then
					Result.merge (l_set)
				end
				i := i + 1
			end
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

	relevant_expressions_with_merging (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
			-- Returns a set of expressions which are relevant to `a_expr' in `a_context'.
			-- If no expressions are relevant to `a_expr' then an empty set is returned.
			-- In this feature the algorithm merges found sets by default.
			-- `a_expr' is the expression for which relevant expressions should be found.
			-- `a_context' indicates in which scope the relevance relation is calculated.
		require
			a_exp_not_void: a_expr /= Void
			a_context_not_void: a_context /= Void
		do
			Result := relevant_expressions (a_expr, a_context, True)
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

	relevant_expressions_without_merging (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
			-- Returns a set of expressions which are relevant to `a_expr' in `a_context'.
			-- If no expressions are relevant to `a_expr' then an empty set is returned.
			-- In this feature the algorithm doesn't merge found sets by default.
			-- `a_expr' is the expression for which relevant expressions should be found.
			-- `a_context' indicates in which scope the relevance relation is calculated.
		require
			a_exp_not_void: a_expr /= Void
			a_context_not_void: a_context /= Void
		do
			Result := relevant_expressions (a_expr, a_context, False)
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

	dependent_expressions (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions that `a_expr' dependends on in `a_context'
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Depencency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and another expression, `b_expr', appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.
		do
			fixme("Not yet implemented. Feb 13, 2011. megg")
		ensure
			good_result: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

feature -- Status report

	is_expression_relevant (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT; a_should_merge: BOOLEAN): BOOLEAN
			-- Returns a boolean specifying if `a_expr' and `b_expr' are relevant.
			-- `a_expr' specifies the first expression which should be used for comparison.
			-- `b_expr' specifies the second expression which should be used for comparison.
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- `a_should_merge' indicates if the found sets shall be merged.
		require
			a_exp_not_void: a_expr /= Void
			b_expr_not_void: b_expr /= Void
			a_context_not_void: a_context /= Void
		local
			i, l_count: INTEGER
			l_set: EPA_HASH_SET [EPA_EXPRESSION]
			l_relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			l_finder: EPA_RELEVANT_EXPRESSION_FINDER
			l_merger: EPA_RELEVANT_EXPRESSION_MERGER
		do
			create l_finder.make (a_context)
			l_finder.find
			l_relevant_expression_sets := l_finder.relevant_expression_sets

			if
				a_should_merge
			then
				create l_merger.make (l_relevant_expression_sets)
				l_merger.merge
				l_relevant_expression_sets := l_merger.relevant_expression_sets
			end

			-- Set Result
			from
				i := 1
				l_count := l_relevant_expression_sets.count
			until
				i > l_count or Result
			loop
				l_set := l_relevant_expression_sets.i_th (i)
				if
					l_set /= Void and then
					l_set.has (a_expr) and then
					l_set.has (b_expr)
				then
					Result := True
				end
				i := i + 1
			end
		end

	is_expression_relevant_with_merging (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
			-- Returns a boolean specifying if `a_expr' and `b_expr' are relevant.
			-- In this feature the algorithm merges found sets by default.
			-- `a_expr' specifies the first expression which should be used for comparison.
			-- `b_expr' specifies the second expression which should be used for comparison.
			-- `a_context' indicates in which scope the relevance relation is calculated.
		require
			a_exp_not_void: a_expr /= Void
			b_expr_not_void: b_expr /= Void
			a_context_not_void: a_context /= Void
		do
			Result := is_expression_relevant (a_expr, b_expr, a_context, True)
		end

	is_expression_relevant_without_merging (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
			-- Returns a boolean specifying if `a_expr' and `b_expr' are relevant.
			-- In this feature the algorithm doesn't merge found sets by default.
			-- `a_expr' specifies the first expression which should be used for comparison.
			-- `b_expr' specifies the second expression which should be used for comparison.
			-- `a_context' indicates in which scope the relevance relation is calculated.
		require
			a_exp_not_void: a_expr /= Void
			b_expr_not_void: b_expr /= Void
			a_context_not_void: a_context /= Void
		do
			Result := is_expression_relevant (a_expr, b_expr, a_context, False)
		end

	is_expression_dependent (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
			-- Is `a_expr' dependent on `b_expr'?
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Dependency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and `b_expr' appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.
		do
			fixme("Not yet implemented. Feb 13, 2011. megg")
		end

feature -- Helper features

	relevant_expressions_for_operands (a_class: CLASS_C; a_feature: FEATURE_I; a_should_merge: BOOLEAN): DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			-- Expressions that are relevant to operands (target and arguments) of `a_feature', viewed in `a_class'
			-- Keys are operand expression of `a_feature', values are expressions that are relevant to those operands.
			-- See `relevant_expressions'.`a_should_merge' for the meaning of `a_should_merge'.
		local
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, STRING]
			l_written_class: CLASS_C
			l_context: ETR_FEATURE_CONTEXT
		do
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)
			create l_context.make (a_feature, create {ETR_CLASS_CONTEXT}.make (a_class))

			l_written_class := a_feature.written_class
			from
				l_cursor := operands_of_feature (a_feature).new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_text := l_cursor.key
				if l_text /~ ti_result then
					create l_expr.make_with_text (a_class, a_feature, l_text, l_written_class)
					Result.force_last (relevant_expressions (l_expr, l_context, a_should_merge), l_expr)
				end
				l_cursor.forth
			end
		end

end
