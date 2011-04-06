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
		end

end
