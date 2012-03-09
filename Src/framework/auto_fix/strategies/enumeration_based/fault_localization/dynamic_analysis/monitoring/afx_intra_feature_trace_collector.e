note
	description: "Summary description for {AFX_INTRA_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INTRA_FEATURE_TRACE_COLLECTOR

inherit

	AFX_SHARED_PROJECT_ROOT_INFO

	EPA_DEBUGGER_UTILITY

	AFX_SHARED_STATE_SERVER

	AFX_UTILITY

	EQA_TEST_EXECUTION_MODE

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_SHARED_SESSION

	REFACTORING_HELPER

create
	make

feature -- Initialization

	make
			-- Initialization.
		do
			create test_case_execution_event_listeners.make
		end

feature -- Basic operation

	reset_collector
			-- Reset the state of collector.
		do
				-- Reset listeners.
			test_case_execution_event_listeners.wipe_out

				-- Reset execution information.
			test_case_info := Void
			monitored_breakpoint_manager := Void
			entry_breakpoint_manager := Void
			current_test_case_execution_mode := Mode_default

				-- Reset execution monitors.
			arff_generator_cache := Void
		end

	collect_trace
			-- Run current project to collect execution traces from test cases.
		local
			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_app_exit_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_new_tc_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_expression_set: DS_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_time_left: INTEGER
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_time_left := session.time_left
				if l_time_left >= 0 then
					reset_collector
					dbg_timer := debugger_manager.new_timer
					dbg_timer.actions.extend (agent quit_debugging)

					register_general_action_listeners

						-- Initialize debugger.
					debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
					remove_breakpoint (debugger_manager, Test_case_super_class)

						-- Register debugger event listener.
					l_app_stop_agent := agent on_application_stopped
					l_app_exit_agent := agent on_application_exit
					debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
					debugger_manager.observer_provider.application_exited_actions.extend (l_app_exit_agent)

						-- Start debugging the application.
					dbg_timer.set_interval (l_time_left)
					start_debugger (debugger_manager, " --analyze-tc " + config.interpreter_log_path + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, config.working_directory, {EXEC_MODES}.Run, False)
					dbg_timer.set_interval (0)

						-- Unregister debugger event listener.
					debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
					debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exit_agent)

						-- Clean up debugger.
					remove_breakpoint (debugger_manager, Test_case_super_class)
					remove_debugger_session

					if session.exception_signature /= Void then
						if config.is_using_random_based_strategy then
								-- Interprete program states based on the observed evaluations.
							set_trace_repository (trace_repository.derived_repository (exception_recipient_feature.derived_state_skeleton))
						end
					else
						session.cancel
					end

				end
			end
		rescue
			l_retried := True
			session.cancel
			retry
		end

feature{None} -- Implementation

	current_test_case_info: detachable EPA_TEST_CASE_SIGNATURE
			-- Information about the test case currently under analysis.

	test_case_info: EPA_TEST_CASE_INFO
			-- Information about the test case currently being executed.

	current_test_case_execution_mode: INTEGER
			-- Execution mode of the current test case.

	monitored_breakpoint_manager: detachable EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Manager for breakpoints where program states need to be monitored.

	entry_breakpoint_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Manager for the breakpoint that marks the entries of test cases.

	exit_breakpoint_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Manager for the breakpoint that marks the exits of test cases.

feature{NONE} -- Execution mode

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

	dbg_timer: DEBUGGER_TIMER
			-- Debugger timer.

	test_case_starting_time: DT_DATE_TIME
			-- Time when the current test case started executing.

feature{NONE} -- Execution Evetn Listener

	test_case_execution_event_listeners: DS_LINKED_LIST[AFX_TEST_CASE_EXECUTION_EVENT_LISTENER]
			-- Subscribed event listeners.

	arff_generator: AFX_ARFF_GENERATOR
			-- Generator for ARFF file, ARFF file is used for the Weka tool.
		do
			if arff_generator_cache = Void then
				create arff_generator_cache.make
			end
			Result := arff_generator_cache
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Event handler

	quit_debugging
			-- Quit debugging.
		do
			unregister_test_case_entry_handler (debugger_manager)
			unregister_program_state_monitoring (Void, debugger_manager)
			kill_debuggee (debugger_manager)
			session.cancel
		end

	on_test_case_setup (a_breakpoint: BREAKPOINT; a_test_case_info: EPA_STATE)
			-- Action to be performed when a new test case has been setup.
			-- The handler is registered during the first exception handling.
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

			current_test_case_execution_mode := l_execution_mode
			check
				in_monitor_mode: is_in_mode_monitor
				exception_signature_available: exception_signature /= Void
			end
			create test_case_info.make (l_uuid, l_uuid)

			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_new_test_case(test_case_info))
			event_actions.notify_on_new_test_case_found (test_case_info)

			register_program_state_monitoring
			test_case_starting_time := session.time_now
			update_cutoff_time_for_test_case_execution (True)
		end

	time_left_for_test_case: INTEGER
			-- Time left in milliseconds before the test case, and therefore the debugging session, should be stopped.
			-- Negative value means time is up; 0 means unlimited time; positive value means limited time.
		local
			l_time_left_for_session, l_time_left_for_test_case: INTEGER
			l_cutoff_time: INTEGER
			l_past: INTEGER
		do
				-- Time left for the test case, despite the session time limit.
			l_cutoff_time := session.config.max_test_case_execution_time * 1000
			if l_cutoff_time > 0 then
				if test_case_starting_time = Void then
					l_time_left_for_test_case := 0
				else
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

			l_time_left_for_session := session.time_left
			if l_time_left_for_session < 0 or else l_time_left_for_test_case < 0 then
				Result := -1
			elseif l_time_left_for_session = 0 or else l_time_left_for_test_case = 0 then
				Result := l_time_left_for_session.max (l_time_left_for_test_case)
			else
				Result := l_time_left_for_session.min (l_time_left_for_test_case)
			end
		end

	update_cutoff_time_for_test_case_execution (is_setting: BOOLEAN)
			-- Set cutoff time for test case execution, when 'is_setting';
			-- Otherwise, clear cutoff time.
		require
			dbg_timer_attached: dbg_timer /= Void
		local
			l_timer: DEBUGGER_TIMER
			l_time_left, l_cutoff_time: INTEGER
			l_max_time_per_test_case: INTEGER
		do
			l_timer := dbg_timer
			if is_setting then
				l_time_left := time_left_for_test_case
				if l_time_left < 0 then
					l_cutoff_time := 0
					quit_debugging
				else
					l_cutoff_time := l_time_left
				end
			else
				l_cutoff_time := 0
			end
			l_timer.set_interval (l_cutoff_time)
		end

	on_breakpoint_hit_in_test_case (a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when `a_breakpoint' is hit.
			-- `a_breakpoint' is a break point in a test case.
			-- `a_state' stores the values of all evaluated expressions'.
		do
			update_cutoff_time_for_test_case_execution (False)
			a_state.keep_if (
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result := a_equation.value.is_boolean or else a_equation.value.is_integer
					end)

			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_breakpoint_hit (test_case_info, a_state, a_breakpoint.breakable_line_number))
			event_actions.notify_on_break_point_hit (test_case_info, a_breakpoint.breakable_line_number)
			update_cutoff_time_for_test_case_execution (True)
		end

	on_application_exit (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_application_exit)
			unregister_test_case_entry_handler (a_dm)
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		local
			l_new_tc_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
		do
			if a_dm.application_is_executing and then a_dm.application_is_stopped then
				if a_dm.application_status.reason_is_catcall then
					a_dm.controller.resume_workbench_application
				elseif a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					if a_dm.application_status.exception_occurred then
						update_cutoff_time_for_test_case_execution (False)

						if not is_in_mode_monitor then
								-- Corresponds to the execution of the first test case, which is used to reproduce the fault.

								-- Analyze the exception and its recipient.
							analyze_exception (a_dm)

								-- Mark the code range of test cases.
							register_test_case_entry_handler
							register_test_case_exit_handler
						else
								-- During monitoring, mark the trace as from a FAILED execution.
							trace_repository.current_trace.set_status_as_failing
						end
							-- Remove any breakpoint that might interfere with monitoring.
						unregister_program_state_monitoring (Void, a_dm)

						update_cutoff_time_for_test_case_execution (True)
					end

						-- Resume anyway.
					a_dm.controller.resume_workbench_application
				end
			end
		end

feature{NONE} -- Event handler registration/unregistration

	register_general_action_listeners
			-- Register general action listeners to respond to actions.
		do
			test_case_execution_event_listeners.force_last (trace_repository)
			if config.is_using_model_based_strategy and then config.is_arff_generation_enabled then
				test_case_execution_event_listeners.force_last (arff_generator)
			end
		end

	register_test_case_exit_handler
			-- Register handler at the exits of test cases.
		local
			l_class: CLASS_C
			l_bp_manager: BREAKPOINTS_MANAGER
			l_bp_location: BREAKPOINT_LOCATION
			l_breakpoint: BREAKPOINT
		do
			l_bp_manager := debugger_manager.breakpoints_manager

				-- Ending point of monitoring.
			l_bp_location := l_bp_manager.breakpoint_location (Test_case_exit_feature.e_feature, 1, False)
			l_breakpoint := l_bp_manager.new_user_breakpoint (l_bp_location)
			l_breakpoint.add_when_hits_action (create {BREAKPOINT_WHEN_HITS_ACTION_EXECUTE}.make (agent unregister_program_state_monitoring))
			l_breakpoint.set_continue_execution (True)
			l_bp_manager.add_breakpoint (l_breakpoint)
			l_bp_manager.notify_breakpoints_changes
		end

	register_test_case_entry_handler
			-- Register test-case-entry handler at breakpoint.
		do
			if entry_breakpoint_manager = Void then
				create entry_breakpoint_manager.make (Test_case_super_class, Test_case_setup_feature)
				entry_breakpoint_manager.set_breakpoint_with_expression_and_action (1, test_case_info_skeleton, agent on_test_case_setup)
			end
			entry_breakpoint_manager.toggle_breakpoints (True)
		end

	unregister_test_case_entry_handler (a_dm: DEBUGGER_MANAGER)
			-- Unregister test-case entry & exit handler.
		do
			if entry_breakpoint_manager /= Void then
				entry_breakpoint_manager.toggle_breakpoints (False)
			end
			remove_breakpoint (a_dm, Test_case_super_class)
		end

	register_program_state_monitoring
			-- Register program state monitoring at each breakpoint in the recipient feature.
		local
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_recipient_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_expressions: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_expression_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_recipient_class := exception_recipient_feature.context_class
			l_recipient := exception_recipient_feature.feature_

			if monitored_breakpoint_manager = Void then
					-- Register expressions at all breakpoints.
				l_expressions := exception_recipient_feature.expressions_to_monitor
				create l_expression_set.make_equal (l_expressions.count)
				l_expressions.keys.do_all (agent l_expression_set.force)

				create monitored_breakpoint_manager.make (l_recipient_class, l_recipient)
				monitored_breakpoint_manager.set_all_breakpoints_with_expression_and_actions (l_expression_set, agent on_breakpoint_hit_in_test_case)
			end

			monitored_breakpoint_manager.toggle_breakpoints (True)
			check debugger_manager.breakpoints_manager.is_breakpoint_enabled (l_recipient.e_feature, 1) end
		end

	unregister_program_state_monitoring (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
			-- Unregister program state monitoring at each breakpoint in the recipient feature.
		require
			current_test_case_attached: current_test_case_info /= Void
		do
			if monitored_breakpoint_manager /= Void then
				monitored_breakpoint_manager.toggle_breakpoints (False)
			end
			remove_breakpoint (a_dm, exception_recipient_feature.context_class)
		end

feature{NONE} -- Test case info

	test_case_info_skeleton: DS_HASH_SET [EPA_EXPRESSION]
			-- State skeleton of test case information.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
			l_expr_set: like test_case_info_skeleton
		do
			if test_case_info_skeleton_cache = Void then
				create l_expr_set.make_equal (14)

				l_class := test_case_super_class
				l_feature := test_case_setup_feature

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

				test_case_info_skeleton_cache := l_expr_set
			end

			Result := test_case_info_skeleton_cache
		ensure
			result_size_correct: Result /= Void and then Result.count = 14
		end

feature{NONE} -- Implementation

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
			Result := test_case_super_class.feature_named (once "setup_before_test")
		ensure
			result_attached: Result /= Void
		end

	Test_case_exit_feature: FEATURE_I
			-- Feature for exiting the test cases.
		once
			Result := test_case_super_class.feature_named (once "cleanup_after_test")
		end

feature{NONE} -- Cache

	arff_generator_cache: detachable AFX_ARFF_GENERATOR
			-- Cache for `arff_generator'.

	test_case_info_skeleton_cache: like test_case_info_skeleton
			-- Cache for `test_case_info_skeleton'.

end
