note
	description: "Summary description for {AFX_EIFFEL_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EIFFEL_PARSER

inherit
	EIFFEL_PARSER
		redefine
			ast_factory
		end

create
	make_with_factory

feature -- Factory

	ast_factory: AFX_EXPRESSION_AST_FACTORY
			-- Abstract Syntax Tree factory

feature -- Status report

	has_old_expression: BOOLEAN
			-- Does parsed string contain old expression?
		do
			Result := ast_factory.has_old_expression
		end

feature -- Setting

	set_has_old_expression (b: BOOLEAN)
			-- Set `has_old_expression' with `b'.
		do
			ast_factory.set_has_old_expression (b)
		end

end
