note
	description: "Summary description for {AFX_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EVENT_LISTENER

inherit
	AFX_LOGGER_MESSAGE

feature -- Actions (notification)

	on_notification_issued (a_notification: STRING; a_level: INTEGER)
			--
		do
		end

feature -- Actions (session)

	on_session_started
		do
		end

	on_session_terminated
		do
		end

	on_session_canceled
		do
		end

feature -- Actions (test analysis)

	on_test_case_analysis_started (a_tc_count: INTEGER)
		do
		end

	on_test_case_entered (a_tc_info: EPA_TEST_CASE_INFO)
		do
		end

	on_break_point_hit (a_cls: CLASS_C; a_feat: FEATURE_I; a_bpslot: INTEGER)
		do
		end

	on_test_case_exited (a_tc_info: EPA_TEST_CASE_INFO)
		do
		end

	on_test_case_analysis_finished
		do
		end

	on_test_case_execution_time_out
		do
		end

feature -- Actions (implementation fix)

	on_implementation_fix_generation_started
		do
		end

	on_implementation_fix_generation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
		do
		end

	on_implementation_fix_validation_started (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
		do
		end

	on_one_implementation_fix_validation_started (a_candidate: AFX_CODE_FIX_TO_FAULT)
		do
		end

	on_one_implementation_fix_validation_finished (a_candidate: AFX_CODE_FIX_TO_FAULT)
		do
		end

	on_implementation_fix_validation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
		do
		end

feature -- Actions (contract fix)

	on_weakest_contract_inference_started (a_feature: AFX_FEATURE_TO_MONITOR)
		do
		end

	on_weakest_contract_inference_finished (a_feature: AFX_FEATURE_TO_MONITOR)
		do
		end

	on_contract_fix_generation_started
		do
		end

	on_contract_fix_generation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
		end

	on_contract_fix_validation_started (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
		end

	on_contract_fix_validation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
		end

feature -- Actions (ranking)

	on_fix_ranking_started (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
		do
		end

	on_fix_ranking_finished (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
		do
		end

feature -- Action (interpreter)

	on_interpreter_started (a_port: INTEGER)
		do
		end

	on_interpreter_failed_to_start (a_port: INTEGER)
		do
		end

feature -- Constants

	Notification_level_essential:		INTEGER = 1
	Notification_level_general: 		INTEGER = 2
	Notification_level_supplemental:	INTEGER = 3


end
