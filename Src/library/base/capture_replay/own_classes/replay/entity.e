indexing
	description: "[
				Common interface for entities (variables&constants).
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

feature -- Access

	type: STRING

feature -- Basic operations

	resolve(resolver: ENTITY_VISITOR): ANY is
			-- Accept visitor for entity resolution.
		deferred end

	represents_void: BOOLEAN
			-- Does `entity' represent a Void?
		deferred end
invariant
	invariant_clause: True -- Your invariant here

end
