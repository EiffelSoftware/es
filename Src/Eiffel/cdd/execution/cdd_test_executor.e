indexing
	description: "Objects that execute test cases through the console."
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_EXECUTOR

inherit

	CDD_ABSTRACT_EXECUTOR
		rename
			start as test_all
		end

	CDD_ROUTINES
		export
			{NONE} all
		end

	EV_SHARED_APPLICATION
		export
			{NONE} all
		end

	SHARED_PLATFORM_CONSTANTS
		export
			{NONE} all
		end

	SHARED_EXEC_ENVIRONMENT
		export
			{NONE} all
		end

	KL_SHARED_OPERATING_SYSTEM
		export
			{NONE} all
		end

	SHARED_FLAGS

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite) is
			-- Create a test executor.
		require
			a_test_suite: a_test_suite /= Void
		do
			test_suite := a_test_suite
			create root_class_printer.make (test_suite)

				-- Create action handlers
			create starting_compiling_actions
			create compiler_output_actions
			create starting_testing_actions
			create starting_testing_routine_actions
			create finished_testing_routine_actions
			create finished_testing_actions
			create error_actions
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Status report

	test_suite: CDD_TEST_SUITE
			-- Test suite containing tests we want to test

	is_executing: BOOLEAN is
			-- Is the test executor currently either compiling or testing?
		do
			Result := is_compiling or is_testing
		ensure then
			definition: Result = (is_compiling or is_executing)
		end

	is_compiling: BOOLEAN is
			-- Is the test executor currently compiling the test suite?
		do
			Result := compiler /= Void
		ensure
			definition: Result = (compiler /= Void)
		end

	is_testing: BOOLEAN is
			-- Is the test exeutor currently exeuting the test suite?
		do
			Result := proxy /= Void
		--ensure
			--definition: Result = (test_suite_process /= Void)
		end

feature -- Access

	current_test_class: CDD_TEST_CLASS is
			-- Test class currently beeing tested
		require
			executing: is_testing
		do
			Result := test_class_cursor.item
		ensure
			not_void: Result /= Void
		end


	current_test_routine: CDD_TEST_ROUTINE is
			-- Routine currently beeing tested
		require
			executing: is_testing
		do
			Result := test_routine_cursor.item
		ensure
			not_void: Result /= Void
		end

feature -- Basic operations

	test_all is
			-- Start compiling and testing in background.
			-- TODO: The idel action should be moved out of this class.
			-- It should be the clients responsibility.
			-- This way we also don't need to have this ugly `is_gui' hack in
			-- there.
		local
			l_target: CONF_TARGET
			l_system: CONF_SYSTEM
		do
			if not test_suite.test_classes.is_empty then
				if root_class_printer.last_print_succeeded then
					test_class_cursor := test_suite.test_classes.new_cursor
					create compiler.make
					starting_compiling_actions.call ([])
					l_target := test_suite.target
					l_system := l_target.system
					compiler.run (l_system.directory, l_system.file_name, tester_target_name (l_target))
					if is_gui then
						add_idle_action
					else
						compiler.block
						idle_action
					end
				else
					-- TODO: notify observers that printing the root class has failed
				end
			else
				finished_testing_actions.call ([])
			end
		end

	stop is
			-- Stop all running processes and remove idle action.
		do
			if is_executing then
				remove_idle_action
				if is_compiling then
					compiler.terminate
					compiler := Void
				else
					proxy.stop
					proxy := Void
				end
			end
			-- TODO: notify log that we have stoped testing
		end

feature -- Event handling

	starting_compiling_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when compiling is started

	compiler_output_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Agents called with the output from the compiler when any is read

	starting_testing_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when testing in general is beeing started

	starting_testing_routine_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_ROUTINE]]
			-- Agents called when we start testing some routine

	finished_testing_routine_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_ROUTINE]]
			-- Agents called when we have finished testing some routines
			-- and some outcome is available

	finished_testing_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when testing is finished

	error_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when some error occured
			-- NOTE: this only includes errors which forced the
			-- executor to terminate testing

feature {NONE} -- Implementation (execution)

	internal_start is
			-- Start compiling and testing in background.
		do
		ensure then
			executing: is_executing
		end

	idle_action_agent: PROCEDURE [ANY, TUPLE]
			-- Agent for 'idle_action'

	is_idle_action_added: BOOLEAN is
			-- Is `idle_action_agent' currently registered?
		do
			Result := idle_action_agent /= Void and then ev_application.idle_actions.has (idle_action_agent)
		end

	add_idle_action is
			-- Add `idle_action_agent' to EV_APPLICATION idle actions.
		require
			gui_available: is_gui
			not_added_yet: not is_idle_action_added
		do
			if idle_action_agent = Void then
				idle_action_agent := agent idle_action
			end
			ev_application.add_idle_action (idle_action_agent)
		ensure
			added: is_idle_action_added
		end

	remove_idle_action is
			-- Remove `idle_action_agent' from EV_APPLICATION idle actions.
		require
			gui_available: is_gui
			added: is_idle_action_added
		do
			ev_application.remove_idle_action (idle_action_agent)
		ensure
			not_added: not is_idle_action_added
		end

	idle_action is
			-- Check status of the process and its output.
		require
			executing: is_executing
		local
			l_go_idle: BOOLEAN
		do
			if is_compiling then
				if not compiler.is_running then
					if compiler.was_successful then
						starting_testing_actions.call ([])
						create proxy.make (interpreter_pathname, interpreter_pathname + "_log.txt")
						proxy.start
						next_test_routine
					else
						--io.error.put_string (compiler.error_message)
						error_actions.call ([])
						if is_gui then
							remove_idle_action
						end
					end
					compiler := Void
				end
			end
			if is_testing then
				from

				until
					not is_testing or l_go_idle
				loop
					if proxy.is_executing_request then
						proxy.process_response
					end
					if proxy.last_response /= Void or proxy.is_ready then
						if proxy.last_response /= Void then
							if proxy.last_response.has_bad_communication and execution_attempts < 1 then
									-- Proxy seems jammed, restart and try again
								proxy.stop
								proxy.start
								execution_attempts := execution_attempts + 1
							else
								current_test_routine.add_outcome (proxy.last_response)
									-- Proxy seems jammed, restart and try again
								proxy.stop
								proxy.start
								finished_testing_routine_actions.call ([current_test_routine])
								next_test_routine
							end
						end
						if test_class_cursor.after then
							proxy.stop
							proxy := Void
							test_class_cursor := Void
							test_routine_cursor := Void
							finished_testing_actions.call ([])
							if is_gui then
								remove_idle_action
							end
						else
							starting_testing_routine_actions.call ([current_test_routine])
							if is_gui then
								proxy.execute_test_async (current_test_class.test_class_name, current_test_routine.name)
								l_go_idle := True
							else
								proxy.execute_test (current_test_class.test_class_name, current_test_routine.name)
							end
						end
					elseif proxy.is_executing_request then
						l_go_idle := True
					end
				end
			end
		end

	next_test_routine is
			-- Move `test_class_cursor' and `test_routine_cursor' forward
		require
			valid_test_class_cursor: test_class_cursor /= Void and then not test_class_cursor.after
		do
			execution_attempts := 0
			if test_routine_cursor = Void or else test_routine_cursor.after or else test_routine_cursor.is_last then
				from
					test_class_cursor.forth
				until
					test_class_cursor.after or else not test_class_cursor.item.test_routines.is_empty
				loop
					test_class_cursor.forth
				end
				if test_class_cursor.after then
					test_routine_cursor := Void
				else
					test_routine_cursor := test_class_cursor.item.test_routines.new_cursor
					test_routine_cursor.start
				end
			else
				test_routine_cursor.forth
			end
		ensure
			execution_attempts_zero: execution_attempts = 0
			test_class_cursor_not_void: test_class_cursor /= Void
			test_class_cursor_after_equals_test_routine_cursor_void: test_class_cursor.after = (test_routine_cursor = Void)
			test_routine_cursor_not_void_equals_not_off: (test_routine_cursor /= Void) implies not test_routine_cursor.off
		end

	interpreter_pathname: FILE_NAME is
			-- Filename of compiled test suite
		do
			create Result.make_from_string (test_suite.target.system.directory)
			Result.extend ("EIFGENs")
			Result.extend (tester_target_name (test_suite.target))
			Result.extend ("W_code")
			if operating_system.is_unix then
				Result.extend (test_suite.target.system.name)
			else
				Result.extend (test_suite.target.system.name + ".exe")
			end
		ensure
			filename_not_void: Result /= Void
		end

	output_handler (an_output: STRING) is
			-- Call compiler output handlers with `an_output'.
		require
			an_output_not_void: an_output /= Void
		do
			compiler_output_actions.call ([an_output])
		end

feature {NONE} -- Implementation

	compiler: AUT_ISE_EIFFEL_COMPILER
			-- Process for compiling the interpreter

	proxy: CDD_INTERPRETER_PROXY
			-- Proxy for communicating with interpreter

	execution_attempts: INTEGER
			-- How many times have we attempted to test `current_test_feature'?

	test_class_cursor: DS_BILINEAR_CURSOR [CDD_TEST_CLASS]
			-- Cursor pointing to current test case beeing tested

	test_routine_cursor: DS_BILINEAR_CURSOR [CDD_TEST_ROUTINE]
			-- Cursor pointing to current routines beeing tested

	testing_output_buffer: STRING
			-- Output from testing process

	root_class_printer: CDD_INTERPRETER_CLASS_PRINTER
			-- Printer for root class (interpreter)

invariant

	test_suite_not_void: test_suite /= Void
	root_class_printer_not_void: root_class_printer /= Void
	executing_implies_compiling_xor_testing: is_executing implies (is_compiling xor is_testing)
	is_executing_implies_correct_cursor: is_executing implies (test_class_cursor /= Void and then not test_class_cursor.off)

	starting_compiling_actions_not_void: starting_compiling_actions /= Void
	compiler_output_actions_not_void: compiler_output_actions /= Void
	starting_testing_actions_not_void: starting_testing_actions /= Void
	starting_testing_routine_actions_not_void: starting_testing_routine_actions /= Void
	finished_testing_routine_actions_not_void: finished_testing_routine_actions /= Void
	finished_testing_actions_not_void: finished_testing_actions /= Void
	error_actions_not_void: error_actions /= Void

end
