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

	derived_change_requirements (a_result: BOOLEAN): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
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

	change_requirements_for_two_integer_expression (a_exp1, a_exp2: EPA_EXPRESSION): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- Change requirements for two integer expressions.
		require
			exps_attached: a_exp1 /= Void and then a_exp2 /= Void
			integer_type: a_exp1.type.is_integer and then a_exp2.type.is_integer
		local
			l_new_expr: EPA_AST_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
			l_requirements: DS_LINKED_LIST[TUPLE[expr1: EPA_EXPRESSION; expr2: EPA_EXPRESSION]]
		do
			create l_requirements.make
			create Result.make (16)

			if not a_exp2.is_constant then
					-- Change the second expression alone.
				create l_new_expr.make_with_text (a_exp2.class_, a_exp2.feature_, a_exp2.text + " + 1", a_exp2.written_class)
				l_requirements.force_last ([a_exp2, l_new_expr])

				create l_new_expr.make_with_text (a_exp2.class_, a_exp2.feature_, a_exp2.text + " - 1", a_exp2.written_class)
				l_requirements.force_last ([a_exp2, l_new_expr])

					-- Change the second according to the first.
				create l_new_expr.make_with_text (a_exp2.class_, a_exp2.feature_, a_exp1.text, a_exp2.written_class)
				l_requirements.force_last ([a_exp2, l_new_expr])

				create l_new_expr.make_with_text (a_exp2.class_, a_exp2.feature_, a_exp1.text + " + 1", a_exp2.written_class)
				l_requirements.force_last ([a_exp2, l_new_expr])

				create l_new_expr.make_with_text (a_exp2.class_, a_exp2.feature_, a_exp1.text + " - 1", a_exp2.written_class)
				l_requirements.force_last ([a_exp2, l_new_expr])
			end

			if not a_exp1.is_constant then
					-- Change the first expression alone.
				create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, a_exp1.text + " + 1", a_exp1.written_class)
				l_requirements.force_last ([a_exp1, l_new_expr])

				create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, a_exp1.text + " - 1", a_exp1.written_class)
				l_requirements.force_last ([a_exp1, l_new_expr])

					-- Change the first according to the second.
				create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, a_exp2.text, a_exp1.written_class)
				l_requirements.force_last ([a_exp1, l_new_expr])

				create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, a_exp2.text + " + 1", a_exp1.written_class)
				l_requirements.force_last ([a_exp1, l_new_expr])

				create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, a_exp2.text + " - 1", a_exp1.written_class)
				l_requirements.force_last ([a_exp1, l_new_expr])

			end

				-- Put the change requirements into the list of requirements.
			from l_requirements.start
			until l_requirements.after
			loop
				create l_requirement.make (l_requirements.item_for_iteration.expr1, l_requirements.item_for_iteration.expr2)
				Result.force_last (l_requirement)

				l_requirements.forth
			end
		end

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
			create Result.make (3)
			create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, "not (" + a_exp1.text + ")", a_exp1.written_class)
			create l_requirement.make (a_exp1, l_new_expr)
			Result.force_last (l_requirement)

			create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, "True", a_exp1.written_class)
			create l_requirement.make (a_exp1, l_new_expr)
			Result.force_last (l_requirement)

			create l_new_expr.make_with_text (a_exp1.class_, a_exp1.feature_, "False", a_exp1.written_class)
			create l_requirement.make (a_exp1, l_new_expr)
			Result.force_last (l_requirement)
		end


end
