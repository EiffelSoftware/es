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

feature -- Basic operations

	test_feature(object_argument: ANY; string_argument: STRING; real_argument: REAL; int_argument: INTEGER)
		do

		end

	set_test_attribute_basic (new_value: INTEGER) is
		do
			test_attribute_basic := new_value
		end

	set_test_attribute_non_basic (new_value: STRING) is
		do
			test_attribute_non_basic := new_value
		end

feature -- Access

	test_attribute_basic: INTEGER

	test_attribute_non_basic: STRING

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
