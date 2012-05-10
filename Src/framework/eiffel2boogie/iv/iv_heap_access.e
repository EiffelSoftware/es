note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_HEAP_ACCESS

inherit

	IV_MAP_ACCESS
		rename
			make as make_map
		end

create
	make

feature {NONE} -- Initialization

	make (a_heap_name: STRING; a_object: IV_EXPRESSION; a_field: IV_EXPRESSION)
			-- Initialize heap access.
		local
			l_entity: IV_ENTITY
		do
				-- TODO: correct type
			create l_entity.make (a_heap_name, create {IV_GENERIC_TYPE}.make)
			make_two (l_entity, a_object, a_field)
		end

end
