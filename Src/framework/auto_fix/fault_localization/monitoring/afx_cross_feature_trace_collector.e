note
	description: "Summary description for {AFX_CROSS_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CROSS_FEATURE_TRACE_COLLECTOR

inherit

	AFX_SHARED_CLASS_THEORY

	AFX_SHARED_PROGRAM_EXECUTION_TRACE_REPOSITORY

	EPA_DEBUGGER_UTILITY

	AFX_SHARED_STATE_SERVER

	SHARED_EIFFEL_PARSER

	AFX_UTILITY

	AFX_SHARED_EVENT_ACTIONS

	EPA_COMPILATION_UTILITY

	EQA_TEST_EXECUTION_MODE

	REFACTORING_HELPER

create
	make

feature -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
		local
			l_repos: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
		do
			config := a_config

			create should_activate_monitor.put (False)

			create l_repos.make
			set_repository (l_repos)

			monitor_activated_actions.extend (agent update_current_test_case_info)
			monitor_deactivated_actions.extend (agent on_monitor_deactivated)
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix configuration.

	feature_as_monitor_activator: detachable FEATURE_I
			-- Feature whose execution would activate execution monitoring.

	feature_as_monitor_deactivator: detachable FEATURE_I
			-- Feature whose execution would deactivate execution monitoring.

	monitor_activated_actions: ACTION_SEQUENCE [TUPLE [DEBUGGER_MANAGER]]
			-- Actions to be performed when the monitor becomes activated.
		do
			if monitor_activated_actions_cache = Void then
				create monitor_activated_actions_cache
			end

			Result := monitor_activated_actions_cache
		end

	monitor_deactivated_actions: ACTION_SEQUENCE [TUPLE [DEBUGGER_MANAGER]]
			-- Actions to be performed when the monitor becomes deactivated.
		do
			if monitor_deactivated_actions_cache = Void then
				create monitor_deactivated_actions_cache
			end

			Result := monitor_deactivated_actions_cache
		end

	application_exited_actions: ACTION_SEQUENCE [TUPLE [DEBUGGER_MANAGER]]
			-- Actions to be performed when application exited in debugger
		do
			if application_exited_actions_cache = Void then
				create application_exited_actions_cache
			end

			Result := application_exited_actions_cache
		end

	exception_summary: EPA_EXCEPTION_TRACE_SUMMARY
			-- Summary information about the exception.

feature -- Basic operation

	collect_trace
			-- Run current project to collect execution traces from test cases.
		require
			activator_and_deactivator_attached: feature_as_monitor_activator /= Void
					and then feature_as_monitor_deactivator /= Void
		local
			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_app_exited_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_class: CLASS_C
		do
			-- Initialize debugger.
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)

			mark_code_range_for_monitoring

			-- Register debugger event listener.
			l_app_stop_agent := agent on_application_stopped
			l_app_exited_agent := agent on_application_exited
			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exited_agent)

			-- Start debugging the application step-by-step.
			start_debugger (debugger_manager, "--analyze-tc " + config.interpreter_log_path + " false", config.working_directory, {EXEC_MODES}.Run, False)

			-- Unregister debugger event listener.
			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exited_agent)

			-- Clean up debugger.
			remove_breakpoint (debugger_manager, l_class)
			remove_debugger_session
		end

	reset_monitor_activator_and_deactivator
			-- Reset monitor activator and deactivator to Void.
		do
			feature_as_monitor_activator := Void
			feature_as_monitor_deactivator := Void
		end

feature{NONE} -- Debugger event listener

	on_application_exited (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			application_exited_actions.call ([a_dm])
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
			--
			-- One failing test case is executed first to reproduce the failure, in mode_execute,
			--		exception information would be collected and put into `exception_summary'.
			-- Afterwards, all test cases are executed again, in mode_monitor, and monitored to get execution traces.
		do
			if a_dm.application_is_executing and then a_dm.application_is_stopped then
				debug("autofix_dynamic_analysis")
					io.put_string ("%T" + a_dm.application_status.e_feature.name + "%T")
				end
				if a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					-- Update the status of the monitor.
					if should_activate_monitor.item /~ is_monitor_activated then
						activate_monitoring (a_dm, should_activate_monitor.item)
					end

					if is_monitor_activated then
						if a_dm.application_status.exception_occurred then
							if is_in_mode_execute then
								analyze_exception (a_dm)
							elseif is_in_mode_monitor then
								-- Mark the trace as from a FAILED execution.
								trace_repository.current_trace.set_status_as_failing
							end

							-- Deactivate monitoring after exception, and continue running.
							activate_monitoring (a_dm, False)
							a_dm.application.set_execution_mode ({EXEC_MODES}.Run)
						else
							if is_in_mode_monitor then
								monitor_program_state (a_dm)
								a_dm.application.set_execution_mode ({EXEC_MODES}.Step_into)
							elseif is_in_mode_execute then
								a_dm.application.set_execution_mode ({EXEC_MODES}.Run)
							else
								check should_not_happen: False end
							end
						end
					else
						-- Continue executing.
						a_dm.application.set_execution_mode ({EXEC_MODES}.Run)
					end

					a_dm.controller.resume_workbench_application
				end
			end
		end

feature{NONE} -- Implementation

	is_in_mode_execute: BOOLEAN
			-- Is current test case running in 'Mode_execute'?
		do
			Result := current_test_execution_mode = Mode_execute
		end

	is_in_mode_monitor: BOOLEAN
			-- Is current test case running in 'Mode_monitor'?
		do
			Result := current_test_execution_mode = Mode_monitor
		end

	mark_code_range_for_monitoring
			-- Mark the range of code where monitoring should be activated.
		local
			l_class: CLASS_C
			l_bp_manager: BREAKPOINTS_MANAGER
			l_bp_location: BREAKPOINT_LOCATION
			l_breakpoint: BREAKPOINT
		do
			l_bp_manager := debugger_manager.breakpoints_manager

			-- Remove breakpoints from last run.
			l_class := feature_as_monitor_activator.written_class
			remove_breakpoint (debugger_manager, l_class)

			-- Starting point of monitoring.
			l_bp_location := l_bp_manager.breakpoint_location (feature_as_monitor_activator.e_feature, 1, False)
			l_breakpoint := l_bp_manager.new_user_breakpoint (l_bp_location)
			l_breakpoint.add_when_hits_action (create {BREAKPOINT_WHEN_HITS_ACTION_MONITOR_EXECUTION}.make (True, should_activate_monitor))
			-- Stop after the breakpoint, so that `on_application_stopped' would get a chance to be called.
			l_breakpoint.set_continue_execution (False)
			l_bp_manager.add_breakpoint (l_breakpoint)

			-- Ending point of monitoring.
			l_bp_location := l_bp_manager.breakpoint_location (feature_as_monitor_deactivator.e_feature, 1, False)
			l_breakpoint := l_bp_manager.new_user_breakpoint (l_bp_location)
			l_breakpoint.add_when_hits_action (create {BREAKPOINT_WHEN_HITS_ACTION_MONITOR_EXECUTION}.make (False, should_activate_monitor))
			-- Stop after the breakpoint, so that `on_application_stopped' would get a chance to be called.
			l_breakpoint.set_continue_execution (False)
			l_bp_manager.add_breakpoint (l_breakpoint)

			l_bp_manager.notify_breakpoints_changes
		end

	on_monitor_deactivated (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when the monitor becomes deactivated.
		do
			-- Nothing need to be done for the moment.
		end

	update_current_test_case_info (a_dm: DEBUGGER_MANAGER)
			-- Update infomation about current test case.
		local
			l_feature: FEATURE_I
			l_class: CLASS_C
			l_exp: EPA_AST_EXPRESSION
			l_val: EPA_EXPRESSION_VALUE
		do
			l_class := a_dm.application_status.dynamic_class
			l_feature := feature_as_monitor_activator

			-- Update `current_test_execution_mode'.
			create l_exp.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_execution_mode, l_class)
			l_val := evaluated_value_from_debugger (a_dm, l_exp)
			check is_integer: l_val.is_integer end
			current_test_execution_mode := l_val.as_integer.item

			-- Update `current_test_case_uuid'.
			create l_exp.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.txt_tci_class_uuid, l_class)
			l_val := evaluated_value_from_debugger (a_dm, l_exp)
			check is_string: l_val.is_string end
			current_test_case_uuid := l_val.as_string.string_value.twin

			minimum_stack_depth := stack_depth (a_dm)
		end

	stack_depth (a_dm: DEBUGGER_MANAGER): INTEGER
			-- Depth of current call stack.
		require
			call_stack_attached: a_dm /= Void and then a_dm.application_status /= Void
		do
			Result := a_dm.application_status.current_call_stack_depth
		ensure
			result_gt_zero: Result > 0
		end

	monitor_program_state (a_dm: DEBUGGER_MANAGER)
			-- Monitor program states at current execution point,
			-- 		and put the observed state into `trace_repository'.`current_trace'.
		require
			is_monitoring: a_dm.application.is_running
					and then is_monitor_activated
					and then current_test_execution_mode = Mode_monitor
		local
			l_repository: like trace_repository
			l_execution_status: INTEGER
			l_status: APPLICATION_STATUS
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expression_set: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			l_execution_state: AFX_PROGRAM_EXECUTION_STATE
			l_state: EPA_STATE
			l_state_value: EPA_EQUATION
			l_index: INTEGER
		do
			if stack_depth (a_dm) > minimum_stack_depth then
				-- Prepare `trace_repository'.`current_trace', if necessary.
				l_repository := trace_repository
				if l_repository.current_trace_id /~ current_test_case_uuid then
					l_repository.start_trace_with_id (current_test_case_uuid)
					l_repository.current_trace.set_status_as_passing
				end

				-- Collect expressions that define the current program state.
				l_status := a_dm.application_status
				l_class := l_status.dynamic_class
				l_feature := l_status.e_feature.associated_feature_i
				l_index := l_status.break_index
				l_expression_set := state_expression_server.expression_set (l_class, l_feature)

				-- Evaluate current state.
				create l_state.make (l_expression_set.count, l_class, l_feature)
				from
					l_expression_set.start
				until
					l_expression_set.after
				loop
					create l_state_value.make (l_expression_set.item_for_iteration, evaluated_value_from_debugger (a_dm, l_expression_set.item_for_iteration))
					l_state.force_last (l_state_value)

					l_expression_set.forth
				end
				create l_execution_state.make_with_state_and_bp_index (l_state, l_index)

				-- Extend `trace_repository'.`current_trace' with the new state.
				l_repository.current_trace.extend (l_execution_state)
			end
		end

	analyze_exception (a_dm: DEBUGGER_MANAGER)
			-- Get exception information from execution status, and make the result available in `exception_summary'.
		local
			l_recipient_id: STRING
			l_static_analyzer: AFX_EXCEPTION_STATIC_ANALYZER

			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
			l_status: APPLICATION_STATUS
			l_call_stack: EIFFEL_CALL_STACK
			l_call_stack_element: CALL_STACK_ELEMENT
			l_class_under_test, l_feature_under_test: STRING
			l_syntax_checker: EIFFEL_SYNTAX_CHECKER

			l_exception_code: INTEGER

			l_failing_class, l_failing_feature: STRING
			l_failing_breakpoint_slot_index: INTEGER
			l_failing_tag: STRING

			l_recipient_class, l_recipient_feature: STRING
			l_recipient_breakpoint_slot_index: INTEGER
		do
			l_status := a_dm.application_status

			l_call_stack := l_status.current_call_stack
			l_exception_code := l_status.exception.code

			fixme ("Check the statuses of call stacks in occurrences of different exceptions.")

			-- Information about the failing position.
			l_call_stack_element := l_call_stack.i_th (1)
			l_failing_class := l_call_stack_element.class_name

			l_failing_tag := l_status.exception_message
			create l_syntax_checker
			if l_failing_tag = Void or else l_failing_tag.is_empty or else not l_syntax_checker.is_valid_identifier (l_failing_tag) then
				l_failing_tag := "noname"
			end

			if l_exception_code /= {EXCEP_CONST}.Class_invariant then
				l_failing_feature := l_call_stack_element.routine_name
				l_failing_breakpoint_slot_index := l_call_stack_element.break_index
			end

			-- Information about the recipient.
			if l_exception_code = {EXCEP_CONST}.Precondition then
				-- Get recipient information from the call stack element next to the top, i.e. with index 2.
				l_call_stack_element := l_call_stack.i_th (2)
				l_recipient_class := l_call_stack_element.class_name
				l_recipient_feature := l_call_stack_element.routine_name
				l_recipient_breakpoint_slot_index := l_call_stack_element.break_index
			else
				l_recipient_class := l_failing_class
				l_recipient_feature := l_failing_feature
				l_recipient_breakpoint_slot_index := l_failing_breakpoint_slot_index
			end

			create exception_summary.make (l_exception_code,
					l_failing_class, l_failing_feature,
					l_failing_breakpoint_slot_index,
					l_failing_tag,
					l_recipient_class, l_recipient_feature,
					l_recipient_breakpoint_slot_index)
		end

	activate_monitoring (a_dm: DEBUGGER_MANAGER; a_flag: BOOLEAN)
			-- Activate monitoring depending on `a_flag'.
		require
			application_attached: a_dm /= Void and then a_dm.application /= Void
		do
			if is_monitor_activated /= a_flag then
				if a_flag then
					monitor_activated_actions.call ([a_dm])
				else
					monitor_deactivated_actions.call ([a_dm])
				end

				-- Update relevant flags.
				is_monitor_activated := a_flag
				should_activate_monitor.put (a_flag)
			end
		end

feature{NONE} -- Access

	current_test_execution_mode: INTEGER
			-- Execution mode of current test.

	current_test_case_uuid: STRING
			-- UUID of the current test case.

	minimum_stack_depth: INTEGER
			-- Minimun depth of the stack to enable monitoring.
			-- This is the depth of the call stack when `feature_as_monitoring_activator' is executed.
			-- During executions of test cases, the call stack has greater depths.

	should_activate_monitor: CELL [BOOLEAN]
			-- Should monitor be activated?
			-- True for yes, and False for no.

	is_monitor_activated: BOOLEAN
			-- Is monitor activated?

	state_expression_server: AFX_PROGRAM_STATE_EXPRESSIONS_SERVER
			-- Server from which program-state-expressions associated with a feature can be queried.
		once
			create Result.make (config, 5)
		end

feature -- Status set

	set_feature_as_monitor_activator (a_class_name: STRING; a_routine_name: STRING)
			-- Set `a_class_name'.`a_feature_name' as the `feature_as_monitor_activator'.
		do
			feature_as_monitor_activator := feature_from_class (a_class_name, a_routine_name)
		ensure
			activator_attached: feature_as_monitor_activator /= Void
		end

	set_feature_as_monitor_deactivator (a_class_name: STRING; a_routine_name: STRING)
			-- Set `a_class_name'.`a_feature_name' as the `feature_as_monitor_deactivator'.
		do
			feature_as_monitor_deactivator := feature_from_class (a_class_name, a_routine_name)
		ensure
			deactivator_attached: feature_as_monitor_deactivator /= Void
		end

feature{NONE} -- Cache

	monitor_activated_actions_cache: like monitor_activated_actions
			-- Cache for `monitor_activated_actions'.

	monitor_deactivated_actions_cache: ACTION_SEQUENCE [TUPLE [DEBUGGER_MANAGER]]
			-- Cache for `monitor_deactivated_actions'.

	application_exited_actions_cache: like application_exited_actions
			-- Cache for `application_exited_actions'.

--feature -- Monitored execution markup

--feature{BREAKPOINT_WHEN_HITS_ACTION_MONITOR_EXECUTION} -- Monitor execution

--	should_activate_monitor (a_dm: DEBUGGER_MANAGER): BOOLEAN
--			-- Should monitor be activated in `a_dm'?
--			-- This is done by checking on if the execution is entering the `feature_as_monitor_activator'.
--		require
--			application_running: a_dm.application.is_running
--			monitor_is_not_activated: not is_monitor_activated
--		do
--			Result := (feature_as_monitor_activator /= Void)
--					and then (a_dm.application_status.e_feature.name ~ "setup_before_test")
--			Result := (feature_as_monitor_activator /= Void)
--					and then (a_dm.application_status.e_feature.name ~ "generated_test_1")
--			Result := (feature_as_monitor_activator /= Void)
--					and then (a_dm.application_status.e_feature.associated_feature_i.rout_id_set ~ feature_as_monitor_activator.rout_id_set)
--		end

--	should_deactivate_monitor (a_dm: DEBUGGER_MANAGER): BOOLEAN
--			-- Should monitor be deactivated in `a_dm'?
--			-- This is done by checking on if the execution is entering the `feature_as_monitor_deactivator'.
--		require
--			application_running: a_dm.application.is_running
--			monitor_is_activated: is_monitor_activated
--		do
--			Result := (feature_as_monitor_deactivator /= Void)
--					and then (a_dm.application_status.e_feature.associated_feature_i.rout_id_set ~ feature_as_monitor_deactivator.rout_id_set)
--		end

--feature -- Application data

--	current_test_case_info: detachable EPA_TEST_CASE_INFO
--			-- Information about currently analyzed test case

--	exception_spots: HASH_TABLE [AFX_EXCEPTION_SPOT, STRING]
--			-- Set of state models that are already met
--			-- Keys are test case info id, check {AFX_TEST_CASE_INFO}.`id' for details.
--			-- Values are the associated exception spots.

--feature{NONE} -- Cache

--	test_case_info_skeleton_cache: like test_case_info_skeleton
--			-- Internal cache for 'test_case_info_skeleton_cache'.

--	test_case_info_skeleton: DS_HASH_SET [EPA_EXPRESSION]
--			-- State skeleton of test case information.
--		local
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--			l_expr: EPA_AST_EXPRESSION
--			l_expr_set: like test_case_info_skeleton
--		do
--			if test_case_info_skeleton_cache = Void then
--				l_feature := feature_as_monitor_activator
--				l_class := l_feature.written_class

--				create l_expr_set.make_equal (14)

--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_name, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_execution_mode, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_uuid, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_class_under_test, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_feature_under_test, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_breakpoint_index, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_creation, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_query, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_is_passing, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_code, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_assertion_tag, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient_class, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient, l_class)
--				l_expr_set.force_last (l_expr)
--				create l_expr.make_with_text (l_class, l_feature, {EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_trace, l_class)
--				l_expr_set.force_last (l_expr)

--				test_case_info_skeleton_cache := l_expr_set
--			end

--			Result := test_case_info_skeleton_cache
--		ensure
--			result_size_correct: Result /= Void and then Result.count = 14
--		end

--	debug_project
--			-- Debug current project to retrieve system states from test cases.
--		local
--			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--			l_app_exited_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--		do
--			-- Initialize debugger.
--			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)

--			-- Register debugger event listener.
--			l_app_stop_agent := agent on_application_stopped
--			l_app_exited_agent := agent on_application_exited
--			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exited_agent)

--			-- Start debugging the application step-by-step.
--			start_debugger (debugger_manager, "--analyze-tc " + config.interpreter_log_path + " false", config.working_directory, {EXEC_MODES}.Step_into, True)

--			-- Unregister debugger event listener.
--			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exited_agent)

--			-- Clean up debugger.
--			remove_debugger_session
--		end

--	toggle_monitor (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER; a_to_enable: BOOLEAN)
--			-- Toggle monitor on or off, depending on `a_to_enable'.
--		require
--			application_attached: debugger_manager /= Void and then debugger_manager.application /= Void
--		local
--			l_app: APPLICATION_EXECUTION
--		do
--			is_monitor_activated := a_to_enable

--			-- Update application execution mode.
--			l_app := a_dm.application
--			if a_to_enable then
--				l_app.set_execution_mode ({EXEC_MODES}.Step_into)
--				monitor_activated_actions.call ([a_dm])
--			else
--				l_app.set_execution_mode ({EXEC_MODES}.Run)
--				monitor_deactivated_actions.call ([a_dm])
--			end
--		end


end
