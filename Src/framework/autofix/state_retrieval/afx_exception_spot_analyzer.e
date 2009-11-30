note
	description: "Summary description for {AFX_EXCEPTION_SPOT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_SPOT_ANALYZER

inherit
	REFACTORING_HELPER

feature -- Access

	last_spot: AFX_EXCEPTION_SPOT
			-- Last analyzed exception spot

feature -- Basic operations

	analyze (a_tc: AFX_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER; a_breakpoint: BREAKPOINT)
			-- Generate `last_spot' for text case `a_tc' in the context
			-- given by the debugger `a_dm' and the breakpoint `a_breakpoint'.			
		local
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]
			l_basic_expr_gen: AFX_BASIC_STATE_EXPRESSION_GENERATOR
			l_implication_gen: AFX_IMPLICATION_GENERATOR
		do
			create l_ranking.make (50)
			l_ranking.compare_objects

				-- Generate basic expressions such as argumentless boolean queries.
			create l_basic_expr_gen
			l_basic_expr_gen.generate (a_tc, l_ranking)

			fixme ("The following hack is for the sake of debugging speed, we don't search for implications for known classes every time. 28.11.2009 Jasonw")
			if a_tc.recipient_class ~ "INTERACTIVE_LIST" then
				update_expressions_with_ranking (l_ranking, implications_for_ACTIVE_LIST (a_tc.recipient_class_, a_tc.recipient_), {AFX_EXPR_RANK}.rank_implication)
			elseif a_tc.recipient_class ~ "ARRAYED_CIRCULAR" then
				update_expressions_with_ranking (l_ranking, implications_for_ARRAYED_CIRCULAR (a_tc.recipient_class_, a_tc.recipient_), {AFX_EXPR_RANK}.rank_implication)
			elseif a_tc.recipient_class ~ "ARRAY" then
				update_expressions_with_ranking (l_ranking, implications_for_ARRAY (a_tc.recipient_class_, a_tc.recipient_), {AFX_EXPR_RANK}.rank_implication)
			elseif a_tc.recipient_class ~ "ARRAYED_LIST" then
				update_expressions_with_ranking (l_ranking, implications_for_ARRAYED_LIST (a_tc.recipient_class_, a_tc.recipient_), {AFX_EXPR_RANK}.rank_implication)
			elseif a_tc.recipient_class ~ "BINARY_SEARCH_TREE_SET" then
				update_expressions_with_ranking (l_ranking, implications_for_BINARY_SEARCH_TREE_SET (a_tc.recipient_class_, a_tc.recipient_), {AFX_EXPR_RANK}.rank_implication)
			else
					-- Generate implications.
				create l_implication_gen
				l_implication_gen.generate (a_tc, l_ranking)
			end

			create last_spot.make (a_tc)
			last_spot.set_ranking (l_ranking)
		end

feature{NONE} -- Implementation

	implications_for_ARRAY (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
		local
			l_expressions: ARRAY [STRING]
		do
			l_expressions := <<>>
			Result := implications_for_class (l_expressions, a_class, a_feature)
		end

	implications_for_BINARY_SEARCH_TREE_SET (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
		local
			l_expressions: ARRAY [STRING]
		do
			l_expressions := <<
				"(not (after)) implies (not (off))",
				"(not (after)) implies (off)",
				"(not (before)) implies (not (off))",
				"(not (before)) implies (off)",
				"(not (is_empty)) implies (not (off))",
				"(not (is_empty)) implies (off)">>
			Result := implications_for_class (l_expressions, a_class, a_feature)
		end




	implications_for_ARRAYED_LIST (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
		local
			l_expressions: ARRAY [STRING]
		do
			l_expressions := <<
				"(is_empty) implies (after)",
				"(is_empty) implies (before)",
				"(is_empty) implies (not (after))",
				"(is_empty) implies (not (before))",
				"(not (after)) implies (not (off))",
				"(not (after)) implies (off)",
				"(not (before)) implies (not (off))",
				"(not (before)) implies (off)",
				"(not (is_empty)) implies (after)",
				"(not (is_empty)) implies (all_default)",
				"(not (is_empty)) implies (before)",
				"(not (is_empty)) implies (isfirst)",
				"(not (is_empty)) implies (islast)",
				"(not (is_empty)) implies (not (after))",
				"(not (is_empty)) implies (not (all_default))",
				"(not (is_empty)) implies (not (before))",
				"(not (is_empty)) implies (not (isfirst))",
				"(not (is_empty)) implies (not (islast))",
				"(not (is_empty)) implies (not (off))",
				"(not (is_empty)) implies (not (readable))",
				"(not (is_empty)) implies (not (writable))",
				"(not (is_empty)) implies (off)",
				"(not (is_empty)) implies (readable)",
				"(not (is_empty)) implies (writable)",
				"(not (isfirst)) implies (is_empty)",
				"(not (isfirst)) implies (not (is_empty))",
				"(not (islast)) implies (is_empty)",
				"(not (islast)) implies (not (is_empty))",
				"(off) implies (after)",
				"(off) implies (not (after))">>
			Result := implications_for_class (l_expressions, a_class, a_feature)
		end

	implications_for_ARRAYED_CIRCULAR (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
		local
			l_expressions: ARRAY [STRING]
		do
			l_expressions := <<
				"(not (after)) implies (is_empty)",
				"(not (after)) implies (not (is_empty))",
				"(not (after)) implies (not (off))",
				"(not (after)) implies (off)",
				"(not (before)) implies (is_empty)",
				"(not (before)) implies (not (is_empty))",
				"(not (before)) implies (not (off))",
				"(not (before)) implies (off)",
				"(not (is_empty)) implies (isfirst)",
				"(not (is_empty)) implies (islast)",
				"(not (is_empty)) implies (not (isfirst))",
				"(not (is_empty)) implies (not (islast))",
				"(not (is_empty)) implies (not (readable))",
				"(not (is_empty)) implies (not (writable))",
				"(not (is_empty)) implies (readable)",
				"(not (is_empty)) implies (writable)",
				"(not (isfirst)) implies (is_empty)",
				"(not (isfirst)) implies (not (is_empty))",
				"(not (islast)) implies (is_empty)",
				"(not (islast)) implies (not (is_empty))",
				"(not (off)) implies (exhausted)",
				"(not (off)) implies (not (exhausted))",
				"(not (writable)) implies (not (readable))",
				"(not (writable)) implies (readable)",
				"(off) implies (after)",
				"(off) implies (not (after))">>
			Result := implications_for_class (l_expressions, a_class, a_feature)
		end

	implications_for_ACTIVE_LIST (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
		local
			l_expressions: ARRAY [STRING]
		do
			l_expressions := <<
				"(is_empty) implies (after)",
				"(is_empty) implies (before)",
				"(is_empty) implies (not (after))",
				"(is_empty) implies (not (before))",
				"(not (after)) implies (not (off))",
				"(not (after)) implies (off)",
				"(not (before)) implies (not (off))",
				"(not (before)) implies (off)",
				"(not (is_empty)) implies (after)",
				"(not (is_empty)) implies (all_default)",
				"(not (is_empty)) implies (before)",
				"(not (is_empty)) implies (isfirst)",
				"(not (is_empty)) implies (islast)",
				"(not (is_empty)) implies (not (after))",
				"(not (is_empty)) implies (not (all_default))",
				"(not (is_empty)) implies (not (before))",
				"(not (is_empty)) implies (not (isfirst))",
				"(not (is_empty)) implies (not (islast))",
				"(not (is_empty)) implies (not (off))",
				"(not (is_empty)) implies (not (readable))",
				"(not (is_empty)) implies (not (writable))",
				"(not (is_empty)) implies (off)",
				"(not (is_empty)) implies (readable)",
				"(not (is_empty)) implies (writable)",
				"(not (isfirst)) implies (is_empty)",
				"(not (isfirst)) implies (not (is_empty))",
				"(not (islast)) implies (is_empty)",
				"(not (islast)) implies (not (is_empty))",
				"(off) implies (after)",
				"(off) implies (not (after))"
			>>
			Result := implications_for_class (l_expressions, a_class, a_feature)
		end

	implications_for_class (a_implications: ARRAY [STRING]; a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [AFX_EXPRESSION]
			-- Implications and their rankings for `a_class'
		local
			i: INTEGER
			l_expr: AFX_AST_EXPRESSION
		do
			create Result.make (40)
			Result.set_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})

			from
				i := a_implications.lower
			until
				i > a_implications.upper
			loop
				create l_expr.make_with_text (a_class, a_feature, a_implications.item (i), a_class)
				Result.force_last (l_expr)
				i := i + 1
			end
		end

	update_expressions_with_ranking (a_expressions: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]; a_new_exprs: DS_HASH_SET [AFX_EXPRESSION]; a_ranking: INTEGER)
			-- Add `a_new_exprs' into `a_expressions' with `a_ranking' into `a_expression'.
			-- If some expression already in `a_expressions' but `a_ranking' is higher than the original ranking,
			-- update it with `a_ranking'.
		local
			l_expr: AFX_EXPRESSION
			l_rank: AFX_EXPR_RANK
		do
			fixme ("Copied from AFX_RELEVANT_STATE_EXPRESSION_GENERATOR. 28.11.2009 Jasonw")
			from
				a_new_exprs.start
			until
				a_new_exprs.after
			loop
				create l_rank.make ({AFX_EXPR_RANK}.rank_implication)
				l_expr := a_new_exprs.item_for_iteration
				if a_expressions.has (l_expr) then
					if a_expressions.item (l_expr) < l_rank then
						a_expressions.replace (l_rank, l_expr)
					end
				else
					a_expressions.put (l_rank, l_expr)
				end
				a_new_exprs.forth
			end
		end

end
