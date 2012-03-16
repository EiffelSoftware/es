note
	description: "Summary description for {PS_BINARY_FORMAT}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BINARY_FORMAT

inherit

	PS_FORMAT

feature -- Access

	representation: ANY -- Return type may change
			-- Binary representation of object passed to `compute_representation'.
		do
			create Result
		end

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

	compute_representation (an_obj: ANY)
			-- Compute `an_obj' representation in current format.
		do
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
