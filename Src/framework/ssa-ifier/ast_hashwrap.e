note
	description: "Summary description for {AST_HASHWRAP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AST_HASHWRAP

inherit
	HASHABLE
		redefine
			is_equal
		end


create
	make

feature
	make (a_ast: AST_EIFFEL)
		do
			ast := a_ast
		end

	ast: AST_EIFFEL

	hash_code: INTEGER
		do
			Result := ast.start_position.hash_code
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := ast.start_position = other.ast.start_position and
			          ast.end_position = other.ast.end_position
		end

end
