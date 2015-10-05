note
	description: "Summary description for {AFX_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SESSION

inherit
	AFX_UTILITY

	EPA_TIME_UTILITY

	SHARED_EXEC_ENVIRONMENT

create
	make

feature -- Initialization

	make (a_config: like config; a_system: SYSTEM_I)
			-- Initialization
		require
			config_attached: a_config /= Void
			a_system /= Void
		do
			config := a_config
			eiffel_system := a_system

			create event_actions.make
		end

feature -- Access

	config: AFX_CONFIG assign set_config
			-- AutoFix configuration.

	eiffel_system: SYSTEM_I
			-- Current system

feature -- Fixing related

	number_of_test_cases_for_fixing: INTEGER

	feature_under_test: AFX_FEATURE_TO_MONITOR

	failure_from_trace: EPA_EXCEPTION_TRACE_SUMMARY assign set_failure_from_trace
			-- Target failure of the fixing session as shown in the trace.

	exception_from_execution: AFX_EXCEPTION_SIGNATURE assign set_exception_from_execution
			-- Signature of the exception as observed during execution.

	fault_signature_id: STRING
		do
			create Result.make (256)
			Result.append (feature_under_test.qualified_feature_name)
			Result.append (".")
			Result.append (exception_from_execution.exception_code.out)
			Result.append (".")
			Result.append (exception_from_execution.recipient_breakpoint.out)
			Result.append (".")
			Result.append (exception_from_execution.recipient_feature_with_context.qualified_feature_name)
		end

	set_number_of_test_cases_for_fixing (a_num: INTEGER)
		do
			number_of_test_cases_for_fixing := a_num
		end

	set_feature_under_test (a_feature: AFX_FEATURE_TO_MONITOR)
			--
		do
			feature_under_test := a_feature
		end

feature -- Status report

	event_actions: AFX_EVENT_ACTIONS
			-- Event actions.

	is_canceled: BOOLEAN
			-- Is the session canceled by the user?

	should_continue: BOOLEAN
			-- Should the session continue execution?
		require
			has_started: has_started
		do
			Result := not is_canceled and then not (has_limited_length and then is_session_time_up)
		end

feature -- Directory structure

	working_directory: PATH
			-- Working directory of the project
		do
			if working_directory_cache = Void then
				working_directory_cache := Execution_environment.current_working_path
			end
			Result := working_directory_cache
		end

	override_directory: PATH
			--
		do
			Result := eiffel_system.eiffel_project.project_directory.path.extended ("override")
		end

	result_dir: PATH
			-- Directory to store AutoFix result.
		require
			failure_from_trace /= Void
		do
			if result_dir_cache = Void then
				if config.result_dir = Void then
					result_dir_cache := eiffel_system.eiffel_project.project_directory.fixing_results_path.extended (failure_from_trace.id)
				else
					create result_dir_cache.make_from_string (config.result_dir)
					result_dir_cache := result_dir_cache.extended (config.fault_signature_id)
				end
			end
			Result := result_dir_cache
		end

	report_file_path: PATH
		do
			if config.report_file = Void then
				Result := result_dir.extended ("result.afr")
			else
				create Result.make_from_string (config.report_file)
			end
		end

	report_dir: PATH
		do
			Result := report_file_path.parent
		end

	afx_tmp_directory: PATH
			-- Directory for putting temporary .e files during fixing.
		do
			Result := eiffel_system.eiffel_project.project_directory.path.extended ("afx_tmp")
		end

	regular_tests_directory: PATH
			--
		do
			Result := afx_tmp_directory.extended ("regular_tests")
		end

	relaxed_tests_directory: PATH
			--
		do
			Result := afx_tmp_directory.extended ("relaxed_tests")
		end

	log_directory: PATH is
			-- Directory for AutoFix logs
		local
			l_path: PATH
		do
			Result := result_dir.extended ("log")
		end

	data_directory: PATH is
			-- Directory for AutoFix data
		local
			l_path: PATH
		do
			Result := result_dir.extended ("data")
		end

	fix_directory: PATH
			-- Directory to store generated fixes
		do
			Result := result_dir.extended ("fix")
		end

	interpreter_log_path: PATH
			-- Full path to the interpreter log file
		do
			Result := log_directory.extended ("interpreter_log.txt")
		end

	proxy_log_path: PATH
			-- Full path to the proxy log file
		do
			Result := log_directory.extended ("proxy_log.txt")
		end

	prepare_directories
			-- Create/Clean the directories used in fixing.
		do
			prepare_empty_directory (log_directory)
			prepare_empty_directory (data_directory)
			prepare_empty_directory (fix_directory)
			prepare_empty_directory (afx_tmp_directory)
			prepare_empty_directory (regular_tests_directory)
			prepare_empty_directory (relaxed_tests_directory)
			empty_directory (override_directory)
			prepare_directory (report_dir)
		end

feature{NONE} -- Directory structure (implementation)

	prepare_directory (a_dir: PATH)
			-- Prepare directory `a_dir' (Create one if not already exists).
		local
			l_dir: KL_DIRECTORY
		do
			create l_dir.make (a_dir.out)
			if not l_dir.exists then
				l_dir.recursive_create_directory
			end
		end

	prepare_empty_directory (a_dir: PATH)
			-- Prepare the empty directory `a_dir' (Create one if not already exists).
		local
			l_dir: KL_DIRECTORY
		do
			create l_dir.make (a_dir.out)
			if l_dir.exists then
				l_dir.recursive_delete
			end
			l_dir.recursive_create_directory
		end

	empty_directory (a_path: PATH)
		local
			l_dir: DIRECTORY
		do
			create l_dir.make_with_path (a_path)
			l_dir.delete_content
		end

feature -- Timing in MILLISECONDS.

	starting_time: DT_DATE_TIME
			-- Time when AutoFix session started.

	has_started: BOOLEAN
			-- Has the session started?
		do
			Result := starting_time /= Void
		end

	maximum_length: INTEGER
			-- Maximum session length in milliseconds.	
			-- '<= 0' means unlimited length.	
		do
			Result := (config.maximum_session_length_in_minutes * 60 * 1000).as_integer_32
		end

	has_limited_length: BOOLEAN
			-- Has the session a limited maximum length?
		do
			Result := maximum_length > 0
		end

	is_session_time_up: BOOLEAN
			-- Is session out of time?
		require
			has_started
			has_limited_length
		do
			Result := time_left_for_session <= 0
		end

	has_limited_length_for_tests: BOOLEAN
		do
			Result := config.max_test_case_execution_time > 0
		end

	length: NATURAL
			-- Length of the session till now.
		require
			has_started: has_started
		do
			Result := duration_from_time(starting_time).to_natural_32
		end

	time_left_for_session: INTEGER
			-- Time left before the session reaching its maximum length.
		require
			has_limited_length
		do
			Result := maximum_length.as_integer_32 - length.as_integer_32
		end

	time_left_for_test_case (a_starting_time: DT_DATE_TIME): INTEGER
			-- Time left before a test case that started at `a_starting_time' should be killed.
		require
			has_limited_length or else has_limited_length_for_tests
		local
			l_length, l_maximum_length_for_test: INTEGER
			l_limit_from_session, l_limit_from_test: INTEGER
		do
			l_length := duration_from_time(a_starting_time).to_integer
			if has_limited_length then
				l_limit_from_session := maximum_length - l_length
			end
			if has_limited_length_for_tests then
				l_limit_from_test := config.max_test_case_execution_time.to_integer_32 * 60 * 1000 - l_length
			end
			Result := l_limit_from_session.min (l_limit_from_test)
		end

feature -- Operations

	start
			-- Start session.
		do
			is_canceled := False
			starting_time := time_now
		ensure
			has_started: has_started
		end

	cancel
			-- Cancel the session.
		do
			is_canceled := True
		end

	clean_up
			-- Clean up session.
		local
		do
		end

feature -- Status set

	set_config (a_config: like config)
			-- Set `config'.
		do
			config := a_config
		end

	set_failure_from_trace (a_failure: EPA_EXCEPTION_TRACE_SUMMARY)
			--
		do
			failure_from_trace := a_failure
		end

	set_exception_from_execution (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `a_signature'.
		require
			signature_attached: a_signature /= Void
		do
			exception_from_execution := a_signature
		end

feature -- Logging

	proxy_logger: AFX_PROXY_LOGGER;
			-- Logger to log proxy messages

	console_logger: AFX_PROXY_LOGGER
			-- Logger to print messages to console

	progression_monitor: AFX_PROGRESSION_MONITOR
			-- Object to monitor AutoFix progression.

	result_logger: AFX_PROXY_LOGGER
			-- Object to log AutoFix result.

	initialize_logging
			-- Initialize logging.
		local
			l_file: PLAIN_TEXT_FILE
			l_logging_level: INTEGER
		do
			create progression_monitor.make
			event_actions.subscribe_action_listener (progression_monitor)

			create result_logger.make ({AFX_EVENT_LISTENER}.Notification_level_essential, report_file_path.out)
			event_actions.subscribe_action_listener (result_logger)

			if config.should_log_for_debugging then
				l_logging_level := {AFX_EVENT_LISTENER}.Notification_level_supplemental
			else
				l_logging_level := {AFX_EVENT_LISTENER}.Notification_level_general
			end

			create proxy_logger.make(l_logging_level, proxy_log_path.out)
			event_actions.subscribe_action_listener (proxy_logger)

			create console_logger.make(l_logging_level, "stdout")
			event_actions.subscribe_action_listener (console_logger)
		end

feature{NONE} -- Cache

	working_directory_cache: PATH

	result_dir_cache: PATH

end
