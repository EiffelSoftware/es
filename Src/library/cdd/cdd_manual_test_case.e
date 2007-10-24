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
		rename
			tear_down as do_nothing
		end

feature

end
