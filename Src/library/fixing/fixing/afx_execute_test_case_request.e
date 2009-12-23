note
	description: "Summary description for {AFX_EXECUTE_TEST_CASE_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXECUTE_TEST_CASE_REQUEST

inherit
	AFX_INTERPRETER_REQUEST

create
	make

feature{NONE} -- Initialization

	make (a_uuid: like test_case_uuid)
			-- Initialize Current.
		require
			a_uuid_attached: a_uuid /= Void
			not_a_uuid_is_empty: not a_uuid.is_empty
		do
			test_case_uuid := a_uuid.twin
		end

feature -- Access

	test_case_uuid: STRING
		-- Universal identifier of the test case to be executed

end
