indexing
	description: "[
			Represents an entity of basic type for the replay phase.
			]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	BASIC_ENTITY


inherit
	ENTITY

create
	make

feature -- Creation

	make (a_type: STRING; a_value: STRING)

		do
			type := a_type
			value := a_value
		end

feature -- Access

	value: STRING

	represents_void: BOOLEAN is False

feature -- Basic operations

	resolve(resolver: ENTITY_VISITOR): ANY is
			-- Resolve this basic entity
		do
			Result := resolver.visit_basic_entity(Current)
		end

invariant
	invariant_clause: True -- Your invariant here

end
