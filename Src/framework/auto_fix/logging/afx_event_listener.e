note
	description: "Summary description for {AFX_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EVENT_LISTENER

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Actions

	on_session_starts
			-- Action to be performed when the whole AutoFix session starts
		do
		end

	on_session_ends
			-- Action to be performed when the whole AutoFix session ends.
		do
		end

	on_session_canceled
			-- Action to be performed when the AutoFix session is canceled.
		do
		end

	on_test_case_analysis_starts
			-- Action to be performed when test case analyzing starts
		do
		end

	on_test_case_analysis_ends
			-- Action to be performed when test case analyzing ends
		do
		end

	on_fix_generation_starts
			-- Action to be performed when fix generation starts
		do
		end

	on_fix_generation_ends (a_fixes: DS_LINKED_LIST [AFX_FIX])
			-- Action to be performed when fix generation ends
		do
		end

	on_fix_validation_starts (a_fixes: LINKED_LIST [AFX_MELTED_FIX])
			-- Action to be performed when fix validation starts
		do
		end

	on_fix_validation_ends (a_fixes: LINKED_LIST [AFX_FIX])
			-- Action to be performed when fix validation ends
		do
		end

	on_new_test_case_found (a_tc_info: EPA_TEST_CASE_INFO)
			-- Action to be performed when a new test case indicated by `a_tc_info' is found in test case analysis phase.
		do
		end

	on_break_point_hits (a_tc_info: EPA_TEST_CASE_INFO; a_bpslot: INTEGER)
			-- Action to be performed when break point `a_bpslot' in `a_tc_info' is hit
		do
		end

	on_fix_candidate_validation_starts (a_candidate: AFX_FIX)
			-- Action to be performed when `a_candidate' is about to be validated
		do
		end

	on_fix_candidate_validation_ends (a_candidate: AFX_FIX; a_valid: BOOLEAN; a_passing_count: INTEGER; a_failing_count: INTEGER)
			-- Action to be performed when `a_candidate' finishes to be validated.
			-- `a_valid' indicates whether `a_candidate' is valid.
		do
		end

	on_interpreter_starts (a_port: INTEGER)
			-- Action to be performed when the interpreter starts with port number `a_port'.
		do
		end

	on_interpreter_start_failed (a_port: INTEGER)
			-- Action to be performed when the interpreter start failed with port number `a_port'.
		do
		end

	on_test_case_execution_time_out
			-- Action to be performed when test case execution during validation times out.
		do
		end

end
