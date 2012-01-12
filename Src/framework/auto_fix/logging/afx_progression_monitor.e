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
			on_session_starts,
			on_session_ends,
			on_session_canceled,
			on_test_case_analysis_starts,
			on_test_case_analysis_ends,
			on_fix_generation_starts,
			on_fix_generation_ends,
			on_fix_validation_starts,
			on_fix_validation_ends,
			on_new_test_case_found,
			on_fix_candidate_validation_ends
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


feature -- Events to monitor

	on_session_starts
			-- <Precursor>
		do
			set_progression (Progression_session_start)
		end

	on_session_ends, on_session_canceled
			-- <Precursor>
		do
			set_progression (Progression_session_end)
		end

	on_test_case_analysis_starts
			-- <Precursor>
		do
			set_progression (Progression_test_case_analysis_start)
		end

	on_test_case_analysis_ends
			-- <Precursor>
		do
			set_progression (Progression_test_case_analysis_end)
		end

	on_fix_generation_starts
			-- <Precursor>
		do
			set_progression (Progression_fix_generation_start)
		end

	on_fix_generation_ends  (a_fixes: DS_LINKED_LIST [AFX_FIX])
			-- <Precursor>
		do
			set_progression (Progression_fix_generation_end)
		end

	on_fix_validation_starts (a_fixes: LINKED_LIST [AFX_MELTED_FIX])
			-- <Precursor>
		do
			set_progression (Progression_fix_validation_start)
		end

	on_fix_validation_ends (a_fixes: LINKED_LIST [AFX_FIX])
			-- <Precursor>
		do
			set_progression (Progression_fix_validation_end)
		end

	on_new_test_case_found (a_tc_info: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			progress (progression_per_test_case_analysis)
		end

	on_fix_candidate_validation_ends (a_candidate: AFX_FIX; a_valid: BOOLEAN; a_passing_count: INTEGER; a_failing_count: INTEGER)
			-- <Precursor>
		do
			progress (progression_per_fix_validation)
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
			valid_val: 0.0 <= a_val and then a_val <= progression_test_case_analysis_end - progression_test_case_analysis_start
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

	progression_session_start: REAL_32 = 0.0
	progression_test_case_analysis_start: REAL_32 = 0.05
	progression_test_case_analysis_execution_end: REAL_32 = 0.25
	progression_test_case_analysis_end: REAL_32 = 0.4
	progression_fix_generation_start: REAL_32 = 0.45
	progression_fix_generation_end: REAL_32 = 0.7
	progression_fix_validation_start: REAL_32 = 0.75
	progression_fix_validation_end: REAL_32 = 0.95
	progression_session_end: REAL_32 = 1.0

invariant

	progression_in_range: 0 <= progression and then progression <= 100

end
