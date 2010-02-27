note
	description: "Summary description for {AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER

inherit
	EPA_EXPRESSION_STRUCTURE_ANALYZER

	REFACTORING_HELPER

	AST_ITERATOR
		redefine
			process_bin_or_as,
			process_bin_or_else_as,
			process_bin_implies_as,
			process_bin_xor_as,
			process_result_as,
			process_current_as,
			process_void_as,
			process_bool_as,
			process_create_creation_expr_as,
			process_nested_as,
			process_nested_expr_as,
			process_access_feat_as,
			process_precursor_as
		end

feature -- Basic operations

	analyze (a_expression: EPA_EXPRESSION)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches current analyzer.
			-- Only matched a linearly constrained expression
		do
			create constraints.make (a_expression)
			class_ := a_expression.class_
			feature_ := a_expression.feature_
			written_class := a_expression.written_class
			is_matched := True

			safe_process (a_expression.ast)
		end

feature -- Access

	constraints: EPA_NUMERIC_CONSTRAINTS
			-- Numeric constraints found in the last `analyze'

feature{NONE} -- Implementation

	class_: CLASS_C
			-- Context class

	feature_: detachable FEATURE_I
			-- Feature under from which the last analyzed expression comes

	written_class: CLASS_C
			-- Written class of the last analyzed expression

feature{NONE} -- Processing

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			is_matched := False
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			is_matched := False
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			is_matched := False
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			is_matched := False
		end

	process_result_as (l_as: RESULT_AS)
		do
			check_expression (new_expression (l_as))
		end

	process_current_as (l_as: CURRENT_AS)
		do
			is_matched := False
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			is_matched := False
		end

	process_void_as (l_as: VOID_AS)
		do
			is_matched := False
		end

	process_bool_as (l_as: BOOL_AS)
		do
			is_matched := False
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			is_matched := False
		end

	process_nested_as (l_as: NESTED_AS)
		do
			check_expression (new_expression (l_as))
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			check_expression (new_expression (l_as))
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			check_expression (new_expression (l_as))
		end

feature -- Visitor

	process (a_visitor: EPA_EXPRESSION_STRUCTURE_ANALYZER_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_linear_constrained_structure_analyzer (Current)
		end

feature{NONE} -- Implementation

	new_expression (a_ast: AST_EIFFEL): EPA_EXPRESSION
			-- Expression from `a_ast'
		do
			create {EPA_AST_EXPRESSION} Result.make_with_text (class_, feature_, text_from_ast (a_ast), written_class)
		end

	check_expression (a_expr: EPA_EXPRESSION)
			-- Check if `a_expr' is of type integer, if so, added into `components' and `occurrence_frequency'.
			-- Otherwise, set `is_matched' to False.
		do
			if attached {TYPE_A} a_expr.type as l_type and then l_type.is_integer then
				constraints.increase_occurrence_frequency (a_expr, 1)
			else
				is_matched := False
			end
		end

end
