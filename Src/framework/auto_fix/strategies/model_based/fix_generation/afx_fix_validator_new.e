note
	description: "Summary description for {AFX_FIX_VALIDATOR_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATOR_NEW

inherit
	EPA_DEBUGGER_UTILITY

	SHARED_DEBUGGER_MANAGER

	AFX_INTERPRETER_CONSTANTS

	EPA_COMPILATION_UTILITY

	AFX_UTILITY

	AFX_SHARED_PROJECT_ROOT_INFO

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT])
			-- Initialize Current to validate fix candidates `a_fixes'.
		do
			test_cases := a_trace_repository.keys
			fixes := a_fixes.twin
			create valid_fixes.make_equal (fixes.count)
		end

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Fix candidates to validate

	test_cases: DS_LINEAR [EPA_TEST_CASE_INFO]
			-- Test cases used for validation.

	valid_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- List of valid fixed found so far

feature -- Basic operation

	validate
			-- Validate `fixes'.
		local
			l_instrumentor: AFX_FIX_INSTRUMENTOR
		do
			if not fixes.is_empty then
				create l_instrumentor.make (fixes)
				l_instrumentor.instrument
				compile_project (eiffel_project, True)

				from until
					fixes.is_empty or else should_quit or else not session.should_continue
				loop
					validate_left_fixes
				end

				l_instrumentor.uninstrument
				compile_project (eiffel_project, True)
			end
		end

feature{NONE} -- Actions

	on_fix_validation_start (a_fix: AFX_CODE_FIX_TO_FAULT)
			-- Action to be performed when `a_melted_fix' is about to be validated
		do
			event_actions.notify_on_one_implementation_fix_validation_started (a_fix)
		end

	on_fix_validation_end (a_fix: AFX_CODE_FIX_TO_FAULT; a_exception_count: NATURAL_32)
			-- Action to be performed when `a_fix' has been validated.
		local
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_valid: BOOLEAN
			l_fix_text: STRING
			l_passing_count: INTEGER
			l_failing_count: INTEGER
			l_valid_fixes_count: INTEGER
		do
			l_valid := exception_count = a_exception_count
			if l_valid then
				a_fix.set_valid (True)
				valid_fixes.force_last (a_fix)

				if config.max_valid_fix_number > 0 and then config.max_valid_fix_number.to_integer_32 <= valid_fixes.count then
					worker.set_should_quit (True)
					should_quit := True
				end
			end
			event_actions.notify_on_one_implementation_fix_validation_finished(a_fix)
			exception_count := a_exception_count
		end

	on_test_case_execution_time_out
			-- Action to be performed when test case execution timed out
		do
			worker.set_is_execution_over_time (True)
			event_actions.notify_on_test_case_execution_time_out
			check process /= Void end
			process.terminate_tree
			process.wait_for_exit
		end

feature{NONE} -- Inter-process communication attributes

	process: PROCESS
		-- Process for the interpreter

	worker: AFX_FIX_VALIDATION_THREAD_NEW
			-- Worker thread to validate fix candidates

	socket: NETWORK_STREAM_SOCKET
			-- Socked used to perform interprocess communication with the debuggee

	socket_listener: AFX_SOCKET_LISTENER
			-- Socket listener

	port: INTEGER
			-- Port used by `socket'

	should_quit: BOOLEAN
			-- Should fix validation be stopped?

	exception_count: NATURAL_32
			-- Number of exceptions that are encountered so far

feature{NONE} -- Inter-process communication operations

	establish_socket
			-- Start the client.
		local
			l_tried_times: INTEGER
			l_max_tring_times: INTEGER
			l_done: BOOLEAN
		do
			from
				l_max_tring_times := 10
			until
				l_tried_times = l_max_tring_times or l_done
			loop
					-- Create socket and start listening on `port'.
				if socket /= Void and then socket.exists and then not socket.is_closed then
					socket.cleanup
				end

				create socket_listener.make (config)
				socket_listener.open_new_socket
				if socket_listener.is_listening then
					port := socket_listener.current_port.to_integer_32
					l_done := True
				end
				l_tried_times := l_tried_times + 1
			end
		end

	cleanup
			-- Clean up Current proxy.
		do
			if socket /= Void then
				cleanup_socket
			end
		end

	cleanup_socket
			-- Cleanup `socket'.
		require
			socket_attached: socket /= Void
		do
			if socket.exists and then not socket.is_closed then
				socket.close
			end
		end

feature{NONE} -- Implementation

	validate_left_fixes
			-- Validate fixes in `melted_fixes'.
		local
			l_fac: PROCESS_FACTORY
			l_cmd_line: STRING
			l_timer: AFX_TIMER_THREAD
		do
			if not fixes.is_empty then
				exception_count := 0
				cleanup
				establish_socket

				if socket_listener.is_listening then
					event_actions.notify_on_interpreter_started (port)
					create l_fac
					l_cmd_line := system.eiffel_system.application_name (True).out + " --validate-fix " + session.interpreter_log_path.utf_8_name + " true " + port.out + " -eif_root " + afx_project_root_class + "." + afx_project_root_feature
					process := l_fac.process_launcher_with_command_line (l_cmd_line, session.working_directory.utf_8_name)
					process.launch
					check process.launched end

					if attached {like socket} socket_listener.wait_for_connection (5000) as l_socket then
						socket := l_socket
						create l_timer.make (agent on_test_case_execution_time_out)
						l_timer.reset_timer
						create worker.make (fixes, agent on_fix_validation_start, agent on_fix_validation_end, l_timer, socket, test_cases)
						worker.execute
						process.wait_for_exit_with_timeout (5000)
						if not process.has_exited then
							process.terminate_tree
							process.wait_for_exit
						end
						cleanup
					end
				else
					event_actions.notify_on_interpreter_failed_to_start (port)
					if process /= Void and then process.launched and then not not process.has_exited then
						process.terminate_tree
						process.wait_for_exit
					end
				end
			end
		end

	store_string_in_file (a_directory: PATH; a_file_name: STRING; a_content: STRING)
			-- Create a file named `a_file_name' in `a_directory' and store `a_content' in it.
		local
			l_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_path (a_directory.extended (a_file_name))
			l_file.create_read_write
			l_file.put_string (a_content)
			l_file.close
		end

end


