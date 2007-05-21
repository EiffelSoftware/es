indexing
	description: "[
				Represents an entity of a non_basic type.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	NON_BASIC_ENTITY

inherit
	ENTITY
		rename
			resolve as accept
		end

create
	make

feature -- Creation

	make (a_type: STRING; an_id: INTEGER)
			-- Create a stub object with id `an_id'
			-- and type `a_type'
		do
			id := an_id
			type := a_type
		end

feature -- Access

	id: INTEGER
		-- Object ID of the entity

feature -- Basic operations

	accept(resolver: ENTITY_VISITOR): ANY is
			-- Resolve this entity
		do
			Result := resolver.visit_non_basic_entity(Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
