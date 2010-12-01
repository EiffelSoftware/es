note
	description: "Summary description for {AFX_FIXING_OPERATION_ON_INTEGERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_OPERATION_ON_INTEGERS

inherit
	AFX_FIXING_OPERATION

create
	make

feature{NONE} -- Initialization

	make (a_target: AFX_FIXING_TARGET; a_expr1, a_expr2: AFX_PROGRAM_STATE_EXPRESSION; a_type: INTEGER)
			-- Initialization.
		require
			is_valid_type_for_integers (a_type)
		do
			fixing_target := a_target

			create target_expressions.make (2)
			target_expressions.set_equality_tester (program_state_expression_equality_tester)
			target_expressions.force_last (a_expr1)
			target_expressions.force_last (a_expr2)

			type := a_type
		end

feature -- Access

	feature_to_call: FEATURE_I
			-- Feature to be called on the target expression.

	operation_text: STRING
			-- <Precursor>
		local
			l_expr1_text, l_expr2_text: STRING
		do
			l_expr1_text := target_expressions.first.text
			l_expr2_text := target_expressions.last.text

			Result := operation_text_template
			Result.replace_substring_all ("{1}", l_expr1_text)
			Result.replace_substring_all ("{2}", l_expr2_text)
		end

invariant

	two_target_expressions: target_expressions /= Void and then target_expressions.count = 2
	integer_target_expressions: target_expressions.first.type.is_integer and then target_expressions.last.type.is_integer

end
