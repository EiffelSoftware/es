note
	description: "Summary description for {AFX_PROXY_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONSOLE_PRINTER

inherit
	AFX_TIME_UTILITY

	AFX_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Configuration of current AutoFix session

feature -- Actions

	on_sesson_starts
			-- Action to be performed when the whole AutoFix session starts
		do
			start_time := time_now
			log_time_stamp_new_line (session_start_message)
		end

	on_session_ends
			-- Action to be performed when the whole AutoFix session ends.
		do
			log_time_stamp_new_line (session_end_message)
		end

	on_test_case_analyzing_starts
			-- Action to be performed when test case analyzing starts
		do
			log_time_stamp_new_line (test_case_analyzing_start_message)
		end

	on_test_case_analyzing_ends
			-- Action to be performed when test case analyzing ends
		do
			log_time_stamp_new_line (test_case_analyzing_end_message)
		end

	on_fix_generation_starts
			-- Action to be performed when fix generation starts
		do
			log_time_stamp_new_line (fix_generation_start_message)
		end

	on_fix_generation_ends (a_candidate_count: INTEGER)
			-- Action to be performed when fix generation ends
		do
			log_time_stamp_new_line (fix_generation_end_message + a_candidate_count.out + " candidates generated.")
			fix_candidate_count := a_candidate_count
			finish_validated_fix_candidate_count := 0
		end

	on_fix_validation_starts
			-- Action to be performed when fix validation starts
		do
			log_time_stamp_new_line (fix_validation_start_message)
		end

	on_fix_validation_ends
			-- Action to be performed when fix validation ends
		do
			log_time_stamp_new_line (fix_validation_end_message)
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
		local
			l_message: STRING
		do
			create l_message.make (128)
			l_message.append (fix_candidate_validation_start_message)
			l_message.append (fix_signature (a_candidate, False, True))
			l_message.append ("; Progress: ")
			if fix_candidate_count > 0 then
				l_message.append (finish_validated_fix_candidate_count.out)
				l_message.append (" / ")
				l_message.append (fix_candidate_count.out)
			end
			l_message.append ("; ")
			log_time_stamp (l_message)
			finish_validated_fix_candidate_count := finish_validated_fix_candidate_count + 1
		end

	valid_fix_count: INTEGER
			-- The number of valid fixes that have been found

	on_fix_candidate_validation_ends (a_candidate: AFX_FIX; a_valid: BOOLEAN; a_passing_count: INTEGER; a_failing_count: INTEGER)
			-- Action to be performed when `a_candidate' finishes to be validated.
			-- `a_valid' indicates whether `a_candidate' is valid.
		do
			if a_valid then
				valid_fix_count := valid_fix_count + 1
				log_line ("Good fix No." + valid_fix_count.out + "; semantics ranking = " + a_candidate.ranking.post_validation_score.out)
				lines_with_prefixes (formated_fix (a_candidate), <<"   ">>).do_all (agent log_line)
			else
				log_line (" Succeeded: " + a_passing_count.out + "; Failed: " + a_failing_count.out)
			end
		end

	on_interpreter_starts (a_port: INTEGER)
			-- Action to be performed when the interpreter starts with port number `a_port'.
		do
			log_time_stamp_new_line ("%N" + interpreter_start_message + a_port.out)
		end

	on_interpreter_start_failed (a_port: INTEGER)
			-- Action to be performed when the interpreter start failed with port number `a_port'.
		do
			log_time_stamp_new_line (interpreter_start_failed_message + a_port.out)
		end

	on_test_case_execution_time_out
			-- Action to be performed when test case execution during validation times out.
		do
			log_time_stamp_new_line (test_case_execution_time_out_message)
		end

feature -- Constants

	session_start_message: STRING = "AutoFix session starts"

	session_end_message: STRING = "AutoFix session ends"

	test_case_analyzing_start_message: STRING = "test case analyzing starts"

	test_case_analyzing_end_message: STRING = "test case analyzing ends"

	fix_generation_start_message: STRING = "fix generation starts"

	fix_generation_end_message: STRING = "fix generation ends. "

	fix_validation_start_message: STRING = "fix validation starts"

	fix_validation_end_message: STRING = "fix validation ends"

	new_test_case_found_message: STRING = "test case found: "

	fix_candidate_validation_start_message: STRING = "Validate "

	interpreter_start_message: STRING = "Interpreter starts at port "

	interpreter_start_failed_message: STRING = "Interpreter failed to start at port "

	test_case_execution_time_out_message: STRING = "Test case execution times out"

feature{NONE} -- Implementation

	start_time: DT_DATE_TIME
			-- Starting time of current AutoFix session

	break_point_count: INTEGER
			-- Number of break points that are met in the last found test case

	test_case_count: INTEGER
			-- Number of test cases that are found so far

	break_point_hit_statistics: HASH_TABLE [INTEGER, INTEGER]
			-- Table to store break point hit statistics
			-- Key is break point slot, value is the number of times that break point is hit.

	fix_candidate_count: INTEGER
			-- Number of generated fix candidates

	finish_validated_fix_candidate_count: INTEGER
			-- Number of fix candidated whose validation are finished

	lines_with_prefixes (a_text: STRING; a_prefixes: ARRAY [STRING]): LIST [STRING]
			-- List of lines in `a_text', each line is prepended with prefixes in `a_prefixes' in order.
			-- If `a_text' is empty, an empty list will be returned.
		require
			a_text_attached: a_text /= Void
			a_prefixes_attached: a_prefixes /= Void
			a_prefixes_not_have_void: not a_prefixes.has (Void)
		local
			l_prefix: STRING
			l_lines: LIST [STRING]
		do
			fixme ("Code copied from AUT_RESPONSE_LOG_PRINTER.")
			if a_text.is_empty then
				create {ARRAYED_LIST [STRING]} Result.make (0)
			else
				create l_prefix.make (64)
				a_prefixes.do_all (agent l_prefix.append ({STRING}?))
				l_lines := a_text.split ('%N')
				if not l_lines.is_empty then
					l_lines.finish
					l_lines.remove
				end
				from
					l_lines.start
				until
					l_lines.after
				loop
					l_lines.item.prepend (l_prefix)
					l_lines.forth
				end
				Result := l_lines
			end
		ensure
			result_attached: Result /= Void
			data_correct: not Result.has (Void)
			result_is_empty_when_a_text_is_empty: a_text.is_empty implies Result.is_empty
		end

feature{NONE} -- Implementation

	log_time_stamp_new_line (a_tag: STRING)
			-- Log tag `a_tag' with timing information.
		do
			log_time_stamp (a_tag)
			log_line ("")
		end

	log_time_stamp (a_tag: STRING)
			-- Log tag `a_tag' with timing information.
		local
			l_time_now: DT_DATE_TIME
			duration: INTEGER
			l_minute: INTEGER
			l_second: INTEGER
		do
			duration := duration_from_time (start_time)
			l_second := duration // 1000
			l_minute := l_second // 60
			l_second := l_second \\ 60

			log (l_minute.out + "m " + l_second.out + "s: ")
			log (a_tag)
		end

	log_line (a_string: STRING)
			-- Log `a_string' followed by a new-line character to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log (a_string)
			log ("%N")
		end

	log (a_string: STRING)
			-- Log `a_string' to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			io.put_string (a_string)
		end

end
