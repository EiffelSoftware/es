note
	description: "Summary description for {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON

inherit
	AFX_PROGRAM_STATE_ASPECT

	AFX_INTEGER_COMPARISON_OPERATOR

create
	make_comparison

feature{NONE} -- Initialization

	make_comparison (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_written_class: CLASS_C; a_bp_index: INTEGER;
					a_left_operand, a_right_operand: AFX_PROGRAM_STATE_EXPRESSION; a_operator: INTEGER)
			-- Initialization.
		require
			context_attached: a_context_class /= VOid and then a_context_feature /= Void and then a_written_class /= Void
			operands_type_correct: (a_left_operand /= Void and then a_left_operand.is_integer)
					and then (a_right_operand /= Void and then a_right_operand.is_integer)
			operator_valid: is_valid_integer_comparison (a_operator)
		local
			l_exp_text: STRING
		do
			left_operand := a_left_operand
			right_operand := a_right_operand
			operator := a_operator

			l_exp_text := "(" + left_operand.text + ") " + operator_text (operator) + " (" + right_operand.text + ")"
			make_with_text (a_context_class, a_context_feature, l_exp_text, a_written_class, a_bp_index)
		end

feature -- Basic operation

	evaluate (a_state: EPA_STATE)
			-- <Precursor>
		local
			l_text: STRING
			l_left_equation, l_right_equation: EPA_EQUATION
			l_left_value, l_right_value: EPA_EXPRESSION_VALUE
		do
			l_text := left_operand.text
			if l_text.is_integer then
				create {EPA_INTEGER_VALUE} l_left_value.make (l_text.to_integer)
			elseif attached a_state.item_with_expression_text (l_text) as lt_left_equation then
				l_left_value := lt_left_equation.value
			end

			l_text := right_operand.text
			if l_text.is_integer then
				create {EPA_INTEGER_VALUE} l_right_value.make (l_text.to_integer)
			elseif attached a_state.item_with_expression_text (l_text) as lt_right_equation then
				l_right_value := lt_right_equation.value
			end

			last_value := evaluate_integer_comparison (l_left_value, l_right_value, operator)
		end

feature -- Access

	left_operand: AFX_PROGRAM_STATE_EXPRESSION
			-- Expression appearing to the left of the operator.

	right_operand: AFX_PROGRAM_STATE_EXPRESSION
			-- Expression appearing to the right of the operator.

	operator: INTEGER
			-- Operator used to compare the two operands.

invariant

	operands_attached: left_operand /= Void and then right_operand /= Void
	operator_valid: is_valid_integer_comparison (operator)

end
