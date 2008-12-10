indexing
	description: "Summary description for {ITP_REQUEST_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_SHARED_CONSTANTS

feature -- Access

	start_request_flag: NATURAL_8 is 1
			-- Flag for "start" request

	quit_request_flag: NATURAL_8 is 2
			-- Flag for "quit" request

	execute_request_flag: NATURAL_8 is 3
			-- Flag for "execute" request

	type_request_flag: NATURAL_8 is 4
			-- Flag for "type" request

	response_starter_flag: NATURAL_8 is 1
			-- Flag to indicate that raw response is followed.
			-- Used in socket IPC.

feature -- SATS project

	sat_real_test_case_request_flag: NATURAL_16 is 1
			-- Flag to indicate that a test request a real test case request,
			-- A real test case request is the request to test some feature,
			-- a non-real test case request can be a request to retrieve the status of an object.

end
