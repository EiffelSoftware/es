note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	MONGODB_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_default_cursor
			-- New test routine
		local
			l_cursor: MONGODB_CURSOR
			l_error: BSON_ERROR
		do
			create l_cursor.make_default
			l_error := l_cursor.cursor_error
			assert ("Expected error", l_error /= Void)
		end

end


