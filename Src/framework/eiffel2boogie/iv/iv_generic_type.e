note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_GENERIC_TYPE

inherit

	IV_TYPE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize generic type.
		do
			is_boolean := True
			is_integer := True
			is_real := True
			is_reference := True
			is_type := True
			is_heap := True
			is_map := True
		end

feature -- Visitor

	process (a_visitor: IV_TYPE_VISITOR)
			-- Process type.
		do
			a_visitor.process_generic_type (Current)
		end

feature -- Equality

	is_same_type (a_other: IV_TYPE): BOOLEAN
			-- Is `a_other' same type as this?
		do
			Result := True
		end

end
