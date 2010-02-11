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

	make (a_uuid: like test_case_uuid; a_retrieve_post_state: BOOLEAN)
			-- Initialize Current.
		require
			a_uuid_attached: a_uuid /= Void
			not_a_uuid_is_empty: not a_uuid.is_empty
		do
			test_case_uuid := a_uuid.twin
			should_retrieve_post_state := a_retrieve_post_state
		end

feature -- Access

	test_case_uuid: STRING
			-- Universal identifier of the test case to be executed

feature -- Status report

	should_retrieve_post_state: BOOLEAN
			-- Should state be retrieved after executing the test case?

end
