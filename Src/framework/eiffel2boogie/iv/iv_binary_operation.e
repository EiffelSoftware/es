note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_BINARY_OPERATION

inherit

	IV_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_left: IV_EXPRESSION; a_operator: STRING; a_right: IV_EXPRESSION; a_type: IV_TYPE)
			-- Initialize binary operation.
		require
			a_left_attached: attached a_left
			a_operator_attached: attached a_operator
			a_operator_valid: True -- TODO
			a_right_attached: attached a_right
			a_type_valid: True -- TODO
		do
			left := a_left
			operator := a_operator.twin
			right := a_right
			type := a_type
		ensure
			left_set: left = a_left
			operator_set: operator ~ a_operator
			right_set: right = a_right
		end

feature -- Access

	type: IV_TYPE
			-- <Precursor>

	operator: STRING
			-- Operator represented as a string.

	left: IV_EXPRESSION
			-- Left expression.

	right: IV_EXPRESSION
			-- Right expression.

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_binary_operation (Current)
		end

invariant
	left_attached: attached left
	right_attached: attached right
	operator_attached: attached operator

end
