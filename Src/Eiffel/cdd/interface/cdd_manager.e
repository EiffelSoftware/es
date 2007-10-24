indexing
	description: "Objects that handle operations on a test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_MANAGER

inherit

	EB_CLUSTER_MANAGER_OBSERVER
		rename
			manager as eb_cluster_manager
		export
			{NONE} all
		redefine
			on_class_removed
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	EB_SHARED_WINDOW_MANAGER
		export
			{NONE} all
		end

	CDD_SHARED_FACTORY
		export
			{NONE} all
		end

	CDD_CONSTANTS
		export
			{NONE} all
		end

	EB_CONSTANTS
		export
			{NONE} all
		end

	CONF_ACCESS
		export
			{NONE} all
		end

	EB_SHARED_GRAPHICAL_COMMANDS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Add `Current' to cluster observer list.
		local
			l_prj_manager: EB_PROJECT_MANAGER
		do
			create refresh_actions
			create update_state_actions
			create log_actions
			l_prj_manager := eiffel_project.manager
			l_prj_manager.load_agents.extend (agent on_project_load)
			l_prj_manager.compile_start_agents.extend (agent on_compile_start)
			l_prj_manager.compile_stop_agents.extend (agent on_compile_stop)
			eb_cluster_manager.add_observer (Current)
			create test_debugger.make_with_manager (Current)
			create test_executor.make_with_manager (Current)
			create test_examinator.make (Current, eb_debugger_manager)
			create log_printer.make_with_manager (Current)
		end

feature -- Access

	is_testing_enabled: BOOLEAN is
			-- Is testing currently enabled?
		do
			Result := (test_suite /= Void)
		end

	test_suite: CDD_TEST_SUITE
			-- Test suite which is managed by `Current'

	is_running: BOOLEAN is
			-- Are we currently running or preparing any test cases?
		do
			Result := is_debugging or is_executing or is_examinating
		end

	is_debugging: BOOLEAN is
			-- Are we running a test case in the debugger?
		do
			Result := test_debugger.is_running
		end

	is_executing: BOOLEAN is
			-- Are we testing any test case externally?
		do
			Result := test_executor.is_running
		end

	is_examinating: BOOLEAN is
			-- Are we examinating some test case?
		do
			Result := test_examinator.is_running
		end

	can_enable_testing: BOOLEAN is
			-- Can testing mode be enabled?
		require
			not_enabled_yet: not is_testing_enabled
		do
			Result := open_project.initialized and
				not open_project.is_read_only and
				not open_target.system.date_has_changed
		end

	can_start_debugging: BOOLEAN is
			-- Can we run a test case in the debugger?
		do
			Result := not is_debugging and test_debugger.can_start_debugged_testing
		end

	can_start_executing: BOOLEAN is
			-- Can we execute all test cases in background?
		do
			Result := not is_executing and test_executor.can_start
		end

	can_start_examinating: BOOLEAN is
			--
		do
			Result := not is_examinating
		end

	valid_status (an_app_status: APPLICATION_STATUS): BOOLEAN is
			-- Is 'an_app_status' valid for creating a ccd test case?
		require
			an_app_status /= Void
		do
			Result := an_app_status.is_stopped and
				an_app_status.exception_occurred and
				(an_app_status.exception_code = {EXCEP_CONST}.void_call_target or
				an_app_status.exception_code = {EXCEP_CONST}.postcondition or
				an_app_status.exception_code = {EXCEP_CONST}.class_invariant or
				an_app_status.exception_code = {EXCEP_CONST}.precondition or
				an_app_status.exception_code = {EXCEP_CONST}.check_instruction)
		end

	open_project: E_PROJECT is
			-- Currently opened project
		do
			Result := eiffel_project
		ensure
			open_project_not_void: Result /= Void
		end

	open_target: CONF_TARGET is
			-- Currently opened target
		require
			project_initialized: open_project.initialized
		do
			Result := eiffel_universe.target
		ensure
			open_target_not_void: Result /= Void
		end

	root_cluster: CONF_CLUSTER is
			-- 	Cluster of root class of `open_target' if any (root class can also be in a library or similar, in which case this is `Void')
		require
			project_initialized: open_project.initialized
		local
			table: HASH_TABLE [CONF_GROUP, STRING]
			group: CONF_GROUP
			classes: LINKED_SET [CONF_CLASS]
			found: BOOLEAN
		do
			Result ?= eiffel_system.root_cluster
			-- NOTE: commented because class_by_name threw segmentation fault in some cases
--			from
--				table := open_target.groups
--				table.start
--			until
--				table.off or found
--			loop
--				group := table.item_for_iteration
--				classes := group.class_by_name (open_target.root.class_name, False)
--				if classes.count > 0 then
--						-- TODO: what happens if there are several classes?
--					Result ?= classes.first.group
--					found := True
--				else
--					table.forth
--				end
--			end
		end

feature -- Status setting

	on_application_stopped (an_app_status: APPLICATION_STATUS; a_window: EB_DEVELOPMENT_WINDOW) is
			-- Try to create a new test case from `an_app_status' and add it to `test_suite'.
			-- `a_window' is the window in which the application was launched.
		require
			app_status_not_void: an_app_status /= Void
			app_status_valid: an_app_status.is_stopped
			a_window_not_void: a_window /= Void
		local
			l_reflection: CDD_REFLECTION
			l_tc: CDD_TEST_CASE
			l_create: BOOLEAN
			l_name, l_dname: STRING
		do
			if is_testing_enabled and valid_status (an_app_status) then
				if is_debugging then
					l_name := test_debugger.test_case.tester_class.name
					l_dname := an_app_status.dynamic_class.name
					if not l_name.is_equal (l_dname) then
						-- The failing class is not the test class
						l_name := test_debugger.test_case.class_under_test.name
						if not l_name.is_equal (l_dname) then
							-- The failing class is not the class under test -> create a new test case
							l_create := True
						else
							l_name := test_debugger.test_case.feature_under_test.name
							l_dname := an_app_status.current_call_stack_element.routine_name
							if not l_name.is_equal (l_dname) and not l_dname.is_equal ("do_nothing") then
								-- The failing feature is not the feature under test -> create a new test case
								l_create := True
							end
						end
					end
				else
					l_create := True
				end
				if l_create then
					if is_examinating and then test_examinator.has_reflection (an_app_status.e_feature) then
						l_reflection := test_examinator.current_reflection
						l_tc := test_examinator.test_case
						test_case_factory.write_reflection_to_file (l_reflection, l_tc.tester_class.name, test_suite.tests_cluster)
						log_printer.note_examintaing_success (l_tc)
					else
						l_reflection := make_reflection (an_app_status)
						if l_reflection /= Void and then l_reflection.reflection_succeded then
							test_case_factory.create_with_reflection (l_reflection, test_suite.tests_cluster)
							if test_case_factory.last_created_test_case /= Void then
								l_tc := test_case_factory.last_created_test_case
								test_suite.add_test_case (l_tc)
							end
						end
					end
					if can_start_executing then
						start_executing
					end
				end
			elseif is_examinating and then test_examinator.valid_application_status then
				test_examinator.on_application_stop
			end
		end

	on_application_quit is
			-- If `is_debugging' is true, notify test debugger that application is quit.
		do
			if is_debugging then
				test_debugger.stop
			elseif is_examinating then
				test_examinator.stop
			end
		end

	enable_testing is
			-- Create test suite and notify tools.
		require
			not_enabled_yet: not is_testing_enabled
			can_enable: can_enable_testing
		local
			l_dirname: DIRECTORY_NAME
			l_dir: KL_DIRECTORY
			l_loc: CONF_FILE_LOCATION
			l_lib: CONF_LIBRARY
			ed: EV_ERROR_DIALOG
			rc: CONF_CLUSTER
			rule: CONF_FILE_RULE
		do
			rc := root_cluster
				-- TODO: Present dialog to user and allow to change location or test suite cluster
			if rc = Void then
				create ed.make_with_text ("Unable to enable cdd-testing, because root class is not in a cluster (but library or similar).")
				ed.show_modal_to_window (Window_manager.last_focused_development_window.window)
			else
				create l_dirname.make_from_string (rc.location.evaluated_directory)
				l_dirname.extend (tests_cluster_name)
				create l_dir.make (l_dirname)
				l_dir.create_directory
				if l_dir.exists then
					eb_cluster_manager.remove_observer (Current)
					l_loc := conf_factory.new_location_from_full_path ("$ISE_LIBRARY\library\cdd\cdd.ecf", open_target)
					l_lib := conf_factory.new_library ("cdd", l_loc, open_target)
					open_target.add_library (l_lib)
					if rc.is_recursive then
						create rule.make
						rule.add_exclude (tests_cluster_name)
						rc.add_file_rule (rule)
					end
					create l_dirname.make_from_string (rc.location.original_directory)
					l_dirname.extend (tests_cluster_name)
					eb_cluster_manager.add_cluster (tests_cluster_name, rc, l_dirname)
					create test_suite.make_with_cluster (eb_cluster_manager.last_added_cluster)
					if not test_executor.has_tester_target then
						test_executor.add_tester_target
					end
					eb_cluster_manager.add_observer (Current)
					melt_project_cmd.execute
				else
					create ed.make_with_text ("Unable to enable cdd-testing, because the test case directory '" + l_dirname +"' could not be created.")
					ed.show_modal_to_window (Window_manager.last_focused_development_window.window)
				end
			end
		end

	disable_testing is
			-- Disable testing
		require
			testing_enabled: is_testing_enabled
			not_running: not is_running
		local
			wd: EV_WARNING_DIALOG
		do
			if test_suite.tests_cluster.target.system.date_has_changed then
				create wd.make_with_text (Warning_messages.w_cannot_delete_need_recompile)
				wd.show_modal_to_window (Window_manager.last_focused_development_window.window)
			else
				if test_executor.has_tester_target then
					test_executor.remove_tester_target
				end
				test_suite.target_under_test.remove_cluster (tests_cluster_name)
				open_target.system.store
				Discover_melt_cmd.execute
				test_suite := Void
			end
		end

	start_debugging (a_tc: CDD_TEST_CASE) is
			-- Run `a_tc' in debugger.
		require
			a_tc_valid: a_tc /= Void
			can_start_debugging: can_start_debugging
		do
			test_debugger.start_debugged_testing (a_tc)
		end

	examinate_test_case (a_tc: CDD_TEST_CASE) is
			-- Try to capture a better pre state for `a_tc' by running the application
			-- and reflect every pre state of the feature under test.
		require
			a_tc_not_void: a_tc /= Void
			can_examinate_test_case: can_start_examinating
		do
			log_printer.note_start_examinating (a_tc)
			test_examinator.examinate (a_tc)
		end

	start_executing is
			-- Test all test cases in background.
		require
			can_start_executing: can_start_executing
		do
			test_executor.start
		end

feature {CDD_ABSTRACT_TESTER} -- Testing status setting

	update_testing_status (a_message: STRING) is
			-- Call update status actions.
		do
			update_state_actions.call ([a_message])
		end

feature -- Test suite manipulation

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove 'a_tc' from 'test_suite' and delete test class from disc.
		require
			a_tc_not_void: a_tc /= Void
			testing_enabled: is_testing_enabled
			a_tc_valid: test_suite.test_cases.has (a_tc)
		do
			-- Remove 'Current' from cluster manager so we do not get notified of the removed class
			eb_cluster_manager.remove_observer (Current)

			test_suite.remove_test_case (a_tc)
			test_case_factory.remove (a_tc)
			eb_cluster_manager.remove_class (a_tc.tester_class)

			window_manager.synchronize_all
			eb_cluster_manager.add_observer (Current)
		ensure
			removed: not test_suite.test_cases.has (a_tc)
		end

feature {EB_CLUSTERS} -- Project Events

	on_project_load is
			--Check if testing was enabled for this project before.
		do
			eiffel_system.system.force_rebuild
			on_compile_stop
		end

	on_compile_start is
			-- Quit test execution if `test_executor' is still running background tests.
		local
			l_classes: HASH_TABLE [EIFFEL_CLASS_I, STRING]
		do
			if is_executing then
				-- TODO: make test executor stop testing
			end
--			if is_testing_enabled then
--				l_classes := test_suite.tests_cluster.classes
--				from
--					l_classes.start
--				until
--					l_classes.off
--				loop
--					if not l_classes.item_for_iteration.is_compiled then
--						eiffel_system.system.add_unref_class (l_classes.item_for_iteration)
--						-- eiffel_system.workbench.add_class_to_recompile (l_classes.item_for_iteration)
--						eiffel_system.system.force_rebuild
--					end
--					l_classes.forth
--				end
--			end
		end

	on_compile_stop is
			-- Refresh test suite.
		local
			l_tests_cluster: CLUSTER_I
			l_classes: HASH_TABLE [EIFFEL_CLASS_I, STRING]
			l_tester_class: EIFFEL_CLASS_I
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
			l_feature: E_FEATURE
			l_tc: CDD_TEST_CASE
			l_was_enabled: BOOLEAN
		do
			if not is_debugging then
				l_tests_cluster := eiffel_universe.cluster_of_name (tests_cluster_name)
				if l_tests_cluster /= Void then
						-- Update test suite, create if necessary
					if is_testing_enabled then
							-- Note the testing was enabled before compilation
						l_was_enabled := True
						test_suite.set_tests_cluster (l_tests_cluster)
					else
						create test_suite.make_with_cluster (l_tests_cluster)
					end
						-- Parse classes in tests cluster
					l_classes := test_suite.tests_cluster.classes
					from
						l_classes.start
					until
						l_classes.after
					loop
						l_tester_class := l_classes.item_for_iteration
						test_case_factory.parse_class (l_tester_class)
						if test_case_factory.last_parsed_feature /= Void then
							l_tc := test_suite.test_case_for_class_name (l_tester_class.name)
							if l_tc /= Void then
								l_tc.set_class_and_feature (l_tester_class, test_case_factory.last_parsed_feature)
							else
								create l_tc.make (l_tester_class, test_case_factory.last_parsed_feature)
								test_suite.add_test_case (l_tc)
							end
						end
						l_classes.forth
					end
						-- Remove test cases from test suite for which there is no class in tests cluster
					if l_was_enabled then
						from
							l_cursor := test_suite.test_cases.new_cursor
							l_cursor.start
						until
							l_cursor.off
						loop
							if not l_classes.has_item (l_cursor.item.tester_class) then
								test_suite.remove_test_case (l_cursor.item)
							else
								l_cursor.forth
							end
						end
					end
				else
					test_suite := Void
				end
			end
			refresh_actions.call ([])
			if is_testing_enabled and then test_suite.test_cases.count > 0 then
				if open_project.successful and can_start_executing then
					start_executing
				end
			end
		end

	on_class_removed (a_class: CLASS_I) is
			-- If class was test class, remove corresponding test case.
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
			l_item: CDD_TEST_CASE
		do
			if test_suite.has_test_case_for_class (a_class) then
				from
					l_cursor := test_suite.test_cases.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					if l_cursor.item.tester_class = a_class then
						l_item := l_cursor.item
						test_suite.remove_test_case (l_cursor.item)
						l_cursor.go_after
					else
						l_cursor.forth
					end
				end
			end
		end

feature -- Actions

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions performed after `Current' has refreshed the test suite

	update_state_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Actions performed when testing status changes

	log_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Agents for redirecting all output from external processes

feature {NONE} -- Implementation

	make_reflection (an_app_status: APPLICATION_STATUS): CDD_REFLECTION is
			-- Try to reflect current object in call stack.
			-- NOTE: Can be void if call stack contains external calls.
		require
			an_app_status_valid: an_app_status /= Void and then an_app_status /= Void
			exception_occured: an_app_status.exception_occurred
		local
			l_cse: EIFFEL_CALL_STACK_ELEMENT
			l_tag: STRING
			l_feature: E_FEATURE
			l_class: EIFFEL_CLASS_C
			l_abort, l_is_creation_call: BOOLEAN
		do
			l_cse ?= an_app_status.current_call_stack_element
			if l_cse /= Void then
				if an_app_status.exception_code = {EXCEP_CONST}.precondition and l_cse.level_in_stack < an_app_status.current_call_stack.count then
					l_cse := caller (l_cse, an_app_status.current_call_stack)
				end
			end
			if l_cse /= Void and then l_cse.dynamic_class /= Void and then l_cse.dynamic_class.is_eiffel_class_c then
				from
					l_feature := l_cse.routine
				until
					l_abort or else (l_feature.export_status.is_all or l_is_creation_call)
				loop
					l_class := l_cse.dynamic_class.eiffel_class_c
					l_is_creation_call := is_creation_procedure (l_class, l_feature)
					if not l_is_creation_call then
						l_cse := caller (l_cse, an_app_status.current_call_stack)
						if l_cse = Void or else l_cse.dynamic_class = Void or else not l_cse.dynamic_class.is_eiffel_class_c then
							l_abort := True
						else
							l_feature := l_cse.routine
						end
					end
				end
				if not l_abort then
					create Result.make (an_app_status, l_cse, l_is_creation_call)
				end
			end
		end

	is_creation_procedure (a_class: EIFFEL_CLASS_C; a_feature: E_FEATURE): BOOLEAN is
			-- Is `l_feature' a creation procedure of `a_class'?
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			Result := a_class.creation_feature = a_feature.associated_feature_i
			if not Result then
				Result := a_class.creators /= Void and then a_class.creators.has (a_feature.name)
			end
		end

	caller (a_element: EIFFEL_CALL_STACK_ELEMENT; a_call_stack: EIFFEL_CALL_STACK): EIFFEL_CALL_STACK_ELEMENT is
			-- Call stack element which called the routine in `a_element' in `a_call_stack'.
			-- NOTE: Void if `a_element' is first element in `a_call_stack' or caller is not a eiffel call stack element.
		require
			a_element_not_void: a_element /= Void
			a_call_stack_not_void: a_call_stack /= Void
			a_element_valid: a_call_stack.i_th (a_element.level_in_stack) = a_element
		do
			if a_element.level_in_stack < a_call_stack.count then
				Result ?= a_call_stack.i_th (a_element.level_in_stack + 1)
			end
		end

	conf_factory: CONF_FACTORY is
			-- Factory for creating cdd library
		once
			create Result
		end

feature {NONE} -- Implementation

	test_debugger: CDD_TEST_DEBUGGER
			-- Tester debugging test case in EiffelStudio

	test_executor: CDD_TEST_EXECUTOR
			-- Tester for executing test cases external

	test_examinator: CDD_TEST_EXAMINATOR
			-- Executes the application and captures the correct pre-states

	log_printer: CDD_LOG_PRINTER
			-- Prints log messages

invariant
	correct_testing_status: is_testing_enabled = (test_suite /= Void)
	refresh_actions_not_void: refresh_actions /= Void
	update_state_actions_not_void: update_state_actions /= Void
	log_actions_not_void: log_actions /= Void
	test_debugger_not_void: test_debugger /= Void
	test_executor_not_void: test_executor /= Void
	test_examinator_not_void: test_examinator /= Void
	not_debugging_and_examinating: not (is_examinating and is_debugging)
	log_printer_not_void: log_printer /= Void

end
