indexing
	description: "Objects that execute test cases through the console."
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_EXECUTOR

inherit

	CDD_ABSTRACT_TESTER
		redefine
			make_with_manager
		end

	EV_SHARED_APPLICATION
		export {NONE} all end

	SHARED_PLATFORM_CONSTANTS
		export {NONE} all end

	SHARED_EXEC_ENVIRONMENT
		export {NONE} all end

	PROCESS_FACTORY
		export {NONE} all end

	KL_SHARED_OPERATING_SYSTEM
		export {NONE} all end

create
	make_with_manager

feature {NONE} -- Initialization

	make_with_manager (a_manager: like manager) is
			-- Create compiler
		local
			-- Added so class gets compiled, to be removed
			l_tmp: CDD_INTERPRETER_SUPPORT
		do
			Precursor {CDD_ABSTRACT_TESTER} (a_manager)
			manager.refresh_actions.extend (agent refresh)
			create output.make
		end

feature -- Status report

	is_running: BOOLEAN is
			-- Is the test executor currently either compiling or testing?
		do
			Result := is_compiling or is_executing
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

	is_executing: BOOLEAN is
			-- Is the test exeutor currently exeuting the test suite?
		do
			Result := test_suite_process /= Void
		ensure
			definition: Result = (test_suite_process /= Void)
		end

	can_start: BOOLEAN is
			-- Can background testing be launched?
		do
			Result := not is_running and test_suite.test_cases.count > 0 and not manager.open_project.is_read_only
		end

feature -- Access

	test_case: CDD_TEST_CASE is
			-- Test case currently beeing tested
		do
			Result := cursor.item
		end

feature {CDD_MANAGER} -- Basic operations

	start is
			-- Start compiling and testing in the background.
		require
			can_start_background_testing: can_start
		do
			create compiler.make
			compiler.set_output_handler (agent output_handler)
			cursor := test_suite.test_cases.new_cursor
			cursor.start
			create_root_class
			manager.update_testing_status ("Compiling test cases")
			compiler.run (test_suite.tests_cluster.target.system.directory, manager.open_target.system.file_name, tester_target_name)
			add_idle_action
		ensure
			running: is_running
		end

	stop is
			-- Stop all running processes and remove idle action.
		do
			remove_idle_action
			if is_executing then
				if test_suite_process.is_running then
					test_suite_process.terminate
				end
				test_suite_process := Void
				cursor := Void
			else
				compiler.terminate
				compiler := Void
			end
			manager.update_state_actions.call (["Done"])
		end

	has_tester_target: BOOLEAN is
			-- Is a cdd-tester target in current config present?
		do
			Result := manager.open_target.system.targets.has (tester_target_name)
		end

	add_tester_target is
			-- Add target with name `tester_target_name' to system.
		require
			not_present: not has_tester_target
		local
			l_target: CONF_TARGET
			l_new_root: CONF_ROOT
		do
			l_target := conf_factory.new_target (tester_target_name, manager.open_target.system)
			manager.open_target.system.add_target (l_target)
			l_target.set_parent (manager.open_target)
			l_new_root := conf_factory.new_root (test_suite.tests_cluster.cluster_name, executor_root_class_name, root_class_feature_name, False)
			l_target.set_root (l_new_root)
			l_target.add_setting (l_target.s_console_application, "true")
			manager.open_target.system.store
		ensure
			added: has_tester_target
		end

	remove_tester_target is
			-- Remove target with name `tester_target_name' from system.
		require
			present: has_tester_target
		do
			manager.open_target.system.remove_target (tester_target_name)
			manager.open_target.system.store
		ensure
			removed: not has_tester_target
		end

feature {NONE} -- Testing status settings

	was_testing_enabled: BOOLEAN
			-- Was testing enabled before last refresh?

	refresh is
			-- Add agents for test suite changes if testing was not enabled.
		do
			if manager.is_testing_enabled and not was_testing_enabled then
				manager.test_suite.add_test_case_actions.extend (agent add_test_case)
				manager.test_suite.remove_test_case_actions.extend (agent remove_test_case)
				was_testing_enabled := True
			elseif not manager.is_testing_enabled then
				was_testing_enabled := False
			end
		end

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Update root class according to test cases in suite.
		do
			create_root_class
			if is_running then
				stop
			end
			start
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Update root class according to test cases in suite.
		do
			create_root_class
			if is_running then
				stop
			end
			start
		end

feature {NONE} -- Idle action

	idle_action_agent: PROCEDURE [ANY, TUPLE]
			-- Agent for 'idle_action'

	add_idle_action is
			-- Add `idle_action_agent' to EV_APPLICATION idle actions.
		require
			not_added_yet: not ev_application.idle_actions.has (idle_action_agent)
		do
			if idle_action_agent = Void then
				idle_action_agent := agent idle_action
			end
			ev_application.add_idle_action (idle_action_agent)
		ensure
			added: ev_application.idle_actions.has (idle_action_agent)
		end

	remove_idle_action is
			-- Remove `idle_action_agent' from EV_APPLICATION idle actions.
		require
			idle_action_agent_not_void: idle_action_agent /= Void
			added: ev_application.idle_actions.has (idle_action_agent)
		do
			ev_application.remove_idle_action (idle_action_agent)
		ensure
			not_added_yet: not ev_application.idle_actions.has (idle_action_agent)
		end

	idle_action is
			-- Check status of the process and its output.
		require
			running: is_running
		local
			l_output: STRING
			l_pos: INTEGER
		do
			if output.has_new_block then
				l_output := output.all_blocks (True).string_representation
				if is_executing then
					testing_output_buffer.append (l_output)
					l_pos := testing_output_buffer.last_index_of ('%N', testing_output_buffer.count)
					if l_pos > 0 then
						testing_output_buffer := testing_output_buffer.substring (l_pos + 1, testing_output_buffer.count)
					end
				end
				manager.log_actions.call ([l_output])
			end
			if is_compiling then
				if not compiler.is_running then
					if compiler.was_successful then
						start_test_case_execution (test_case)
					else
						compiler := Void
						manager.update_state_actions.call (["Compilation failed"])
						remove_idle_action
					end
				end
			end
			if is_executing then
				if test_suite_process.has_exited then
					retrieve_test_case_status
					if cursor.is_last then
						stop
					else
						cursor.forth
						start_test_case_execution (test_case)
					end
				end
			end
		end

	retrieve_test_case_status is
			-- Parse testing results for `current_test_case' from `testing_output_buffer'.
		require
			testing: is_executing
			process_exited: test_suite_process.has_exited
		local
			l_list: LIST [STRING]
			l_status: INTEGER
			l_class, l_feature: STRING
			l_exception: STRING
		do
			l_status := {CDD_TEST_CASE}.fail_code
			if test_suite_process.exit_code /= 0 then
				l_list := testing_output_buffer.split ('.')
				if l_list.count > 2 then
					l_class := l_list.i_th (1)
					l_feature := l_list.i_th (2)
					l_exception := l_list.i_th (3)
				end
			end
			if test_suite_process.exit_code = 0 then
				l_status := {CDD_TEST_CASE}.pass_code
			elseif test_suite_process.exit_code = 30 then
				l_status := {CDD_TEST_CASE}.invalid_code
			else
				if l_exception /= Void then
					if test_suite_process.exit_code = {EXCEP_CONST}.precondition then
						if l_class.is_equal (test_case.class_under_test.name) and
							l_feature.is_equal (test_case.feature_under_test.name) then
							l_status := {CDD_TEST_CASE}.invalid_code
						end
					end
				end
			end
			test_case.set_status (l_status, l_class, l_feature, l_exception)
		end

feature {NONE} -- Implementation

	test_suite_exe_filename: FILE_NAME is
			-- Filename of compiled test suite
		local
			exe_postfix: STRING
		do
			create Result.make_from_string (test_suite_dirname)
			if operating_system.is_windows then
				exe_postfix := ".exe"
			else
				exe_postfix := ""
			end
			Result.extend (manager.open_project.system.name + exe_postfix)
		ensure
			filename_not_void: Result /= Void
		end

	test_suite_dirname: FILE_NAME is
			-- Directory name of test suite executable
		do
			create Result.make_from_string (test_suite.tests_cluster.target.system.directory)
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
			arguments: ARRAYED_LIST [STRING]
			env_vars: HASH_TABLE [STRING, STRING_8]
		do
			compiler := Void
			if operating_system.is_windows then
				create arguments.make (1)
				arguments.force (a_test_case.tester_class.name)
				test_suite_process := process_launcher (test_suite_exe_filename, arguments, test_suite_dirname)
			else
				create arguments.make (2)
				arguments.extend ("-c")
				arguments.extend ("%'%'"+test_suite_exe_filename+" "+a_test_case.tester_class.name+"%'%'")
				test_suite_process := process_launcher ("/bin/sh", arguments, test_suite_dirname)
			end
			create testing_output_buffer.make_empty
			manager.update_state_actions.call (["Testing " + test_case.tester_class.name])
			test_suite_process.redirect_output_to_agent (agent output_handler)
			test_suite_process.redirect_error_to_same_as_output
			test_suite_process.set_buffer_size (512)
			test_suite_process.enable_launch_in_new_process_group

			create env_vars.make (1)
			env_vars.put (test_suite_dirname, "MELT_PATH")
			test_suite_process.set_environment_variable_table (env_vars)
			test_suite_process.set_hidden (True)
			test_suite_process.launch
		ensure
			testing: is_executing
		end

	create_root_class is
			-- Write root class for interpreter to disc.
			-- When `with_argument' is True, the compiled executable will expect an argument.
		local
			l_file: KL_OUTPUT_FILE
		do
			l_file := root_class_file
			l_file.open_write
			if l_file.is_open_write then
				printer.print_root_class (test_suite.test_cases, l_file)
				l_file.close
			end
		end

	output_handler (an_output: STRING) is
			-- Append 'an_output' to output.
		require
			an_output_not_void: an_output /= Void
		local
			l_storage: EB_PROCESS_IO_STRING_BLOCK
		do
			create l_storage.make (an_output, False, False)
			output.extend_block (l_storage)
		end

feature {NONE} -- Implementation

	root_class_file_name: STRING is
			-- File name for interpreter root class
		do
			Result := test_suite.tests_cluster.location.build_path ("", executor_root_class_name.as_lower + ".e")
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	root_class_file: KL_OUTPUT_FILE is
			-- File where root class is written to
		do
			create {KL_TEXT_OUTPUT_FILE} Result.make (root_class_file_name)
		ensure
			not_void: Result /= Void
			valid: Result.name.is_equal (root_class_file_name)
		end

	compiler: AUT_ISE_EIFFEL_COMPILER
			-- Process for compiling the interpreter

	test_suite_process: PROCESS
			-- Currently executed process

	output: EB_PROCESS_IO_STORAGE
			-- Stored output from the process

	testing_output_buffer: STRING
			-- Output from testing process

	cursor: DS_LIST_CURSOR [CDD_TEST_CASE]
			-- Cursor pointing to current test case

	printer: CDD_EXECUTOR_ROOT_PRINTER is
			-- Root test class printer
		once
			create Result
		ensure
			printer_not_void: Result /= Void
		end

invariant

	not_compiling_and_running: not (is_compiling and is_executing)
	is_testing_implies_correct_cursor: is_executing implies (cursor /= Void and then not cursor.off)
	output_not_void: output /= Void

end
