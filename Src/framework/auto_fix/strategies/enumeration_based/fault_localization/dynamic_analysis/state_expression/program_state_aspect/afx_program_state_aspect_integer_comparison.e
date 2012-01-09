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

	make_comparison (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_written_class: CLASS_C;
					a_left_operand, a_right_operand: EPA_EXPRESSION; a_operator: INTEGER)
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

			create operand_expressions.make_equal (2)
			operand_expressions.force (left_operand)
			operand_expressions.force (right_operand)

			l_exp_text := "(" + left_operand.text + ") " + operator_text (operator) + " (" + right_operand.text + ")"
			make_with_text (a_context_class, a_context_feature, l_exp_text, a_written_class)
		end

feature -- Basic operation

	negation: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
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
			l_left := left_operand
			l_right := right_operand
			create l_requirements.make
			create Result.make (16)

			create l_increase_list.make (2)
			create l_decrease_list.make (2)
			create l_equal_list.make (2)
			if operator = Operator_integer_ne then
				l_equal_list.force_last ([l_left, l_right])
				l_equal_list.force_last ([l_right, l_left])
			elseif operator = Operator_integer_eq then
				l_increase_list.force_last ([l_left, l_right])
				l_increase_list.force_last ([l_right, l_left])
				l_decrease_list.force_last ([l_left, l_right])
				l_decrease_list.force_last ([l_right, l_left])
			elseif operator = Operator_integer_gt then
				l_decrease_list.force_last ([l_left, l_right])
				l_increase_list.force_last ([l_right, l_left])
				l_equal_list.force_last ([l_left, l_right])
				l_equal_list.force_last ([l_right, l_left])
			elseif operator = Operator_integer_ge then
				l_decrease_list.force_last ([l_left, l_right])
				l_increase_list.force_last ([l_right, l_left])
			elseif operator = Operator_integer_lt then
				l_increase_list.force_last ([l_left, l_right])
				l_decrease_list.force_last ([l_right, l_left])
				l_equal_list.force_last ([l_left, l_right])
				l_equal_list.force_last ([l_right, l_left])
			elseif operator = Operator_integer_le then
				l_increase_list.force_last ([l_left, l_right])
				l_decrease_list.force_last ([l_right, l_left])
			end

			from l_increase_list.start
			until l_increase_list.after
			loop
				l_target := l_increase_list.item_for_iteration.target
				l_relative := l_increase_list.item_for_iteration.relative

				if not l_target.is_constant then
					create l_new_expr.make_with_text (l_target.class_, l_target.feature_, l_target.text + " + 1", l_target.written_class)
					Result.force_last (create {AFX_STATE_CHANGE_REQUIREMENT}.make(l_target, l_new_expr))
					create l_new_expr.make_with_text (l_target.class_, l_target.feature_, l_relative.text + " + 1", l_target.written_class)
					Result.force_last (create {AFX_STATE_CHANGE_REQUIREMENT}.make(l_target, l_new_expr))
				end

				l_increase_list.forth
			end

			from l_decrease_list.start
			until l_decrease_list.after
			loop
				l_target := l_decrease_list.item_for_iteration.target
				l_relative := l_decrease_list.item_for_iteration.relative

				if not l_target.is_constant then
					create l_new_expr.make_with_text (l_target.class_, l_target.feature_, l_target.text + " - 1", l_target.written_class)
					Result.force_last (create {AFX_STATE_CHANGE_REQUIREMENT}.make(l_target, l_new_expr))
					create l_new_expr.make_with_text (l_target.class_, l_target.feature_, l_relative.text + " - 1", l_target.written_class)
					Result.force_last (create {AFX_STATE_CHANGE_REQUIREMENT}.make(l_target, l_new_expr))
				end

				l_decrease_list.forth
			end

			from l_equal_list.start
			until l_equal_list.after
			loop
				l_target := l_equal_list.item_for_iteration.target
				l_relative := l_equal_list.item_for_iteration.relative

				if not l_target.is_constant then
					create l_new_expr.make_with_text (l_target.class_, l_target.feature_, l_relative.text, l_target.written_class)
					Result.force_last (create {AFX_STATE_CHANGE_REQUIREMENT}.make(l_target, l_new_expr))
				end

				l_equal_list.forth
			end

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
	operator_valid: is_valid_integer_comparison (operator)

end
