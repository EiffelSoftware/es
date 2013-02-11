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
		redefine
			type
		end

create
	make

feature {NONE} -- Initialization

	make (a_heap_name: STRING; a_object: IV_EXPRESSION; a_field: IV_EXPRESSION)
			-- Initialize heap access.
		local
			l_entity: IV_ENTITY
		do
			create l_entity.make (a_heap_name, types.heap_type)
			make_two (l_entity, a_object, a_field)
		end

feature -- Access

	type: IV_TYPE
			-- <Precursor>.
		do
			if attached {IV_FIELD_TYPE} indexes.i_th (2).type as l_field then
				Result := l_field.content_type
			else
				Result := types.generic_type
			end
		end

end
