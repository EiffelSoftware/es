indexing
	description: "Objects that represent an abstract test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_TEST_CASE

inherit

	HASHABLE

feature -- Access

	is_set_up: BOOLEAN is
			-- Has `current' been set up yet?
		deferred
		end

	hash_code: INTEGER is
			-- Hash code value
		do
			Result := generating_type.hash_code
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
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant

end
