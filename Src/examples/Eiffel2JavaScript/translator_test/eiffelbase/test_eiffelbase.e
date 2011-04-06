class
	TEST_EIFFELBASE

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			l_test: TEST
		do
			create {TEST_ARRAY}l_test.make
			create {TEST_STRING}l_test.make
			create {TEST_LIST}l_test.make
			create {TEST_HASH_TABLE}l_test.make
			create {TEST_SET}l_test.make
		end

end
