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
