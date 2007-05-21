indexing
	description: "Visitor for entities."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_VISITOR

feature -- Basic operations

	visit_basic_entity(basic: BASIC_ENTITY): ANY is
			-- Visit a basic entity
		require
			basic_not_void: basic /= Void
		deferred end

	visit_non_basic_entity(non_basic: NON_BASIC_ENTITY):ANY is
			-- Visit a non-basic entity
		require
			non_basic_not_void: non_basic /= Void
		deferred end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
