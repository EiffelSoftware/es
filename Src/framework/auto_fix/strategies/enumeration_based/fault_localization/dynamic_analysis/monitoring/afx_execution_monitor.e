note
	description: "Summary description for {AFX_INTRA_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXECUTION_MONITOR

inherit

	AFX_SHARED_SESSION

	AFX_UTILITY

	AFX_SHARED_PROJECT_ROOT_INFO

	EQA_TEST_EXECUTION_MODE

	EPA_DEBUGGER_UTILITY
		rename
			start_debugger as start_debugger_general
		end

	REFACTORING_HELPER

feature -- Trace for monitoring

	trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY assign set_trace_repository
			-- Traces collected by monitoring program execution.

feature{AFX_EXECUTION_MONITOR} -- Trace for monitoring (set)

	set_trace_repository (a_repository: like trace_repository)
		do
			trace_repository := a_repository
		end

feature -- Scope of monitoring

	features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR] assign set_features_to_monitor
			-- Features to be monitored during execution.
		do
			if features_to_monitor_cache = Void then
				create features_to_monitor_cache.make_equal (1)
			end
			Result := features_to_monitor_cache
		end

	set_features_to_monitor (a_features: like features_to_monitor)
		require
			a_features /= Void
		do
			features_to_monitor_cache := a_features.twin
		end

feature{NONE} -- Scope of monitoring (implementation)

	features_to_monitor_cache: like features_to_monitor
			-- Cache for `features_to_monitor'.

feature	-- Basic operation

	collect (a_should_update_values_of_old_expressions: BOOLEAN)
			-- Run current project to collect execution traces into `trace_repository'.
		local
			l_time_left: INTEGER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create trace_repository.make_default
				if session.should_continue then
					set_up
					start_debugger
					wrap_up (a_should_update_values_of_old_expressions)
				end
			end
		rescue
			l_retried := True
			session.cancel
			retry
		end

feature{NONE} -- Steps

	set_up
			-- Set up the collector.
		do
				-- Reset result.
			create trace_repository.make_default

				-- Monitoring
			remove_breakpoint (debugger_manager, Test_case_super_class)
			create monitored_breakpoint_managers.make
			init_test_case_info_skeleton
			init_test_case_boundary_breakpoint_managers
			create test_case_execution_event_listeners.make
			test_case_execution_event_listeners.force_last (trace_repository)

				-- Register debugger event listener.
			app_stop_agent := agent on_application_stopped
			app_exit_agent := agent on_application_exit
			debugger_manager.observer_provider.application_stopped_actions.extend (app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.extend (app_exit_agent)
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
			dbg_timer := debugger_manager.new_timer
			dbg_timer.actions.extend (agent on_debugger_time_up)

				-- Test case execution status related
			test_case_info := Void
			is_inside_test_case := False
			current_test_case_execution_mode := Mode_default

			if session.has_limited_length then
				update_timer (session.time_left_for_session)
			end
		end

	start_debugger
			-- Start debugging with proper arguments.
		deferred
		end

	wrap_up (a_should_update_values_of_old_expressions: BOOLEAN)
			-- Wrap up the collection process.
		do
			debugger_manager.observer_provider.application_stopped_actions.prune_all (app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.prune_all (app_exit_agent)

				-- Disable/Remove breakpoints
			entry_breakpoint_manager.toggle_breakpoints (False)
			enable_state_monitoring (False)
			remove_breakpoint (debugger_manager, Test_case_super_class)

			remove_debugger_session

			prune_empty_and_invalid_traces

			if a_should_update_values_of_old_expressions then
				trace_repository.do_all (agent {AFX_PROGRAM_EXECUTION_TRACE}.update_values_of_old_expressions (features_to_monitor_by_names (features_to_monitor)))
			end
		end

feature{NONE} -- Initialization

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
			entry_breakpoint_manager.toggle_breakpoints (True)

				-- Disable state monitoring on test case exit.
			l_bp_manager := debugger_manager.breakpoints_manager
			l_bp_location := l_bp_manager.breakpoint_location (Test_case_exit_feature.e_feature, 1, False)
			l_breakpoint := l_bp_manager.new_user_breakpoint (l_bp_location)
			l_breakpoint.add_when_hits_action (create {BREAKPOINT_WHEN_HITS_ACTION_EXECUTE}.make (agent on_test_case_exit))
			l_breakpoint.set_continue_execution (True)
			l_bp_manager.add_breakpoint (l_breakpoint)
			l_bp_manager.notify_breakpoints_changes
		end

feature{NONE} -- Debugger

	app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			-- Debugger action when application is stopped.

	app_exit_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			-- Debugger action when application exits.

	on_application_exit (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_application_exit)

			entry_breakpoint_manager.toggle_breakpoints (False)
			enable_state_monitoring (False)
			remove_breakpoint (a_dm, Test_case_super_class)
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
					a_dm.controller.resume_workbench_application
				end
			end
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- Action on application exception.
		deferred
		end

feature{NONE} -- Timer for debugging

	dbg_timer: DEBUGGER_TIMER
			-- Debugger timer.

	update_timer (a_interval: INTEGER)
			-- Update `dbg_timer' with `a_interval'.
		do
			if a_interval < 0 then
				dbg_timer.set_interval (1)
			elseif a_interval >= 0 then
				dbg_timer.set_interval (a_interval)
			end
		end

	on_debugger_time_up
			-- Action on debugger time up.
		do
			kill_debuggee (debugger_manager)
			wrap_up (False)
		end

feature{NONE} -- Test case events

	test_case_execution_event_listeners: DS_LINKED_LIST[AFX_TEST_CASE_EXECUTION_EVENT_LISTENER]
			-- Subscribed event listeners.

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
			event_actions.notify_on_test_case_entered (test_case_info)

			enable_state_monitoring (True)

			current_test_case_execution_mode := l_execution_mode
			class_under_test := l_class_under_test
			feature_under_test := l_feature_under_test

			test_case_starting_time := session.time_now
			update_timer (session.time_left_for_test_case (test_case_starting_time))
			is_inside_test_case := True
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

			create l_current_program_location_context.make (debugger_manager.application_status.e_feature.associated_feature_i,
								debugger_manager.application_status.dynamic_class)
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_breakpoint_hit (test_case_info, a_state,
					create {AFX_PROGRAM_LOCATION}.make (l_current_program_location_context, a_breakpoint.breakable_line_number)))
			event_actions.notify_on_break_point_hit (a_class, a_feature, a_breakpoint.breakable_line_number)
		end

	on_test_case_exit (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
			-- Action on exiting test case.
		do
			enable_state_monitoring (False)
			is_inside_test_case := False
			update_timer (0)	-- Reset debugger timer
		end

feature{NONE} -- Execution monitoring

	monitored_breakpoint_managers: DS_LINKED_LIST [EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER]
			-- Managers for breakpoints where program states need to be monitored.

	entry_breakpoint_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Manager for the breakpoint that marks the entries of test cases.

	register_program_state_monitoring
			-- Register program state monitors.
		deferred
		end

	enable_state_monitoring (a_flag: BOOLEAN)
			-- Enable breakpoints for state monitoring, if `a_flag'.
			-- Diable otherwise.
		do
			monitored_breakpoint_managers.do_all (agent {EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER}.toggle_breakpoints (a_flag))
		end

feature{NONE} -- Test cases

	test_case_info: EPA_TEST_CASE_INFO
			-- Information about the test case currently being executed.

	is_inside_test_case: BOOLEAN

	class_under_test: CLASS_C
			-- Class under test.

	feature_under_test: FEATURE_I
			-- Feature under test.

	test_case_starting_time: DT_DATE_TIME
			-- Time when the current test case started executing.

	current_test_case_execution_mode: INTEGER
			-- Execution mode of the current test case.

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

	test_case_info_skeleton: DS_HASH_SET [EPA_EXPRESSION]
			-- State skeleton of test case information.

feature{NONE} -- Implementation

	prune_empty_and_invalid_traces
			-- Prune empty and invalid traces from `trace_repository'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			l_new_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
		do
			from
				create l_new_repository.make_default
				l_cursor := trace_repository.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_cursor.item.is_empty and then (l_cursor.item.is_passing or else l_cursor.item.is_failing) then
					l_new_repository.force (l_cursor.item, l_cursor.key)
				end
				l_cursor.forth
			end
			trace_repository := l_new_repository
		end

feature{NONE} -- Constant

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
			Result := test_case_super_class.feature_named (once "right_before_test")
		ensure
			result_attached: Result /= Void
		end

	Test_case_exit_feature: FEATURE_I
			-- Feature for exiting the test cases.
		once
			Result := test_case_super_class.feature_named (once "right_after_test")
		end

	Test_case_surrounding_feature_name: STRING
			-- Name of the feature for preparing and executin the test cases.
		once
			Result := "generated_test_1"
		end

end
