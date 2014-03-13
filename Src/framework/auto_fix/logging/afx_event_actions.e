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
			create notification_issued_actions

			create session_started_actions
			create session_terminated_actions
			create session_canceled_actions

			create test_case_analysis_started_actions
			create test_case_entered_actions
			create break_point_hit_actions
			create test_case_exited_actions
			create test_case_analysis_finished_actions
			create test_case_execution_time_out_actions

			create implementation_fix_generation_started_actions
			create implementation_fix_generation_finished_actions

			create implementation_fix_validation_started_actions
			create one_implementation_fix_validation_started_actions
			create one_implementation_fix_validation_finished_actions
			create implementation_fix_validation_finished_actions

			create weakest_contract_inference_started_actions
			create weakest_contract_inference_finished_actions
			create contract_fix_generation_started_actions
			create contract_fix_generation_finished_actions
			create contract_fix_validation_started_actions
			create contract_fix_validation_finished_actions

			create fix_ranking_started_actions
			create fix_ranking_finished_actions

			create interpreter_started_actions
			create interpreter_failed_to_start_actions

		end

feature -- Subscribe

	subscribe_action_listener (a_listener: AFX_EVENT_LISTENER)
			-- Subscribe `a_listener' to listen to the current events.
		do
			notification_issued_actions.extend (agent a_listener.on_notification_issued)

			session_started_actions.extend (agent a_listener.on_session_started)
			session_terminated_actions.extend (agent a_listener.on_session_terminated)
			session_canceled_actions.extend (agent a_listener.on_session_canceled)

			test_case_analysis_started_actions.extend (agent a_listener.on_test_case_analysis_started)
			test_case_entered_actions.extend (agent a_listener.on_test_case_entered)
			break_point_hit_actions.extend (agent a_listener.on_break_point_hit)
			test_case_exited_actions.extend (agent a_listener.on_test_case_exited)
			test_case_analysis_finished_actions.extend (agent a_listener.on_test_case_analysis_finished)
			test_case_execution_time_out_actions.extend (agent a_listener.on_test_case_execution_time_out)

			implementation_fix_generation_started_actions.extend (agent a_listener.on_implementation_fix_generation_started)
			implementation_fix_generation_finished_actions.extend (agent a_listener.on_implementation_fix_generation_finished)
			implementation_fix_validation_started_actions.extend (agent a_listener.on_implementation_fix_validation_started)
			one_implementation_fix_validation_started_actions.extend (agent a_listener.on_one_implementation_fix_validation_started)
			one_implementation_fix_validation_finished_actions.extend (agent a_listener.on_one_implementation_fix_validation_finished)
			implementation_fix_validation_finished_actions.extend (agent a_listener.on_implementation_fix_validation_finished)

			weakest_contract_inference_started_actions.extend (agent a_listener.on_weakest_contract_inference_started)
			weakest_contract_inference_finished_actions.extend (agent a_listener.on_weakest_contract_inference_finished)
			contract_fix_generation_started_actions.extend (agent a_listener.on_contract_fix_generation_started)
			contract_fix_generation_finished_actions.extend (agent a_listener.on_contract_fix_generation_finished)
			contract_fix_validation_started_actions.extend (agent a_listener.on_contract_fix_validation_started)
			contract_fix_validation_finished_actions.extend (agent a_listener.on_contract_fix_validation_finished)

			fix_ranking_started_actions.extend (agent a_listener.on_fix_ranking_started)
			fix_ranking_finished_actions.extend (agent a_listener.on_fix_ranking_finished)

			interpreter_started_actions.extend (agent a_listener.on_interpreter_started)
			interpreter_failed_to_start_actions.extend (agent a_listener.on_interpreter_failed_to_start)
		end

feature -- Access

	notification_issued_actions: ACTION_SEQUENCE [TUPLE[notification: STRING; level: INTEGER]]
	session_started_actions: ACTION_SEQUENCE [TUPLE]
	session_terminated_actions: ACTION_SEQUENCE [TUPLE]
	session_canceled_actions: ACTION_SEQUENCE [TUPLE]
	test_case_analysis_started_actions: ACTION_SEQUENCE [TUPLE [INTEGER]]
	test_case_entered_actions: ACTION_SEQUENCE [TUPLE [tc_info: EPA_TEST_CASE_INFO]]
	break_point_hit_actions: ACTION_SEQUENCE [TUPLE [cls: CLASS_C; feat: FEATURE_I; break_point_slot: INTEGER]]
	test_case_exited_actions: ACTION_SEQUENCE [TUPLE [tc_info: EPA_TEST_CASE_INFO]]
	test_case_execution_time_out_actions: ACTION_SEQUENCE [TUPLE]
	test_case_analysis_finished_actions: ACTION_SEQUENCE [TUPLE]
	implementation_fix_generation_started_actions: ACTION_SEQUENCE [TUPLE]
	implementation_fix_generation_finished_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT]]]
	implementation_fix_validation_started_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT]]]
	one_implementation_fix_validation_started_actions: ACTION_SEQUENCE [TUPLE [a_fix: AFX_CODE_FIX_TO_FAULT]]
	one_implementation_fix_validation_finished_actions: ACTION_SEQUENCE [TUPLE [a_fix: AFX_CODE_FIX_TO_FAULT]]
	implementation_fix_validation_finished_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT]]]
	weakest_contract_inference_started_actions: ACTION_SEQUENCE [TUPLE [a_feature: AFX_FEATURE_TO_MONITOR]]
	weakest_contract_inference_finished_actions: ACTION_SEQUENCE [TUPLE [a_feature: AFX_FEATURE_TO_MONITOR]]
	contract_fix_generation_started_actions: ACTION_SEQUENCE [TUPLE]
	contract_fix_generation_finished_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT]]]
	contract_fix_validation_started_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT]]]
	contract_fix_validation_finished_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT]]]
	fix_ranking_started_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_FIX_TO_FAULT]]]
	fix_ranking_finished_actions: ACTION_SEQUENCE [TUPLE [a_fixes: DS_LIST [AFX_FIX_TO_FAULT]]]
	interpreter_started_actions: ACTION_SEQUENCE [TUPLE [a_port: INTEGER]]
	interpreter_failed_to_start_actions: ACTION_SEQUENCE [TUPLE [a_port: INTEGER]]

feature -- actions

	notify_on_notification_issued (a_notification: STRING; a_level: INTEGER)
		do
			notification_issued_actions.call([a_notification, a_level])
		end

	notify_on_essential_notification_issued (a_notification: STRING)
		do
			notification_issued_actions.call ([a_notification, {AFX_EVENT_LISTENER}.Notification_level_essential])
		end

	notify_on_general_notification_issued (a_notification: STRING)
		do
			notification_issued_actions.call ([a_notification, {AFX_EVENT_LISTENER}.Notification_level_general])
		end

	notify_on_supplemental_notification_issued (a_notification: STRING)
		do
			notification_issued_actions.call ([a_notification, {AFX_EVENT_LISTENER}.Notification_level_supplemental])
		end

	notify_on_session_started
		do
			session_started_actions.call (Void)
		end

	notify_on_session_terminated
		do
			session_terminated_actions.call (Void)
		end

	notify_on_session_canceled
		do
			session_canceled_actions.call(Void)
		end

	notify_on_test_case_analysis_started (a_tc_count: INTEGER)
		do
			test_case_analysis_started_actions.call ([a_tc_count])
		end

	notify_on_test_case_entered (a_tc_info: EPA_TEST_CASE_INFO)
		do
			test_case_entered_actions.call ([a_tc_info])
		end

	notify_on_break_point_hit (a_cls: CLASS_C; a_feature: FEATURE_I; a_bpslot: INTEGER)
		do
			break_point_hit_actions.call ([a_cls, a_feature, a_bpslot])
		end

	notify_on_test_case_execution_time_out
		do
			test_case_execution_time_out_actions.call (Void)
		end

	notify_on_test_case_exited (a_tc_info: EPA_TEST_CASE_INFO)
		do
			test_case_exited_actions.call ([a_tc_info])
		end

	notify_on_test_case_analysis_finished
		do
			test_case_analysis_finished_actions.call (Void)
		end

	notify_on_implementation_fix_generation_started
		do
			implementation_fix_generation_started_actions.call (Void)
		end

	notify_on_implementation_fix_generation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
		do
			implementation_fix_generation_finished_actions.call ([a_fixes])
		end

	notify_on_implementation_fix_validation_started (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
		do
			implementation_fix_validation_started_actions.call ([a_fixes])
		end

	notify_on_one_implementation_fix_validation_started (a_fix: AFX_CODE_FIX_TO_FAULT)
		do
			one_implementation_fix_validation_started_actions.call ([a_fix])
		end

	notify_on_one_implementation_fix_validation_finished (a_fix: AFX_CODE_FIX_TO_FAULT)
		do
			one_implementation_fix_validation_finished_actions.call ([a_fix])
		end

	notify_on_implementation_fix_validation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- Call actions in `fix_generation_end_actions'.
		do
			implementation_fix_validation_finished_actions.call ([a_fixes])
		end

	notify_on_weakest_contract_inference_started (a_feature: AFX_FEATURE_TO_MONITOR)
		do
			weakest_contract_inference_started_actions.call ([a_feature])
		end

	notify_on_weakest_contract_inference_finished (a_feature: AFX_FEATURE_TO_MONITOR)
		do
			weakest_contract_inference_finished_actions.call ([a_feature])
		end

	notify_on_contract_fix_generation_started
		do
			contract_fix_generation_started_actions.call (Void)
		end

	notify_on_contract_fix_generation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
			contract_fix_generation_finished_actions.call ([a_fixes])
		end

	notify_on_contract_fix_validation_started (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
			contract_fix_validation_started_actions.call ([a_fixes])
		end

	notify_on_contract_fix_validation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
		do
			contract_fix_validation_finished_actions.call ([a_fixes])
		end

	notify_on_fix_ranking_started (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
		do
			fix_ranking_started_actions.call ([a_fixes])
		end

	notify_on_fix_ranking_finished (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
		do
			fix_ranking_finished_actions.call ([a_fixes])
		end

	notify_on_interpreter_started (a_port: INTEGER)
			-- Cal actions in `interpreter_start_actions'.
		do
			interpreter_started_actions.call ([a_port])
		end

	notify_on_interpreter_failed_to_start (a_port: INTEGER)
			-- Cal actions in `interpreter_start_failed_actions'.
		do
			interpreter_failed_to_start_actions.call ([a_port])
		end

end
