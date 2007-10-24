indexing
	description: "Objects that execute test cases in the debugger"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_DEBUGGER

inherit

	CDD_ABSTRACT_TESTER

	EB_SHARED_GRAPHICAL_COMMANDS
		export
			{NONE} all
		end

create
	make_with_manager

feature -- Access

	is_running: BOOLEAN
			-- Is `Current' preparing or debugging a test case?

	test_case: CDD_TEST_CASE
			-- Test case beeing debugged

	can_start_debugged_testing: BOOLEAN is
			-- Can testing be launched in the debugger?
		do
			Result := not is_running and
				not manager.open_project.is_read_only and
				not manager.open_project.is_compiling and
				not run_project_cmd.debugger_manager.application.is_running
		end

feature -- Basic operations

	start_debugged_testing (a_tc: CDD_TEST_CASE)
			-- Run `a_tc' in the debugger.
		require
			a_tc_valid: a_tc /= Void
			can_start_debugged_testing: can_start_debugged_testing
		local
			l_new_root: CONF_ROOT
		do
			is_running := True
			test_case := a_tc
			create_root_class
			old_root := manager.open_target.root
			l_new_root := conf_factory.new_root (test_suite.tests_cluster.cluster_name, debugger_root_class_name, root_class_feature_name, False)
			manager.open_target.set_root (l_new_root)
			manager.open_target.system.store
			manager.update_testing_status ("Preparing")
			melt_project_cmd.execute_and_wait
			if manager.open_project.successful then
				is_running := True
				manager.update_testing_status ("Running " + test_case.tester_class.name + " in debugger")
				run_project_cmd.execute
			else
				manager.update_testing_status ("An error ocurred compiling the project")
				reset_root_class_and_recompile
			end
		end

feature {CDD_MANAGER} -- Status setting

	stop is
			-- Reset old root class and recompile project.
		do
			if application.is_running then
				application.kill
			end
			manager.update_testing_status ("")
			reset_root_class_and_recompile
			is_running := False
		end

feature {NONE} -- Implementation

	application: APPLICATION_EXECUTION is
			-- The debugged application
		require
			running: is_running
		do
			Result := run_project_cmd.debugger_manager.application
		end

	old_root: CONF_ROOT
			-- Old root configuration before `Current' started test run in debugger

	create_root_class is
			-- Write root class for interpreter to disc.
			-- When `with_argument' is True, the compiled executable will expect an argument.
		require
			can_start_background_testing: True
		local
			l_file: KL_OUTPUT_FILE
		do
			l_file := root_class_file
			l_file.open_write
			if l_file.is_open_write then
				printer.print_root_class (test_case, manager.open_target.root.class_name, l_file)
				l_file.close
			end
		end

	root_class_file_name: STRING is
			-- File name for interpreter root class
		do
			Result := test_suite.tests_cluster.location.build_path ("", debugger_root_class_name.as_lower + ".e")
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

	reset_root_class_and_recompile is
			-- Set current root to `old_root', store configuration and recompile project
		do
			manager.open_target.set_root (old_root)
			manager.open_target.system.store
			melt_project_cmd.execute_and_wait
		end


	printer: CDD_DEBUGGER_ROOT_PRINTER is
			-- Printer for creating root class
		once
			create Result
		end

end
