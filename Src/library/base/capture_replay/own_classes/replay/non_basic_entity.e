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

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
