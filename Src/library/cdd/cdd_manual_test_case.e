indexing
	description: "[
			Objects that represent manuel test cases.
			Features in descendants of CDD_MANUAL_TEST_CASE which
			are prefixed with test_ are considered to be test routines.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_MANUAL_TEST_CASE

inherit

	CDD_ABSTRACT_TEST_CASE

feature -- Access

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
