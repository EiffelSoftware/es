note
	description: "Summary description for {AFX_HASHABLE_AST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_HASHABLE_AST

inherit
	HASHABLE
		redefine
			is_equal
		end

	SHARED_SERVER
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_ast: like ast; a_written_class: like written_class)
			-- Initialize Current.
		do
			ast := a_ast
			written_class := a_written_class
		ensure
			ast_set: ast = a_ast
			written_class_set: written_class = a_written_class
		end

feature -- Access

	written_class: CLASS_C
			-- Class where the `ast' from which `hash_code' is calculated
			-- is written

	ast: AST_EIFFEL
			-- AST node

feature -- Access

	hash_code: INTEGER is
			-- Hash code for `v'
		do
			Result := ast.first_token (match_list_server.item (written_class.class_id)).position
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				(written_class.class_id = other.written_class.class_id) and then
				hash_code = other.hash_code
		end

end
