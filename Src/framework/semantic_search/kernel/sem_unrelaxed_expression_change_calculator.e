note
	description: "Calculator to measure the change from an expression to another expression. No relaxing of integer-changes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UNRELAXED_EXPRESSION_CHANGE_CALCULATOR

inherit
	EPA_EXPRESSION_CHANGE_CALCULATOR
		redefine
			process_integer_value
		end

feature{NONE} -- Process/Data

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		local
			l_equation: detachable EPA_EQUATION
			l_delta_expr: EPA_AST_EXPRESSION
			l_change: EPA_EXPRESSION_CHANGE
			l_change_list: LINKED_LIST [EPA_EXPRESSION_CHANGE]
			l_delta: INTEGER
		do
			l_equation := source_state.item_with_expression (expression)

			if l_equation /= Void and then attached {EPA_INTEGER_VALUE} l_equation.value as l_source_value then
				l_delta := a_value.item - l_source_value.item
				if l_delta /= 0 then
					create l_change_list.make

					create l_delta_expr.make_with_text (expression.class_, expression.feature_, l_delta.out, expression.written_class)
					l_change_list.extend (new_expression_change (expression, new_single_value_change_set (l_delta_expr), True, 1.0))
					expression_change_set.force_last (l_change_list, expression)
				end
			end
		end
end
