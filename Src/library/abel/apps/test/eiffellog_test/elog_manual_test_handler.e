note
	description: "Test launcher for manual tests."
	author: "Marco Piccioni"
	date: "$ $"
	revision: "$ $"

class
	ELOG_MANUAL_TEST_HANDLER

inherit
	EQA_TEST_SET

		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		local
			l_evn: EXECUTION_ENVIRONMENT
		do
			create console_logger
			create log_manager.make
			if log_file = Void then
				create log_file.make_open_append ("/tmp/elog_log_file.log")
			else
				log_file.open_append
			end
			create file_logger.make (log_file)
		end

	on_clean
			-- <Precursor>
		do
			log_file.close
		end

feature -- Test attributes

	 file_logger: ELOG_FILE_LOGGER

	 console_logger: ELOG_CONSOLE_LOGGER

	 log_manager: ELOG_LOG_MANAGER

	 log_file: detachable PLAIN_TEXT_FILE

feature -- Tests for {ELOG_LOG_MANAGER}.

	test_log_manager_defaults
			-- Invoke tests for {ELOG_LOG_MANAGER}
		do
			assert ("default level should be 'Error'.", log_manager.level.is_equal (log_manager.Error_level))
			assert ("default threadshold level should be 'Error'.", log_manager.level_threshold.is_equal (log_manager.Error_level))
			assert ("default logging level should be active at the beginning'.", log_manager.is_current_logging_level_active)
		end

	test_console_logger
			-- Invoke tests for {ELOG_CONSOLE_LOGGER}.
		do
			log_manager.extend_with_logger (console_logger)
			log_manager.put_line ("test put_line")
			log_manager.set_absolute_time_mode
			log_manager.put_line_with_time ("test put_line_with_time")
			log_manager.put_line_with_level ("test put_line_with_level at fatal level", log_manager.fatal_level)
			assert ("default level should stay 'Error'.", log_manager.level.is_equal (log_manager.Error_level))
			log_manager.set_level_threshold (log_manager.debug_level)
			log_manager.set_duration_time_mode
			assert ("duration time mode set", log_manager.time_logging_mode = log_manager.duration_time_logging_mode)
			log_manager.put_line_with_level_and_time ("test put_line_with_level and time at debug level", log_manager.debug_level)
		end

	test_file_logger
			-- Invoke tests for {ELOG_FILE_LOGGER}.
		do
			log_manager.extend_with_logger (file_logger)
			log_manager.put_line ("test put_line")
			log_manager.set_absolute_time_mode
			log_manager.put_line_with_time ("test put_line_with_time")
			log_manager.put_line_with_level ("test put_line_with_level at fatal level", log_manager.Fatal_level)
			assert ("default level should stay 'Error'.", log_manager.level.is_equal (log_manager.Error_level))
			log_manager.set_level_threshold (log_manager.Debug_level)
			log_manager.set_duration_time_mode
			log_manager.put_line_with_time_and_level ("test put_line_with_time_and_level at debug level", log_manager.Debug_level)
			log_manager.put_line_with_level_and_time ("test put_line_with_level_and_time at info level", log_manager.Info_level)
			log_manager.put_string_with_level ("test put_string", log_manager.Error_level)
			log_manager.set_absolute_time_mode
			log_manager.put_string_with_time ("test put_string")
		end

	test_file_and_console_loggers
			-- Invoke tests using both {ELOG_FILE_LOGGER} and {ELOG_CONSOLE_LOGGER}.
		do
			log_manager.extend_with_logger (file_logger)
			log_manager.extend_with_logger (console_logger)
			log_manager.put_line ("test put_line")
			log_manager.set_absolute_time_mode
			log_manager.put_line_with_time ("test put_line_with_time")
			log_manager.put_line_with_level ("test put_line_with_level at fatal level", log_manager.fatal_level)
			assert ("default level should stay 'Error'.", log_manager.level.is_equal (log_manager.Error_level))
			log_manager.set_level_threshold (log_manager.debug_level)
			log_manager.set_duration_time_mode
			log_manager.put_line_with_level_and_time ("test put_line_with_level and time at debug level", log_manager.debug_level)
		end
end
