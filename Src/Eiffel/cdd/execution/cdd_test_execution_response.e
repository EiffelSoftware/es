indexing
	description: "Represents the outcome and log of a test case execution"
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class CDD_TEST_EXECUTION_RESPONSE

create
	make

feature {NONE} -- Initialization

	make (a_setup_response: CDD_ROUTINE_INVOCATION_RESPONSE;
			a_test_response: CDD_ROUTINE_INVOCATION_RESPONSE;
			a_teardown_response: CDD_ROUTINE_INVOCATION_RESPONSE) is
					-- Create a new response.
		require
			a_setup_response_not_void: a_setup_response /= Void
			a_test_response_good: a_setup_response.is_normal = (a_test_response /= Void)
			a_teardonwn_response_good: (a_test_response /= Void and then not a_test_response.is_bad) = (a_teardown_response /= Void)
		do
			setup_response := a_setup_response
			test_response := a_test_response
			teardown_response := a_teardown_response
		ensure
			setup_response_set: setup_response = a_setup_response
			test_response_set: test_response = a_test_response
			teardown_response_set: teardown_response = a_teardown_response
		end

feature {ANY} -- Status

	is_bad: BOOLEAN is
			-- Is the test execution as a whole considered bad?
		do
			Result := (setup_response /= Void and then setup_response.is_bad) or
						(test_response /= Void and then (test_response.is_bad or teardown_response.is_bad))
		end

feature {ANY} -- Access

	setup_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from test setup

	test_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from actual test routine

	teardown_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from test teardown

invariant

	setup_response_not_void: setup_response /= Void
	setup_normal_equals_test_not_void: setup_response.is_normal = (test_response /= Void)
	test_normal_equals_teardown_not_void: (test_response /= Void and then not test_response.is_bad) = (teardown_response /= Void)

end
