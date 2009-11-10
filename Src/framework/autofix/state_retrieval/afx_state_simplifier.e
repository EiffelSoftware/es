note
	description: "Summary description for {AFX_STATE_SIMPLIFIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_SIMPLIFIER

feature -- Access

	last_state: detachable AFX_STATE_SKELETON
			-- Last state simplified by `simplify'

feature -- Basic operations

	simplify (a_state: like last_state)
			-- Simplify `a_state', store result in `last_state'.
			-- `last_state' is simplified from `a_state' by doing the following:
			-- 1. Remove all tautologies from `a_state'.
		local
			l_kept_exprs: DS_HASH_SET [AFX_EXPRESSION]
			l_done: BOOLEAN
			l_implied_expr: detachable AFX_EXPRESSION
			l_expr_list: LINKED_LIST [AFX_EXPRESSION]
		do
			create l_kept_exprs.make (a_state.count)
			l_kept_exprs.set_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})

				-- Remove all tautology expressions.
			a_state.do_if (agent l_kept_exprs.force_last, agent is_expression_non_tautology (?, a_state))

--				-- Remove expressions that can be implied by others.
--			from
--			until
--				l_done
--			loop
--				l_implied_expr := implied_expression (l_kept_exprs, a_state)
--				if l_implied_expr /= Void then
--					l_kept_exprs.remove (l_implied_expr)
--				else
--					l_done := True
--				end
--			end

				-- Construct `last_state'.
			create l_expr_list.make
			l_kept_exprs.do_all (agent l_expr_list.extend)
			create last_state.make_with_expressions (a_state.class_, a_state.feature_, l_expr_list)
		end

feature{NONE} -- Implementation

	is_expression_tautology (a_expr: AFX_EXPRESSION; a_state: like last_state): BOOLEAN
			-- Is `a_expr' a tautology in the context of `a_state'?
		require
			a_expr_in_a_state: a_state.has (a_expr)
		do
			smtlib_generator.generate_for_tautology_checking (a_expr, a_state)
			Result := z3_launcher.is_unsat (smtlib_generator.last_smtlib)
		end

	is_expression_non_tautology (a_expr: AFX_EXPRESSION; a_state: like last_state): BOOLEAN
			-- Is `a_expr' not a tautology in the context of `a_state'?
		require
			a_expr_in_a_state: a_state.has (a_expr)
		do
			Result := not is_expression_tautology (a_expr, a_state)
		end

	implied_expression (a_expressions: DS_HASH_SET [AFX_EXPRESSION]; a_state: like last_state): detachable AFX_EXPRESSION
			-- A random expression from `a_expressions' which can be implied by the other expressions
			-- in `a_expressions'. Void if no such expression is found.
		local
			l_cursor: DS_HASH_SET_CURSOR [AFX_EXPRESSION]
			l_exprs: like a_expressions
			l_expr: AFX_EXPRESSION
			l_list: LINKED_LIST [AFX_EXPRESSION]
		do
			from
				l_exprs := a_expressions.twin
				l_cursor := a_expressions.new_cursor
				l_cursor.start
			until
				l_cursor.after or else l_cursor.after
			loop
				l_expr := l_cursor.item
				l_exprs.remove (l_expr)
				create l_list.make
				l_exprs.do_all (agent l_list.extend)
				smtlib_generator.generate_for_implied_checking (l_expr, l_list, a_state)
				if z3_launcher.is_unsat (smtlib_generator.last_smtlib) then
					Result := l_expr
				else
					l_exprs.force_last (l_expr)
				end
				l_cursor.forth
			end
		ensure
			good_result: Result /= Void implies a_expressions.has (Result)
		end

feature{NONE} -- Implementation

	z3_launcher: AFX_SMTLIB_LAUNCHER
			-- Z3 launcher
		once
			create Result
		end

	smtlib_generator: AFX_SMTLIB_FILE_GENERATOR
			-- Z3 SMTLIB file generator
		once
			create Result
		end

end
