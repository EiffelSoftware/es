note
	description: "Summary description for {PS_DADL_FORMAT}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_DADL_FORMAT

inherit
	PS_FORMAT redefine default_create end

feature {NONE} -- Initialization

	default_create
	do
		precursor
		representation := ""
	end


	make
			-- Initialization for `Current'.
		do
		end

feature -- Access

	representation: STRING_32
			-- Last object representation computed.

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
			-- Compute `an_obj' representation in dADL format. Update `representation'.
		do
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
