note
	description: "Class to access to relationships between expressions"
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
			create l_empty_set.make_default
			Result := l_empty_set
			from
				i := 1
			until
				i > relevant_expression_sets.count
			loop
				if
					relevant_expression_sets.i_th (i) /= Void and then relevant_expression_sets.i_th (i).has (a_expr)
				then
					Result := relevant_expression_sets.i_th (i)
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
			-- Set of expressions that `a_expr' dependents on in `a_context'
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Depencency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and another expression, `b_expr', appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.		
		do
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
			-- Depencency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and `b_expr' appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.		
		local
			l_printer: EPA_DEPENDENT_EXPRESSION_FINDER
		do
		end

feature -- Dependent Expressions

	dependent_visit_feature (a_class_name: STRING; a_feature_name: STRING)
			--
		require
			a_class_name_not_void: a_class_name /= Void
			a_feature_name_not_void: a_feature_name /= Void
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_printer: EPA_DEPENDENT_EXPRESSION_FINDER
			l_context: ETR_FEATURE_CONTEXT
			l_class_context: ETR_CLASS_CONTEXT
		do
			l_class := first_class_starts_with_name (a_class_name)
			l_feature := l_class.feature_named (a_feature_name)
			create l_class_context.make (l_feature.written_class)
			create l_context.make (l_feature, l_class_context)
			create l_printer.make
			l_printer.set_context_class (l_class)
			l_printer.set_written_class (l_feature.written_class)
			l_printer.set_context_feature (l_feature)
			l_feature.e_feature.ast.process (l_printer)
			across precondition_of_feature (l_feature, l_class) as l_preconditions loop
				l_preconditions.item.ast.process (l_printer)
			end
			across postcondition_of_feature (l_feature, l_class) as l_postcondition loop
				l_postcondition.item.ast.process (l_printer)
			end
			l_printer.dump_file ("/home/marc/Desktop/")
		end

	dependent_visit_class (a_class_name: STRING)
			--
		require
			a_class_name_not_void: a_class_name /= Void
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_printer: EPA_DEPENDENT_EXPRESSION_FINDER
			l_context: ETR_FEATURE_CONTEXT
			l_class_context: ETR_CLASS_CONTEXT
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
		do
			l_class := first_class_starts_with_name (a_class_name)
			l_feat_tbl := l_class.feature_table

			create l_printer.make

			l_cursor := l_feat_tbl.cursor
			from
				l_feat_tbl.start
			until
				l_feat_tbl.after
			loop
				l_feature := l_feat_tbl.item_for_iteration
				create l_class_context.make (l_feature.written_class)
				create l_context.make (l_feature, l_class_context)
				l_printer.set_context_class (l_class)
				l_printer.set_written_class (l_feature.written_class)
				l_printer.set_context_feature (l_feature)
				l_feature.e_feature.ast.process (l_printer)
				across precondition_of_feature (l_feature, l_class) as l_preconditions loop
					l_preconditions.item.ast.process (l_printer)
				end
				across postcondition_of_feature (l_feature, l_class) as l_postcondition loop
					l_postcondition.item.ast.process (l_printer)
				end
				l_feat_tbl.forth
			end
			l_feat_tbl.go_to (l_cursor)
			across invariant_of_class (l_class) as l_invariants loop
				l_invariants.item.ast.process (l_printer)
			end
			l_printer.dump_file ("/home/marc/Desktop/")
		end

feature {NONE} -- Implementation

	relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			-- Data structure containing sets of relevant expressions.

	find_relevant_expressions (a_context: ETR_CONTEXT)
			--
		require
			a_context_not_void: a_context /= Void
		local
			l_relevancy_finder: EPA_RELEVANT_EXPRESSION_FINDER
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
			l_feature: FEATURE_I
		do
			create l_relevancy_finder.make (a_context)
			if attached {ETR_CLASS_CONTEXT} a_context as l_class_ctxt then
				l_relevancy_finder.set_context_class (l_class_ctxt.context_class)
				l_relevancy_finder.set_written_class (l_class_ctxt.written_class)
				l_feat_tbl := l_class_ctxt.written_class.feature_table
				l_cursor := l_feat_tbl.cursor
				from
					l_feat_tbl.start
				until
					l_feat_tbl.after
				loop
					l_feature := l_feat_tbl.item_for_iteration
					l_relevancy_finder.set_context_feature (l_feature)
					l_relevancy_finder.set_written_class (l_feature.written_class)
					l_relevancy_finder.find (l_feature.e_feature.ast)
					across precondition_of_feature (l_feature, l_class_ctxt.context_class) as l_preconditions loop
						l_relevancy_finder.find (l_preconditions.item.ast)
					end
					across postcondition_of_feature (l_feature, l_class_ctxt.context_class) as l_postconditions loop
						l_relevancy_finder.find (l_postconditions.item.ast)
					end
					l_feat_tbl.forth
				end
				l_feat_tbl.go_to (l_cursor)

				across invariant_of_class (l_class_ctxt.context_class) as l_invariants loop
					l_relevancy_finder.find (l_invariants.item.ast)
				end
			elseif attached {ETR_FEATURE_CONTEXT} a_context as l_feat_ctxt then
				l_feature := l_feat_ctxt.written_feature
				l_relevancy_finder.set_context_feature (l_feat_ctxt.written_feature)
				l_relevancy_finder.set_written_class (l_feat_ctxt.written_feature.written_class)
				l_relevancy_finder.set_context_class (l_feat_ctxt.context_class)
				l_relevancy_finder.find (l_feature.e_feature.ast)
				across precondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_preconditions loop
					l_relevancy_finder.find (l_preconditions.item.ast)
				end
				across postcondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_postconditions loop
					l_relevancy_finder.find (l_postconditions.item.ast)
				end
			end
			relevant_expression_sets := l_relevancy_finder.relevant_expression_sets
		ensure
			relevant_expression_sets_not_void: relevant_expression_sets /= Void
		end

	merge_not_disjoint_sets
			-- Merges the sets of relevant expressions if two different sets are not disjoint.
		local
			m,n: INTEGER
			l_count: INTEGER
			l_rev_sets: like relevant_expression_sets
		do
			l_rev_sets := relevant_expression_sets
			l_count := l_rev_sets.count
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
					if
						l_rev_sets.i_th (m) /= Void and then
						l_rev_sets.i_th (n) /= Void and then
						not expression_set_without_constants (l_rev_sets.i_th (m)).is_disjoint (expression_set_without_constants (l_rev_sets.i_th (n)))
					then
						l_rev_sets.i_th (m).merge (l_rev_sets.i_th (n))
						l_rev_sets.put_i_th (Void, n)
					end
					n := n + 1
				end
					-- Find the next set which may be merged with another set.
				from
					m := m + 1
				until
				   m > l_count or else l_rev_sets.i_th (m) /= Void
				loop
					m := m + 1
				end
			end
		end

	expression_set_without_constants (a_set: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- A set whose elements are non-constant elements from `a_set'.
		do
			create Result.make (a_set.count)
			Result.set_equality_tester (expression_equality_tester)
			a_set.do_if (agent Result.force_last, agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_constant end)
		end

end
