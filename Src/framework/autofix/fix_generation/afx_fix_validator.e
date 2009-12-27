note
	description: "Summary description for {AFX_FIX_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATOR

inherit
	AFX_DEBUGGER_HELPER

	SHARED_DEBUGGER_MANAGER

	AFX_INTERPRETER_CONSTANTS

	AFX_MELT_FEATURE_FACILITY

	AFX_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config; a_spot: like exception_spot; a_fixes: LINKED_LIST [AFX_FIX]; a_status: like test_case_execution_status)
			-- Initialize Current to validate fix candidates `a_fixes'.
		require
			a_config_attached: a_config /= Void
			a_spot_attached: a_spot /= Void
			a_status_attached: a_status /= Void
		local
			l_fix: AFX_FIX
		do
			config := a_config
			exception_spot := a_spot
			test_case_execution_status := a_status

				-- Setup `test_cases'.
			create test_cases.make
			from
				test_case_execution_status.start
			until
				test_case_execution_status.after
			loop
				test_cases.extend (test_case_execution_status.key_for_iteration)
				test_case_execution_status.forth
			end

				-- Setup `fixes' and `melted_fixes'.
			create fixes.make (a_fixes.count)
			create melted_fixes.make
			from
				a_fixes.start
			until
				a_fixes.after
			loop
				l_fix := a_fixes.item_for_iteration
				if attached {AFX_MELTED_FIX} melted_fix_from_fix (l_fix) as l_melted then
					fixes.put (l_fix, l_fix.id)
					melted_fixes.extend (l_melted)
				end
				a_fixes.forth
			end

			create valid_fixes.make
		end

feature -- Access

	config: AFX_CONFIG
			-- Config of Current AutoFix session

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception spot

	fixes: HASH_TABLE [AFX_FIX, INTEGER]
			-- Fix candidates to validate
			-- Key is fix ID, value is the fix associated with that ID

	test_case_execution_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- Execution status for test cases related to the fault
			-- Key is uuid of a test case, value is the execution status of that test case

	test_cases: LINKED_LIST [STRING]
			-- Universal IDs for test cases used to validate fix candidates

	valid_fixes: LINKED_LIST [AFX_FIX]
			-- List of valid fixed found so far

feature -- Actions

	worker: AFX_FIX_VALIDATION_THREAD
			-- Worker thread to validate fix candidates

	valid_fix_count: INTEGER
			-- Number of good fixes validated so far

	should_quit: BOOLEAN
			-- Should fix validation be stopped?

feature{NONE} -- Actions

	on_fix_validation_start (a_melted_fix: AFX_MELTED_FIX)
			-- Action to be performed when `a_melted_fix' is about to be validated
		do
			io.put_string ("Strat validate fix No. " + a_melted_fix.id.out + ",  " + melted_fixes.count.out + " to go.  ")
		end

	on_fix_validation_end (a_melted_fix: AFX_MELTED_FIX; a_exception_count: NATURAL_32)
			-- Action to be performed when `a_melted_fix' is about to be validated
		local
			l_fix: AFX_FIX
		do
			io.put_string ("Failed: " + (a_exception_count.to_integer_32 - exception_count.to_integer_32).out + "  Succeeded: " + (test_case_execution_status.count - (a_exception_count.to_integer_32 - exception_count.to_integer_32)).out + "  " + a_exception_count.out + ", " + exception_count.out + "%N")
			if exception_count = a_exception_count then
				l_fix := fixes.item (a_melted_fix.id)
				l_fix.ranking.set_impact_on_passing_test_cases (l_fix.impact_on_passing_test_cases)
				l_fix.set_is_valid (True)
				store_fix_in_file (config.fix_directory, l_fix, True)

				io.put_string ("====================================================%N")
				valid_fix_count := valid_fix_count + 1
				io.put_string ("Good fix No." + valid_fix_count.out + "%N")
				io.put_string (formated_fix (l_fix))
				io.put_string ("Ranking: " + l_fix.ranking.syntax_score.out + "%N")
				io.put_string ("Impact on passing test cases: " + l_fix.ranking.impact_on_passing_test_cases.out + "%N")
				io.put_string ("%N")

					-- Maximal number of valid fixes have already been found, terminate fix validation.
				if config.max_valid_fix_number > 0 and then config.max_valid_fix_number = valid_fix_count then
					timer.set_timeout (0)
					worker.set_should_quit (True)
					should_quit := True
				end
				valid_fixes.extend (fixes.item (a_melted_fix.id))
			end
			exception_count := a_exception_count
		end

	on_test_case_execution_time_out
			-- Action to be performed when test case execution timed out
		do
			check process /= Void end
			if process.is_running then
				process.terminate_tree
				process.wait_for_exit
			end
		end

feature{NONE} -- Requests for interpreter

	timer: AFX_TIMER_THREAD
			-- Timer to control test case execution time out.

	exception_count: NATURAL_32
			-- Number of exceptions that are encountered so far

	process: PROCESS
		-- Process for the interpreter

	melted_fixes: LINKED_LIST [AFX_MELTED_FIX]
			-- Melted fixes for fixes in `fixes'

feature -- Basic operations

	validate_left_fixes
			-- Validate fixes in `melted_fixes'.
		local
			l_fac: PROCESS_FACTORY
		do
			if not melted_fixes.is_empty then
				exception_count := 0
				cleanup
				establish_socket

				if socket_listener.is_listening then
					create l_fac
					process := l_fac.process_launcher_with_command_line (system.eiffel_system.application_name (True) + " --validate-fix " + config.interpreter_log_path + " true " + port.out , config.working_directory)
					process.launch
					check process.launched end

					if attached {like socket} socket_listener.wait_for_connection (5000) as l_socket then
						socket := l_socket

						create timer.make (agent on_test_case_execution_time_out)
						timer.set_timeout (0)
						timer.start

						create worker.make (config, fixes, melted_fixes, agent on_fix_validation_start, agent on_fix_validation_end, timer, socket, test_cases)
						worker.execute
						if process.is_running then
							process.wait_for_exit_with_timeout (5000)
						end
						if process.is_running then
							process.terminate_tree
							process.wait_for_exit_with_timeout (5000)
						end
						cleanup
					end
				end
			end
		end

	validate
			-- Validate `fixes'.
		do
			from until
				melted_fixes.is_empty or else should_quit
			loop
				validate_left_fixes
			end
		end

	melted_fix_from_fix (a_fix: AFX_FIX): detachable AFX_MELTED_FIX
			-- Melted fix from `a_fix'
		local
			l_class: EIFFEL_CLASS_C
			l_feat: FEATURE_I
			l_request: AFX_MELT_FEATURE_REQUEST
			l_byte_code: STRING
			l_body_id: INTEGER
			l_pattern_id: INTEGER
			l_data: TUPLE [byte_code: STRING; last_bpslot: INTEGER]
		do
			l_class ?= a_fix.recipient_written_class
			l_feat := a_fix.origin_recipient
			l_data := feature_byte_code_with_text (l_class, l_feat, "feature " + a_fix.feature_text)
			if not l_data.byte_code.is_empty then
				l_body_id := l_feat.real_body_id (l_class.types.first) - 1
				l_pattern_id := l_feat.real_pattern_id (l_class.types.first)
				create Result.make (a_fix.id, l_body_id, l_pattern_id, l_data.byte_code, l_data.last_bpslot)
			end
		end

feature{NONE} -- Inter-process communication

	socket: NETWORK_STREAM_SOCKET
			-- Socked used to perform interprocess communication with the debuggee

	socket_listener: AUT_SOCKET_LISTENER
			-- Socket listener

	port: INTEGER
			-- Port used by `socket'

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

				create socket_listener.make
				socket_listener.open_new_socket
				if socket_listener.is_listening then
					port := socket_listener.current_port
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

end
