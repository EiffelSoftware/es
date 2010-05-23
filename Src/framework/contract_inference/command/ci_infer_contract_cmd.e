note
	description: "Command to run test cases to infer contracts"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_INFER_CONTRACT_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	EPA_DEBUGGER_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	CI_SHARED_EQUALITY_TESTERS

	CI_MESSAGES

	EPA_COMPILATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: CI_CONFIG)
			-- Initialize Current.
		do
			config := a_config
			class_ := first_class_starts_with_name (config.class_name)
			feature_ := class_.feature_named (config.feature_name_for_test_cases)
			context_type := class_.constraint_actual_type
			create log_manager.make
			log_manager.set_time_logging_mode ({EPA_LOG_MANAGER}.duration_time_logging_mode)
			log_manager.loggers.extend (create {EPA_CONSOLE_LOGGER})

			setup_inferrers
		end

feature -- Access

	config: CI_CONFIG
			-- Configuration for contract inference

	class_: CLASS_C
			-- Context class

	feature_: FEATURE_I
			-- Feature (viewed in `class_') whose contracts are to be inferred

	log_manager: EPA_LOG_MANAGER
			-- Log manager

	context_type: TYPE_A
			-- Context type in which types are resolved

	inferrers: LINKED_LIST [CI_INFERRER]
			-- List of inferrers

feature -- Basic operations

	execute
			-- Execute current command
		do
			initialize_data_structure

				-- Compile project
			log_manager.put_line_with_time (msg_contract_inference_started)
			compile_project (eiffel_project, True)

			log_manager.put_line_with_time (msg_test_case_execution_started)
				-- Debug project
			debug_project

			log_manager.put_line_with_time (msg_contract_inference_ended)
		end

feature{NONE} -- Implementation

	debug_project
			-- Debug current project to retrieve system states from test cases.
		local
			l_test_case_info_bp_manager: like breakpoint_manager_for_setup_test_case
			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_app_exited_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
		do
				-- Initialize debugger.
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
			remove_breakpoint (debugger_manager, root_class)

			l_app_stop_agent := agent on_application_stopped
			l_app_exited_agent := agent on_application_exited

			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exited_agent)

				-- Setup break point at the beginning of a test case execution, to query for information of that test case.
			l_test_case_info_bp_manager := breakpoint_manager_for_setup_test_case
			l_test_case_info_bp_manager.toggle_breakpoints (True)

				-- Start debugger.
			start_debugger (debugger_manager, feature_.feature_name.as_lower, config.working_directory)

				-- Clean up debugger.
			l_test_case_info_bp_manager.toggle_breakpoints (False)
			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_exited_agent)
			remove_debugger_session
		end

	breakpoint_manager_for_setup_test_case: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Break point manager for {EQA_SERIALIZED_TEST_SET}.`setup_test_case'.
		local
			l_tc_info: CI_TEST_CASE_INFO
		do
			create l_tc_info.make_empty
			create Result.make (l_tc_info.test_set_class, l_tc_info.feat_setup_test_case)
			Result.set_breakpoint_with_expression_and_action (1, l_tc_info.test_case_info_expressions, agent on_new_test_case_found)
		end

	breakpoint_manager_for_expression_evaluation (a_tc_info: CI_TEST_CASE_INFO; a_pre_execution: BOOLEAN): EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			-- Break point manager for evaluating expressions related to test case defined in `a_tc_info'.
			-- `a_pre_execution' indicates if those expressions are to be evaluated before the execution
			-- of the test case.
		local
			l_bp_slot: INTEGER
		do
			if a_pre_execution then
				l_bp_slot := a_tc_info.before_test_break_point_slot
			else
				l_bp_slot := a_tc_info.after_test_break_point_slot
			end
			create Result.make (a_tc_info.test_case_class, a_tc_info.test_feature)
			Result.set_breakpoint_with_expression_and_action (l_bp_slot, expressions_to_evaluate (a_tc_info, a_pre_execution), agent on_state_expression_evaluated (?, ?, a_pre_execution, a_tc_info, Result))
		end

	expressions_to_evaluate (a_tc_info: CI_TEST_CASE_INFO; a_pre_execution: BOOLEAN): DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions to be evaluated, those expressions are relative to `a_tc_info'
			-- `a_pre_execution' indicates that the resulting expressions should be evaluated before
			-- the execution of the test case.
		local
			l_expr_finder: EPA_TYPE_BASED_FUNCTION_FINDER
			l_context: EPA_CONTEXT
			l_operand_map: DS_HASH_TABLE [STRING_8, INTEGER_32]
			l_functions: DS_HASH_SET [EPA_FUNCTION]
		do
				-- Setup expressions to be evaluated before and after the test case execution.
			create l_context.make_with_class_and_feature (a_tc_info.test_case_class, a_tc_info.test_feature, False, True)
			create l_expr_finder.make_for_feature (a_tc_info.class_under_test, a_tc_info.feature_under_test, a_tc_info.operand_map, l_context, config.data_directory, a_tc_info.class_under_test.constraint_actual_type)
			l_expr_finder.set_is_for_pre_execution (a_pre_execution)
			l_expr_finder.set_is_creation (a_tc_info.is_feature_under_test_creation)
			l_expr_finder.search (Void)
			l_functions := nullary_functions (l_expr_finder.functions, l_context)
			create Result.make (l_functions.count)
			Result.set_equality_tester (expression_equality_tester)
			l_functions.do_all (agent (a_function: EPA_FUNCTION; a_set: DS_HASH_SET [EPA_EXPRESSION]; a_ctxt: EPA_CONTEXT) do a_set.force_last (a_function.as_expression (a_ctxt)) end (?, Result, l_context))
		end

	nullary_functions (a_functions: DS_HASH_SET [EPA_FUNCTION]; a_context: EPA_CONTEXT): DS_HASH_SET [EPA_FUNCTION]
			-- Nullary version of functions in `a_functions'
			-- For functions that are already nullary, those functions are directly put into the resulting set.
			-- For functions whose domain needs dynamic evaluation, we evaluate the domain and use the evaluated
			-- domain to form nullary functions.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_func: EPA_FUNCTION
		do
			create Result.make (a_functions.count * 2)
			Result.set_equality_tester (function_equality_tester)
			from
				l_cursor := a_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_func := l_cursor.item
				if l_func.is_nullary then
					Result.force_last (l_func)
				else
					Result.append (functions_with_domain_resolved (l_func, a_context))
				end
				l_cursor.forth
			end
		end

	functions_with_domain_resolved (a_function: EPA_FUNCTION; a_context: EPA_CONTEXT): DS_HASH_SET [EPA_FUNCTION]
			-- Functions from `a_fucntion' with its domain resolved
		require
			a_function_has_unresolved_domain: a_function.arity = 1 and then a_function.argument_domain (1).is_integer_range
		local
			l_lowers: LINKED_LIST [EPA_EXPRESSION]
			l_uppers: LINKED_LIST [EPA_EXPRESSION]
			l_resolved_lowers: SORTED_TWO_WAY_LIST [INTEGER]
			l_resolved_uppers: SORTED_TWO_WAY_LIST [INTEGER]
			l_cursor: CURSOR
			l_expr: EPA_EXPRESSION
			l_has_error: BOOLEAN
			l_value: EPA_EXPRESSION_VALUE
			l_final_lower: INTEGER
			l_final_upper: INTEGER
			i: INTEGER
			l_arg: EPA_FUNCTION
			l_int_expr: EPA_AST_EXPRESSION
		do
			create Result.make (10)
			Result.set_equality_tester (function_equality_tester)

			if attached {EPA_INTEGER_RANGE_DOMAIN} a_function.argument_domain (1) as l_domain then
				l_lowers := l_domain.lower_bounds
				l_uppers := l_domain.upper_bounds

					-- Evaluate lower bounds.
				create l_resolved_lowers.make
				l_cursor := l_lowers.cursor
				from
					l_lowers.start
				until
					l_lowers.after or l_has_error
				loop
					l_expr := l_lowers.item_for_iteration
					if l_expr.is_integer then
						l_resolved_lowers.extend (l_expr.text.to_integer)
					else
						l_value := evaluated_value_from_debugger (debugger_manager, l_expr)
						l_has_error := not l_value.is_integer
						if not l_has_error then
							l_resolved_lowers.extend (l_value.out.to_integer)
						end
					end
					l_lowers.forth
				end
				l_lowers.go_to (l_cursor)

					-- Evaluate upper bounds.
				if not l_has_error then
					create l_resolved_uppers.make
					l_cursor := l_uppers.cursor
					from
						l_uppers.start
					until
						l_uppers.after or l_has_error
					loop
						l_expr := l_uppers.item_for_iteration
						if l_expr.is_integer then
							l_resolved_uppers.extend (l_expr.text.to_integer)
						else
							l_value := evaluated_value_from_debugger (debugger_manager, l_expr)
							l_has_error := not l_value.is_integer
							if not l_has_error then
								l_resolved_uppers.extend (l_value.out.to_integer)
							end
						end
						l_uppers.forth
					end
					l_uppers.go_to (l_cursor)
				end

					-- Fabricate functions.
				if not l_has_error then
					l_resolved_lowers.sort
					l_resolved_uppers.sort
					l_final_lower := l_resolved_lowers.first
					l_final_upper := l_resolved_uppers.last
					from
						i := l_final_lower
					until
						i > l_final_upper
					loop
						create l_int_expr.make_with_text (a_context.class_, a_context.feature_, i.out, a_context.class_)
						create l_arg.make_from_expression (l_expr)

						Result.force_last (a_function.partially_evalauted (l_arg, 1))
						i := i + 1
					end
				end
			end
		end

	log_new_test_case_found (a_tc_info: CI_TEST_CASE_INFO)
			-- Log that a test case `a_tc_info' has been found.
		do
			test_case_count := test_case_count + 1
			log_manager.put_line (msg_separator)
			log_manager.put_line_with_time (msg_found_test_case + test_case_count.out)
			log_manager.put_line (msg_test_class_name + a_tc_info.test_case_class.name)
			log_manager.put_line (msg_feature_under_test + a_tc_info.class_under_test.name_in_upper + once "." + a_tc_info.feature_under_test.feature_name)
		end

feature{NONE} -- Implementation

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

	test_case_count: INTEGER
			-- Number of test cases found so far

feature{NONE} -- Actions

	on_new_test_case_found (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed if a new test case is found and about to execute
		local
			l_after_expr_finder: EPA_TYPE_BASED_FUNCTION_FINDER
			l_functions: DS_HASH_SET [EPA_FUNCTION]
			l_before_dbg_manager: like breakpoint_manager_for_expression_evaluation
		do
				-- Setup information of the newly found test case.
			create last_test_case_info.make (a_state)

				-- Log information of the newly found test case.
			log_new_test_case_found (last_test_case_info)

				-- Setup break points to evaluate expressions.
			l_before_dbg_manager := breakpoint_manager_for_expression_evaluation (last_test_case_info, True)

				-- Enable break points for expression evaluation.
			l_before_dbg_manager.toggle_breakpoints (True)
		end

	on_state_expression_evaluated (a_bp: BREAKPOINT; a_state: EPA_STATE; a_pre_execution: BOOLEAN; a_tc_info: CI_TEST_CASE_INFO; a_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER)
			-- Action to be performed when expressions are evaluated for test case defined in `a_tc_info'.
			-- The evaluated expressions as well as their values are in `a_state'.
			-- `a_pre_execution' indicates if those expressions are evaluated before the execution of the test case.
		local
			l_after_dbg_manager: like breakpoint_manager_for_expression_evaluation
		do
			a_bp_manager.toggle_breakpoints (False)

				-- Logging.
			log_manager.put_line (once "---------------------------------------------------%N")
			if a_pre_execution then
				log_manager.put_line_with_time (once "Pre-execution state:")
			else
				log_manager.put_line_with_time (once "Post-execution state:")
			end
			log_manager.put_line (a_state.debug_output)

				-- Setup post-execution expression evaluator.
			if a_pre_execution then
				l_after_dbg_manager := breakpoint_manager_for_expression_evaluation (last_test_case_info, False)
				l_after_dbg_manager.toggle_breakpoints (True)
			end

				-- Store results.
			if a_pre_execution then
				last_pre_execution_evaluations := a_state
			else
				last_post_execution_evaluations := a_state
				build_last_transition
			end
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		do
			if a_dm.application_is_executing or a_dm.application_is_stopped then
				if a_dm.application_status.reason_is_catcall then
					a_dm.controller.resume_workbench_application
				elseif a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					if a_dm.application_status.exception_occurred then
						a_dm.controller.resume_workbench_application
					end
				end
			end
		end

	on_application_exited (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			inferrers.do_all (agent {CI_INFERRER}.infer (transition_data))
		end

feature{NONE} -- Implementation

	initialize_data_structure
			-- Initialize data structures.
		do
			create transition_data.make
		end

	build_last_transition
			-- Build transition from `last_test_case_info', `last_pre_execution_evaluations' and
			-- `last_post_execution_evaluations' and store resulting transition in `transitions'.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_context: EPA_CONTEXT
			l_func_analyzer: CI_FUNCTION_ANALYZER
			l_pre_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			l_post_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			l_transition_info: CI_TRANSITION_INFO
		do
			create l_context.make (last_test_case_info.variables)
			create l_transition.make (
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.operand_map,
				l_context,
				last_test_case_info.is_feature_under_test_creation)

			l_transition.set_precondition (last_pre_execution_evaluations)
			l_transition.set_postcondition (last_post_execution_evaluations)

				-- Analyze functions in pre-execution state.
			create l_func_analyzer
			l_func_analyzer.analyze (
				l_transition.precondition,
				l_context,
				last_test_case_info.operand_map,
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.class_under_test.constraint_actual_type)
			l_pre_valuations := l_func_analyzer.valuations

				-- Analyze functions in post-execution state.
			create l_func_analyzer
			l_func_analyzer.analyze (
				l_transition.postcondition,
				l_context,
				last_test_case_info.operand_map,
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.class_under_test.constraint_actual_type)
			l_post_valuations := l_func_analyzer.valuations

				-- Fabricate transition info for the last executed test case.
			create l_transition_info.make (last_test_case_info, l_transition, l_pre_valuations, l_post_valuations)
			transition_data.extend (l_transition_info)
		end

	setup_inferrers
			-- Setup `inferrers'.
		local
			l_simple_inferrer: CI_SIMPLE_FRAME_CONTRACT_INFERRER
		do
			create inferrers.make
			create l_simple_inferrer
			l_simple_inferrer.set_logger (log_manager)
			inferrers.extend (l_simple_inferrer)
		end

feature{NONE} -- Results

	last_test_case_info: CI_TEST_CASE_INFO
			-- Test case info of the last found test case

	last_pre_execution_evaluations: EPA_STATE
			-- Pre-execution expression evaluations of the last found test case

	last_post_execution_evaluations: EPA_STATE
			-- Post-execution expression evaluations of the last found test csae

	transition_data: LINKED_LIST [CI_TRANSITION_INFO]
			-- Data collected for transitions retrieved from executed test cases


end
