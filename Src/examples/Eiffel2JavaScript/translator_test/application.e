note
	description : "Test the JavaScript compiler"
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	JS_OBJECT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			run_tests
		end

feature {NONE} -- Implementation

	run_tests
		local
			l_test: TEST
		do
			create {TEST_ASSERTIONS}l_test.make
			create {TEST_OBJECT_TESTS}l_test.make
			create {TEST_RESCUE}l_test.make
			create {TEST_INVARIANT}l_test.make
			create {TEST_OLD}l_test.make
			create {TEST_PRECURSOR}l_test.make
			create {TEST_RENAME}l_test.make
			create {TEST_REDEFINE}l_test.make
			create {TEST_AGENTS}l_test.make
			create {TEST_EIFFELBASE}l_test.make
		end

end
