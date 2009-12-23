note
	description: "Summary description for {AFX_INTERPRETER_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INTERPRETER_CONSTANTS

feature -- Access

	request_exit_type: NATURAL_32 = 1
			-- Type id of an exit request

	request_execute_test_case_type: NATURAL_32 = 2
			-- Type id of an execute test case request

	request_melt_feature_type: NATURAL_32 = 3
			-- Type id of an melt feature request

end
