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
			create output.make
			create root_class_printer.make (test_suite)
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

	current_test_case: CDD_TEST_CASE is
			-- Test case currently beeing tested
		require
			executing: is_testing
		do
			Result := test_case_cursor.item
		ensure
			not_void: Result /= Void
		end

	test_case_index: INTEGER is
			-- Index of the test case beeing tested relative to test suite
		require
			executing: is_testing
		do
			Result := test_case_cursor.index
		ensure
			valid_index: Result >= 1 and Result <= test_suite.test_cases.count
		end

	current_test_feature: STRING is
			-- Test routine in `current_test_case' beeing tested
		require
			executing: is_testing
		do
			Result := test_feature_cursor.item
		end

feature -- Basic operations

	test_all is
			-- Start compiling and testing in background.
		local
			l_target: CONF_TARGET
			l_system: CONF_SYSTEM
		do
			root_class_printer.print_root_class
			if not root_class_printer.last_print_succeeded then
				create compiler.make
				-- TODO: notify gui that compiling has started...
				l_target := test_suite.target
				l_system := l_target.system
				if is_gui then
					-- TODO: what to do with compiler output?
					compiler.set_output_handler (agent output_handler)
				else
					compiler.set_output_handler (agent io.put_string)
				end
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

feature {NONE} -- Internal execution

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
			l_output: STRING
			l_pos: INTEGER
			l_idle: BOOLEAN
			l_ft: FEATURE_TABLE
		do
			if output.has_new_block then
				l_output := output.all_blocks (True).string_representation
				-- TODO: redirect output to observers
				io.put_string (l_output)
			end
			if is_compiling then
				if not compiler.is_running then
					if compiler.was_successful then
						create proxy.make (interpreter_pathname, interpreter_pathname + "_log.txt")
						proxy.start
					else
						-- TODO: notify observers that compiling has failed
						if is_gui then
							remove_idle_action
						end
					end
					compiler := Void
				end
			end
			if is_testing then
				from
					next_test_routine
				until
					proxy = Void or l_idle
				loop
					if proxy.is_executing_request or not proxy.is_ready then
						if not proxy.is_running then
							execution_attempts := execution_attempts + 1
							proxy.stop
							if execution_attempts > max_execution_attempts then
								next_test_routine
							end
							if not test_case_cursor.after then
								proxy.start
							end
						else
							proxy.process_response
							if proxy.last_response /= Void then
								-- TODO: do something with the result
								next_test_routine
							end
						end
						if test_case_cursor.after then
							proxy.stop
							proxy := Void
							test_case_cursor := Void
							test_feature_cursor := Void
							-- TODO: notify observers that we are finished with testing
							if is_gui then
								remove_idle_action
							end
						end
					else
						proxy.execute_test (current_test_case.test_class.name, current_test_feature)
					end
					if is_gui then
						l_idle := True
					end
				end
			end
		end

	retrieve_test_case_status is
			-- Parse testing results for `current_test_case' from `testing_output_buffer'.
		require
			testing: is_executing
		local
			l_list: LIST [STRING]
			l_status: INTEGER
			l_class, l_feature: STRING
			l_exception: STRING
		do
			-- Add some outcome to
		end

feature {NONE} -- Implementation

	next_test_routine is
			-- Move `test_case_cursor' and `test_feature_cursor' to forward
		local
			l_done: BOOLEAN
		do
			execution_attempts := 0
			if test_case_cursor = Void then
				test_case_cursor := test_suite.test_cases.new_cursor
				test_case_cursor.start
			end
			if test_feature_cursor = Void then
				if not test_case_cursor.after then
					test_feature_cursor := test_routines_old (test_case_cursor.item.test_class).new_cursor
					test_feature_cursor.start
				else
					test_feature_cursor := (create {DS_LINKED_LIST [STRING]}.make).new_cursor
				end
			end
			from until
				test_case_cursor.after or else (not test_feature_cursor.after)
			loop
				if test_feature_cursor.after then
					test_case_cursor.forth
					if not test_case_cursor.after then
						test_feature_cursor := test_routines_old (test_case_cursor.item.test_class).new_cursor
					end
				else
					test_feature_cursor.forth
				end
			end
		ensure
			test_case_cursor_not_void: test_case_cursor /= Void
			test_feature_cursor_not_void: test_feature_cursor /= Void
			same_state: test_case_cursor.off = test_feature_cursor.off
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

	test_suite_dirname: FILE_NAME is
			-- Directory name of test suite executable
		do
			create Result.make_from_string (test_suite.target.system.directory)
			Result.extend ("EIFGENs")
			Result.extend ("cdd_tester")
			Result.extend ("W_code")
		ensure
			filename_not_void: Result /= Void
		end

	start_test_case_execution (a_test_case: CDD_TEST_CASE) is
			-- Start executing `a_test_case' in background.
		require
			a_test_case_not_void: a_test_case /= Void
			has_compiled: (is_compiling and then compiler.was_successful) or is_executing
		local
--			arguments: ARRAYED_LIST [STRING]
--			env_vars: HASH_TABLE [STRING, STRING_8]
		do
--			compiler := Void
--			if operating_system.is_windows then
--				create arguments.make (1)
--				arguments.force (a_test_case.tester_class.name)
--				test_suite_process := process_launcher (test_suite_exe_filename, arguments, test_suite_dirname)
--			else
--				create arguments.make (2)
--				arguments.extend ("-c")
--				arguments.extend ("%'%'"+test_suite_exe_filename+" "+a_test_case.tester_class.name+"%'%'")
--				test_suite_process := process_launcher ("/bin/sh", arguments, test_suite_dirname)
--			end
--			create testing_output_buffer.make_empty
--			manager.update_state_actions.call (["Testing " + test_case.tester_class.name])
--			test_suite_process.redirect_output_to_agent (agent output_handler)
--			test_suite_process.redirect_error_to_same_as_output
--			test_suite_process.set_buffer_size (512)
--			test_suite_process.enable_launch_in_new_process_group

--			create env_vars.make (1)
--			env_vars.put (test_suite_dirname, "MELT_PATH")
--			test_suite_process.set_environment_variable_table (env_vars)
--			test_suite_process.set_hidden (True)
--			test_suite_process.launch
		ensure
--			testing: is_executing
		end

	output_handler (an_output: STRING) is
			-- Append `an_output' to output.
		require
			an_output_not_void: an_output /= Void
		local
			l_storage: EB_PROCESS_IO_STRING_BLOCK
		do
			create l_storage.make (an_output, False, False)
			output.extend_block (l_storage)
		end

feature {NONE} -- Implementation

	compiler: AUT_ISE_EIFFEL_COMPILER
			-- Process for compiling the interpreter

	proxy: CDD_INTERPRETER_PROXY
			-- Proxy for communicating with interpreter

	execution_attempts: INTEGER
			-- How many times have we attempted to test `current_test_feature'?

	output: EB_PROCESS_IO_STORAGE
			-- Stored output from the process

	test_case_cursor: DS_LIST_CURSOR [CDD_TEST_CASE]
			-- Cursor pointing to current test case beeing tested

	test_feature_cursor: DS_LIST_CURSOR [STRING]
			-- Cursor pointing to current feature name beeing tested

	testing_output_buffer: STRING
			-- Output from testing process

	root_class_printer: CDD_ROOT_CLASS_PRINTER
			-- Prints root class

invariant

	test_suite_not_void: test_suite /= Void
	root_class_printer_not_void: root_class_printer /= Void
	--executing_equals_idle_action_added: is_executing = is_idle_action_added
	executing_implies_compiling_xor_testing: is_executing implies (is_compiling xor is_testing)
	is_testing_implies_correct_cursor: is_testing implies (test_case_cursor /= Void and then not test_case_cursor.off)
	is_testing_implies_correct_cursor: is_testing implies (test_feature_cursor /= Void and then not test_feature_cursor.off)
	output_not_void: output /= Void

end
