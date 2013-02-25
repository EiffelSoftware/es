note
	description: "Summary description for {AFX_FIX_VALIDATION_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATION_THREAD

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
		a_melted_fixes: like melted_fixes;
		a_fix_start_agent: like on_fix_validation_start;
		a_fix_end_agent: like on_fix_validation_end;
		a_timer: like timer; a_socket: like socket; a_test_cases: like test_cases; a_passing_test_cases: like passing_test_cases)
			-- Initialize Current.
		do
			fixes := a_fixes
			melted_fixes := a_melted_fixes
			on_fix_validation_start := a_fix_start_agent
			on_fix_validation_end := a_fix_end_agent
			timer := a_timer
			socket := a_socket
			test_cases := a_test_cases.twin
			passing_test_cases := a_passing_test_cases.twin

			create nbr_of_valid_fix_map.make_equal (config.max_fixing_target + 1)
		end

feature -- Access

	fixes: HASH_TABLE [AFX_FIX, INTEGER]
			-- Fix candidates to validate
			-- Key is fix ID, value is the fix associated with that ID

	melted_fixes: LINKED_LIST [AFX_MELTED_FIX]
			-- Melted fixes to be validated

	max_test_case_time: INTEGER
			-- Max time in second to allow a test case to execute
		do
			Result := config.max_test_case_execution_time
		end

	test_cases: LINKED_LIST [EPA_TEST_CASE_INFO]
			-- Test cases used to validate fix candidates.

	passing_test_cases: LINKED_LIST [EPA_TEST_CASE_INFO]
			-- Passing test cases used to validate fix candidates.
			-- This should be a subset of `test_cases'.

	exception_count: NATURAL_32
			-- Number of exceptions when executing test cases.

	is_execution_over_time: BOOLEAN assign set_is_execution_over_time
			-- Is there any test case execution that failed to finish within `max_test_case_time'.

	last_test_case_execution_state: HASH_TABLE [AFX_TEST_CASE_EXECUTION_SUMMARY, EPA_TEST_CASE_INFO]
			-- State retrieved before/after test case execution.
			-- Key is test case, value is the execution summary associated with that test case.

feature {AFX_FIX_VALIDATOR} -- Status set

	set_is_execution_over_time (a_flag: BOOLEAN)
			-- Set `is_execution_over_time'.
		do
			is_execution_over_time := a_flag
		end

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
			create l_request.make (a_fix.feature_body_id, a_fix.feature_pattern_id, a_fix.feature_byte_code, fix_signature (fixes.item (a_fix.id), False, True))
			socket.put_natural_32 (request_melt_feature_type)
			socket.independent_store (l_request)
			socket.read_natural_32
		end

	send_execute_test_case_request (a_test_case: EPA_TEST_CASE_INFO; a_fix: AFX_FIX; a_retrieve_post_state: BOOLEAN)
			-- Send and execute test case request to the interpreter
			-- to execute the test case `a_test_case' to validate fix `a_fix'
			-- If `a_retrieve_post_state' is True, retrieve state after test case execution.
		local
			l_request: AFX_EXECUTE_TEST_CASE_REQUEST
			l_response: detachable ANY
		do
			create l_request.make (a_test_case.id, a_retrieve_post_state)
			socket.put_natural_32 (request_execute_test_case_type)
			socket.independent_store (l_request)
			socket.read_natural_32
			exception_count := socket.last_natural_32

				-- Get post state from the interpreter.
			if a_retrieve_post_state then
				l_response := socket.retrieved
				if attached {HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER]} l_response as l_post_state then
					set_last_post_execution_state (l_post_state, a_test_case, a_fix)
				elseif attached {STRING} l_response as l_str and then l_str.same_string (void_state) then
					set_last_post_execution_state (Void, a_test_case, a_fix)
				end
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

	nbr_of_valid_fix_map: DS_HASH_TABLE [INTEGER, AFX_FIXING_TARGET]
			-- Number of valid fixes for each fixing target.
			-- Key: fixing target.
			-- Val: number of valid fixes.

feature -- Execution

	execute
			-- Start execute current thread.
		local
			l_fix: AFX_MELTED_FIX
			l_origin_fix: AFX_FIX
			l_retried: BOOLEAN
			l_exception_count: NATURAL_32
			l_fixing_target: AFX_FIXING_TARGET
		do
			if not l_retried then
				timer.set_timeout (0)
				timer.start

				from
					melted_fixes.start
				until
					should_quit or else socket.is_closed or else not session.should_continue
				loop
					l_fix := melted_fixes.item_for_iteration
					melted_fixes.remove
					l_origin_fix := fixes.item (l_fix.id)
					l_fixing_target := l_origin_fix.fixing_target
					on_fix_validation_start.call ([l_fix])
					timer.set_timeout (max_test_case_time)

						-- Melt feature body with fix.
					send_melt_feature_request (l_fix)

						-- Execute all registered test cases.
					l_exception_count := exception_count
					set_is_execution_over_time (False)
					create last_test_case_execution_state.make (test_cases.count)
					from
						test_cases.start
					until
						exception_count /= l_exception_count or else is_execution_over_time or else test_cases.after or else not session.should_continue
					loop
						timer.set_timeout (max_test_case_time)
						send_execute_test_case_request (test_cases.item_for_iteration, l_origin_fix, False)
						timer.set_timeout (0)
						if exception_count /= l_exception_count or else is_execution_over_time then
							io.put_string ("Failing/Looping test case: ")
							io.put_string (test_cases.item_for_iteration.id)
							io.put_new_line
						end
						test_cases.forth
					end

						-- We found a fix which passes all test cases, re-execute all passing test cases to retrieve post states.
					if exception_count = l_exception_count and then not is_execution_over_time and then test_cases.after then
						from
							passing_test_cases.start
						until
							passing_test_cases.after
						loop
							timer.set_timeout (max_test_case_time)
							send_execute_test_case_request (passing_test_cases.item_for_iteration, l_origin_fix, True)
							timer.set_timeout (0)
							passing_test_cases.forth
						end
					end

					l_origin_fix.set_post_fix_execution_status (last_test_case_execution_state)
					on_fix_validation_end.call ([l_fix, exception_count])

					if not should_quit then
						set_should_quit (melted_fixes.after)
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

feature{NONE} -- Implementation

	print_state (a_state: detachable HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER])
			-- Print `a_state' to console.
		do
			if a_state /= Void then
				io.put_string ("Post state:%N")
				from
					a_state.start
				until
					a_state.after
				loop
					io.put_string ("Operand " + a_state.key_for_iteration.out + "%N")
					if attached {HASH_TABLE [STRING, STRING]} a_state.item_for_iteration as l_state then
						from
							l_state.start
						until
							l_state.after
						loop
							io.put_string (l_state.key_for_iteration + " == " + l_state.item_for_iteration + "%N")
							l_state.forth
						end
					end
					a_state.forth
				end
			else
				io.put_string ("Post state: Void%N")
			end
		end

	set_last_post_execution_state (a_state: HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER]; a_test_case: EPA_TEST_CASE_INFO; a_fix: AFX_FIX)
			-- Set post state of the test case `a_test_case' to `a_state',
			-- `a_state' is retrieved when executing the test case to validate `a_fix'.
		local
			l_summary: AFX_TEST_CASE_EXECUTION_SUMMARY
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_state: detachable EPA_STATE
			l_operand_names: HASH_TABLE [STRING, INTEGER]
			i: INTEGER
			l_args: FEAT_ARG
			l_state_string: STRING
			l_opd_state: HASH_TABLE [STRING, STRING]
			l_prefix: STRING
			l_expression: STRING
			l_value: STRING
		do
			if a_state /= Void then
				l_class := a_fix.recipient_class
				l_feature := a_fix.recipient_

					-- Find out operand names from `l_feature'.
				create l_operand_names.make (1 + l_feature.argument_count)
				l_operand_names.put ("", 0)
				from
					i := 1
					l_args := l_feature.arguments
				until
					i > l_feature.argument_count
				loop
					if l_args.i_th (i).is_basic then
						l_prefix := l_args.item_name (i).twin
					else
						l_prefix := l_args.item_name (i) + "."
					end
					l_operand_names.put (l_prefix, i)
					i := i + 1
				end

					-- Construct string representation for the state.
				create l_state_string.make (1024)
				from
					a_state.start
				until
					a_state.after
				loop
					l_prefix := l_operand_names.item (a_state.key_for_iteration)
					l_opd_state := a_state.item_for_iteration
					from
						l_opd_state.start
					until
						l_opd_state.after
					loop
						if l_prefix.ends_with (once ".") then
							l_expression := l_prefix + l_opd_state.key_for_iteration
						elseif l_prefix.is_empty then
							l_expression := l_opd_state.key_for_iteration
						else
							l_expression := l_prefix
						end
						l_value := l_opd_state.item_for_iteration
						if l_value.is_boolean or else l_value.is_integer then
							fixme ("Only support integer and boolean for the moment. 25.12.2009 Jasonw")
							l_state_string.append (l_expression)
							l_state_string.append (nonsensical)
							l_state_string.append (l_value)
							l_state_string.append_character ('%N')
						end
						l_opd_state.forth
					end
					a_state.forth
				end
				create l_state.make_from_string (l_class, l_feature, l_state_string)
			end

			create l_summary.make (a_test_case, Void, l_state)
			last_test_case_execution_state.put (l_summary, a_test_case)
		end

end
