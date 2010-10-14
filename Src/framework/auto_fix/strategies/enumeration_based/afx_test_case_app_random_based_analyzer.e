note
	description: "Summary description for {AFX_TEST_CASE_APP_RANDOM_BASED_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_APP_RANDOM_BASED_ANALYZER

inherit

--	AFX_SHARED_EVENT_ACTIONS

	AFX_TEST_CASE_APP_ANALYZER
		rename
			test_case_info_skeleton as old_test_case_info_skeleton,
			on_application_stopped as old_on_application_stopped,
			collect_exception_info as old_collect_exception_info
		redefine
			execute,
			generate_fixes
		end

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_EXECUTION_MODE

	SHARED_SERVER

create
	make

--feature -- Initialization

--	make (a_config: AFX_CONFIG)
--			-- Initialization.
--		require
--			config_attached: a_config /= Void
--		do
--			config := a_config
--		end

--feature -- Access

--	config: AFX_CONFIG
--			-- AutoFix configuration.

feature -- Basic operations

	execute
			-- <Precursor>
		local
--			l_trace_collector: AFX_PROGRAM_EXECUTION_TRACE_COLLECTOR
			l_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

			l_cross_feature_trace_collector: AFX_CROSS_FEATURE_TRACE_COLLECTOR
			l_intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
			l_localizer: AFX_EXTENDED_EXPRESSION_RANKING_HEURISTIC_III
			l_extended_expression_ranker: AFX_EXTENDED_EXPRESSION_RANKING_HEURISTIC_III
			l_original_expression_ranker: AFX_ORIGINAL_EXPRESSION_RANKER
			l_ranking: DS_ARRAYED_LIST [TUPLE [INTEGER_32, EPA_EXPRESSION, REAL_32]]
		do
			initialize_logging

			-- Step for experiment implementation.
			experimental_step

			event_actions.notify_on_session_starts

			-- Compile project			
			compile_project (eiffel_project, True)

			-- Start test case analysis
			event_actions.notify_on_test_case_analysis_starts

			l_ranking := ranking_of_original_object_usage
--			create l_extended_expression_ranker.make (config)
--			l_extended_expression_ranker.set_trace_repository (l_trace_repository)
--			l_extended_expression_ranker.compute_ranking

--			create l_original_expression_ranker.make (config)
--			l_original_expression_ranker.set_extended_expression_ranking (l_extended_expression_ranker.ranking)

			event_actions.notify_on_test_case_analysis_ends

			-- Generate fixes.
			event_actions.notify_on_fix_generation_starts
--			generate_fixes

			-- Store fixes in files.
--			store_fixes (fixes)
			event_actions.notify_on_fix_generation_ends (fixes.count)

			-- Validate generated fixes.
			event_actions.notify_on_fix_validation_starts
--			validate_fixes
			event_actions.notify_on_fix_validation_ends

			event_actions.notify_on_session_ends
		end

feature{NONE} -- Experiment

	experimental_step
			-- Step for experiment implementation.
		local
--			l_collector: EPA_PROGRAM_STATE_EXPRESSION_COLLECTOR
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_collection: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			l_builder: EPA_CFG_BUILDER
			l_graph, l_cfg: EPA_CONTROL_FLOW_GRAPH
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
			l_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]
			l_printer: EGX_SIMPLE_GDL_GRAPH_PRINTER [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			l_node_text_action: FUNCTION [ANY, TUPLE [a_node: EPA_BASIC_BLOCK], TUPLE [a_title: STRING; a_label: STRING]]
			l_edge_text_action: FUNCTION [ANY, TUPLE [a_edge: EPA_CFG_EDGE], STRING]
			l_graph_string: STRING
			l_file_name1, l_file_name2: FILE_NAME
			l_file1, l_file2: PLAIN_TEXT_FILE
			l_analyzer: EPA_EXCEPTION_TRACE_PARSER
			l_trace1, l_trace2, l_trace3, l_trace4, l_trace5: STRING
			l_parser: EPA_EXCEPTION_TRACE_PARSER
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_test: EPA_EXCEPTION_TRACE_EXPLAINER_TEST
			l_execution_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_expressions_servers: AFX_PROGRAM_STATE_EXPRESSIONS_SERVER
			l_assistant: AFX_CROSS_FEATURE_TRACE_COLLECTOR
			l_collector: AFX_PROGRAM_EXECUTION_TRACE_COLLECTOR
			l_intra_feature_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
			l_statistic: AFX_EXECUTION_TRACE_STATISTIC
			l_heuristic: AFX_EXTENDED_EXPRESSION_RANKING_HEURISTIC_III
		do
			create l_test
--			l_test.test
		end

	ranking_of_original_object_usage: DS_ARRAYED_LIST [TUPLE [INTEGER_32, EPA_EXPRESSION, REAL_32]]
			-- Collect execution trace.
		local
			l_cross_feature_trace_collector: AFX_CROSS_FEATURE_TRACE_COLLECTOR
			l_intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
			l_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_exception_spot: AFX_EXCEPTION_SPOT
			l_extended_expression_ranker: AFX_EXTENDED_EXPRESSION_RANKING_HEURISTIC_III
			l_original_expression_ranker: AFX_ORIGINAL_EXPRESSION_RANKER
			l_original_ranking: DS_ARRAYED_LIST [TUPLE [INTEGER_32, EPA_EXPRESSION, REAL_32]]
		do
--			-- Collect trace of the whole test case execution.	
--			create l_cross_feature_trace_collector.make (config)
--			l_cross_feature_trace_collector.set_feature_as_monitor_activator ("EQA_SERIALIZED_TEST_SET", "setup_before_test")
--			l_cross_feature_trace_collector.set_feature_as_monitor_deactivator ("EQA_SERIALIZED_TEST_SET", "cleanup_after_test")
--			l_cross_feature_trace_collector.collect_trace
--			Result := l_cross_feature_trace_collector.trace_repository

			-- Collect trace of the recipient feature.
			create l_intra_feature_trace_collector.make (config)
			l_intra_feature_trace_collector.collect_trace
			l_trace_repository := l_intra_feature_trace_collector.trace_repository
			l_exception_spot := l_intra_feature_trace_collector.exception_spot

			create l_extended_expression_ranker.make (config)
			l_extended_expression_ranker.set_trace_repository (l_intra_feature_trace_collector.trace_repository)
			l_extended_expression_ranker.compute_ranking

			create l_original_expression_ranker.make (config)
			l_original_expression_ranker.set_extended_expression_ranking (l_extended_expression_ranker.ranking)
			l_original_expression_ranker.set_exception_spot (l_exception_spot)
			l_original_expression_ranker.compute_ranking
			l_original_ranking := l_original_expression_ranker.ranking
			Result := l_original_ranking
		end

--	collect_execution_trace: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
--			-- Collect execution trace.
--		local
--			l_intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
--			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--			l_app_exit_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--			l_new_tc_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
--			l_expression_set: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--		do
--			create l_intra_feature_trace_collector.make (config)

--			-- Initialize debugger.
--			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
--			remove_breakpoint (debugger_manager, Test_case_super_class)

--			-- Register debugger event listener.
--			l_app_stop_agent := agent l_intra_feature_trace_collector.on_application_stopped
--			l_app_exit_agent := agent l_intra_feature_trace_collector.on_application_exit
--			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exit_agent)

--			-- Collect basic information about a test case at its beginning.
--			create l_new_tc_bp_manager.make (Test_case_super_class, Test_case_setup_feature)
--			l_new_tc_bp_manager.set_breakpoint_with_expression_and_action (1, l_intra_feature_trace_collector.test_case_info_skeleton, agent l_intra_feature_trace_collector.on_test_case_setup)
--			l_new_tc_bp_manager.toggle_breakpoints (True)

--			-- Start debugging the application.
--			start_debugger (debugger_manager, "--analyze-tc " + config.interpreter_log_path + " false", config.working_directory, {EXEC_MODES}.Run, False)

--			-- Unregister debugger event listener.
--			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exit_agent)

--			-- Clean up debugger.
--			remove_breakpoint (debugger_manager, l_class)
--			remove_debugger_session
--		end

feature{NONE} -- Implementation

--	current_test_execution_mode: INTEGER
--			-- Execution mode of current test.

--	test_case_super_class: CLASS_C
--			-- Super class of all test case classes.
--		do
--			if test_case_super_class_cache = Void then
--				test_case_super_class_cache := first_class_starts_with_name (once "EQA_SERIALIZED_TEST_SET")
--			end
--			Result := test_case_super_class_cache
--		ensure
--			result_attached: Result /= Void
--		end

--	test_case_super_class_cache: like test_case_super_class
--			-- Internal cache for `test_case_super_class'.

--	test_case_setup_feature: FEATURE_I
--			-- Feature for setting up the test cases.
--		do
--			if test_case_setup_feature_cache = Void then
--				test_case_setup_feature_cache := test_case_super_class.feature_named (once "setup_before_test")
--			end

--			Result := test_case_setup_feature_cache
--		ensure
--			result_attached: Result /= Void
--		end

--	test_case_setup_feature_cache: like test_case_setup_feature
--			-- Internal cache for `test_case_setup_feature'.

--	debug_project
--			-- Debug current project to retrieve system states from test cases.
--		local
--			l_tc_super_class: CLASS_C
--			l_tc_setup_feature: FEATURE_I
--			l_new_tc_bp_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
--			l_mark_tc_feat: FEATURE_I
--			l_tc_info_skeleton: AFX_STATE_SKELETON
--			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--			l_app_exited_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
--		do
--			-- Initialize debugger.
--			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
----			remove_breakpoint (debugger_manager, root_class)
----			remove_breakpoint (debugger_manager, test_case_super_class)

--			-- Register debugger event listener.
--			l_app_stop_agent := agent on_application_stopped
--			l_app_exited_agent := agent on_application_exited
--			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exited_agent)

----			-- Setup breakpoint location before exercising a test case.
----			create l_new_tc_bp_manager.make (test_case_super_class, test_case_setup_feature)
----			l_new_tc_bp_manager.set_breakpoint_with_expression_and_action (1, test_case_info_skeleton, agent on_test_case_setup)
----			l_new_tc_bp_manager.toggle_breakpoints (True)

--			-- Start debugging the application step-by-step.
--			start_debugger (debugger_manager, "--analyze-tc " + config.interpreter_log_path + " false", config.working_directory, {EXEC_MODES}.Step_into, False)

--			-- Unregister debugger event listener.
--			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
--			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exited_agent)

--			-- Clean up debugger.
----			remove_breakpoint (debugger_manager, root_class)
----			remove_breakpoint (debugger_manager, test_case_super_class)
--			remove_debugger_session
--		end

--	test_case_info_skeleton_cache: like test_case_info_skeleton
--			-- Internal cache for `test_case_info_skeleton_cache'.

--	test_case_info_skeleton: DS_HASH_SET [EPA_EXPRESSION]
--			-- State skeleton of test case information.
--		local
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--			l_expr: EPA_AST_EXPRESSION
--			l_expr_set: like test_case_info_skeleton
--		do
--			if test_case_info_skeleton_cache = Void then
--				create l_expr_set.make_equal (14)
----				l_expr_set.set_equality_tester (Expression_equality_tester)

--				l_class := test_case_super_class
--				l_feature := test_case_setup_feature

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

--	on_test_case_setup (a_breakpoint: BREAKPOINT; a_test_case_info: EPA_STATE)
--			-- Action to be performed when a new test case has been setup.
--		local
--			l_class_under_test: CLASS_C
--			l_execution_mode: INTEGER
--			l_feature_under_test: FEATURE_I
--			l_recipient_class_name, l_recipient_feature_name: STRING
--			l_recipient_class: CLASS_C
--			l_recipient: FEATURE_I
--			l_exception_code: INTEGER
--			l_bpslot: INTEGER
--			l_tag: STRING
--			l_passing: BOOLEAN
--			l_table: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
--			l_spot: AFX_EXCEPTION_SPOT
--			l_uuid: STRING
--			l_trace: STRING
--			l_strategy: AFX_STATE_MONITORING_STRATEGY
--			l_start_index, l_end_index: INTEGER
--		do
--			l_table := a_test_case_info.to_hash_table

--			l_class_under_test := first_class_starts_with_name (l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_class_under_test).out)
--			l_execution_mode := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_execution_mode).out.to_integer
--			l_feature_under_test := l_class_under_test.feature_named (l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_feature_under_test).out)
--			l_recipient_class_name := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient_class).out
--			l_recipient_feature_name := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_recipient).out
--			l_recipient_class := first_class_starts_with_name (l_recipient_class_name)
--			l_recipient := l_recipient_class.feature_named (l_recipient_feature_name)
--			l_exception_code := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_code).out.to_integer
--			l_bpslot := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_breakpoint_index).out.to_integer
--			l_tag := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_assertion_tag).out
--			l_passing := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_is_passing).out.to_boolean
--			l_uuid := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_class_uuid).out
--			l_trace := l_table.item ({EQA_SERIALIZED_TEST_SET}.Txt_tci_exception_trace).out

--			current_test_execution_mode := l_execution_mode
----			set_is_current_test_case_dry_run (l_table.item (expr_a_dry_run).out.to_boolean)

--			if not l_passing then
--				-- Failing test cases are executed before passing ones.
--				create current_test_case_info.make (l_class_under_test.name, l_feature_under_test.feature_name, l_recipient_class_name, l_recipient_feature_name, l_exception_code, l_bpslot, l_tag, l_passing, l_uuid)
--			else
--				check not exception_spots.is_empty end
--				exception_spots.start
--				current_test_case_info := exception_spots.item_for_iteration.test_case_info.deep_twin
--				current_test_case_info.set_is_passing (True)
--				current_test_case_info.set_uuid (l_uuid)
--			end

--			if current_test_execution_mode = Mode_execute then
--				-- Remove break points possibly set before.
--				remove_breakpoint (debugger_manager, current_test_case_info.recipient_written_class)
--			else
--				l_spot := exception_spots.item (current_test_case_info.id)

--				event_actions.notify_on_new_test_case_found (current_test_case_info)
--				test_case_start_actions.call ([current_test_case_info])

--				-- Dispose previous breakpoint manager, as well as its breakpoints.
--				if current_test_case_breakpoint_manager /= Void then
--					current_test_case_breakpoint_manager.toggle_breakpoints (False)
--					remove_breakpoint (debugger_manager, current_test_case_breakpoint_manager.class_)
--				end

--				-- Create a new breakpoint manager to manage breakpoints and expressions,
--				l_recipient_class := current_test_case_info.recipient_written_class
--				l_recipient := current_test_case_info.origin_recipient
--				create current_test_case_breakpoint_manager.make (l_recipient_class, l_recipient)

--				-- Using appropriate monitoring strategy specified by the config.
--				if config.is_monitoring_breakpointwise then
--					create {AFX_BREAKPOINT_SPECIFIC_STATE_MONITORING} l_strategy
--				else
--					create {AFX_FEATURE_WISE_STATE_MONITORING} l_strategy
--				end

--				-- Register breakpoint slot monitors.
--				l_start_index := l_spot.recipient_ast_structure.first_breakpoint_slot_number
--				l_end_index := l_spot.recipient_ast_structure.last_breakpoint_slot_number
--				l_strategy.set_up_monitoring (current_test_case_breakpoint_manager, l_spot.skeleton, [l_start_index, l_end_index], agent on_breakpoint_hit_in_test_case)
--				current_test_case_breakpoint_manager.toggle_breakpoints (True)

----				current_test_case_breakpoint_manager.set_all_breakpoints_with_expression_and_actions (l_spot.skeleton, agent on_breakpoint_hit_in_test_case)
----				check debugger_manager.breakpoints_manager.is_breakpoint_enabled (l_recipient.e_feature, 1) end
--			end
--		end

--	on_application_stopped (a_dm: DEBUGGER_MANAGER)
--			-- Action to be performed when application is stopped in the debugger
--		do
--			if a_dm.application_is_executing or a_dm.application_is_stopped then
--				if a_dm.application_status.reason_is_catcall then
--					a_dm.controller.resume_workbench_application
--				elseif a_dm.application_status.reason_is_overflow then
--					a_dm.application.kill
--				else
--					if a_dm.application_status.exception_occurred and then current_test_execution_mode = Mode_execute then
--						static_exception_analysis
--					end
--					a_dm.controller.resume_workbench_application
--				end
--			end
--		end


--	static_exception_analysis
--			-- Analyze exception statically.
--			--
--			-- Static analysis happens only once.
--			-- One failing test case is executed first to reproduce the failure, and static analysis aims at finding out
--			--		where to set breakpoints, which expressions to monitor, and what else information to collect.
--			-- After the static analysis, all the test cases, including the already executed failing one, are executed and
--			-- 		monitored to collect relevant information.
--		local
----			l_stack_level: INTEGER
----			l_old_stack_level: INTEGER
----			l_app: APPLICATION_EXECUTION
----			l_value: DUMP_VALUE
----			l_stack_ele: CALL_STACK_ELEMENT
----			l_spot_analyzer: AFX_EXCEPTION_SPOT_ANALYZER

----			l_spot: AFX_EXCEPTION_SPOT
----			l_nested_expression_generator: EPA_NESTED_EXPRESSION_GENERATOR

--			l_recipient_id: STRING
--			l_static_analyzer: AFX_EXCEPTION_STATIC_ANALYZER
--		do
--				-- Generate state model for current test case.
--			l_recipient_id := current_test_case_info.id
--			if not exception_spots.has (l_recipient_id) then
--				create l_static_analyzer.make (config)
--				l_static_analyzer.analyze_exception (current_test_case_info, debugger_manager.application_status.exception_text)
--				exception_spots.put (l_static_analyzer.last_spot, l_recipient_id)

----				create l_spot.make (current_test_case_info)
----				exception_spots.put (l_spot, l_recipient_id)

----				collect_relevant_expressions (current_test_case_info.recipient_written_class)
----				create l_spot_analyzer.make (config)
----				l_spot_analyzer.analyze (current_test_case_info, debugger_manager)
----				exception_spots.put (l_spot_analyzer.last_spot, l_recipient_id)
--			end
--		end

--	collect_relevant_expressions (a_class: CLASS_C)
--			-- Collect expressions relevant to the exception recipient.
--		local
--			l_finder: EPA_ALL_EXPRESSION_FINDER
--			l_rep: EPA_HASH_SET [EPA_EXPRESSION]
--		do
--			check unique_exception_spot: exception_spots.count = 1 end
--			exception_spots.start

--			create l_rep.make (5)
--			l_rep.set_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})

--			create l_finder.make (a_class)
--			l_finder.search (l_rep)
--			l_rep := l_finder.last_found_expressions
--		end

	generate_fixes
			-- <Precursor>
		local
			l_gen: AFX_RANDOM_BASED_FIX_GENERATOR
		do
			create fixes.make
			check unique_exception_spot: exception_spots.count = 1 end
			exception_spots.start
			create l_gen.make (exception_spots.item_for_iteration, config, test_case_execution_status.status)
			l_gen.generate
			fixes.append (l_gen.fixes)
		end

end
