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

feature -- Status report

	has_free_var_named (a_name: STRING): BOOLEAN
			-- Does this expression contain a free variable with name `a_name'?
		do
			Result := expression.has_free_var_named (a_name)
		end

feature -- Comparison

	same_expression (a_other: IV_EXPRESSION): BOOLEAN
			-- Does this expression equal `a_other' (if considered in the same context)?
		do
			Result := attached {IV_UNARY_OPERATION} a_other as unop and then
				(operator ~ unop.operator and expression.same_expression (unop.expression))
		end

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
