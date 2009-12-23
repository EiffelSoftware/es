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

	make (a_config: like config; a_spot: like exception_spot; a_fixes: like fixes; a_status: like test_case_execution_status)
			-- Initialize Current to validate fix candidates `a_fixes'.
		require
			a_config_attached: a_config /= Void
			a_spot_attached: a_spot /= Void
			a_status_attached: a_status /= Void
		do
			config := a_config
			fixes := a_fixes
			exception_spot := a_spot
			test_case_execution_status := a_status
		end

feature -- Access

	config: AFX_CONFIG
			-- Config of Current AutoFix session

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception spot

	fixes: LINKED_LIST [AFX_FIX]
			-- Fix candidates to validate

	test_case_execution_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- Execution status for test cases related to the fault
			-- Key is uuid of a test case, value is the execution status of that test case

feature -- Actions


	on_application_launched (a_dm: DEBUGGER_MANAGER)
			-- Action to perform when the application is launched
		local
			l_good_fix: INTEGER
			l_exception_count: NATURAL_32
		do
			if attached {like socket} socket_listener.wait_for_connection (5000) as l_socket then
				socket := l_socket

				if not test_case_execution_status.is_empty then
					from
						fixes.start
					until
						fixes.after
					loop
						io.put_string (fixes.index.out + " / " + fixes.count.out + "   ")
						send_melt_feature_request (fixes.item_for_iteration)

						if is_last_fix_valid then
							l_exception_count := exception_count
							from
								test_case_execution_status.start
							until
								test_case_execution_status.after
							loop
								send_execute_test_case_request (test_case_execution_status.key_for_iteration)
								test_case_execution_status.forth
							end
							io.put_string ("Failed: " + (exception_count.to_integer_32 - l_exception_count.to_integer_32).out + "  Succeeded: " + (test_case_execution_status.count - (exception_count.to_integer_32 - l_exception_count.to_integer_32)).out + "%N")
							if exception_count = l_exception_count then
--								io.put_string ("====================================================%N")
								l_good_fix := l_good_fix + 1
								io.put_string ("Good fix No." + l_good_fix.out + "%N")
								io.put_string (formated_fix (fixes.item_for_iteration))
--								io.put_string ("Ranking: " + fixes.item_for_iteration.ranking.score.out + "%N")
--								io.put_string (fixes.item_for_iteration.feature_text)
--								io.put_string ("%N")
							end
						end
						fixes.forth
					end
				end
				send_exit_request
				cleanup
				process.wait_for_exit
			end
		end

	formated_fix (a_fix: AFX_FIX): STRING
			-- Pretty printed feature text for `a_fix'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
		do
			if a_fix.feature_text.has_substring ("should not happen") then
				Result := a_fix.feature_text.twin
			else
				entity_feature_parser.parse_from_string ("feature " + a_fix.feature_text, Void)
				create l_output.make_with_indentation_string ("%T")
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (entity_feature_parser.feature_node)
				Result := l_output.string_representation
			end
		end

--	on_application_exited (a_dm: DEBUGGER_MANAGER)
--			-- Action to perform when the application is exited
--		do

--		end

--	on_application_stopped (a_dm: DEBUGGER_MANAGER)
--			-- Action to be performed when application is stopped in the debugger
--		do
--			if a_dm.application_is_executing or a_dm.application_is_stopped then

--				if a_dm.application_status.reason_is_catcall or a_dm.application_status.reason_is_overflow then
--					a_dm.application.kill
--				else
--					io.put_string (a_dm.application_status.exception_text + "%N")
--					exception_count := exception_count + 1
--					a_dm.controller.resume_workbench_application
--				end
--			end
--		end

feature{NONE} -- Requests for interpreter

	send_exit_request
			-- Send an exit request to the interpreter.
		do
			socket.put_natural_32 (request_exit_type)
			socket.independent_store (create {AFX_INTERPRETER_REQUEST})
		end

	send_execute_test_case_request (a_uuid: STRING)
			-- Send and execute test case request to the interpreter
			-- to execute the test case specified by `a_uuid'.
		local
			l_request: AFX_EXECUTE_TEST_CASE_REQUEST
		do
			create l_request.make (a_uuid)
			socket.put_natural_32 (request_execute_test_case_type)
			socket.independent_store (l_request)
			socket.read_natural_32
			exception_count := socket.last_natural
		end

	send_melt_feature_request (a_fix: AFX_FIX)
			-- Send request the the interpreter to melt `a_fix' for the feature under fix.
		local
			l_class: EIFFEL_CLASS_C
			l_feat: FEATURE_I
			l_request: AFX_MELT_FEATURE_REQUEST
			l_byte_code: STRING
			l_body_id: INTEGER
			l_pattern_id: INTEGER
			l_data: TUPLE [byte_code: STRING; last_bpslot: INTEGER]
		do
			l_class ?= a_fix.recipient_class
			l_feat := a_fix.recipient_
			l_data := feature_byte_code_with_text (l_class, l_feat, "feature " + a_fix.feature_text)
			is_last_fix_valid := not l_data.byte_code.is_empty
			if is_last_fix_valid then
				last_breakpoint_slot := l_data.last_bpslot
				l_body_id := l_feat.real_body_id (l_class.types.first) - 1
				l_pattern_id := l_feat.real_pattern_id (l_class.types.first)

				create l_request.make (l_body_id, l_pattern_id, l_data.byte_code)
				socket.put_natural_32 (request_melt_feature_type)
				socket.independent_store (l_request)
			end
		end

	is_last_fix_valid: BOOLEAN
			-- Is last tried fix a valid Eiffel piece of code?

	last_breakpoint_slot: INTEGER
			-- Last break point slot

	exception_count: NATURAL_32

feature -- Basic operations

	process: PROCESS

	validate
			-- Validate `fixes'.
		local
			l_launch_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_exit_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_fac: PROCESS_FACTORY
		do
				-- Setup debugger manipulation agents.
--			l_launch_agent := agent on_application_launched
--			l_exit_agent := agent on_application_exited
--			l_stop_agent := agent on_application_stopped
--			debugger_manager.observer_provider.application_launched_actions.extend (l_launch_agent)
--			debugger_manager.observer_provider.application_exited_actions.extend (l_exit_agent)
--			debugger_manager.observer_provider.application_stopped_actions.extend (l_stop_agent)

				-- Start server for IPC.
			establish_socket

				-- Launch debugger.
			if socket_listener.is_listening then
				create l_fac

				process := l_fac.process_launcher_with_command_line (system.eiffel_system.application_name (True) + " --validate-fix " + config.interpreter_log_path + " true " + port.out , config.working_directory)
				process.launch
				check process.launched end
				on_application_launched (debugger_manager)
--				start_debugger (debugger_manager, "--validate-fix " + config.interpreter_log_path + " true " + port.out,  config.working_directory)
			end

				-- Remove debugger manipulation agents.
--			debugger_manager.observer_provider.application_launched_actions.prune_all (l_launch_agent)
--			debugger_manager.observer_provider.application_exited_actions.prune_all (l_exit_agent)
--			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_stop_agent)
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
