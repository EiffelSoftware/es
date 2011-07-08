note
	description: "Helper functions for snippet extraction AST processing."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_UTILITY

inherit
	REFACTORING_HELPER

feature {NONE} -- Helpers (Expression)

	negate_expression (l_as: EXPR_AS): EXPR_AS
			-- Negates an expression.
			-- If the root of the expression AST is of type `{UN_NOT_AS}' it will be removed.
			-- If the root of the expression AST is not of type `{UN_NOT_AS}' it such node
			-- including and inner `{PARAN_AS}' will be wrapped around.
		require
			attached l_as
		do
			if attached {UN_NOT_AS} l_as as l_un_not_as then
				Result := l_un_not_as.expr
			else
				Result := create {UN_NOT_AS}.initialize (paran_expression (l_as), Void)
			end
		ensure
			attached Result
		end

	and_expression_list (a_list: LIST [EXPR_AS]): EXPR_AS
			-- Concatenates a list of expressions with binary 'and'.
		require
			not a_list.is_empty
		local
			l_current: EXPR_AS
			l_new_list: like a_list
		do
			if a_list.count > 1 then
				l_new_list := a_list.twin
				l_current := l_new_list.last

				l_new_list.start
				l_new_list.prune (l_current)
				check l_new_list.count < a_list.count end

				Result := and_expression (and_expression_list (l_new_list), l_current)
			else
				Result := a_list.first
			end
		end

	and_expression (a_left_as, a_right_as: EXPR_AS): EXPR_AS
			-- Wraps parenthesis around both expressions and connects them with a binary 'and'.
		local
			l_bin_and_as: BIN_AND_AS
		do
			create l_bin_and_as.initialize (paran_expression (a_left_as), paran_expression (a_right_as), Void)
			Result := l_bin_and_as
		end

	paran_expression (a_as: EXPR_AS): EXPR_AS
			-- Creates a new expression of `a_as' with parenthesis wrapped around.
		local
			l_paran_as: PARAN_AS
		do
			create l_paran_as.initialize (a_as, Void, Void)
			Result := l_paran_as
		end

end
