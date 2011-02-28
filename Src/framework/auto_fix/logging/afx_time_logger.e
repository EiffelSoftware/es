note
	description: "Summary description for {AFX_TIME_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TIME_LOGGER

inherit
	AFX_EVENT_LISTENER
		redefine
			on_session_starts,
			on_session_ends,
			on_test_case_analysis_starts,
			on_test_case_analysis_ends,
			on_fix_generation_starts,
			on_fix_generation_ends,
			on_fix_validation_starts,
			on_fix_validation_ends
		end

	EPA_TIME_UTILITY

create
	reset

feature -- Reset time trace

	reset
			-- Reset time trace.
		do
			session_start_time := Void
			session_end_time := Void
			test_case_analysis_start_time := Void
			test_case_analysis_end_time := Void
			fix_generation_start_time := Void
			fix_generation_end_time := Void
			fix_validation_start_time := Void
			fix_validation_end_time := Void
		end

feature -- Access

	session_start_time: DT_DATE_TIME
			-- Time when session starts.

	session_end_time: DT_DATE_TIME
			-- Time when session ends.

	test_case_analysis_start_time: DT_DATE_TIME
			-- Time when test case analysis starts.

	test_case_analysis_end_time: DT_DATE_TIME
			-- Time when test case analysis ends.

	fix_generation_start_time: DT_DATE_TIME
			-- Time when fix generation starts.

	fix_generation_end_time: DT_DATE_TIME
			-- Time when fix generation ends.

	fix_validation_start_time: DT_DATE_TIME
			-- Time when fix validation starts.

	fix_validation_end_time: DT_DATE_TIME
			-- Time when fix validation ends.

	session_duration: DT_DATE_TIME_DURATION
			-- Duration of session.
		do
			if session_start_time = Void or else session_end_time = Void then
				Result := Void
			else
				Result := session_end_time.duration (session_start_time)
			end
		end

	test_case_analysis_duration: DT_DATE_TIME_DURATION
			-- Duration of test case analysis.
		do
			if test_case_analysis_start_time = Void or else test_case_analysis_end_time = Void then
				Result := Void
			else
				Result := test_case_analysis_end_time.duration (test_case_analysis_start_time)
			end
		end

	fix_generation_duration: DT_DATE_TIME_DURATION
			-- Duration of fix generation.
		do
			if fix_generation_start_time = Void and then fix_generation_end_time = Void then
				Result := Void
			else
				Result := fix_generation_end_time.duration (fix_generation_start_time)
			end
		end

	fix_validation_duration: DT_DATE_TIME_DURATION
			-- Duration of fix validation.
		do
			if fix_validation_start_time = Void or else fix_validation_end_time = Void then
				Result := Void
			else
				Result := fix_validation_end_time.duration (fix_validation_start_time)
			end
		end

feature -- Actions

	on_session_starts
			-- <Precursor>
		do
			session_start_time := time_now
		end

	on_session_ends
			-- <Precursor>
		do
			session_end_time := time_now
		end

	on_test_case_analysis_starts
			-- <Precursor>
		do
			test_case_analysis_start_time := time_now
		end

	on_test_case_analysis_ends
			-- <Precursor>
		do
			test_case_analysis_end_time := time_now
		end

	on_fix_generation_starts
			-- <Precursor>
		do
			fix_generation_start_time := time_now
		end

	on_fix_generation_ends (a_candidate_count: INTEGER)
			-- <Precursor>
		do
			fix_generation_end_time := time_now
		end

	on_fix_validation_starts
			-- <Precursor>
		do
			fix_validation_start_time := time_now
		end

	on_fix_validation_ends
			-- <Precursor>
		do
			fix_validation_end_time := time_now
		end

end
