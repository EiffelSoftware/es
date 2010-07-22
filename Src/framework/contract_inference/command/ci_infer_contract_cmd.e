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

	CI_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: CI_CONFIG)
			-- Initialize Current.
		local
			l_file_name: FILE_NAME
		do
			config := a_config
			class_ := first_class_starts_with_name (config.class_name)
			feature_ := class_.feature_named (config.feature_name_for_test_cases.first)
			context_type := class_.constraint_actual_type
			create log_manager.make
			create l_file_name.make_from_string (config.log_directory)
			l_file_name.set_file_name ("log.txt")
			create log_file.make_create_read_write (l_file_name)
			log_manager.set_time_logging_mode ({EPA_LOG_MANAGER}.duration_time_logging_mode)
			log_manager.loggers.extend (create {EPA_CONSOLE_LOGGER})
			log_manager.loggers.extend (create {EPA_FILE_LOGGER}.make (log_file))

				-- Enable verbose logging (for debugging purpose)
				-- When the code is ready, use a concise logging level will save some time.
			log_manager.set_level_threshold_to_fine
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

	log_file: PLAIN_TEXT_FILE
			-- File used for logging

feature -- Access

	last_preconditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Precconditions inferred by last invocation to `infer'
		do
			Result := last_contracts.item (True)
		end

	last_postconditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Postconditions inferred by last invocation to `infer'
		do
			Result := last_contracts.item (False)
		end

	last_contracts: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BOOLEAN]
			-- Contracts inferred by last invocation to `infer'.
			-- Key is a boolean indicating precondition or postcondition,
			-- value is the set of assertions of that kind.	

feature -- Basic operations

	execute
			-- Infer contracts, make results available in `last_preconditions' and `last_postconditions'.
		do
			initialize_data_structure

				-- Compile project
			log_manager.put_line_with_time (msg_contract_inference_started)
			compile_project (eiffel_project, True)

			log_manager.put_line_with_time (msg_test_case_execution_started)
				-- Debug project
			debug_project

			log_manager.put_line_with_time (msg_contract_inference_ended)

				-- Store transitions in files
			store_transition_in_files

			if log_file /= Void and then log_file.is_open_write then
				log_file.close
			end
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
			start_debugger (debugger_manager, feature_.feature_name.as_lower, config.working_directory, False)

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
				l_bp_slot := a_tc_info.before_test_break_point_slot + 1
			else
				l_bp_slot := a_tc_info.after_test_break_point_slot
			end
			create Result.make (a_tc_info.test_case_class, a_tc_info.test_feature)
			Result.set_breakpoint_with_agent_and_action (
				l_bp_slot,
				agent expressions_to_evaluate (a_tc_info, a_pre_execution),
				agent on_state_expression_evaluated (?, ?, a_pre_execution, a_tc_info, Result))
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
--			l_expr_finder.set_should_include_tilda_expressions (True)
			l_expr_finder.set_should_include_operand_and_expression_comparison (True)

				-- We enable evaluating queries with preconditions.
				-- Even though this will cause a lot of expressions to be [[nonsensical]].
			l_expr_finder.set_should_search_for_query_with_precondition (True)
			l_expr_finder.search (Void)
			l_functions := nullary_functions (l_expr_finder.functions, l_context, a_pre_execution)
			create Result.make (l_functions.count)
			Result.set_equality_tester (expression_equality_tester)
			l_functions.do_all (agent (a_function: EPA_FUNCTION; a_set: DS_HASH_SET [EPA_EXPRESSION]; a_ctxt: EPA_CONTEXT) do a_set.force_last (a_function.as_expression (a_ctxt)) end (?, Result, l_context))
		end

	nullary_functions (a_functions: DS_HASH_SET [EPA_FUNCTION]; a_context: EPA_CONTEXT; a_pre_execution: BOOLEAN): DS_HASH_SET [EPA_FUNCTION]
			-- Nullary version of functions in `a_functions'
			-- For functions that are already nullary, those functions are directly put into the resulting set.
			-- For functions whose domain needs dynamic evaluation, we evaluate the domain and use the evaluated
			-- domain to form nullary functions.
			-- `a_pre_execution' indicates if the computation is for a pre-execution state or a post-execution state.
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
					Result.append (functions_with_domain_resolved (l_func, a_context, a_pre_execution))
				end
				l_cursor.forth
			end
		end

	target_of_function (a_function: EPA_FUNCTION): STRING
			-- Target expression of `a_function', assuming that `a_function' is a qualified feature call
		local
			l_body: STRING
		do
			fixme ("Assume that `a_function' is a qualified feature call and the target is a name (local, argument, Current, Result. 2.6.2010 Jasonw")
			l_body := a_function.body
			Result := l_body.substring (1, l_body.index_of ('.', 1) - 1)
		end

	functions_with_domain_resolved (a_function: EPA_FUNCTION; a_context: EPA_CONTEXT; a_pre_execution: BOOLEAN): DS_HASH_SET [EPA_FUNCTION]
			-- Functions from `a_fucntion' with its domain resolved
			-- `a_pre_execution' indicates if the computation is for a pre-execution state or a post-execution state.
		require
			a_function_has_unresolved_domain: a_function.arity = 1 and then a_function.argument_domain (1).is_integer_range
		local
			l_lowers: LINKED_LIST [EPA_EXPRESSION]
			l_uppers: LINKED_LIST [EPA_EXPRESSION]
			l_constant_lower_map: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			l_resolved_lower_map: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			l_constant_upper_map: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			l_resolved_upper_map: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			l_constant_uppers: SORTED_TWO_WAY_LIST [INTEGER]
			l_resolved_lowers: SORTED_TWO_WAY_LIST [INTEGER]
			l_constant_lowers: SORTED_TWO_WAY_LIST [INTEGER]
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
			l_value_text: STRING
			l_target_of_function: STRING
			l_function_name: STRING
			l_func_with_domain: CI_FUNCTION_WITH_INTEGER_DOMAIN
			l_final_lower_expr: EPA_EXPRESSION
			l_final_upper_expr: EPA_EXPRESSION
		do
			create Result.make (10)
			Result.set_equality_tester (function_equality_tester)
			create l_constant_uppers.make
			create l_constant_lowers.make
			create l_constant_upper_map.make (2)
			create l_resolved_upper_map.make (2)
			create l_constant_lower_map.make (2)
			create l_resolved_lower_map.make (2)

			if attached {EPA_INTEGER_RANGE_DOMAIN} a_function.argument_domain (1) as l_domain then
				l_target_of_function := target_of_function (a_function)
				l_function_name := a_function.body.substring (l_target_of_function.count + 2, a_function.body.index_of ('(', 1) - 1)
				l_function_name.left_adjust
				l_function_name.right_adjust

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
					l_value_text := l_expr.text
					if l_value_text.is_integer then
						l_constant_lowers.extend (l_value_text.to_integer)
						l_constant_lower_map.force (l_expr, l_value_text.to_integer)
					else
						fixme ("The following way of making a qualified call may not be valid in general. 14.6.2010 Jasonw")
						l_value := evaluated_string_from_debugger (debugger_manager, l_target_of_function + "." + l_value_text)
						l_has_error := not l_value.is_integer
						if not l_has_error then
							l_resolved_lowers.extend (l_value.out.to_integer)
							l_resolved_lower_map.force (l_expr, l_value.out.to_integer)
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
						l_value_text := l_expr.text
						if l_value_text.is_integer then
							l_constant_uppers.extend (l_value_text.out.to_integer)
							l_resolved_upper_map.force (l_expr, l_value_text.out.to_integer)
						else
							fixme ("The following way of making a qualified call may not be valid in general. 14.6.2010 Jasonw")
							l_value := evaluated_string_from_debugger (debugger_manager, l_target_of_function + "." + l_value_text)
							l_has_error := not l_value.is_integer
							if not l_has_error then
								l_resolved_uppers.extend (l_value.out.to_integer)
								l_resolved_upper_map.force (l_expr, l_value.out.to_integer)
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
					l_constant_uppers.sort
					l_constant_lowers.sort
					if l_resolved_lowers.is_empty then
						l_final_lower := l_constant_lowers.first
						l_final_lower_expr := l_constant_lower_map.item (l_final_lower)
					elseif l_constant_lowers.is_empty then
						l_final_lower := l_resolved_lowers.first
						l_final_lower_expr := l_resolved_lower_map.item (l_final_lower)
					else
						if l_resolved_lowers.first > l_constant_lowers.last then
							l_final_lower := l_resolved_lowers.first
							l_final_lower_expr := l_resolved_lower_map.item (l_final_lower)
						else
							l_final_lower := l_constant_lowers.last
							l_final_lower_expr := l_constant_lower_map.item (l_final_lower)
						end
					end

					if l_resolved_uppers.is_empty then
						l_final_upper := l_constant_uppers.first
						l_final_upper_expr := l_constant_upper_map.item (l_final_upper)
					elseif l_constant_uppers.is_empty then
						l_final_upper := l_resolved_lowers.first
						l_final_upper_expr := l_resolved_upper_map.item (l_final_upper)
					else
						if l_resolved_uppers.min < l_constant_uppers.max then
							l_final_upper := l_resolved_uppers.min
						else
							l_final_upper := l_resolved_uppers.max
						end
						l_final_upper_expr := l_resolved_upper_map.item (l_final_upper)
					end

					if l_final_lower <= l_final_upper then
						from
							i := l_final_lower
						until
							i > l_final_upper
						loop
							create l_int_expr.make_with_text (a_context.class_, a_context.feature_, i.out, a_context.class_)
							create l_arg.make_from_expression (l_int_expr)
							Result.force_last (a_function.partially_evalauted (l_arg, 1))

								-- Register functions with bounded integer domain.
							create l_func_with_domain.make (l_target_of_function, l_function_name, l_final_lower, l_final_upper, a_context, l_final_lower_expr.text, l_final_upper_expr.text)
							if a_pre_execution and then not last_pre_execution_bounded_functions.has (l_func_with_domain) then
								last_pre_execution_bounded_functions.force_last (l_func_with_domain)
							end
							if not a_pre_execution and then not last_post_execution_bounded_functions.has (l_func_with_domain) then
								last_post_execution_bounded_functions.force_last (l_func_with_domain)
							end
							i := i + 1
						end
					else
							-- Register functions with an EMPTY bounded integer domain.
						create l_func_with_domain.make (l_target_of_function, l_function_name, l_final_lower, l_final_upper, a_context, l_final_lower_expr.text, l_final_upper_expr.text)
						if a_pre_execution and then not last_pre_execution_bounded_functions.has (l_func_with_domain) then
							last_pre_execution_bounded_functions.force_last (l_func_with_domain)
						end
						if not a_pre_execution and then not last_post_execution_bounded_functions.has (l_func_with_domain) then
							last_post_execution_bounded_functions.force_last (l_func_with_domain)
						end
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
			l_before_dbg_manager: like breakpoint_manager_for_expression_evaluation
			l_after_dbg_manager: like breakpoint_manager_for_expression_evaluation
			l_functions: DS_HASH_SET [EPA_FUNCTION]
		do
			if config.max_test_case_to_execute > 0 and then test_case_count >= config.max_test_case_to_execute then
			else
					-- Setup information of the newly found test case.
				create last_test_case_info.make (a_state)
				create last_pre_execution_bounded_functions.make (5)
				last_pre_execution_bounded_functions.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)
				create last_post_execution_bounded_functions.make (5)
				last_post_execution_bounded_functions.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)

					-- Log information of the newly found test case.
				log_new_test_case_found (last_test_case_info)

					-- Setup break points to evaluate expressions.
				l_before_dbg_manager := breakpoint_manager_for_expression_evaluation (last_test_case_info, True)
				l_after_dbg_manager := breakpoint_manager_for_expression_evaluation (last_test_case_info, False)

					-- Enable break points for expression evaluation.
				l_before_dbg_manager.toggle_breakpoints (True)
				l_after_dbg_manager.toggle_breakpoints (True)
			end
		end

	on_state_expression_evaluated (a_bp: BREAKPOINT; a_state: EPA_STATE; a_pre_execution: BOOLEAN; a_tc_info: CI_TEST_CASE_INFO; a_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER)
			-- Action to be performed when expressions are evaluated for test case defined in `a_tc_info'.
			-- The evaluated expressions as well as their values are in `a_state'.
			-- `a_pre_execution' indicates if those expressions are evaluated before the execution of the test case.
		do
			a_bp_manager.toggle_breakpoints (False)

				-- Store results.
			if a_pre_execution then
				last_pre_execution_evaluations := a_state.cloned_object
				mutate_equality_comparision_expressions (last_pre_execution_evaluations)
			else
				last_post_execution_evaluations := a_state.cloned_object
				mutate_equality_comparision_expressions (last_post_execution_evaluations)
				build_last_transition
			end

				-- Logging.
			log_manager.push_level ({EPA_LOG_MANAGER}.fine_level)
			log_manager.put_line (once "---------------------------------------------------%N")
			if a_pre_execution then
				log_manager.put_line_with_time (once "Pre-execution state:")
				log_manager.put_line (last_pre_execution_evaluations.debug_output)
			else
				log_manager.put_line_with_time (once "Post-execution state:")
				log_manager.put_line (last_post_execution_evaluations.debug_output)
			end
			log_manager.pop_level
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
		local
			l_preconditions: DS_HASH_SET [EPA_EXPRESSION]
			l_postconditions: DS_HASH_SET [EPA_EXPRESSION]
		do
			setup_data

				-- Infer contracts using all registered inferrers.
			inferrers.do_all (agent {CI_INFERRER}.infer (data))

				-- Setup results.
			create l_preconditions.make (100)
			l_preconditions.set_equality_tester (expression_equality_tester)
			create l_postconditions.make (100)
			l_postconditions.set_equality_tester (expression_equality_tester)

				-- Iterate through all inferrers to collect inferred contracts.
			across inferrers as l_inferrers loop
				l_preconditions.append_last (l_inferrers.item.last_preconditions)
				l_postconditions.append_last (l_inferrers.item.last_postconditions)
			end

			create last_contracts.make (2)
			last_contracts.put (l_preconditions, True)
			last_contracts.put (l_postconditions, False)

			log_final_contracts
		end

	log_final_contracts
			-- Log final contracts in `last_postconditions'.
		local
			l_cursor: like last_postconditions.new_cursor
			l_printer: CI_EXPRESSION_PRINTER
		do
				-- Logging.
			create l_printer.make
			log_manager.push_info_level
			log_manager.put_line_with_time ("Found the following final postconditions:")
			from
				l_cursor := last_postconditions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				log_manager.put_line (once "%T" + l_printer.printed_expression (l_cursor.item))
				l_cursor.forth
			end
			log_manager.pop_level
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
			l_transition_info: CI_TEST_CASE_TRANSITION_INFO
		do
			create l_context.make (last_test_case_info.variables)
			create l_transition.make (
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.operand_map,
				l_context,
				last_test_case_info.is_feature_under_test_creation)
			l_transition.set_uuid (last_test_case_info.uuid)

			l_transition.set_preconditions (last_pre_execution_evaluations)
			l_transition.set_postconditions (last_post_execution_evaluations)

				-- Analyze functions in pre-execution state.
			create l_func_analyzer
			l_func_analyzer.analyze (
				l_transition.preconditions,
				l_context,
				last_test_case_info.operand_map,
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.class_under_test.constraint_actual_type)
			l_pre_valuations := l_func_analyzer.valuations

				-- Logging.
			log_manager.push_level ({EPA_LOG_MANAGER}.fine_level)
			log_manager.put_line_with_time ("Function analysis in pre-state:")
			log_manager.put_line (l_func_analyzer.dumped_result)

				-- Analyze functions in post-execution state.
			create l_func_analyzer
			l_func_analyzer.analyze (
				l_transition.postconditions,
				l_context,
				last_test_case_info.operand_map,
				last_test_case_info.class_under_test,
				last_test_case_info.feature_under_test,
				last_test_case_info.class_under_test.constraint_actual_type)
			l_post_valuations := l_func_analyzer.valuations

			log_manager.put_line_with_time ("Function analysis in post-state:")
			log_manager.put_line (l_func_analyzer.dumped_result)
			log_manager.pop_level

				-- Fabricate transition info for the last executed test case.
			create l_transition_info.make (
				last_test_case_info,
				l_transition,
				l_pre_valuations,
				l_post_valuations,
				last_pre_execution_bounded_functions,
				last_post_execution_bounded_functions)

			transition_data.extend (l_transition_info)
		end

	setup_inferrers
			-- Setup `inferrers'.
		local
			l_simple_inferrer: CI_SIMPLE_FRAME_CONTRACT_INFERRER
			l_sequence_inferrer: CI_SEQUENCE_PROPERTY_INFERRER
			l_composite_frame_inferrer: CI_COMPOSITE_FRAME_PROPERTY_INFERRER
			l_daikon_inferrer: CI_DAIKON_INFERRER
			l_dnf_inferrer: CI_DNF_INFERRER
			l_implication_inferrer: CI_IMPLICATION_INFERRER
		do
			create inferrers.make

			if config.is_simple_property_enabled then
				create l_simple_inferrer
				l_simple_inferrer.set_logger (log_manager)
				inferrers.extend (l_simple_inferrer)
			end

			if config.is_sequence_property_enabled then
				create l_sequence_inferrer
				l_sequence_inferrer.set_logger (log_manager)
				inferrers.extend (l_sequence_inferrer)
			end

			if config.is_composite_property_enabled then
				create l_composite_frame_inferrer
				l_composite_frame_inferrer.set_logger (log_manager)
				l_composite_frame_inferrer.set_config (config)
				inferrers.extend (l_composite_frame_inferrer)
			end

			if config.is_daikon_enabled then
				create l_daikon_inferrer
				l_daikon_inferrer.set_config (config)
				l_daikon_inferrer.set_logger (log_manager)
				inferrers.extend (l_daikon_inferrer)
			end

			if config.is_dnf_property_enabled then
				create l_dnf_inferrer
				l_dnf_inferrer.set_config (config)
				l_dnf_inferrer.set_logger (log_manager)
				inferrers.extend (l_dnf_inferrer)
			end

			if config.is_implication_property_enabled then
				create l_implication_inferrer
				l_implication_inferrer.set_config (config)
				l_implication_inferrer.set_logger (log_manager)
				inferrers.extend (l_implication_inferrer)
			end
		end

	mutate_equality_comparision_expressions (a_state: EPA_STATE)
			-- Mutate equality comparision related expressions in `a_state'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_set: DS_HASH_SET [EPA_EQUATION]
			l_equation: EPA_EQUATION
			l_expr: EPA_AST_EXPRESSION
			l_expr_text: STRING
			l_orig_expr: EPA_EXPRESSION
			l_orig_expr_text: STRING
			l_left, l_right: STRING
			l_connector: STRING
			l_negated_connector: STRING
			l_parts: LIST [STRING]
			l_connector_tbl: HASH_TABLE [STRING, STRING]
			l_orig_value: EPA_EXPRESSION_VALUE
			l_value1: EPA_EXPRESSION_VALUE
			l_value2: EPA_EXPRESSION_VALUE
			l_value3: EPA_EXPRESSION_VALUE
			l_bool: BOOLEAN
		do
			create l_set.make (10)
			l_set.set_equality_tester (equation_equality_tester)

			create l_connector_tbl.make (2)
			l_connector_tbl.compare_objects
			l_connector_tbl.put (once " /~ ", once " ~ ")
			l_connector_tbl.put (once " /= ", once " = ")

			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_orig_expr := l_cursor.item.expression
				l_orig_expr_text := l_orig_expr.text
				if l_cursor.item.expression.is_boolean then
					l_orig_value := l_cursor.item.value
					across l_connector_tbl as l_connectors loop
						l_connector := l_connectors.key
						l_negated_connector := l_connectors.item

						if l_orig_expr_text.has_substring (l_connector) then
							l_parts := string_slices (l_orig_expr_text, l_connector)
							check l_parts.count = 2 end
							l_left := l_parts.first
							l_right := l_parts.last
							if l_orig_value.is_boolean then
								l_bool := l_orig_value.as_boolean.item
								l_value1 := l_orig_value
								create {EPA_BOOLEAN_VALUE} l_value2.make (not l_bool)
								create {EPA_BOOLEAN_VALUE} l_value3.make (not l_bool)
							else
								l_value1 := l_orig_value
								l_value2 := l_orig_value
								l_value3 := l_orig_value
							end
							across <<[l_right, l_left, l_connector, l_value1], [l_left, l_right, l_negated_connector, l_value2], [l_right, l_left, l_negated_connector, l_value3]>> as l_exprs loop
								if
									attached {STRING} l_exprs.item.reference_item (1) as l_new_left and then
									attached {STRING} l_exprs.item.reference_item (2) as l_new_right and then
									attached {STRING} l_exprs.item.reference_item (3) as l_new_connector and then
									attached {EPA_EXPRESSION_VALUE} l_exprs.item.reference_item (4) as l_new_value
								then
									create l_expr_text.make (64)
									l_expr_text.append (l_new_left)
									l_expr_text.append (l_new_connector)
									l_expr_text.append (l_new_right)

									create l_expr.make_with_text_and_type (l_orig_expr.class_, l_orig_expr.feature_, l_expr_text, l_orig_expr.written_class, l_orig_expr.type)
									create l_equation.make (l_expr, l_new_value)
									l_set.force_last (l_equation)
								end
							end
						end
					end

--					if l_orig_expr_text.has_substring (once " ~ ") then
--						l_expr_text := l_orig_expr_text.twin
--						l_expr_text.replace_substring_all ("~", "/~")
--						create l_expr.make_with_text_and_type (l_orig_expr.class_, l_orig_expr.feature_, l_expr_text, l_orig_expr.written_class, l_orig_expr.type)
--						create l_value.make (not l_cursor.item.value.as_boolean.item)
--						create l_equation.make (l_expr, l_value)
--						l_set.force_last (l_equation)
--					end
				end
				l_cursor.forth
			end
			a_state.append (l_set)
		end

	store_transition_in_files
			-- Store transitions in `transition_data' into files.
		local
			l_writer: SEM_DOCUMENT_WRITER
			l_reader: SEM_DOCUMENT_LOADER
		do
--			create l_writer
--			create l_reader
--			across transition_data as l_cursor loop
--				l_writer.write (l_cursor.item.transition, config.transition_directory)
--				l_reader.load_from_file (l_writer.last_file_path)
--				if attached {SEM_FEATURE_CALL_TRANSITION} l_reader.last_queryable as l_transition then
--				end
--			end
		end

feature{NONE} -- Results

	last_test_case_info: CI_TEST_CASE_INFO
			-- Test case info of the last found test case

	last_pre_execution_evaluations: EPA_STATE
			-- Pre-execution expression evaluations of the last found test case

	last_post_execution_evaluations: EPA_STATE
			-- Post-execution expression evaluations of the last found test csae

	last_pre_execution_bounded_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			-- Functions with bounded integer domain in pre-execution state

	last_post_execution_bounded_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			-- Functions with bounded integer domain in post-execution state

feature{NONE} -- Data

	transition_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]
			-- Data collected for transitions retrieved from executed test cases

	data: CI_TEST_CASE_DATA
			-- Data collected from executed test cases

feature{NONE} -- Implementation

	generate_arff_relation
			-- Generate `arff_relation' from `transition_data'.
		local
			l_gen: CI_TRANSITION_TO_WEKA_PRINTER
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
			if inferrers.there_exists (agent {CI_INFERRER}.is_arff_needed) then
				log_manager.put_line_with_time ("Generating ARFF relation.")

					-- Setup ARFF generator.
				create l_gen.make
				l_gen.set_is_union_mode (False)
				l_gen.set_is_absolute_change_included (True)
				l_gen.set_is_relative_change_included (True)
				l_gen.set_is_value_table_generated (True)
				l_gen.set_equation_selection_function (
					agent (a_equation: EPA_EQUATION; a_tran: SEM_TRANSITION; a_pre_state: BOOLEAN): BOOLEAN
						local
							l_type: TYPE_A
						do
							l_type := a_equation.expression.type
							Result :=
								(l_type.is_integer or l_type.is_boolean)
--								not a_equation.value.is_nonsensical
						end)

				data.interface_transitions.do_all (agent l_gen.extend_transition ({SEM_FEATURE_CALL_TRANSITION}?))
				data.set_arff_relation (l_gen.as_weka_relation)

					-- Store ARFF file.
				create l_file_name.make_from_string (config.data_directory)
				l_file_name.set_file_name (class_.name_in_upper + "__" + feature_.feature_name.as_lower + ".arff")
				create l_file.make_create_read_write (l_file_name)
				data.arff_relation.to_medium (l_file)
				l_file.close
			end
		end

	generate_expression_value_mapping
			-- Generate expression-value mapping.
		do
			if inferrers.there_exists (agent {CI_INFERRER}.is_expression_value_map_needed) then
				log_manager.put_line_with_time ("Generating interface expression value mapping.")
				data.initialize_interface_expression_value_mapping
				log_interface_expression_value_statistics
			end
		end

	setup_data
			-- Setup `data'.
		do
			log_manager.put_line_with_time ("Analyzing test case data.")

			create data.make (transition_data)

				-- Generate ARFF relation if needed.
			generate_arff_relation

				-- Generate expression-value mapping if needed.
			generate_expression_value_mapping
		end

	log_interface_expression_value_statistics
			-- Log statistics information of interface expression values.
		local
			l_text: STRING
			l_expr: STRING
			l_exprs: SORTED_TWO_WAY_LIST [STRING]
			l_expr_values: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION_VALUE], STRING]
			l_value_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION_VALUE]
			i, l_count: INTEGER
		do
				-- Logging.
			log_manager.push_fine_level
			if log_manager.is_logging_needed then
				log_manager.put_line_with_time ("Statistics of interface expressions:")
				across <<True, False>> as l_states loop
					if l_states.item then
						log_manager.put_line ("%TIn pre-state:")
					else
						log_manager.put_line ("%TIn post-state:")
					end
					create l_exprs.make
					l_expr_values := data.interface_expression_values.item (l_states.item)
					across l_expr_values as l_values loop
						l_exprs.extend (l_values.key)
					end
					l_exprs.sort
					across l_exprs as l_sorted_exprs loop
						l_expr := l_sorted_exprs.item
						create l_text.make (128)
						l_text.append (once "%T%T")
						l_text.append (l_expr)
						l_text.append (once " = { ")
						from
							i := 1
							l_count := l_expr_values.item (l_expr).count
							l_value_cursor := l_expr_values.item (l_expr).new_cursor
							l_value_cursor.start
						until
							l_value_cursor.after
						loop
							l_text.append (l_value_cursor.item.out)
							if i < l_count then
								l_text.append (once ", ")
							end
							i := i + 1
							l_value_cursor.forth
						end
						l_text.append (once " }")
						log_manager.put_line (l_text)
					end
				end

				log_manager.put_line ("%TChanged interface expressions:")
				across data.interface_expression_changes as l_changes loop
					if l_changes.item then
						log_manager.put_line (once "%T%T" + l_changes.key)
					end
				end
			end
			log_manager.pop_level
		end

end
