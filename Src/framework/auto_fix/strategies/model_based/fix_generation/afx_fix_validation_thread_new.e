note
	description: "Summary description for {AFX_FIX_VALIDATION_THREAD_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATION_THREAD_NEW

inherit
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

	AFX_UTILITY
		rename
			system as eiffel_system
		end

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	a_pl: LINKED_PRIORITY_QUEUE [INTEGER]

	make (
		a_fixes: like fixes;
		a_fix_start_agent: like on_fix_validation_start;
		a_fix_end_agent: like on_fix_validation_end;
		a_timer: like timer; a_socket: like socket;
		a_test_cases: like test_cases)
			-- Initialize Current.
		do
			fixes := a_fixes
			on_fix_validation_start := a_fix_start_agent
			on_fix_validation_end := a_fix_end_agent
			timer := a_timer
			socket := a_socket
			test_cases := a_test_cases.twin
		end

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Fix candidates to validate

	max_test_case_time: INTEGER
			-- Max time in second to allow a test case to execute
		do
			Result := config.max_test_case_execution_time.to_integer_32
		end

	test_cases: DS_LINEAR [EPA_TEST_CASE_INFO]
			-- Test cases used to validate fix candidates.

	exception_count: NATURAL_32
			-- Number of exceptions when executing test cases.

	is_execution_over_time: BOOLEAN assign set_is_execution_over_time
			-- Is there any test case execution that failed to finish within `max_test_case_time'.

feature --{AFX_FIX_VALIDATOR} -- Status set

	set_is_execution_over_time (a_flag: BOOLEAN)
			-- Set `is_execution_over_time'.
		do
			is_execution_over_time := a_flag
		end

feature -- Status report

	should_quit: BOOLEAN
			-- Should current thread exit?

feature -- Actions

	on_fix_validation_start: PROCEDURE [ANY, TUPLE [a_fix: AFX_CODE_FIX_TO_FAULT]]
			-- Action to be performed when `melted_fix' is about to be validated.

	on_fix_validation_end: PROCEDURE [ANY, TUPLE [a_fix: AFX_CODE_FIX_TO_FAULT; except_count: NATURAL_32]]
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

	send_execute_test_case_request (a_test_case: EPA_TEST_CASE_INFO; a_fix: AFX_CODE_FIX_TO_FAULT; a_retrieve_post_state: BOOLEAN)
			-- Send and execute test case request to the interpreter
			-- to execute the test case `a_test_case' to validate fix `a_fix'
			-- If `a_retrieve_post_state' is True, retrieve state after test case execution.
		local
			l_request: AFX_EXECUTE_TEST_CASE_REQUEST
			l_response: detachable ANY
		do
			create l_request.make (a_fix.id, a_test_case.id, a_retrieve_post_state)
			socket.put_natural_32 (request_execute_test_case_type)
			socket.independent_store (l_request)
			socket.read_natural_32
			exception_count := socket.last_natural_32
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
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_retried: BOOLEAN
			l_exception_count: NATURAL_32
			l_fixing_target: AFX_FIXING_TARGET
			l_test_cursor: DS_LINEAR_CURSOR [EPA_TEST_CASE_INFO]
			l_notification: STRING
		do
			if not l_retried then
				timer.set_timeout (0)
				timer.start

				from
				until
					should_quit or else socket.is_closed or else not session.should_continue or else fixes.is_empty
				loop
					l_fix := fixes.first
					fixes.remove_first
					l_fixing_target := l_fix.fixing_target

					on_fix_validation_start.call ([l_fix])
					timer.set_timeout (max_test_case_time)

						-- Execute all registered test cases.
					l_exception_count := exception_count
					set_is_execution_over_time (False)
					from
						l_test_cursor := test_cases.new_cursor
						l_test_cursor.start
					until
						exception_count /= l_exception_count or else is_execution_over_time or else l_test_cursor.after or else not session.should_continue
					loop
						timer.set_timeout (max_test_case_time)
						send_execute_test_case_request (l_test_cursor.item, l_fix, False)
						timer.set_timeout (0)

							-- Non-terminating tests are like failing ones.
						if is_execution_over_time then
							exception_count := l_exception_count + 1
						end

						if exception_count /= l_exception_count or else is_execution_over_time then
							l_notification := "%TFailing/Overlong test case: " + l_test_cursor.item.id
							event_actions.notify_on_general_notification_issued (l_notification)
						end
						l_test_cursor.forth
					end

					on_fix_validation_end.call ([l_fix, exception_count])

					if not should_quit then
						set_should_quit (fixes.after)
					end
				end
				send_exit_request
				timer.set_should_quit (True)
				timer.set_timeout (0)
			end
		rescue
			timer.set_should_quit (True)
			timer.set_timeout (0)
			l_retried := True
			retry
		end

end

