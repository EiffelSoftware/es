note
	description: "Summary description for {AFX_FIXING_RESULT_REPORTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRESSION_MONITOR

inherit
	AFX_EVENT_LISTENER
		redefine
			on_session_started,
			on_session_terminated,
			on_session_canceled,

			on_test_case_analysis_started,
			on_test_case_entered,
			on_break_point_hit,
			on_test_case_exited,
			on_test_case_analysis_finished,
			on_test_case_execution_time_out,

			on_implementation_fix_generation_started,
			on_implementation_fix_generation_finished,
			on_implementation_fix_validation_started,
			on_one_implementation_fix_validation_started,
			on_one_implementation_fix_validation_finished,
			on_implementation_fix_validation_finished,

			on_weakest_contract_inference_started,
			on_weakest_contract_inference_finished,
			on_contract_fix_generation_started,
			on_contract_fix_generation_finished,
			on_contract_fix_validation_started,
			on_contract_fix_validation_finished,

			on_fix_ranking_started,
			on_fix_ranking_finished
		end

	AFX_UTILITY

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			create progression_updated_actions
		end

feature -- Progression

	progression: REAL_32
			-- Progression of the session.

	progress (a_val: REAL_32)
			-- Progress `a_val'.
		require
			positive_val: a_val > 0
		do
			set_progression (progression + a_val)
		ensure
			progression_increased: progression = old progression + a_val
		end

	set_progression (a_val: REAL_32)
			-- Set `progression' with `a_val'.
		require
			val_in_range: 0.0 <= a_val and then a_val <= 100.0
		do
			progression := a_val
			progression_updated_actions.call ([progression])
		ensure
			progression_set: progression = a_val
		end

feature -- Event to publish

	progression_updated_actions: ACTION_SEQUENCE [TUPLE [value: REAL_32]]
			-- Actions upon progression updates.

feature -- Listener (un)subscription

	subscribe (a_listener: PROCEDURE[ANY, TUPLE[REAL_32]])
			-- Subscribe `a_listener' to `progression_updated_actions'.
		require
			listener_attached: a_listener /= Void
		do
			progression_updated_actions.extend (a_listener)
		end

	unsubscribe_all
			-- Unsubscribe all listeners to `progression_updated_actions'.
		do
			progression_updated_actions.wipe_out
		end


feature -- Actions (session)

	on_session_started
			-- <Precursor>
		do
			set_progression (Progression_session_start)
		end

	on_session_terminated, on_session_canceled
			-- <Precursor>
		do
			set_progression (Progression_session_end)
		end

feature -- Actions (test analysis)

	on_test_case_analysis_started (a_tc_count: INTEGER)
			-- <Precursor>
		do
			set_progression (progression_trace_collection_start)
		end

	on_test_case_entered (a_tc_info: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			progress (progression_per_test_case_analysis)
		end

	on_break_point_hit (a_cls: CLASS_C; a_feat: FEATURE_I; a_bpslot: INTEGER)
			-- Action to be performed when break point `a_bpslot' in `a_tc_info' is hit
		do
		end

	on_test_case_exited (a_tc_info: EPA_TEST_CASE_INFO)
			-- Action to be performed when a new test case indicated by `a_tc_info' is found in test case analysis phase.
		do
		end

	on_test_case_execution_time_out
			-- Action to be performed when test case execution during validation times out.
		do
		end

	on_test_case_analysis_finished
			-- <Precursor>
		do
			set_progression (progression_fault_localization_end)
		end

feature -- Actions (implementation fix)

	on_implementation_fix_generation_started
			-- <Precursor>
		do
			set_progression (Progression_fix_generation_start)
		end

	on_implementation_fix_generation_finished  (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			set_progression (Progression_fix_generation_end)
		end

	on_implementation_fix_validation_started (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			set_progression (Progression_fix_validation_start)
		end

	on_one_implementation_fix_validation_started (a_candidate: AFX_CODE_FIX_TO_FAULT)
			-- Action to be performed when `a_candidate' is about to be validated
		do
		end

	on_one_implementation_fix_validation_finished (a_candidate: AFX_CODE_FIX_TO_FAULT)
			-- <Precursor>
		do
			progress (progression_per_fix_validation)
		end

	on_implementation_fix_validation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			set_progression (Progression_fix_validation_end)
		end

feature -- Actions (contract fix)

	on_weakest_contract_inference_started (a_feature: AFX_FEATURE_TO_MONITOR)
			-- Action to be performed when weakest contract inference starts
		do
		end

	on_weakest_contract_inference_finished (a_feature: AFX_FEATURE_TO_MONITOR)
			-- Action to be performed when weakest contract inference ends
		do
		end

	on_contract_fix_generation_started
			-- Action to be performed when contract fix generation starts
		do
		end

	on_contract_fix_generation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			-- Action to be performed when contract fix generation ends
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

feature -- Progression in small

	progression_per_test_case_analysis: REAL_32
			-- Progression for each analyzed test case.

	progression_per_fix_validation: REAL_32
			-- Progression for each (in)validated test case.

feature -- Set progression in small

	set_progression_per_test_case_analysis (a_val: REAL_32)
			-- Set `progression_per_test_case_analysis' with `a_val'.
		require
			valid_val: 0.0 <= a_val and then a_val <= progression_fault_localization_end - progression_trace_collection_start
		do
			progression_per_test_case_analysis := a_val
		ensure
			progression_per_test_case_analysis_set: progression_per_test_case_analysis = a_val
		end

	set_progression_per_fix_validation (a_val: REAL_32)
			-- Set `progression_per_fix_validation' with `a_val'.
		require
			valid_val: 0.0 <= a_val and then a_val <= progression_fix_validation_end - progression_fix_validation_start
		do
			progression_per_fix_validation := a_val
		ensure
			progression_per_fix_validation_set: progression_per_fix_validation = a_val
		end

feature -- Progression Constants

	progression_session_start: 				REAL_32 = 0.0
	progression_trace_collection_start: 	REAL_32 = 0.4
	progression_trace_collection_end: 		REAL_32 = 0.4
	progression_fault_localization_start: 	REAL_32 = 0.4
	progression_fault_localization_end: 	REAL_32 = 0.4
	progression_fix_generation_start: 		REAL_32 = 0.45
	progression_fix_generation_end: 		REAL_32 = 0.7
	progression_fix_validation_start: 		REAL_32 = 0.75
	progression_fix_validation_end: 		REAL_32 = 0.95
	progression_fix_report_generation_start:REAL_32 = 0.97
	progression_fix_report_generation_end:	REAL_32 = 0.98
	progression_session_end: 				REAL_32 = 1.0

invariant

	progression_in_range: 0 <= progression and then progression <= 1.00

end
