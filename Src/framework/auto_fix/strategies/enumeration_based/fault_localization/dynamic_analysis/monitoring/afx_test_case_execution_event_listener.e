note
	description: "Summary description for {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_TEST_CASE_EXECUTION_EVENT_LISTENER

feature -- Access

	current_test_case: EPA_TEST_CASE_INFO
			-- Test case currently under execution.

feature -- Status report

	is_test_case_new (a_tc: EPA_TEST_CASE_INFO): BOOLEAN
			-- Is `a_tc' a new test case?
		require
			test_case_attached: a_tc /= Void
		deferred
		end

feature -- Event handler

	on_new_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- Action to take on new test case.
		require
			test_case_attached: a_tc /= Void
			new_test_case: is_test_case_new (a_tc)
		deferred
		ensure
			current_test_case_set: current_test_case = a_tc
		end

	on_breakpoint_hit (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_location: AFX_PROGRAM_LOCATION)
			-- Action to take when `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the retrieved system state at `a_location'.
		require
			test_case_attached: a_tc /= Void
			about_current_test_case: current_test_case ~ a_tc
		deferred
		end

	on_application_exit
			-- Action to take on application exit.
		deferred
		end

feature{AFX_TEST_CASE_EXECUTION_EVENT_LISTENER} -- Status set

	set_current_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- Set `current_test_case'.
		do
			current_test_case := a_tc
		end

end
