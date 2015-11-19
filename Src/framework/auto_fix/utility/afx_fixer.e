note
	description: "Summary description for {AFX_FIXER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXER

inherit

	SHARED_WORKBENCH

	SHARED_DEBUGGER_MANAGER

	EPA_SHARED_CLASS_THEORY

	EPA_DEBUGGER_UTILITY

	AFX_SHARED_STATE_SERVER

	SHARED_EIFFEL_PARSER

	AFX_UTILITY

	EPA_COMPILATION_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_EXECUTION_MODE

	SHARED_SERVER

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	AFX_SHARED_SESSION

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_FIX_TO_FAULT]
			-- Fixes generated.

	features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			--

feature -- Basic operation

	execute
			--
		local
			l_traces_before_fixing, l_traces_before_fixing_twin, l_traces_after_relaxing, l_traces_for_validation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_index: INTEGER
			l_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT]
			l_code_fixes, l_valid_code_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_feature_to_relax: AFX_FEATURE_TO_MONITOR
			l_features_to_relax, l_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_exception_code: INTEGER
		do
			disable_catcall_warnings
			create fixes.make_equal (30)

				-- HACK: force re-compiling the root class by "touch"ing it, otherwise expression evaluation might fail.
			(create {PLAIN_TEXT_FILE}.make_with_name (root_class_of_system.file_name)).touch
			compile_project (eiffel_project, True)

			session.initialize_logging
			session.start
			event_actions.notify_on_session_started

			reproduce_failure

				-- Replace recipient feature with 'session.exception_from_execution.recipient_feature_with_context',
				-- because the latter have extra expressions to monitor during trace collection.
			from
				l_features_to_monitor := features_to_monitor
				l_features_to_monitor.start
			until
				l_features_to_monitor.after
			loop
				if l_features_to_monitor.item_for_iteration.qualified_feature_name ~ session.exception_from_execution.recipient_feature_with_context.qualified_feature_name then
					l_features_to_monitor.item_for_iteration.add_extra_expressions (session.exception_from_execution.recipient_feature_with_context.extra_expressions)
				end
				l_features_to_monitor.forth
			end

			l_traces_before_fixing := collect_behavior_of_regular_tests
			l_traces_before_fixing_twin := l_traces_before_fixing.twin

			if not config.is_fixing_implementation then
				l_fixing_targets := localize_faulty_targets (l_traces_before_fixing)
				if config.should_log_for_debugging then
						-- Log at most the first 100 fixing targets.
					event_actions.notify_on_supplemental_notification_issued ("LOGGING FIXING TARGETS")
					from
						l_fixing_targets.start
						l_index := 0
					until
						l_index >= 100 or l_fixing_targets.after
					loop
						event_actions.notify_on_supplemental_notification_issued (l_fixing_targets.item_for_iteration.debug_output)
						l_fixing_targets.forth
						l_index := l_index + 1
					end
				end

				l_code_fixes := generate_implementation_fixes (l_fixing_targets)
				if config.should_log_for_debugging then
					event_actions.notify_on_supplemental_notification_issued ("LOGGING ALL CODE FIXES")
					from l_code_fixes.start
					until
						l_code_fixes.after
					loop
						event_actions.notify_on_supplemental_notification_issued (l_code_fixes.item_for_iteration.out)
						l_code_fixes.forth
					end
				end

				l_valid_code_fixes := validate_implementation_fixes (l_traces_before_fixing, l_code_fixes)
				if config.should_log_for_debugging then
					event_actions.notify_on_supplemental_notification_issued ("LOGGING VALID CODE FIXES")
					from l_valid_code_fixes.start
					until
						l_valid_code_fixes.after
					loop
						event_actions.notify_on_supplemental_notification_issued (l_valid_code_fixes.item_for_iteration.out)
						l_valid_code_fixes.forth
					end
				end

				fixes.append_last (l_valid_code_fixes)
			end

			l_exception_code := session.exception_from_execution.exception_code
			if config.is_fixing_contract and then (l_exception_code = 3 or l_exception_code = 4) then
				create l_feature_to_relax.make_from_feature_with_context_class (session.exception_from_execution.exception_feature_with_context)
				l_feature_to_relax.set_monitor_contracts (True)
				l_feature_to_relax.set_monitor_body (False)
				l_traces_after_relaxing := collect_behavior_of_relaxed_tests (l_feature_to_relax)

				l_contract_fixes := generate_contract_fixes (l_traces_before_fixing_twin, l_traces_after_relaxing)
				if config.should_log_for_debugging then
					event_actions.notify_on_supplemental_notification_issued ("LOGGING CONTRACT FIXES")
					from l_contract_fixes.start
					until
						l_contract_fixes.after
					loop
						event_actions.notify_on_supplemental_notification_issued (l_contract_fixes.item_for_iteration.out)
						l_contract_fixes.forth
					end
				end
				validate_contract_fixes (l_contract_fixes)
				sort_contract_fixes (l_contract_fixes)
				fixes.append_last (l_contract_fixes)
			end

			rank_fixes
			event_actions.notify_on_session_terminated
			session.clean_up

		end

feature{NONE} -- Implementation

	reproduce_failure
			--
		local
			l_reproducer: AFX_FAILURE_REPRODUCER
		do
			create l_reproducer
			l_reproducer.reproduce (False)
			features_to_monitor := l_reproducer.features_to_monitor
		end

	collect_behavior_of_regular_tests: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			--
		local
			l_collector: AFX_TRACE_COLLECTOR
		do
			event_actions.notify_on_test_case_analysis_started (session.number_of_test_cases_for_fixing)

			create l_collector
			l_collector.set_monitor_mode (l_collector.mode_analyze_tc)
			l_collector.set_features_to_monitor (features_to_monitor)
			l_collector.collect (config.is_fixing_contract)
			Result := l_collector.trace_repository.derived_compound_repository (features_to_monitor, True)

			event_actions.notify_on_test_case_analysis_finished
		end

	localize_faulty_targets (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY): DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- Compute suspiciousness values of fixing targets.
		local
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_feature_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FEATURE_TO_MONITOR]
			l_feature: AFX_FEATURE_TO_MONITOR
			l_bpt_interval: INTEGER_INTERVAL
			l_bpts: DS_HASH_SET [INTEGER]

			l_recipient: AFX_FEATURE_TO_MONITOR
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
		do
			if session.should_continue then
				progression_monitor.set_progression (progression_monitor.progression_fault_localization_start)
				event_actions.notify_on_implementation_fix_generation_started

				create l_trace_analyzer
				from
					l_recipient := session.exception_from_execution.recipient_feature_with_context
					l_feature_cursor := features_to_monitor.new_cursor
					l_feature_cursor.start
				until
					l_feature_cursor.after
				loop
					l_feature := l_feature_cursor.item

					if l_recipient.is_about_same_feature (l_feature) then
						l_bpt_interval := l_feature.first_breakpoint_in_body |..| l_feature.last_breakpoint_in_body
						create l_bpts.make_equal (l_bpt_interval.count)
						l_bpt_interval.do_all (agent l_bpts.force)
						l_trace_analyzer.add_breakpoints_for_feature (l_bpts, l_feature)
					end

					l_feature_cursor.forth
				end

				l_trace_analyzer.collect_statistics_from_trace_repository (a_trace_repository, {AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

				create l_ranker.make (session.exception_from_execution)
				l_ranker.compute_ranks (l_trace_analyzer.statistics_from_passing, l_trace_analyzer.statistics_from_failing)
				Result := l_ranker.fixing_target_list

				progression_monitor.set_progression (progression_monitor.progression_fault_localization_end)
			else
				Result := Void
			end
		end

	generate_implementation_fixes (a_fixing_target_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- <Precursor>
		local
			l_generator: AFX_RANDOM_BASED_FIX_GENERATOR
			l_fix_texts: DS_HASH_SET [STRING]
			l_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_text: STRING
		do
			create Result.make_equal (1)
			if session.should_continue then
				progression_monitor.set_progression (progression_monitor.progression_fix_generation_start)

					-- Generation
				create l_generator
				l_generator.set_fixing_target_list (a_fixing_target_list)
				l_generator.generate

				Result := l_generator.fixes

				event_actions.notify_on_implementation_fix_generation_finished (Result)
				progression_monitor.set_progression (progression_monitor.progression_fix_generation_end)
			end
		end

	validate_implementation_fixes (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; l_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
		local
			l_validator: AFX_FIX_VALIDATOR_NEW
		do
			create Result.make_equal (1)
			if session.should_continue then
				create l_validator.make (a_trace_repository, l_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_start)
				event_actions.notify_on_implementation_fix_validation_started (l_validator.fixes)

				l_validator.validate
				Result := l_validator.valid_fixes

				event_actions.notify_on_implementation_fix_validation_finished (l_validator.valid_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_end)
			end
		end

	collect_behavior_of_relaxed_tests (a_feature_to_relax: AFX_FEATURE_TO_MONITOR): AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			--
		local
			l_features: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
			l_feature_contract_remover: EPA_FEATURE_CONTRACT_REMOVER
			l_collector: AFX_TRACE_COLLECTOR
		do
			event_actions.notify_on_weakest_contract_inference_started (a_feature_to_relax)

				-- Relax feature contracts
			create l_features.make_equal (1)
			l_features.force (a_feature_to_relax)
			create l_feature_table.make_equal (2)
			l_feature_table.force (l_features, True)
			l_feature_table.force (l_features.twin, False)
			create l_feature_contract_remover
			l_feature_contract_remover.remove_contracts_of_features (l_feature_table)
			compile_project (Eiffel_project, True)

				-- Monitor behavior of feature with relaxed contracts
			create l_features_to_monitor.make_equal (1)
			l_features_to_monitor.force_last (a_feature_to_relax)
			create l_collector
			l_collector.set_monitor_mode (l_collector.mode_analyze_relaxed_tc)
			l_collector.set_features_to_monitor (l_features_to_monitor)
			l_collector.collect (True)
			if l_collector.trace_repository /= Void then
				Result := l_collector.trace_repository.derived_compound_repository (l_features_to_monitor, True)
			else
				create Result.make_default
			end
			l_feature_contract_remover.undo_last_removal
			compile_project (Eiffel_project, True)

			event_actions.notify_on_weakest_contract_inference_finished (a_feature_to_relax)
		end

	generate_contract_fixes (a_traces_before_fixing, a_traces_after_relaxing: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY): DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT]
			--
		local
			l_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_strengthener: AFX_TRACE_BASED_CONTRACT_STRENGTHENER
			l_weakener: AFX_TRACE_BASED_CONTRACT_WEAKENER
			l_regular_traces, l_relaxed_traces, l_failing_regular_traces, l_passing_regular_traces, l_all_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]

			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
			l_new_fix: AFX_CONTRACT_FIX_TO_FAULT
		do
			create Result.make_equal (64)
			if session.should_continue then
				event_actions.notify_on_contract_fix_generation_started

				create l_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				a_traces_before_fixing.do_all (agent l_regular_traces.force_last)
				create l_relaxed_traces.make_equal (a_traces_after_relaxing.count + 1)
				a_traces_after_relaxing.do_all (agent l_relaxed_traces.force_last)
				create l_passing_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				l_regular_traces.do_if (agent l_passing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_passing)
				create l_failing_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				l_regular_traces.do_if (agent l_failing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_failing)
				create l_all_traces.make_equal (l_regular_traces.count + l_relaxed_traces.count + 1)
				l_regular_traces.do_all (agent l_all_traces.force_last)
				l_relaxed_traces.do_all (agent l_all_traces.force_last)

					-- Prefer weakening
				create l_weakener
				l_weakener.fix_traces (l_regular_traces, l_relaxed_traces, features_to_monitor)
				Result.append_last (l_weakener.last_contract_fixes)

				create l_strengthener
				l_strengthener.fix_traces (l_passing_regular_traces, l_failing_regular_traces, l_relaxed_traces, features_to_monitor)
				Result.append_last (l_strengthener.last_contract_fixes)

				event_actions.notify_on_contract_fix_generation_finished (Result)
			end
		end

	validate_contract_fixes (a_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			--
		local
			l_features_to_weaken: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
			l_fix_validator: AFX_TEST_CASE_MONITOR_FOR_FIX_VALIDATION
			l_collector: AFX_TRACE_COLLECTOR
			l_trace_for_validation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_TO_FAULT]
			l_feature_contract_remover: EPA_FEATURE_CONTRACT_REMOVER
			l_index: INTEGER
		do
			if session.should_continue then
				event_actions.notify_on_contract_fix_validation_started (a_contract_fixes)

					-- Disable the preconditions of `features_to_monitor'.
				create l_features_to_weaken.make_equal (10)
				features_to_monitor.do_all (agent l_features_to_weaken.force_last)
				create l_feature_table.make_equal (2)
				l_feature_table.force (l_features_to_weaken, True)
				create l_feature_contract_remover
				l_feature_contract_remover.remove_contracts_of_features (l_feature_table)
				compile_project (Eiffel_project, True)

					-- Run all available tests and collect the traces.
				create l_collector
				l_collector.set_monitor_mode (l_collector.mode_analyze_all_tc)
				l_collector.set_features_to_monitor (features_to_monitor)
				l_collector.collect (True)
				l_trace_for_validation := l_collector.trace_repository.derived_compound_repository (features_to_monitor, True)

					-- Restore the preconditions.
				l_feature_contract_remover.undo_last_removal
				compile_project (Eiffel_project, True)

					-- Validate fixes w.r.t. the observed traces.
				a_contract_fixes.do_all (
						agent (a_fix: AFX_CONTRACT_FIX_TO_FAULT; a_traces: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_all_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR])
							do a_fix.compute_ranking_wrt_trace_repository (a_traces, a_all_features_to_monitor) end (?, l_trace_for_validation, features_to_monitor))

					-- Remove invalid fixes, keep at most config.max_valid_fix_number valid fixes.
				from
					l_cursor := a_contract_fixes.new_cursor
					l_cursor.start
					l_index := 0
				until
					l_cursor.after
				loop
					if l_cursor.item.ranking >= {AFX_CONTRACT_FIX_TO_FAULT}.Ranking_weight_for_failing or l_index >= session.config.max_valid_fix_number.to_integer_32 then
						a_contract_fixes.remove_at_cursor (l_cursor)
					else
						l_cursor.forth
						l_index := l_index + 1
					end
				end

				event_actions.notify_on_contract_fix_validation_finished (a_contract_fixes)
			end
		end

	sort_contract_fixes (a_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			--
		local
			l_sorter: DS_QUICK_SORTER [AFX_CONTRACT_FIX_TO_FAULT]
		do
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [AFX_CONTRACT_FIX_TO_FAULT]}.make (
					agent (f1, f2: AFX_CONTRACT_FIX_TO_FAULT): BOOLEAN
						do
							Result := f1.ranking <= f2.ranking
						end (?, ?)))
			l_sorter.sort (a_contract_fixes)
		end

	rank_fixes
			--
		local
		do
			event_actions.notify_on_fix_ranking_started (fixes)


			event_actions.notify_on_fix_ranking_finished (fixes)
		end

	disable_catcall_warnings
			-- Disable catcall console and debugger warnings.
		external
			"C inline"
		alias
			"[
							extern int catcall_detection_mode;
							catcall_detection_mode = 0;
			]"
		end

end
