note
	description: "Summary description for {AFX_PROXY_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROXY_LOGGER

inherit
	AFX_EVENT_LISTENER
		redefine
			on_notification_issued,

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
			on_fix_ranking_finished,

			on_interpreter_started,
			on_interpreter_failed_to_start
		end

	AFX_UTILITY

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make (a_level: INTEGER; a_log_file_path_string: STRING)
			-- Initialization.
		require
			a_log_file_path_string /= Void
		do
			set_level (a_level)
			log_file_path_string := a_log_file_path_string.twin
		end

feature -- Access

	level: INTEGER
			-- Level of details to log.

	log_file: PLAIN_TEXT_FILE
			-- File to store logs

	log_file_path_string: STRING
			-- Path to `log_file'.

feature -- Set

	set_level (a_level: INTEGER)
		do
			level := a_level
		end

feature -- Status report

	is_more_verbose_than (a_level: INTEGER): BOOLEAN
			-- Should the listener react to an action at `a_level'.
		do
			Result := level >= a_level
		end

feature{NONE} -- Access

	number_of_test_cases_to_analyze: INTEGER

	number_of_analyzed_test_cases: INTEGER

	number_of_implementation_fixes_to_validate: INTEGER

	number_of_validated_implementation_fixes: INTEGER

	number_of_valid_implementation_fixes: INTEGER

	number_of_contract_fixes_to_validate: INTEGER

feature -- General action

	on_notification_issued (a_msg: STRING; a_level: INTEGER)
			-- <Precursor>
		do
			log_message (False, a_level, a_msg)
		end

feature -- Actions (session)

	on_session_started
			-- <Precursor>
		do
			log_file := initialize_log_file

			if log_file = Void then
				log_file := Io.output
				log_message (False, notification_level_essential, "Error: cannot open file for logging at: " + log_file_path_string)
				log_message (False, notification_level_essential, "       Using stdout instead.")
				log_file_path_string := "stdout"
			end
			log_message (True, notification_level_general, session_started_message)
		end

	on_session_terminated
			-- <Precursor>
		do
			log_message (True, notification_level_general, session_terminated_message)

			if log_file /= Io.output and then log_file /= Io.error and then log_file /= Void and then log_file.is_open_write then
				log_file.close
			end
		end

	on_session_canceled
			-- <Precursor>
		do
			log_message (True, notification_level_general, session_canceled_message)

			if log_file /= Io.output and then log_file /= Io.error and then log_file /= Void and then log_file.is_open_write then
				log_file.close
			end
		end

feature -- Actions (test analysis)

	on_test_case_analysis_started (a_tc_count: INTEGER)
			-- <Precursor>
		do
			number_of_test_cases_to_analyze := a_tc_count
			number_of_analyzed_test_cases := 0

			log_message (True, notification_level_general, test_case_analysis_started_message + section_separator + a_tc_count.out + " test cases.")
		end

	on_test_case_entered (a_tc_info: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			number_of_analyzed_test_cases := number_of_analyzed_test_cases + 1

			if number_of_test_cases_to_analyze /= 0 then
				log_message (True, notification_level_general, test_case_entered_message + section_separator + a_tc_info.id + " (" + number_of_analyzed_test_cases.out + "/" + number_of_test_cases_to_analyze.out + ")")
			else
				log_message (True, notification_level_general, test_case_entered_message + section_separator + a_tc_info.id)
			end
		end

	on_break_point_hit (a_cls: CLASS_C; a_feat: FEATURE_I; a_bpslot: INTEGER)
			-- <Precursor>
		do
		end

	on_test_case_exited (a_tc_info: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			log_message (True, notification_level_general, "%T" + test_case_exited_message)
		end

	on_test_case_execution_time_out
			-- <Precursor>
		do
			log_message (True, notification_level_general, "%T" + test_case_execution_time_out_message)
		end

	on_test_case_analysis_finished
			-- <Precursor>
		do
			number_of_test_cases_to_analyze := 0

			log_message (True, notification_level_general, test_case_analysis_finished_message)
		end

feature -- Actions (implementation fix)

	on_implementation_fix_generation_started
			-- <Precursor>
		do
			log_message (True, notification_level_general, implementation_fix_generation_started_message)
		end

	on_implementation_fix_generation_finished (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			log_message (True, notification_level_general, implementation_fix_generation_finished_message + section_separator + a_fixes.count.out + " implementation fixes generated.")
		end

	on_implementation_fix_validation_started (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			number_of_implementation_fixes_to_validate := a_fixes.count
			number_of_validated_implementation_fixes := 0

			log_message (True, notification_level_general, implementation_fix_validation_started_message + section_separator + number_of_implementation_fixes_to_validate.out + " implementation fixes to validate.")
		end

	on_one_implementation_fix_validation_started (a_candidate: AFX_CODE_FIX_TO_FAULT)
			-- <Precursor>
		do
			number_of_validated_implementation_fixes := number_of_validated_implementation_fixes + 1

			log_message (True, notification_level_general, one_implementation_fix_validation_started_message + section_separator + "ID-" + a_candidate.id.out + " (" + number_of_validated_implementation_fixes.out + "/" + number_of_implementation_fixes_to_validate.out + ")")
		end

	on_one_implementation_fix_validation_finished (a_candidate: AFX_CODE_FIX_TO_FAULT)
			-- <Precursor>
		local
			l_message: STRING
		do
			log_message (True, notification_level_general, "%T" + one_implementation_fix_validation_finished_message + section_separator + "ID-" + a_candidate.id.out + " (Validity: " + a_candidate.is_valid.out + ")")

			if a_candidate.is_valid then
				log_line (Msg_valid_fix_start)
				log_multi_line_message (a_candidate.out)
				log_line ("")
				log_line (Msg_valid_fix_end)
			end
		end

	Msg_valid_fix_start: STRING = "<[- Valid fix start -]>"
	Msg_valid_fix_end:   STRING = "<[-  Valid fix end  -]>"

	on_implementation_fix_validation_finished  (a_fixes: DS_LIST [AFX_CODE_FIX_TO_FAULT])
			-- <Precursor>
		do
			number_of_valid_implementation_fixes := a_fixes.count

			log_message (True, notification_level_general, implementation_fix_validation_finished_message + section_separator + number_of_valid_implementation_fixes.out + " valid fixes")
		end

feature -- Actions (contract fix)

	on_weakest_contract_inference_started (a_feature: AFX_FEATURE_TO_MONITOR)
			-- <Precursor>
		do
			log_message (True, notification_level_general, weakest_contract_inference_started_message + section_separator + a_feature.qualified_feature_name)
		end

	on_weakest_contract_inference_finished (a_feature: AFX_FEATURE_TO_MONITOR)
			-- <Precursor>
		do
			log_message (True, notification_level_general, weakest_contract_inference_started_message + section_separator + a_feature.qualified_feature_name)
		end

	on_contract_fix_generation_started
			-- <Precursor>
		do
			log_message (True, notification_level_general, contract_fix_generation_started_message)
		end

	on_contract_fix_generation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			-- <Precursor>
		local
			l_cursor: DS_LIST_CURSOR [AFX_CONTRACT_FIX_TO_FAULT]
			l_fix_index: INTEGER
			l_fix: AFX_CONTRACT_FIX_TO_FAULT
		do
			log_message (True, notification_level_general, contract_fix_generation_finished_message + section_separator + a_fixes.count.out + " contract fixes generated")
		end

	on_contract_fix_validation_started (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			-- <Precursor>
		do
			log_message (True, notification_level_general, contract_fix_validation_started_message + section_separator + a_fixes.count.out + " contract fixes to validate")
		end

	on_contract_fix_validation_finished (a_fixes: DS_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			-- <Precursor>
		local
			l_cursor: DS_LIST_CURSOR [AFX_CONTRACT_FIX_TO_FAULT]

			l_fix_index: INTEGER
			l_fix: AFX_CONTRACT_FIX_TO_FAULT
		do
			log_message (True, notification_level_general, contract_fix_validation_finished_message + section_separator + a_fixes.count.out + " valid contract fixes")

			from
				l_cursor := a_fixes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_fix := l_cursor.item
				log_line (Msg_valid_fix_start)
				log_multi_line_message (l_fix.out)
				log_line ("")
				log_line (Msg_valid_fix_end)

				l_cursor.forth
			end
		end

feature -- Actions (ranking)

	on_fix_ranking_started (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
			-- <Precursor>
		do
			log_message (True, notification_level_general, fix_ranking_started_message)
		end

	on_fix_ranking_finished (a_fixes: DS_LIST [AFX_FIX_TO_FAULT])
			-- <Precursor>
		do
			log_message (True, notification_level_general, fix_ranking_finished_message)
		end

feature -- Action (interpreter)

	on_interpreter_started (a_port: INTEGER)
			-- <Precursor>
		do
			log_message (True, notification_level_general, interpreter_started_message + section_separator + a_port.out)
		end

	on_interpreter_failed_to_start (a_port: INTEGER)
			-- <Precursor>
		do
			log_message (True, notification_level_general, interpreter_failed_to_start_message + section_separator + a_port.out)
		end

feature{NONE} -- Log format

	timestamp_column_width: 	INTEGER = 9
	level_column_width: 		INTEGER = 5

feature{NONE} -- Implementation

	initialize_log_file: PLAIN_TEXT_FILE
			-- Initialize `log_file' using `log_file_path_string'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				if log_file_path_string /= Void then
					if log_file_path_string.as_lower ~ "stdout" then
						Result := Io.output
					elseif log_file_path_string.as_lower ~ "stderr" then
						Result := Io.error
					else
						create Result.make_with_name (log_file_path_string)
						Result.open_write
						if not Result.is_open_write then
							Result := Void
						end
					end
				else
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	level_to_string_map: DS_HASH_TABLE[STRING, INTEGER]
			--
		do
			if level_to_string_map_cache = Void then
				create level_to_string_map_cache.make_equal (3)
				level_to_string_map_cache.force ("ESS", Notification_level_essential)
				level_to_string_map_cache.force ("GEN", Notification_level_general)
				level_to_string_map_cache.force ("SUP", Notification_level_supplemental)
			end
			Result := level_to_string_map_cache
		end

	log_message (a_timestamp: BOOLEAN; a_level: INTEGER; a_msg: STRING)
			-- Log `a_msg' as `a_level'-notification and with optional timestamp.
		local
			l_total_width: INTEGER
			l_timestamp_string: STRING
			l_line: STRING
		do
			if is_more_verbose_than (a_level) then
				l_total_width := timestamp_column_width + level_column_width + a_msg.count

				l_timestamp_string := " "
				l_timestamp_string.multiply (timestamp_column_width)
				if a_timestamp then
					l_timestamp_string.prepend ("@" + session.length.out)
					l_timestamp_string.remove_substring (timestamp_column_width + 1, l_timestamp_string.count)
				end

				create l_line.make (l_total_width)
				l_line.append (l_timestamp_string + " " + level_to_string_map.item (a_level) + " " + a_msg)
				log_line (l_line)
			end
		end

	log_multi_line_message (a_msg: STRING)
			--
		local
			l_prefix: STRING
		do
			lines_with_prefixes (a_msg, "").do_all (agent log_line)
		end

	log_line (a_string: STRING)
			-- Log `a_string' followed by a new-line character to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log_string (a_string + "%N")
		end

	log_string (a_string: STRING)
			-- Log `a_string' to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			if log_file /= Void and then log_file.is_open_write then
				log_file.put_string (a_string)
				log_file.flush
			end
	end

feature{NONE} -- Cache

	level_to_string_map_cache: like level_to_string_map


end
