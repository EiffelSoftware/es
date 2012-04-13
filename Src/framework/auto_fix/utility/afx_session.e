note
	description: "Summary description for {AFX_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SESSION

inherit
	EPA_TIME_UTILITY

create
	make

feature -- Initialization

	make (a_config: like config)
			-- Initialization
		require
			config_attached: a_config /= Void
		do
			config := a_config
			maximum_length := config.maximum_session_length_in_minutes * 60 * 1000
			create event_actions.make
		end

feature -- Access

	config: AFX_CONFIG assign set_config
			-- AutoFix configuration.

	exception_signature: AFX_EXCEPTION_SIGNATURE assign set_exception_signature
			-- Signature of the exception.

	exception_recipient_feature: AFX_EXCEPTION_RECIPIENT_FEATURE
			-- Recipient feature of `exception_signature'.

	event_actions: AFX_EVENT_ACTIONS
			-- Event actions.

	is_canceled: BOOLEAN
			-- Is the session canceled by the user?

	should_continue: BOOLEAN
			-- Should the session continue execution?
		require
			has_started: has_started
		do
			Result := not is_canceled and then not is_time_up
		end

feature -- Timing in MILLISECONDS.

	maximum_length: NATURAL
			-- Maximum session length.	
			-- '0' means unlimited length.	

	has_limited_length: BOOLEAN
			-- Has the session a limited maximum length?
		do
			Result := maximum_length /= 0
		end

	starting_time: DT_DATE_TIME
			-- Time when AutoFix session started.

	start
			-- Start session.
		do
			starting_time := time_now
			is_canceled := False
		ensure
			has_started: has_started
		end

	clean_up
			-- Clean up session.
		local
			l_default_report_file, l_fault_signature: STRING
			l_new_report_file: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_now: DATE_TIME
		do
			if proxy_logger /= Void and then proxy_logger.log_file /= Void and then proxy_logger.log_file.is_open_write then
				proxy_logger.log_file.close
			end
			if result_logger /= Void and then result_logger.log_file /= Void and then result_logger.log_file.is_open_write then
				result_logger.log_file.close
			end

				-- Rename the default report file after the signature of the fault under fix.
			if config.is_using_default_report_file_path and then exception_signature /= Void then
				l_default_report_file := config.report_file_path

					-- New report file name.
				create l_new_report_file.make_from_string (config.output_directory)
				l_fault_signature := exception_signature.id
				l_fault_signature.replace_substring_all (".", "__")
				l_new_report_file.set_file_name (l_fault_signature)
				l_new_report_file.add_extension (config.report_file_extension)

					-- Rename the existing report for the same fault.
				create l_file.make (l_new_report_file)
				if l_file.exists then
					create l_now.make_now
					l_file.change_name (l_new_report_file + "." + l_now.seconds.out)
				end

					-- Rename the default report name to the new name.
				create l_file.make (l_new_report_file)
				if not l_file.exists then
					create l_file.make (l_default_report_file)
					l_file.change_name (l_new_report_file)
				end
			end
		end

	length: NATURAL
			-- Length of the session till now.
		require
			has_started: has_started
			valid_sequence: time_now.is_greater_equal (starting_time)
		do
			Result := duration_from_time(starting_time).to_natural_32
		end

	time_left: INTEGER
			-- Time left before the session will be cut off.
			-- Negative value means time is up; 0 means unlimited time; positive value means limited time.
		require
			has_started: has_started
		do
			if has_limited_length then
				Result := maximum_length.to_integer_32 - length.to_integer_32
				if Result = 0 then
					Result := -1
				end
			else
				Result := 0
			end
		end

	has_started: BOOLEAN
			-- Has the session started?
		do
			Result := starting_time /= Void
		end

	is_time_up: BOOLEAN
			-- Is session out of time?
		require
			has_started: has_started
		do
			Result := time_left < 0
		end

feature -- Status set

	cancel
			-- Cancel the session.
		do
			is_canceled := True
		end

	set_config (a_config: like config)
			-- Set `config'.
		do
			config := a_config
		end

	set_exception_signature (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `a_signature'.
		require
			signature_attached: a_signature /= Void
		do
			exception_signature := a_signature
			create exception_recipient_feature.make_for_exception (exception_signature)
		end

feature -- Logging

	proxy_logger: AFX_PROXY_LOGGER;
			-- Logger to log proxy messages

	console_logger: AFX_PROXY_LOGGER
			-- Logger to print messages to console

	time_trace_logger: AFX_TIME_LOGGER
			-- Logger to keep track of time spent in AutoFix.

	progression_monitor: AFX_PROGRESSION_MONITOR
			-- Object to monitor AutoFix progression.

	result_logger: AFX_RESULT_LOGGER
			-- Object to log AutoFix result.

	initialize_logging
			-- Initialize logging.
		local
			l_result_path: STRING
			l_report_file: FILE_NAME
		do
			create progression_monitor.make
			event_actions.subscribe_action_listener (progression_monitor)

			l_result_path := config.report_file_path
			create result_logger.make (create {PLAIN_TEXT_FILE}.make_open_write (l_result_path))
			event_actions.subscribe_action_listener (result_logger)

			create proxy_logger.make(create {PLAIN_TEXT_FILE}.make_open_write (config.proxy_log_path), False)
			event_actions.subscribe_action_listener (proxy_logger)

			create console_logger.make(Io.default_output, False)
			event_actions.subscribe_action_listener (console_logger)

			create time_trace_logger.reset
			event_actions.subscribe_action_listener (time_trace_logger)
		end

end
