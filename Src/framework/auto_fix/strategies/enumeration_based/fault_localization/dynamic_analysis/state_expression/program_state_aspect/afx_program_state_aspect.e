note
	description: "Summary description for {AFX_PROGRAM_STATE_ASPECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_PROGRAM_STATE_ASPECT

inherit

	EPA_AST_EXPRESSION

feature -- Basic operation

	evaluate (a_state: EPA_STATE)
			-- Evaluate current program state aspect regarding `a_state',
			--		and make the evaluation result available in `last_result'.
		require
			state_attached: a_state /= Void
		deferred
		end

	derived_change_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- Requirements about how to change the state to make the
			-- aspect evaluate to `a_result'.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Access

	last_value: EPA_EXPRESSION_VALUE
			-- Value of current program state aspect from last evaluation.

	operand_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions used as operands to construct the aspect.

feature{NONE} -- Implementation

	change_requirements_for_one_boolean_expression (a_exp1: EPA_EXPRESSION): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- Generate change requirements for one boolean expression.
		require
			expression_attached: a_exp1 /= Void
			boolean_expression: a_exp1.type.is_boolean
		local
			l_target_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_new_expr: EPA_AST_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
			l_target: AFX_FIXING_TARGET
		do
			create Result.make (2)
			create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, "not (" + a_exp1.text + ")", a_exp1.written_class)
			create l_requirement.make (a_exp1, l_new_expr)
			Result.force_last (l_requirement)

			create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, "False", a_exp1.written_class)
			create l_requirement.make (a_exp1, l_new_expr)
			Result.force_last (l_requirement)
		end


end
