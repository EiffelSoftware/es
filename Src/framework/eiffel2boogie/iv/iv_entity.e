note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_ENTITY

inherit

	IV_EXPRESSION

inherit {NONE}

	IV_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_type: IV_TYPE)
			-- Initialize with name `a_name' and type `a_type'.
		require
			a_name_valid: is_valid_name (a_name)
		do
			name := a_name.twin
			type := a_type
		ensure
			name_set: name ~ a_name
			type_set: type = a_type
		end

feature -- Access

	name: STRING
			-- Name of entity.

	type: IV_TYPE
			-- Type of entity.

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_entity (Current)
		end

invariant
	valid_name: is_valid_name (name)

end
