indexing
	description: "Objects that represent an abstract test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_TEST_CASE

feature -- Access

	is_set_up: BOOLEAN is
			-- Has `current' been set up yet?
		deferred
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

	set_up is
			-- Initialize required state for running `Current'.
		deferred
		ensure
			set_up: is_set_up
		end

	tear_down is
			-- Tear down any remaining state used to run `Current'.
		require
			set_up: is_set_up
		deferred
		ensure
			not_set_up: not is_set_up
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant

end
