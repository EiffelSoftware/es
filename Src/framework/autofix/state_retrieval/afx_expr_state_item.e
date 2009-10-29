note
	description: "State item based on an expression AST node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPR_STATE_ITEM

inherit
	AFX_STATE_ITEM

feature -- Access

	expression: EXPR_AS
			-- Expression AST node of current item

feature -- Setting

	set_expression (a_expression: like expression)
			-- Set `expression' with `a_expression'.
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end
end
