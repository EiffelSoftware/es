note
	description: "Summary description for {AFX_FIXING_OPERATION_ON_INTEGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_OPERATION_ON_INTEGER

inherit

	AFX_FIXING_OPERATION

create
	make

feature{NONE} -- Initialization

	make (a_target: AFX_FIXING_TARGET; a_expression: AFX_PROGRAM_STATE_EXPRESSION; a_type: INTEGER)
			-- Initialization.
		require
			is_valid_type_for_integer (a_type)
		do
			fixing_target := a_target

			create target_expressions.make (1)
			target_expressions.set_equality_tester (program_state_expression_equality_tester)
			target_expressions.force (a_expression)

			type := a_type
		end

feature -- Access

	operation_text: STRING
			-- <Precursor>
		local
			l_expr_text: STRING
		do
			l_expr_text := target_expressions.first.text
			Result := operation_text_template
			Result.replace_substring_all ("{1}", l_expr_text)
		end

invariant

	one_target_expression: target_expressions /= Void and then target_expressions.count = 1
	integer_target_expression: target_expressions.first.type.is_integer

end
