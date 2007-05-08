indexing
	description: "[
				Common interface for entities (variables&constants).
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY


feature -- Creation

feature -- Access

	type: STRING

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	accept(resolver: ENTITY_RESOLVER): ANY is
			-- Visitor for entity resolution.
		deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
