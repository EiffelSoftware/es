note
	description: "Summary description for {AFX_EVENT_PRODUCER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EVENT_ACTIONS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create session_start_actions
			create session_end_actions

			create test_case_analysis_start_actions
			create test_case_analysis_end_actions

			create fix_generation_start_actions
			create fix_generation_end_actions

			create fix_validation_start_actions
			create fix_validation_end_actions

			create new_test_case_found_actions
			create break_point_hit_actions

			create fix_candidate_validation_start_actions
			create fix_candidate_validation_end_actions

			create interpreter_start_actions
			create interpreter_start_failed_actions
		end

feature -- Access

	session_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when the whole AutoFix session starts

	session_end_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when the whole AutoFix session ends

	test_case_analysis_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when the analyzing of test cases starts

	test_case_analysis_end_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when the analyzing of test cases ends

	fix_generation_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when fix generation starts

	fix_generation_end_actions: ACTION_SEQUENCE [TUPLE [a_candidate_count: INTEGER]]
			-- Actions to be performed when fix generation ends
			-- `a_candidate_count' indidates the number of generated fix candidates

	fix_validation_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when fix validation starts

	fix_validation_end_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when fix validation ends

	new_test_case_found_actions: ACTION_SEQUENCE [TUPLE [tc_info: AFX_TEST_CASE_INFO]]
			-- Actions to be performed when test case indicated by `tc_info' is found during test case analysis phase

	break_point_hit_actions: ACTION_SEQUENCE [TUPLE [tc_info: AFX_TEST_CASE_INFO; break_point_slot: INTEGER]]
			-- Actions to be performed when break point `break_point_slot' in `tc_info' is hit

	fix_candidate_validation_start_actions: ACTION_SEQUENCE [TUPLE [a_candidate: AFX_FIX]]
			-- Actions to be performed when a fix candidate `a_candidate' starts to be validated

	fix_candidate_validation_end_actions: ACTION_SEQUENCE [TUPLE [a_candidate: AFX_FIX; a_valid: BOOLEAN]]
			-- Actions to be performed when a fix candidate `a_candidate' finishes to be validated.
			-- `a_valid' indicates whether `a_candidate' is valid.

	interpreter_start_actions: ACTION_SEQUENCE [TUPLE [a_port: INTEGER]]
			-- Actions to be performed when the interpreter starts
			-- `a_port' is the port number used for inter-process communication.

	interpreter_start_failed_actions: ACTION_SEQUENCE [TUPLE [a_port: INTEGER]]
			-- Actions to be performed when the interpreter start failed
			-- `a_port' is the port number used for inter-process communication.

feature -- actions

	notify_on_session_starts
			-- Call actions in `session_start_actions'.
		do
			session_start_actions.call (Void)
		end

	notify_on_session_ends
			-- Call actions in `session_end_actions'.
		do
			session_end_actions.call (Void)
		end

	notify_on_test_case_analysis_starts
			-- Call actions in `test_case_analysis_start_actions'.
		do
			test_case_analysis_start_actions.call (Void)
		end

	notify_on_test_case_analysis_ends
			-- Call actions in `test_case_analysis_end_actions'.
		do
			test_case_analysis_end_actions.call (Void)
		end

	notify_on_fix_generation_starts
			-- Call actions in `fix_generation_end_actions'.
		do
			fix_generation_start_actions.call (Void)
		end

	notify_on_fix_generation_ends (a_candidate_count: INTEGER)
			-- Call actions in `fix_generation_end_actions'.
			-- `a_candidate_count' indidates the number of generated fix candidates.
		do
			fix_generation_end_actions.call ([a_candidate_count])
		end

	notify_on_fix_validation_starts
			-- Call actions in `fix_validation_end_actions'.
		do
			fix_validation_start_actions.call (Void)
		end

	notify_on_fix_validation_ends
			-- Call actions in `fix_validation_end_actions'.
		do
			fix_validation_end_actions.call (Void)
		end

	notify_on_new_test_case_found (a_tc_info: AFX_TEST_CASE_INFO)
			-- Call actions in `new_test_case_found_actions'.
		do
			new_test_case_found_actions.call ([a_tc_info])
		end

	notify_on_break_point_hit (a_tc_info: AFX_TEST_CASE_INFO; a_bpslot: INTEGER)
			-- Call actions in `break_point_hit_actions'.
		do
			break_point_hit_actions.call ([a_tc_info, a_bpslot])
		end

	notify_on_fix_candidate_validation_starts (a_candidate: AFX_FIX)
			-- Call actions in `fix_candidate_validation_start_actions'.
		do
			fix_candidate_validation_start_actions.call ([a_candidate])
		end

	notify_on_fix_candidate_validation_ends (a_candidate: AFX_FIX; a_valid: BOOLEAN)
			-- Call actions in `fix_candidate_validation_end_actions'.
		do
			fix_candidate_validation_end_actions.call ([a_candidate, a_valid])
		end

	notify_on_interpreter_starts (a_port: INTEGER)
			-- Cal actions in `interpreter_start_actions'.
		do
			interpreter_start_actions.call ([a_port])
		end

	notify_on_interpreter_start_failed (a_port: INTEGER)
			-- Cal actions in `interpreter_start_failed_actions'.
		do
			interpreter_start_failed_actions.call ([a_port])
		end
end
