note
	description: "Summary description for {AFX_RESULT_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RESULT_LOGGER

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

	make (a_log_file: PLAIN_TEXT_FILE)
			-- Initialize Current.
		require
			log_file_attached: a_log_file /= Void
		do
			log_file := a_log_file
		end

feature -- Access

	log_file: PLAIN_TEXT_FILE
			-- File to store logs

feature -- Actions

	on_session_starts
			-- Action to be performed when the whole AutoFix session starts
		do
			log_time_stamp (session_start_message)
			finish_validated_fix_candidate_count := 0
			fix_candidate_count := 0
			test_case_count := 0
			valid_fix_candidate_count := 0
		end

	on_session_ends
			-- Action to be performed when the whole AutoFix session ends.
		do
			log_time_stamp (session_end_message)
			log_summary
		end

	on_session_canceled
			-- <Precursor>
		do
			log_time_stamp (session_canceled_message)
			log_summary
		end

	on_test_case_analysis_starts
			-- Action to be performed when test case analyzing starts
		do
			log_time_stamp (test_case_analyzing_start_message)
		end

	on_new_test_case_found (a_tc_info: EPA_TEST_CASE_INFO)
			-- Action to be performed when a new test case indicated by `a_tc_info' is found in test case analysis phase.
		do
			test_case_count := test_case_count + 1
		end

	on_test_case_analysis_ends
			-- Action to be performed when test case analyzing ends
		do
			log_time_stamp (test_case_analyzing_end_message + test_case_count.out + " found")
		end

	on_fix_generation_starts
			-- Action to be performed when fix generation starts
		do
			log_time_stamp (fix_generation_start_message)
		end

	on_fix_generation_ends (a_fixes: DS_LINKED_LIST [AFX_FIX])
			-- Action to be performed when fix generation ends
		do
			log_time_stamp (fix_generation_end_message + " " + a_fixes.count.out + " candidates generated")
			log_fixes (a_fixes)
		end

	on_fix_validation_starts (a_fixes: LINKED_LIST [AFX_MELTED_FIX])
			-- Action to be performed when fix validation starts
		do
			fix_candidate_count := a_fixes.count
			log_time_stamp (fix_validation_start_message + " " + fix_candidate_count.out + " candidates to validate")
		end

	on_fix_candidate_validation_ends (a_candidate: AFX_FIX; a_valid: BOOLEAN; a_passing_count: INTEGER; a_failing_count: INTEGER)
			-- Action to be performed when `a_candidate' finishes to be validated.
			-- `a_valid' indicates whether `a_candidate' is valid.
		local
			l_message: STRING
		do
			if a_valid then
				log_line (">> valid_fix_candidate_start_tag <<")
				log_fix (a_candidate, True)
				log_line (">> valid_fix_candidate_end_tag <<")

				valid_fix_candidate_count := valid_fix_candidate_count + 1
			end
			finish_validated_fix_candidate_count := finish_validated_fix_candidate_count + 1
		end

	on_fix_validation_ends (a_fixes: LINKED_LIST [AFX_FIX])
			-- Action to be performed when fix validation ends
		do
			log_time_stamp (fix_validation_end_message + " " + a_fixes.count.out + " valid fixes")
		end

feature -- Constants

	session_start_message: STRING = "AutoFix session starts"

	session_end_message: STRING = "AutoFix session ends"

	session_canceled_message: STRING = "AutoFix session canceled"

	test_case_analyzing_start_message: STRING = "test case analyzing starts"

	test_case_analyzing_end_message: STRING = "test case analyzing ends"

	fix_generation_start_message: STRING = "fix generation starts"

	fix_generation_end_message: STRING = "fix generation ends"

	fix_validation_start_message: STRING = "fix validation starts"

	fix_validation_end_message: STRING = "fix validation ends"

feature{NONE} -- Implementation

	test_case_count: INTEGER
			-- Number of test cases that are found so far

	fix_candidate_count: INTEGER
			-- Number of generated fix candidates

	finish_validated_fix_candidate_count: INTEGER
			-- Number of fix candidated whose validation are finished

	valid_fix_candidate_count: INTEGER
			-- Number of valid fix candidates.

feature{NONE} -- Implementation

	log_summary
			-- Log summary.
		do
			log_line (">> Summary_start_tag <<")
			log_line ("Session length (ms): " + session.length.out)
			log_line ("Nr. of test cases: " + test_case_count.out)
			log_line ("Nr. of candidate fixes to validate: " + fix_candidate_count.out)
			log_line ("Nr. of validated candidates: " + finish_validated_fix_candidate_count.out)
			log_line ("Nr. of valid candidates: " + valid_fix_candidate_count.out)
			log_line (">> Summary_end_tag <<")
		end

	log_fixes (a_fixes: DS_LINKED_LIST [AFX_FIX])
			-- Log fixes.
		require
			fixes_attached: a_fixes /= Void
		local
			l_fixes_cursor: DS_LINKED_LIST_CURSOR[AFX_FIX]
		do
			l_fixes_cursor := a_fixes.new_cursor
			from l_fixes_cursor.start
			until l_fixes_cursor.after
			loop
				log_fix (l_fixes_cursor.item, False)
				l_fixes_cursor.forth
			end
		end

	log_fix (a_fix: AFX_FIX; a_validated: BOOLEAN)
			-- Log one fix.
		require
			fix_attached: a_fix /= Void
		local
			l_str: STRING
		do
			log_line ("--" + fix_signature (a_fix, a_validated, True))

			l_str := formated_fix (a_fix)
			l_str.append ("%N%N")
			log (l_str)
		end

	log_time_stamp (a_tag: STRING)
			-- Log tag `a_tag' with timing information.
		require
			session_started: session.has_started
		local
			l_time_now: DT_DATE_TIME
			duration: INTEGER
			l_length: NATURAL
			l_line: STRING
		do
			l_length := session.length
			create l_line.make (32)
			l_line.append (once ">> time stamp: ")
			l_line.append (a_tag)
			l_line.append ("; ")
			l_line.append (l_length.out)
			log_line (l_line)
		end

	log_line (a_string: STRING)
			-- Log `a_string' followed by a new-line character to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log (a_string + "%N")
		end

	log (a_string: STRING)
			-- Log `a_string' to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log_file.put_string (a_string)
			log_file.flush
		end


end
