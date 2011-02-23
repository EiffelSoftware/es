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

	EPA_CONTRACT_EXTRACTOR

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
			i: INTEGER
			l_empty_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			find_relevant_expressions (a_context)

			if
				a_should_merge
			then
				merge_not_disjoint_sets
			end

			-- Set Result
			create l_empty_set.make_default
			Result := l_empty_set
			Result.set_equality_tester (expression_equality_tester)
			from
				i := 1
			until
				i > relevant_expression_sets.count
			loop
				if
					relevant_expression_sets.i_th (i) /= Void and then relevant_expression_sets.i_th (i).has (a_expr)
				then
					Result.merge (relevant_expression_sets.i_th (i))
				end
				i := i + 1
			end
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

	relevant_expressions_with_merge (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
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

	relevant_expressions_without_merge (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
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
			i: INTEGER
			l_is_expression_relevant: BOOLEAN
		do
			find_relevant_expressions (a_context)

			if
				a_should_merge
			then
				merge_not_disjoint_sets
			end

			-- Set Result
			from
				i := 1
			until
				i > relevant_expression_sets.count or l_is_expression_relevant
			loop
				if
					relevant_expression_sets.i_th (i) /= Void and then relevant_expression_sets.i_th (i).has (a_expr) and then relevant_expression_sets.i_th (i).has (b_expr)
				then
					l_is_expression_relevant := True
				end
				i := i + 1
			end
			Result := l_is_expression_relevant
		end

	is_expression_relevant_with_merge (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
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

	is_expression_relevant_without_merge (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
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

feature {NONE} -- Implementation

	relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			-- Data structure containing sets of relevant expressions.

	find_relevant_expressions (a_context: ETR_CONTEXT)
			-- Finds all relevant expression in `a_context'.
		require
			a_context_not_void: a_context /= Void
		local
			l_relevancy_finder: EPA_RELEVANT_EXPRESSION_FINDER
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
			l_feature: FEATURE_I
			l_features: LINKED_LIST[FEATURE_I]
		do
			create l_relevancy_finder.make (a_context)

			if attached {ETR_CLASS_CONTEXT} a_context as l_class_ctxt then
				l_relevancy_finder.set_context_class (l_class_ctxt.context_class)
				l_relevancy_finder.set_written_class (l_class_ctxt.written_class)
				create l_features.make
				l_feat_tbl := l_class_ctxt.written_class.feature_table
				l_cursor := l_feat_tbl.cursor
				from
					l_feat_tbl.start
				until
					l_feat_tbl.after
				loop
					l_features.extend (l_feat_tbl.item_for_iteration)
					l_feat_tbl.forth
				end
				l_feat_tbl.go_to (l_cursor)

				-- Process all features of `a_context'
				from
					l_features.start
				until
					l_features.after
				loop
					l_feature := l_features.item_for_iteration
					l_relevancy_finder.set_context_feature (l_feature)
					l_relevancy_finder.set_written_class (l_feature.written_class)

					-- Process feature
					l_relevancy_finder.find (l_feature.e_feature.ast)

					-- Process preconditions
					across precondition_of_feature (l_feature, l_class_ctxt.context_class) as l_preconditions loop
						l_relevancy_finder.find (l_preconditions.item.ast)
					end

					-- Process postconditions
					across postcondition_of_feature (l_feature, l_class_ctxt.context_class) as l_postconditions loop
						l_relevancy_finder.find (l_postconditions.item.ast)
					end
					l_features.forth
				end

				-- Process invariants
				across invariant_of_class (l_class_ctxt.context_class) as l_invariants loop
					l_relevancy_finder.find (l_invariants.item.ast)
				end
			elseif attached {ETR_FEATURE_CONTEXT} a_context as l_feat_ctxt then
				l_feature := l_feat_ctxt.written_feature
				l_relevancy_finder.set_context_feature (l_feat_ctxt.written_feature)
				l_relevancy_finder.set_written_class (l_feat_ctxt.written_feature.written_class)
				l_relevancy_finder.set_context_class (l_feat_ctxt.context_class)

				-- Process feature
				l_relevancy_finder.find (l_feature.e_feature.ast)

				-- Process preconditions
				across precondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_preconditions loop
					l_relevancy_finder.find (l_preconditions.item.ast)
				end

				-- Process postconditions
				across postcondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_postconditions loop
					l_relevancy_finder.find (l_postconditions.item.ast)
				end
			end
			relevant_expression_sets := l_relevancy_finder.relevant_expression_sets
		ensure
			relevant_expression_sets_not_void: relevant_expression_sets /= Void
		end

	merge_not_disjoint_sets
			-- Merges the sets of relevant expressions (`relevant_expression_sets') if two different sets are not disjoint.
		require
			relevant_expression_sets_not_void: relevant_expression_sets /= Void
		local
			m,n: INTEGER
			l_count: INTEGER
			l_sets, l_edited_sets: like relevant_expression_sets
		do
			l_sets := relevant_expression_sets
			create l_edited_sets.make (relevant_expression_sets.count)
			across relevant_expression_sets as l_revs loop
				l_edited_sets.extend (l_revs.item.cloned_object)
			end
			remove_unnecessary_expressions (l_edited_sets)
			l_count := l_edited_sets.count

			from
				m := 1
			until
				m > l_count
			loop
				from
					n := m + 1
				until
					n > l_count
				loop

					-- Merge sets
					if
						m /= n and then
						l_edited_sets.i_th (m) /= Void and then
						l_edited_sets.i_th (n) /= Void and then
						not l_edited_sets.i_th (m).is_disjoint (l_edited_sets.i_th (n))
					then
						l_sets.i_th (m).merge (l_sets.i_th (n))
						l_sets.put_i_th (Void, n)
						l_edited_sets.i_th (m).merge (l_edited_sets.i_th (n))
						l_edited_sets.put_i_th (Void, n)
						n := m + 1
					else
						n := n + 1
					end
				end

				-- Find the next set which may be merged with another set.
				from
					m := m + 1
				until
				   m > l_count or else l_edited_sets.i_th (m) /= Void
				loop
					m := m + 1
				end
			end
		end

	remove_unnecessary_expressions (a_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]])
			-- Removes the unnecessary expressions from `a_sets' namely
			-- constants and the expression "Void".
		require
			a_expression_sets_not_void: a_expression_sets /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_expression_sets.count
			loop
				a_expression_sets.put_i_th (set_without_unnecessary_expressions (a_expression_sets.i_th (i)), i)
				i := i + 1
			end
		end

	set_without_unnecessary_expressions (a_expression_set: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- A set whose elements are non-constant and non-void expressions from `a_set'.
		require
			a_expression_set_not_void: a_expression_set /= Void
		do
			create Result.make (a_expression_set.count)
			Result.set_equality_tester (expression_equality_tester)
			a_expression_set.do_if (agent Result.force_last, agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_constant and not a_expr.is_void end)
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

end
