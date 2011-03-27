note
	description: "Class to find equality (eith by reference or by object) comparison between operands of a feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_OPERAND_COMPARISON_FINDER

inherit
	AST_ITERATOR
		redefine
			process_bin_eq_as,
			process_bin_ne_as,
			process_bin_tilde_as,
			process_bin_not_tilde_as
		end

	EPA_UTILITY

feature -- Access

	last_comparisons:  LINKED_LIST [TUPLE [operand1: EPA_EXPRESSION; operand2: EPA_EXPRESSION]]
			-- Operand comparisons found by either `find_reference_comparisons' or `find_object_comparison'
			-- `operand1' and `operand2' are the too operands that are involved in the comparison

	last_feature_value_comparisons: LINKED_LIST [TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION]]
			-- Expression comparisons where at least one expression from `expression1' and `expression2' is not an operand

	find_reference_comparisons (a_expression: EPA_EXPRESSION; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find reference comparisons (in `a_expression') between operands of `a_feature' from `a_class',
			-- make result available in `last_comparisons'.
		do
			find (a_expression, a_class, a_feature, True)
		end

	find_object_comparisons (a_expression: EPA_EXPRESSION; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find object comparisons (in `a_expression') between operands of `a_feature' from `a_class',
			-- make result available in `last_comparisons'.
		do
			find (a_expression, a_class, a_feature, False)
		end

feature{NONE} -- Implementation

	class_: CLASS_C
			-- Class

	feature_: FEATURE_I
			-- Feature

	is_for_reference_comparison: BOOLEAN
			-- Are we looking for reference comparisons between operands?

	expression: EPA_EXPRESSION
			-- The expression in which we are search for comparisons

	operands: like operands_of_feature
			-- Operands of `feature_'

	find (a_expression: EPA_EXPRESSION; a_class: CLASS_C; a_feature: FEATURE_I; a_for_reference: BOOLEAN)
			-- Find operand comparisons
		do
			create last_comparisons.make
			create last_feature_value_comparisons.make
			class_ := a_class
			feature_ := a_feature
			operands := operands_of_feature (a_feature)
			expression := a_expression
			is_for_reference_comparison := a_for_reference
--			if attached {BIN_EQ_AS} a_expression.ast as l_equation and then attached {BOOL_AS} l_equation.right then
--				l_equation.left.process (Current)
--			else
				a_expression.ast.process (Current)
--			end
		end

	comparison_from_left_and_right (a_left: EXPR_AS; a_right: EXPR_AS): detachable TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION; is_pure_operand: BOOLEAN]
			-- Comaprison from `a_left' and `a_right' if they are inside `operands',
			-- otherwise, return Void.
		local
			l_left, l_right: STRING
			l_left_expr, l_right_expr: EPA_AST_EXPRESSION
			l_left_ast, l_right_ast: EXPR_AS
		do
			l_left_ast := ast_without_surrounding_paranthesis (a_left)
			l_right_ast := ast_without_surrounding_paranthesis (a_right)
			l_left := text_from_ast (l_left_ast)
			l_right := text_from_ast (l_left_ast)
			create l_left_expr.make_with_feature (class_, feature_, l_left_ast, class_)
			create l_right_expr.make_with_feature (class_, feature_, l_right_ast, class_)

			if operands.has (l_left) and operands.has (l_right) then
				Result := [l_left_expr, l_right_expr, True]
			else
				if
					(operands.has (l_left) or attached {EXPR_CALL_AS} l_left) and
					(operands.has (l_right) or attached {EXPR_CALL_AS} l_right)
				then
					Result := [l_left_expr, l_right_expr, False]
				end
			end
		end

feature{NONE} -- Implementation/Process

	process_bin_eq_as (l_as: BIN_EQ_AS)
		local
			l_done: BOOLEAN
			l_comp: like comparison_from_left_and_right
		do
			if is_for_reference_comparison then
				l_comp := comparison_from_left_and_right (l_as.left, l_as.right)
				if l_comp /= Void then
					l_done := True
					if l_comp.is_pure_operand then
						last_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					else
						last_feature_value_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					end
				end
			end
			if not l_done then
				process_binary_as (l_as)
			end
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		local
			l_done: BOOLEAN
			l_comp: like comparison_from_left_and_right
		do
			if is_for_reference_comparison then
				l_comp := comparison_from_left_and_right (l_as.left, l_as.right)
				if l_comp /= Void then
					l_done := True
					if l_comp.is_pure_operand then
						last_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					else
						last_feature_value_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					end
				end
			end
			if not l_done then
				process_binary_as (l_as)
			end
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		local
			l_done: BOOLEAN
			l_comp: like comparison_from_left_and_right
		do
			if not is_for_reference_comparison then
				l_comp := comparison_from_left_and_right (l_as.left, l_as.right)
				if l_comp /= Void then
					l_done := True
					if l_comp.is_pure_operand then
						last_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					else
						last_feature_value_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					end
				end
			end
			if not l_done then
				process_binary_as (l_as)
			end
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		local
			l_done: BOOLEAN
			l_comp: like comparison_from_left_and_right
		do
			if not is_for_reference_comparison then
				l_comp := comparison_from_left_and_right (l_as.left, l_as.right)
				if l_comp /= Void then
					l_done := True
					if l_comp.is_pure_operand then
						last_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					else
						last_feature_value_comparisons.extend ([l_comp.expression1, l_comp.expression2])
					end
				end
			end
			if not l_done then
				process_binary_as (l_as)
			end
		end

end
