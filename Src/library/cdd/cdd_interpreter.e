indexing
	description: "[
			Objects that run test cases and print testing result
			to console. Descendants of this class should be used
			as the root class of some target.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_INTERPRETER

inherit

	EXCEPTIONS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make is
			-- Run `test_case' and report testing results.
		do
			initialize_test_case

--			if F then
--				io.put_string ("Test failed:!%N")
--				io.put_string ("Reason: " + l_executor.reason.out)
--				io.put_string ("%NMessage: " + l_executor.message)
--				die (30)
--			else
--				io.put_string ("Test succeeded%N")
--			end
		end

feature -- Access

	test_case: CDD_ABSTRACT_TEST_CASE
			-- Test case to be tested

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	initialize_test_case is
			-- Initialize `test_case'.
		deferred
		ensure
			test_case_not_void: test_case /= Void
		end


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
