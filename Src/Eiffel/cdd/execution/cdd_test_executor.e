indexing
	description: "Compiles and executes unit tests in the background (in a separate process)"
	instructions: "[
					This class allows testing in the background through
					a poor mans implementation of cooperative multi-tasking.
					To start testing call `start' and then call `step' as long
					as `has_next_step' is `True'. It is guaranteed that `step' will
					not block for too long.
				  ]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_EXECUTOR

inherit

	AUT_TASK

	CDD_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_OPERATING_SYSTEM
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_cdd_manager: like cdd_manager) is
			-- Create a test executor.
		require
			a_cdd_manager_not_void: a_cdd_manager /= Void
		do
			cdd_manager := a_cdd_manager
			create root_class_printer.make (test_suite)
		ensure
			cdd_manager_set: cdd_manager = a_cdd_manager
		end

feature -- Status report

	test_suite: CDD_TEST_SUITE is
			-- Test suite containing tests we want to test
		do
			Result := cdd_manager.test_suite
		end

	cdd_manager: CDD_MANAGER
			-- Manager controlling `Current'

	has_next_step: BOOLEAN is
			-- Is the test executor currently either compiling or testing?
		do
			Result := is_compiling or is_executing
		ensure then
			definition: Result = (is_compiling xor is_executing)
		end

	is_compiling: BOOLEAN is
			-- Is the test executor currently compiling the test suite?
		do
			Result := compiler /= Void
		ensure
			definition: Result = (compiler /= Void)
		end

	is_executing: BOOLEAN is
			-- Is the test exeutor currently exeuting the test suite?
		do
			Result := proxy /= Void
		end

feature -- Access

	current_test_class: CDD_TEST_CLASS is
			-- Test class currently beeing tested;
			-- Void if currently not testing
		do
			if test_class_cursor /= Void then
				Result := test_class_cursor.item
			end
		end

	current_test_routine: CDD_TEST_ROUTINE is
			-- Routine currently beeing tested;
			-- Void if currently not testing
		do
			if test_routine_cursor /= Void then
				Result := test_routine_cursor.item
			end
		end

feature -- Basic operations

	start is
			-- Start compiling and testing in background.
		local
			l_target: CONF_TARGET
			l_system: CONF_SYSTEM
		do
			if has_next_step then
				cancel
			end
			if not test_suite.test_classes.is_empty then
				root_class_printer.print_class
				if root_class_printer.last_print_succeeded then
					create compiler.make
					compiler.set_output_handler (agent io.put_string)
					cdd_manager.status_update_actions.call ([update_step])
					l_target := test_suite.target
					l_system := l_target.system
					compiler.run (l_system.directory, l_system.file_name, tester_target_name (l_target))
				else
					-- TODO: notify observers that printing the root class has failed
				end
			else
				cdd_manager.status_update_actions.call ([update_step])
			end
		end

	cancel is
			-- Stop all running processes.
		do
			if is_compiling then
				if compiler.is_running then
					compiler.terminate
				end
				compiler := Void
			else
				if proxy.is_launched then
					proxy.stop
				end
				proxy := Void
			end
			cdd_manager.status_update_actions.call ([update_step])
		end

	step is
			-- Execute one short testing step.
		do
			if is_compiling then
				step_compile
			elseif is_executing then
				step_executing
			end
		end

feature {NONE} -- Implementation (execution)

	step_compile is
			-- Execute one short step in compiling the test suite.
		require
			is_compiling: is_compiling
		do
			if compiler.is_running then
				compiler.process_output
			else
				if compiler.was_successful then
					create proxy.make (interpreter_pathname, interpreter_pathname + "_log.txt")
					proxy.start
					select_first_test_routine
				else
					cdd_manager.status_update_actions.call ([create {CDD_STATUS_UPDATE}.make_with_code ({CDD_STATUS_UPDATE}.execution_error_code)])
				end
				compiler := Void
				cdd_manager.status_update_actions.call ([update_step])
			end
		end

	step_executing is
			-- Execute one short step in executing the test suite.
		require
			is_executing: is_executing
			current_test_routine_not_void: current_test_routine /= Void
		local
			l_list: DS_ARRAYED_LIST [CDD_TEST_ROUTINE_UPDATE]
		do
			if proxy.last_response /= Void then
				current_test_routine.add_outcome (proxy.last_response)
				create l_list.make (1)
				l_list.put_first (create {CDD_TEST_ROUTINE_UPDATE}.make (current_test_routine, {CDD_TEST_ROUTINE_UPDATE}.new_outcome_code))
				test_suite.test_routine_update_actions.call ([l_list])
				select_next_test_routine
				if not proxy.is_ready then
					check proxy.last_response.has_bad_communication end
						-- Proxy seems jammed, restart and try again
					proxy.stop
					proxy.start
				end
			end
			if current_test_class = Void then
				proxy.stop
				proxy := Void
				cdd_manager.status_update_actions.call ([update_step])
			else
				if proxy.is_ready then
					cdd_manager.status_update_actions.call ([update_step])
					proxy.execute_test_async (current_test_class.test_class_name, current_test_routine.name)
				elseif proxy.is_executing_request then
					proxy.process_response
				end
			end
		end

	select_first_test_routine is
			-- Select first routine under test. Similar to
			-- `select_next_test_routine'.
		do
			test_class_cursor := test_suite.test_classes.new_cursor
			select_next_test_routine
		end

	select_next_test_routine is
			-- Move `test_routine_cursor' and `test_routine_class' so that they point
			-- to the next routine under test. Set `test_routine_cursor' and `test_class_cursor'
			-- to void if no more routines are under test.
		require
			is_executing: is_executing
		do
			if test_routine_cursor = Void or else test_routine_cursor.after or else test_routine_cursor.is_last then
					-- Skip test classes with no test routines.
				from
					test_class_cursor.forth
				until
					test_class_cursor.after or else not test_class_cursor.item.test_routines.is_empty
				loop
					test_class_cursor.forth
				end
				if test_class_cursor.after then
					test_routine_cursor := Void
					test_class_cursor := Void
				else
					test_routine_cursor := test_class_cursor.item.test_routines.new_cursor
					test_routine_cursor.start
				end
			else
				test_routine_cursor.forth
			end
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

feature {NONE} -- Implementation

	compiler: AUT_ISE_EIFFEL_COMPILER
			-- Process for compiling the interpreter

	proxy: CDD_INTERPRETER_PROXY
			-- Proxy for communicating with interpreter

	test_class_cursor: DS_BILINEAR_CURSOR [CDD_TEST_CLASS]
			-- Cursor pointing to current test case beeing tested

	test_routine_cursor: DS_BILINEAR_CURSOR [CDD_TEST_ROUTINE]
			-- Cursor pointing to current routines beeing tested;
			-- May be Void if no routine is currently under test.

	testing_output_buffer: STRING
			-- Output from testing process

	root_class_printer: CDD_INTERPRETER_CLASS_PRINTER
			-- Printer for root class (interpreter)

	update_step: CDD_STATUS_UPDATE is
			-- Update used after each step of `Current'
		once
			create Result.make_with_code ({CDD_STATUS_UPDATE}.executor_step_code)
		ensure
			not_void: Result /= Void
		end

invariant

	cdd_manager_not_void: cdd_manager /= Void
	not_executing_and_compiling: not (is_executing and is_compiling)
	test_suite_not_void: test_suite /= Void
	root_class_printer_not_void: root_class_printer /= Void
	is_executing_implies_correct_cursor: is_executing implies (test_class_cursor /= Void and then not test_class_cursor.off)
	test_class_cursor_not_off: test_class_cursor /= Void implies not test_class_cursor.off
	test_routine_cursor_not_off: test_routine_cursor /= Void implies not test_routine_cursor.off
end
