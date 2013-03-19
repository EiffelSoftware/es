note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_QUANTIFIER

inherit

	IV_EXPRESSION

	IV_SHARED_TYPES

feature {NONE} -- Initialization

	make (a_expression: IV_EXPRESSION)
			-- Initialize quantifier with expression `a_expression'.
		require
			a_expression_attached: attached a_expression
			a_expression_valid: a_expression.type = types.bool
		do
			expression := a_expression
			create bound_variables.make
			create triggers.make
		end

feature -- Access

	expression: IV_EXPRESSION
			-- Forall expression.

	bound_variables: LINKED_LIST [IV_ENTITY_DECLARATION]
			-- List of bound variables.

	triggers: LINKED_LIST [IV_EXPRESSION]
			-- List of triggers.

	type: IV_TYPE
			-- <Precursor>
		once
			Result := types.bool
		end

feature -- Element change

	add_bound_variable (a_name: STRING; a_type: IV_TYPE)
			-- Add a bound variable with name `a_name' and type `a_type'.
		do
			bound_variables.extend (create {IV_ENTITY_DECLARATION}.make (a_name, a_type))
		end

	add_trigger (a_expr: IV_EXPRESSION)
			-- Add `a_expr' to triggers for this quantifier.
		require
			a_expr_attached: attached a_expr
		do
			triggers.extend (a_expr)
		end

invariant
	expression_attached: attached expression
	expression_valid: expression.type = types.bool
	bound_variables_attached: attached bound_variables
	bound_variables_valid: across bound_variables as i all i.item.property = Void end
	type_valid: type = types.bool

end
