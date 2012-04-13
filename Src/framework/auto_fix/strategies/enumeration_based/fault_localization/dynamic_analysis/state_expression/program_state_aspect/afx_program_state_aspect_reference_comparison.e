note
	description: "Summary description for {AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON

inherit
	AFX_PROGRAM_STATE_ASPECT

	AFX_REFERENCE_COMPARISON_OPERATOR

create
	make_comparison

feature{NONE} -- Initialization

	make_comparison (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_written_class: CLASS_C;
					a_left_operand, a_right_operand: EPA_EXPRESSION; a_operator: INTEGER)
			-- Initialization.
		require
			context_attached: a_context_class /= VOid and then a_context_feature /= Void and then a_written_class /= Void
			operator_valid: is_valid_reference_comparison (a_operator)
		local
			l_exp_text: STRING
		do
			left_operand := a_left_operand
			right_operand := a_right_operand
			operator := a_operator

			create operand_expressions.make_equal (2)
			operand_expressions.force (left_operand)
			operand_expressions.force (right_operand)

			l_exp_text := "(" + left_operand.text + ") " + operator_text (operator) + " (" + right_operand.text + ")"
			make_with_text (a_context_class, a_context_feature, l_exp_text, a_written_class)
		end

feature -- Basic operation

	negation: AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON
			-- Negation of the current.
		do
			create Result.make_comparison (Current.context_class, Current.feature_, Current.written_class, left_operand.twin, right_operand.twin, negation_operator (operator))
		end

	evaluate (a_state: EPA_STATE)
			-- <Precursor>
		local
			l_text: STRING
			l_left_equation, l_right_equation: EPA_EQUATION
			l_left_value, l_right_value: EPA_EXPRESSION_VALUE
		do
			l_text := left_operand.text
			if attached a_state.item_with_expression_text (l_text) as lt_left_equation then
				l_left_value := lt_left_equation.value
			end

			l_text := right_operand.text
			if attached a_state.item_with_expression_text (l_text) as lt_right_equation then
				l_right_value := lt_right_equation.value
			end

			last_value := evaluate_reference_comparison (l_left_value, l_right_value, operator)
		end

	derived_change_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- <Precursor>
		local
			l_left, l_right: EPA_EXPRESSION
			l_new_expr: EPA_AST_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
			l_requirements: DS_LINKED_LIST[TUPLE[expr1: EPA_EXPRESSION; expr2: EPA_EXPRESSION]]
			l_increase_list, l_decrease_list, l_equal_list: DS_ARRAYED_LIST [TUPLE[target, relative: EPA_EXPRESSION]]
			l_target, l_relative: EPA_EXPRESSION
		do
			create Result.make (16)
		end

feature -- Access

	left_operand: EPA_EXPRESSION
			-- Expression appearing to the left of the operator.

	right_operand: EPA_EXPRESSION
			-- Expression appearing to the right of the operator.

	operator: INTEGER
			-- Operator used to compare the two operands.

invariant

	operands_attached: left_operand /= Void and then right_operand /= Void
	operator_valid: is_valid_reference_comparison (operator)


end
