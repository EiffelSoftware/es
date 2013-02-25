note
	description: "Summary description for {AFX_INTRA_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_TRACE_COLLECTOR

inherit

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_SHARED_SESSION

	AFX_UTILITY

	AFX_SHARED_PROJECT_ROOT_INFO

	AFX_SHARED_STATE_SERVER

	EQA_TEST_EXECUTION_MODE

	EPA_DEBUGGER_UTILITY
		rename
			start_debugger as start_debugger_general
		end

	REFACTORING_HELPER

feature{AFX_TRACE_COLLECTOR} -- Initialization

	make_general
			-- Initialization.
		do
			create test_case_execution_event_listeners.make
			create monitored_breakpoint_managers.make
			init_test_case_info_skeleton
		end

feature	-- Basic operation

	collect
			-- Run current project to collect execution traces into `trace_repository'.
		local
			l_time_left: INTEGER
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_time_left := session.time_left
				if l_time_left >= 0 then
					set_up

					update_timer (l_time_left)
					start_debugger

					wrap_up
				end
			end
		rescue
			l_retried := True
			session.cancel
			retry
		end

	set_up
			-- Set up the collector.
		do
			test_case_execution_event_listeners.wipe_out
			test_case_execution_event_listeners.force_last (trace_repository)

				-- Remove/set breakpoints.
			remove_breakpoint (debugger_manager, Test_case_super_class)
			init_test_case_boundary_breakpoint_managers

				-- Register debugger event listener.
			app_stop_agent := agent on_application_stopped
			app_exit_agent := agent on_application_exit
			debugger_manager.observer_provider.application_stopped_actions.extend (app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.extend (app_exit_agent)
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)

			dbg_timer := debugger_manager.new_timer
			dbg_timer.actions.extend (agent quit)

			test_case_info := Void
			current_test_case_info := Void
			current_test_case_execution_mode := Mode_default
		end

	wrap_up
			-- Wrap up the collection process.
		do
			debugger_manager.observer_provider.application_stopped_actions.prune_all (app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.prune_all (app_exit_agent)

				-- Disable/Remove breakpoints
			entry_breakpoint_manager.toggle_breakpoints (False)
			enable_state_monitoring (False)
			remove_breakpoint (debugger_manager, Test_case_super_class)

			remove_debugger_session
		end

	quit
			-- Quit collecting.
		do
			kill_debuggee (debugger_manager)
			session.cancel

			wrap_up
		end

feature -- Customize

	register_program_state_monitoring
			-- Register program state monitors.
		deferred
		end

feature -- Debugger action

	start_debugger
			-- Start debugging with proper arguments.
		do
			start_debugger_general (debugger_manager, " --analyze-tc " + config.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, config.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- Action on application exception.
		do
			if not is_in_mode_monitor then
					-- Corresponds to the execution of the first test case, which is used to reproduce the fault.
				analyze_exception (a_dm)
				register_program_state_monitoring

				entry_breakpoint_manager.toggle_breakpoints (True)
			else
					-- During monitoring, mark the trace as from a FAILED execution.
				trace_repository.current_trace.set_status_as_failing
			end
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action on application stopped.
		do
			if a_dm.application_is_executing and then a_dm.application_is_stopped then
				if a_dm.application_status.reason_is_catcall then
					a_dm.controller.resume_workbench_application
				elseif a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					if a_dm.application_status.exception_occurred then
						on_application_exception (a_dm)
					end

						-- Resume anyway.
					a_dm.controller.resume_workbench_application
				end
			end
		end

	on_application_exit (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_application_exit)

			entry_breakpoint_manager.toggle_breakpoints (False)
			enable_state_monitoring (False)
			remove_breakpoint (a_dm, Test_case_super_class)
		end

feature -- Test-case-related action

	init_test_case_boundary_breakpoint_managers
			-- Init breakpoint managers to handle test case entries and exits.
			-- Use `entry_breakpoint_manager' to enable/disable breakpoints at entries;
			-- Breakpoint at the exit is always enabled.
		local
			l_bp_manager: BREAKPOINTS_MANAGER
			l_bp_location: BREAKPOINT_LOCATION
			l_breakpoint: BREAKPOINT
		do
			create entry_breakpoint_manager.make (Test_case_super_class, Test_case_setup_feature)
			entry_breakpoint_manager.set_breakpoint_with_expression_and_action (1, test_case_info_skeleton, agent on_test_case_entry)

				-- Disable state monitoring on test case exit.
			l_bp_manager := debugger_manager.breakpoints_manager
			l_bp_location := l_bp_manager.breakpoint_location (Test_case_exit_feature.e_feature, 1, False)
			l_breakpoint := l_bp_manager.new_user_breakpoint (l_bp_location)
			l_breakpoint.add_when_hits_action (create {BREAKPOINT_WHEN_HITS_ACTION_EXECUTE}.make (agent on_test_case_exit))
			l_breakpoint.set_continue_execution (True)
			l_bp_manager.add_breakpoint (l_breakpoint)
			l_bp_manager.notify_breakpoints_changes
		end

	on_test_case_entry (a_breakpoint: BREAKPOINT; a_test_case_info: EPA_STATE)
			-- Action to be performed when entering a new test case.
		local
			l_class_under_test: CLASS_C
			l_execution_mode: INTEGER
			l_feature_under_test: FEATURE_I
			l_recipient_class_name, l_recipient_feature_name: STRING
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_exception_code: INTEGER
			l_bpslot: INTEGER
			l_tag: STRING
			l_passing: BOOLEAN
			l_table: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_spot: AFX_EXCEPTION_SPOT
			l_uuid: STRING
			l_trace: STRING
			l_start_index, l_end_index: INTEGER
			l_expression_set: DS_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_repository: like trace_repository
		do
			l_table := a_test_case_info.to_hash_table

			l_class_under_test := first_class_starts_with_name (l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_class_under_test).out)
			l_execution_mode := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_execution_mode).out.to_integer
			l_feature_under_test := l_class_under_test.feature_named (l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_feature_under_test).out)
			l_recipient_class_name := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient_class).out
			l_recipient_feature_name := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient).out
			l_recipient_class := first_class_starts_with_name (l_recipient_class_name)
			l_recipient := l_recipient_class.feature_named (l_recipient_feature_name)
			l_exception_code := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_code).out.to_integer
			l_bpslot := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_breakpoint_index).out.to_integer
			l_tag := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_assertion_tag).out
			l_passing := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_is_passing).out.to_boolean
			l_uuid := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_class_uuid).out
			l_trace := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_trace).out

			create test_case_info.make (l_uuid, l_uuid)
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_new_test_case(test_case_info))
			event_actions.notify_on_new_test_case_found (test_case_info)

			enable_state_monitoring (True)

			current_test_case_execution_mode := l_execution_mode
			class_under_test := l_class_under_test
			feature_under_test := l_feature_under_test

			test_case_starting_time := session.time_now
			update_timer (time_left_for_test_case)
		end

	on_test_case_exit (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
			-- Action on exiting test case.
		do
			enable_state_monitoring (False)
			update_timer (session.time_left)
		end

	current_program_location_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Context for the monitored locations in this test case.
		do
			create Result.make (debugger_manager.application_status.e_feature.associated_feature_i,
								debugger_manager.application_status.dynamic_class)
		end

	on_breakpoint_hit_in_test_case (a_class: CLASS_C; a_feature: FEATURE_I; a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when `a_breakpoint' is hit.
			-- `a_breakpoint' is a break point in a test case.
			-- `a_state' stores the values of all evaluated expressions'.
		local
			l_current_program_location_context: EPA_FEATURE_WITH_CONTEXT_CLASS
		do
			a_state.keep_if (
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result := a_equation.value.is_boolean or else a_equation.value.is_integer
					end)

			l_current_program_location_context := current_program_location_context
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_breakpoint_hit (test_case_info, a_state,
					create {AFX_PROGRAM_LOCATION}.make (l_current_program_location_context, a_breakpoint.breakable_line_number)))
			event_actions.notify_on_break_point_hit (test_case_info, a_breakpoint.breakable_line_number)
		end

feature -- Status monitoring

	enable_state_monitoring (a_flag: BOOLEAN)
			-- Enable breakpoints for state monitoring, if `a_flag'.
			-- Diable otherwise.
		do
			monitored_breakpoint_managers.do_all (agent {EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER}.toggle_breakpoints (a_flag))
		end

feature -- Exception analysis

	analyze_exception (a_dm: DEBUGGER_MANAGER)
			-- Analyze exception statically.
		require
			exception_raised: a_dm /= Void and then a_dm.application_status.exception_occurred
			exception_info_not_set: exception_signature = Void
		local
			l_exception_code: INTEGER
			l_exception_tag: STRING

			l_call_stack: EIFFEL_CALL_STACK
			l_current_stack_element, l_previous_stack_element: CALL_STACK_ELEMENT
			l_current_class, l_previous_class: CLASS_C
			l_current_feature, l_previous_feature: FEATURE_I
			l_current_breakpoint, l_previous_breakpoint: INTEGER
			l_current_breakpoint_nested, l_previous_breakpoint_nested: INTEGER
			l_exception_signature: AFX_EXCEPTION_SIGNATURE
		do
			l_exception_code := a_dm.application_status.exception.code
			l_exception_tag := a_dm.application_status.exception.message.twin

			l_call_stack := a_dm.application_status.current_call_stack
			l_current_stack_element := l_call_stack.i_th (1)
			l_current_class := first_class_starts_with_name (l_current_stack_element.class_name)
			l_current_feature := l_current_class.feature_named_32 (l_current_stack_element.routine_name)
			l_current_breakpoint := l_current_stack_element.break_index
			l_current_breakpoint_nested := l_current_stack_element.break_nested_index
			l_previous_stack_element := l_call_stack.i_th (2)
			l_previous_class := first_class_starts_with_name (l_previous_stack_element.class_name)
			l_previous_feature := l_previous_class.feature_named_32 (l_previous_stack_element.routine_name)
			l_previous_breakpoint := l_previous_stack_element.break_index
			l_previous_breakpoint_nested := l_previous_stack_element.break_nested_index

			if l_exception_code = {EXCEP_CONST}.Void_call_target then
				create {AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_exception_tag,
						l_current_class, l_current_feature,
						l_current_breakpoint, l_current_breakpoint_nested)
			elseif l_exception_code = {EXCEP_CONST}.precondition then
				create {AFX_PRECONDITION_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint,
						l_previous_class, l_previous_feature, l_previous_breakpoint, l_previous_breakpoint_nested)
			elseif l_exception_code = {EXCEP_CONST}.postcondition then
				create {AFX_POSTCONDITION_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint)
			elseif l_exception_code = {EXCEP_CONST}.Class_invariant then
				create {AFX_INVARIANT_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_exception_tag, l_previous_class, l_previous_feature)
			elseif l_exception_code = {EXCEP_CONST}.Check_instruction then
				create {AFX_CHECK_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint)
			end
			session.set_exception_signature (l_exception_signature)
		end

feature -- Test case info

	class_under_test: CLASS_C
			-- Class under test.

	feature_under_test: FEATURE_I
			-- Feature under test.

	test_case_info_skeleton: DS_HASH_SET [EPA_EXPRESSION]
			-- State skeleton of test case information.

	init_test_case_info_skeleton
			-- Initialize `test_case_info_skeleton'.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
			l_expr_set: like test_case_info_skeleton
		do
			l_class := test_case_super_class
			l_feature := test_case_setup_feature

			create l_expr_set.make_equal (14)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_name, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_execution_mode, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_uuid, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_under_test, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_feature_under_test, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_breakpoint_index, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_creation, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_query, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_passing, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_code, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_assertion_tag, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient_class, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient, l_class)
			l_expr_set.force_last (l_expr)
			create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_trace, l_class)
			l_expr_set.force_last (l_expr)

			test_case_info_skeleton := l_expr_set
		ensure
			test_case_info_skeleton_initialized: test_case_info_skeleton /= Void and then test_case_info_skeleton.count = 14
		end

feature	-- Access

	test_case_execution_event_listeners: DS_LINKED_LIST[AFX_TEST_CASE_EXECUTION_EVENT_LISTENER]
			-- Subscribed event listeners.

feature -- Helper operation

	time_left_for_test_case: INTEGER
			-- Time left in milliseconds before the test case should be stopped.
			-- Negative value means time is up; 0 means unlimited time; positive value means limited time.
		local
			l_time_left_for_test_case: INTEGER
			l_cutoff_time: INTEGER
			l_past: INTEGER
		do
			l_cutoff_time := session.config.max_test_case_execution_time * 1000
			if l_cutoff_time > 0 then
				check test_case_starting_time /= Void then
					l_past := session.duration_from_time(test_case_starting_time).to_integer
					if l_past >= l_cutoff_time then
						l_time_left_for_test_case := -1
					else
						l_time_left_for_test_case := l_cutoff_time - l_past
					end
				end
			else
				l_time_left_for_test_case := 0
			end

			Result := session.time_left_combined (l_time_left_for_test_case)
		end

	update_timer (a_interval: INTEGER)
			-- Update `dbg_timer' with `a_interval'.
		do
			if a_interval < 0 then
				dbg_timer.set_interval (0)
			elseif a_interval > 0 then
				dbg_timer.set_interval (a_interval)
			elseif a_interval = 0 then
				-- Do nothing in case of unlimited time budget.
			end
		end

	test_case_starting_time: DT_DATE_TIME
			-- Time when the current test case started executing.

feature -- Status report

	is_in_mode_execute: BOOLEAN
			-- Is current test case being executed?
		do
			Result := current_test_case_execution_mode = Mode_execute
		end

	is_in_mode_monitor: BOOLEAN
			-- Is current test case being monitored?
		do
			Result := current_test_case_execution_mode = Mode_monitor
		end

feature -- Helper attribute

	current_test_case_info: detachable EPA_TEST_CASE_SIGNATURE
			-- Information about the test case currently under analysis.

	test_case_info: EPA_TEST_CASE_INFO
			-- Information about the test case currently being executed.

	current_test_case_execution_mode: INTEGER
			-- Execution mode of the current test case.

	monitored_breakpoint_managers: DS_LINKED_LIST [EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER]
			-- Managers for breakpoints where program states need to be monitored.

	entry_breakpoint_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Manager for the breakpoint that marks the entries of test cases.

	dbg_timer: DEBUGGER_TIMER
			-- Debugger timer.

	app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			-- Debugger action when application is stopped.

	app_exit_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			-- Debugger action when application exits.

feature -- Constant

	Test_case_super_class: CLASS_C
			-- Super class of all test case classes.
		once
			Result := first_class_starts_with_name (once "EQA_SERIALIZED_TEST_SET")
		ensure
			result_attached: Result /= Void
		end

	Test_case_setup_feature: FEATURE_I
			-- Feature for setting up the test cases.
		once
			Result := test_case_super_class.feature_named (once "setup_before_test")
		ensure
			result_attached: Result /= Void
		end

	Test_case_exit_feature: FEATURE_I
			-- Feature for exiting the test cases.
		once
			Result := test_case_super_class.feature_named (once "cleanup_after_test")
		end

	Test_case_surrounding_feature_name: STRING
			-- Name of the feature for preparing and executin the test cases.
		once
			Result := "generated_test_1"
		end

invariant

	test_case_execution_event_listeners_attached: test_case_execution_event_listeners /= Void

end
