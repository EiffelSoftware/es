indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_CLASS

create
	make

feature -- Creation
	make

		do

		end

	test_feature(object_argument: ANY; string_argument: STRING; real_argument: REAL; int_argument: INTEGER)
		do

		end

feature -- Access

	basic_field: INTEGER

	non_basic_field: EXAMPLE_CLASS

feature -- Status setting

	set_basic_field (new_value: INTEGER) is
			-- Set `basic_field' to `new_value'
		do
			basic_field := new_value
		end

	set_non_basic_field (new_value: EXAMPLE_CLASS) is
			-- Set `non_basic_field' to `new_value'
		do
			non_basic_field := new_value
		end

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
