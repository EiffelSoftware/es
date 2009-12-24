note
	description: "Summary description for {AFX_FIX_VALIDATION_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATION_THREAD

inherit
--	THREAD
--		rename
--			sleep as thread_sleep,
--			launch as launch_thread
--		export
--			{NONE} all
--		end

	AFX_INTERPRETER_CONSTANTS


	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

	EXECUTION_ENVIRONMENT
		rename
			launch as launch_process
		export
			{NONE} all
		end

	KL_SHARED_OPERATING_SYSTEM
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

create
	make

feature{NONE} -- Initialization

	make (
		a_melted_fixes: like melted_fixes;
		a_max_tc_time: INTEGER;
		a_fix_start_agent: like on_fix_validation_start;
		a_fix_end_agent: like on_fix_validation_end;
		a_timer: like timer; a_socket: like socket; a_test_cases: like test_cases)
			-- Initialize Current.
		do
			melted_fixes := a_melted_fixes
			max_test_case_time := a_max_tc_time
			on_fix_validation_start := a_fix_start_agent
			on_fix_validation_end := a_fix_end_agent
			timer := a_timer
			socket := a_socket
			test_cases := a_test_cases.twin
		end

feature -- Access

	melted_fixes: LINKED_LIST [AFX_MELTED_FIX]
			-- Melted fixes to be validated

	max_test_case_time: INTEGER
			-- Max time in second to allow a test case to execute

	test_cases: LINKED_LIST [STRING]
			-- Universal IDs for test cases used to validate fix candidats.

	exception_count: NATURAL_32

feature -- Status report

	should_quit: BOOLEAN
			-- Should current thread exit?

feature -- Actions

	on_fix_validation_start: PROCEDURE [ANY, TUPLE [melted_fix: AFX_MELTED_FIX]]
			-- Action to be performed when `melted_fix' is about to be validated.

	on_fix_validation_end: PROCEDURE [ANY, TUPLE [melted_fix: AFX_MELTED_FIX; except_count: NATURAL_32]]
			-- Action to be performed when `melted_fix' is validated.

feature -- Setting

	set_should_quit (b: BOOLEAN)
			-- Set `should_quit' with `b'.
		do
			should_quit := b
		ensure
			should_quit_set: should_quit = b
		end

feature{NONE} -- Impelmentation

	send_melt_feature_request (a_fix: AFX_MELTED_FIX)
			-- Send request the the interpreter to melt `a_fix' for the feature under fix.
		local
			l_request: AFX_MELT_FEATURE_REQUEST
			l: NATURAL_32
		do
			create l_request.make (a_fix.feature_body_id, a_fix.feature_pattern_id, a_fix.feature_byte_code)
			socket.put_natural_32 (request_melt_feature_type)
			socket.independent_store (l_request)
			socket.read_natural_32
		end

	send_execute_test_case_request (a_uuid: STRING)
			-- Send and execute test case request to the interpreter
			-- to execute the test case specified by `a_uuid'.
		local
			l_request: AFX_EXECUTE_TEST_CASE_REQUEST
			l_response: detachable ANY
		do
			create l_request.make (a_uuid)
			socket.put_natural_32 (request_execute_test_case_type)
			socket.independent_store (l_request)
			socket.read_natural_32
			exception_count := socket.last_natural_32
			l_response := socket.retrieved
			if attached {HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER]} l_response as l_post_state then
				io.put_string ("Post state:%N")
				from
					l_post_state.start
				until
					l_post_state.after
				loop
					io.put_string ("Operand " + l_post_state.key_for_iteration.out + "%N")
					if attached {HASH_TABLE [STRING, STRING]} l_post_state.item_for_iteration as l_state then
						from
							l_state.start
						until
							l_state.after
						loop
							io.put_string (l_state.key_for_iteration + " == " + l_state.item_for_iteration + "%N")
							l_state.forth
						end
					end
					l_post_state.forth
				end
			elseif attached {STRING} l_response as l_str and then l_str ~ void_state then
				io.put_string ("Post state: Void%N")
			end
		end

	send_exit_request
			-- Send an exit request to the interpreter.
		do
			if socket.is_open_write then
				socket.put_natural_32 (request_exit_type)
				socket.independent_store (create {AFX_INTERPRETER_REQUEST})
			end
		end

feature{NONE} -- Inter-process communication

	socket: NETWORK_STREAM_SOCKET
			-- Socked used to perform interprocess communication with the debuggee

	timer: AFX_TIMER_THREAD
			-- Timer to control test case execution time

feature -- Execution

	execute
			-- Start execute current thread.
		local
			l_fix: AFX_MELTED_FIX
		do
			timer.set_timeout (0)
			timer.start

			from
				melted_fixes.start
			until
				should_quit or else socket.is_closed
			loop
				l_fix := melted_fixes.item_for_iteration
				on_fix_validation_start.call ([l_fix])
				timer.set_timeout (max_test_case_time)

					-- Melt feature body with fix.
				send_melt_feature_request (l_fix)

					-- Execute all registered test cases.
				from
					test_cases.start
				until
					test_cases.after
				loop
					timer.set_timeout (max_test_case_time)
					send_execute_test_case_request (test_cases.item_for_iteration)
					timer.set_timeout (0)
					test_cases.forth
				end
				on_fix_validation_end.call ([l_fix, exception_count])
				melted_fixes.remove
				set_should_quit (melted_fixes.after)
			end

			send_exit_request
			timer.set_should_quit (True)
		end

end
