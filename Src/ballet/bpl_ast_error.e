indexing
	description: "An error associated with an ast node, reported by Ballet"
	author: "Bernd Schoeller and others"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_AST_ERROR

inherit
	BPL_ERROR

create
	make_ast

feature{NONE} -- Initialization

	make_ast (a_text: STRING; an_ast: AST_EIFFEL) is
			-- Create an error message with `a_text' as message and 
			-- an_ast as associated ast node, which is the source of the 
			-- error
		do
			make(a_text)
			ast := an_ast
		ensure
			text_set: message = a_text
			ast_set: ast = an_ast			 
		end

feature -- Access

	ast: AST_EIFFEL
			-- associated ast node

end
