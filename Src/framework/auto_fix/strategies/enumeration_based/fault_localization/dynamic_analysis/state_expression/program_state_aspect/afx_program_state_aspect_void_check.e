note
	description: "Summary description for {AFX_PROGRAM_STATE_ASPECT_VOID_CHECK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_ASPECT_VOID_CHECK

inherit
	AFX_PROGRAM_STATE_ASPECT

	AFX_VOID_CHECK_OPERATOR

create
	make_void_check

feature{NONE} -- Initialization

	make_void_check (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_written_class: CLASS_C; a_reference: EPA_EXPRESSION; a_equality_operator: INTEGER)
			-- Initialization.
		require
			context_attached: a_context_class /= Void and then a_context_feature /= Void and then a_written_class /= Void
			operands_type_correct: True-- Reference type.
			is_valid_void_check_operator: is_valid_void_check_operator (a_equality_operator)
		local
			l_exp_text: STRING
		do
			operand := a_reference
			operator := a_equality_operator

			create operand_expressions.make_equal (1)
			operand_expressions.force (operand)

			l_exp_text := "(" + a_reference.text + ")" + void_check_operator_text (a_equality_operator) + "Void"
			make_with_text (a_context_class, a_context_feature, l_exp_text, a_written_class)
		end

feature -- Basic operation

	evaluate (a_state: EPA_STATE)
			-- <Precursor>
		local
			l_value: EPA_EXPRESSION_VALUE
		do
			if attached {EPA_EQUATION} a_state.item_with_expression_text (operand.text) as lt_equation then
				l_value := lt_equation.value
			end

			last_value := evaluate_void_check (l_value, operator)
		end

	derived_change_requirements (a_result: BOOLEAN): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- <Precursor>
		do
			Result := change_requirements_for_one_boolean_expression (Current)
		end

feature -- Access

	operand: EPA_EXPRESSION
			-- Expression to compare with "Void".

	operator: INTEGER
			-- Operator used to compare with "Void".
end
