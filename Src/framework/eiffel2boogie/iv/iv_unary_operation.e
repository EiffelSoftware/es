note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_UNARY_OPERATION
inherit

	IV_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_operator: STRING; a_expression: IV_EXPRESSION; a_type: IV_TYPE)
			-- Initialize unary operation.
		require
			a_operator_attached: attached a_operator
			a_operator_valid: True -- TODO
			a_expression_attached: attached a_expression
			a_type_valid: True -- TODO
		do
			operator := a_operator.twin
			expression := a_expression
			type := a_type
		ensure
			operator_set: operator ~ a_operator
			expression_set: expression = a_expression
		end

feature -- Access

	type: IV_TYPE
			-- <Precursor>

	operator: STRING
			-- Operator represented as a string.

	expression: IV_EXPRESSION
			-- Unary expression.

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_unary_operation (Current)
		end

invariant
	expression_attached: attached expression
	operator_attached: attached operator

end
