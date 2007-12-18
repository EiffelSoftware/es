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
		redefine
			set_up,
			tear_down
		end

feature -- Basic operations

	set_up is
			-- Initialize required state for running `Current'.
			-- Redefine in descendats to provide custom setup.
		do
		end

	tear_down is
			-- Tear down any remaining state used to run `Current'.
			-- Redefine in descendats to provide custom teardown.
		do
		end
end
