note
	description: "Summary description for {AFX_CONTRACT_FIXER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTRACT_FIXER

inherit

	SHARED_WORKBENCH

	SHARED_DEBUGGER_MANAGER

	EPA_SHARED_CLASS_THEORY

	EPA_DEBUGGER_UTILITY

	AFX_SHARED_STATE_SERVER

	SHARED_EIFFEL_PARSER

	AFX_UTILITY

	EPA_COMPILATION_UTILITY

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_EXECUTION_MODE

	SHARED_SERVER

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		local
			l: AFX_INTERPRETER
		do
			create test_case_start_actions
			create test_case_breakpoint_hit_actions
			create application_exited_actions
		end

feature -- Access

	test_case_start_actions: ACTION_SEQUENCE[TUPLE [EPA_TEST_CASE_SIGNATURE]]
			-- Actions to be performed when a test case is to be analyzed.
			-- The information about the test case is passed as the argument to the agent.

	test_case_breakpoint_hit_actions: ACTION_SEQUENCE [TUPLE [a_tc: EPA_TEST_CASE_SIGNATURE; a_state: EPA_STATE; a_bpslot: INTEGER]]
			-- Actions to be performed when a breakpoint is hit in a test case.
			-- `a_tc' is the test case currently analyzed.
			-- `a_state' is the state evaluated at the breakpoint.
			-- `a_bpslot' is the breakpoint slot number.

	application_exited_actions: ACTION_SEQUENCE [TUPLE [DEBUGGER_MANAGER]]
			-- Actions to be performed when application exited in debugger


feature -- Basic operation

	execute
		local
			l_file: PLAIN_TEXT_FILE
		do
			session.initialize_logging
			session.start
			create l_file.make_with_name (root_class_of_system.file_name)
			l_file.touch
			compile_project (Eiffel_project, True)

			event_actions.notify_on_session_starts
			event_actions.notify_on_test_case_analysis_starts

			execute_test_cases
			trace_repository_from_test_cases := build_derived_traces (trace_repository_from_test_cases, contract_skeletons_for_features, True, True)
			save_trace_repository_to_file(trace_repository_from_test_cases, "trace_repository_from_test_cases")

			execute_relaxed_test_cases
			trace_repository_from_relaxed_test_cases := build_derived_traces (trace_repository_from_relaxed_test_cases, contract_skeletons_for_features, True, True)
			save_trace_repository_to_file(trace_repository_from_relaxed_test_cases, "trace_repository_from_relaxed_test_cases")

			event_actions.notify_on_test_case_analysis_ends

			event_actions.notify_on_fix_generation_starts
			generate_fix_suggestions
			event_actions.notify_on_contract_fixes_generation_ends (fixes_to_contracts)

			fixes_to_contracts_as_fixes_in_ast_expressions
			validate_fixes
			trace_repository_for_fix_validation := build_derived_traces (trace_repository_for_fix_validation, contract_skeletons_for_features, False, False)
			save_trace_repository_to_file(trace_repository_for_fix_validation, "trace_repository_for_fix_validation")

			rank_fixes			-- (fix_texts_to_new_contracts)
			sort_fixes_to_contracts
			event_actions.notify_on_contract_fixes_validation_ends (fixes_to_contracts)
			event_actions.notify_on_session_ends
			event_actions.notify_on_report_generation_starts
			event_actions.notify_on_report_generation_ends
			session.clean_up

		end

	fixes_to_contracts_as_fixes_in_ast_expressions
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_new_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
		do
			create l_new_fixes.make_equal (fixes_to_contracts.count + 1)
			from
				l_cursor := fixes_to_contracts.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_new_fixes.force_last (l_cursor.item.as_fix_in_ast_expressions)
				l_cursor.forth
			end
			fixes_to_contracts := l_new_fixes
		end

	fix_texts_to_new_contracts: DS_HASH_TABLE [DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], EPA_FEATURE_WITH_CONTEXT_CLASS], STRING]
			--
		local
			l_feature_contracts: DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_fixes_to_contracts: like fixes_to_contracts
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
			l_fix_text: STRING
			l_feature_fix_cursor: DS_HASH_TABLE_CURSOR [TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE], AFX_FEATURE_TO_MONITOR]
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_fix_pre, l_fix_post: AFX_CONTRACT_FIX_PER_FEATURE
			l_new_contracts_from_fix: DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], EPA_FEATURE_WITH_CONTEXT_CLASS]
			l_origin_contract_pre, l_origin_contract_post, l_new_contract_pre, l_new_contract_post: EPA_HASH_SET [EPA_AST_EXPRESSION]
		do
			l_fixes_to_contracts := fixes_to_contracts
			create Result.make_equal (l_fixes_to_contracts.count + 1)
			if not l_fixes_to_contracts.is_empty then
				l_feature_contracts := test_case_monitor.feature_contracts
				from
					l_fix_cursor := l_fixes_to_contracts.new_cursor
					l_fix_cursor.start
				until
					l_fix_cursor.after
				loop
					l_fix := l_fix_cursor.item
					l_fix_text := l_fix.debug_output
					create l_new_contracts_from_fix.make_equal (10)
					from
						l_feature_fix_cursor := l_fix.new_cursor
						l_feature_fix_cursor.start
					until
						l_feature_fix_cursor.after
					loop
						l_feature_to_monitor := l_feature_fix_cursor.key
						l_fix_pre := l_feature_fix_cursor.item.pre
						l_fix_post:= l_feature_fix_cursor.item.post

						if l_feature_contracts.has (l_feature_to_monitor) then
							l_new_contract_pre := l_feature_contracts.item (l_feature_to_monitor).pre.twin
							l_new_contract_post:= l_feature_contracts.item (l_feature_to_monitor).post.twin
						else
							create l_new_contract_pre.make_equal (5)
							create l_new_contract_post.make_equal (5)
						end
						if l_fix_pre /= Void then
							l_new_contract_pre.subtract (l_fix_pre.clauses_to_remove)
							l_new_contract_pre.merge (l_fix_pre.clauses_to_add)
						end
						if l_fix_post /= Void then
							l_new_contract_post.subtract (l_fix_post.clauses_to_remove)
							l_new_contract_post.merge (l_fix_post.clauses_to_add)
						end

						l_new_contracts_from_fix.force ([l_new_contract_pre, l_new_contract_post], l_feature_to_monitor)

						l_feature_fix_cursor.forth
					end

					Result.force (l_new_contracts_from_fix, l_fix_text)

					l_fix_cursor.forth
				end
			end
		end

	rank_fixes -- (a_fix_texts_to_new_contracts: DS_HASH_TABLE [DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], EPA_FEATURE_WITH_CONTEXT_CLASS], STRING])
			--
		local
			l_fix_texts_to_new_contracts: DS_HASH_TABLE [DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], EPA_FEATURE_WITH_CONTEXT_CLASS], STRING]
			l_fixes_to_contracts: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_texts_to_fixes: DS_HASH_TABLE [AFX_CONTRACT_FIX_ACROSS_FEATURES, STRING]
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
		do
			l_fixes_to_contracts := fixes_to_contracts
			create l_texts_to_fixes.make_equal (l_fixes_to_contracts.count + 1)
			if not l_fixes_to_contracts.is_empty then
				l_fix_texts_to_new_contracts := fix_texts_to_new_contracts
				from
					l_fix_cursor := l_fixes_to_contracts.new_cursor
					l_fix_cursor.start
				until
					l_fix_cursor.after
				loop
					l_texts_to_fixes.force (l_fix_cursor.item, l_fix_cursor.item.out)
					l_fix_cursor.forth
				end

				from
					l_fix_cursor := l_fixes_to_contracts.new_cursor
					l_fix_cursor.start
				until
					l_fix_cursor.after
				loop
					l_fix := l_fix_cursor.item
					rank_a_fix (l_fix, l_fix_texts_to_new_contracts.item (l_fix.out))
					l_fix_cursor.forth
				end

			end
		end

	true_expression_texts_from_state (a_state: EPA_STATE): EPA_HASH_SET [STRING]
		local
			l_aspect: EPA_AST_EXPRESSION
			l_exp: EPA_AST_EXPRESSION
		do
			create Result.make_equal (a_state.count)
			from
				a_state.start
			until
				a_state.after
			loop
				if a_state.item_for_iteration.value.is_true_boolean then
					Result.force (a_state.item_for_iteration.expression.text)
				end
				a_state.forth
			end
		end

	rank_a_fix (a_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES; a_contract_from_fix: DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], EPA_FEATURE_WITH_CONTEXT_CLASS])
			--
		local
			l_traces_for_validation, l_traces_from_fixing: like trace_repository_for_fix_validation
			l_passing_tests: DS_HASH_SET [EPA_TEST_CASE_INFO]
			l_trace_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_execution_state: AFX_PROGRAM_EXECUTION_STATE
			l_location: AFX_PROGRAM_LOCATION
			l_location_context: AFX_FEATURE_TO_MONITOR
			l_feature_under_test: like feature_under_test
			l_pre, l_post, l_contract, l_true_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_true_expression_texts, l_contract_texts: EPA_HASH_SET [STRING]
			l_is_failing, l_is_invalid: BOOLEAN
			l_nbr_failing, l_nbr_invalid: INTEGER
		do
			l_feature_under_test := feature_under_test
			l_traces_for_validation := trace_repository_for_fix_validation
			l_traces_from_fixing := trace_repository_from_test_cases
			l_nbr_failing := 0
			l_nbr_invalid := 0
			from
				l_trace_cursor := l_traces_for_validation.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item

				from
					l_is_failing := False
					l_is_invalid := False
					l_trace.start
				until
					l_trace.after or else l_is_invalid or else l_is_failing
				loop
					l_execution_state := l_trace.item_for_iteration
					l_location := l_execution_state.location
					create l_location_context.make_from_feature_with_context_class (l_location.context)
					l_true_expression_texts := true_expression_texts_from_state(l_execution_state.state)

					if a_contract_from_fix.has (l_location_context) then
						if l_location.breakpoint_index = 1 then
							l_contract := a_contract_from_fix.item (l_location_context).pre
						else
							l_contract := a_contract_from_fix.item (l_location_context).post
						end
						create l_contract_texts.make_equal (l_contract.count + 1)
						l_contract.do_all (agent (a_exp: EPA_AST_EXPRESSION; a_texts: EPA_HASH_SET [STRING]) do a_texts.force (a_exp.text) end (?, l_contract_texts))
						if not l_contract_texts.subtraction (l_true_expression_texts).is_empty then
							if l_feature_under_test ~ l_location_context and then l_location.breakpoint_index = 1 then
								l_is_invalid := True
								l_nbr_invalid := l_nbr_invalid + 1
							else
								l_is_failing := True
								l_nbr_failing := l_nbr_failing + 1
							end
						end
					end
					l_trace.forth
				end
				l_trace_cursor.forth
			end

			a_fix.set_rank (1000 * l_nbr_failing + l_nbr_invalid)
		end


	validate_fixes
		local
			l_features_to_weaken: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
		do
			reset_report
			initialize_feature_under_test
			create l_features_to_weaken.make_equal (10)
			test_case_monitor.features_on_stack.do_all (agent l_features_to_weaken.force)
			create l_feature_table.make_equal (2)
			l_feature_table.force (l_features_to_weaken, True)
			relax_feature_contracts (l_feature_table)

			fix_validator.set_features_to_monitor (l_features_to_weaken)
			fix_validator.set_contract_expressions_for_features (test_case_monitor.contract_expressions_for_features)
			fix_validator.collect
			trace_repository_for_fix_validation := trace_repository


		end

	execute_test_cases
			-- Analyze the execution of test cases.
		local
			l_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
		do
			reset_report
			test_case_monitor.collect
			trace_repository_from_test_cases := trace_repository
			progression_monitor.set_progression (progression_monitor.progression_test_case_analysis_execution_end)
		end

	execute_relaxed_test_cases
		local
			l_features_to_weaken: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
		do
			reset_report
			initialize_relaxed_feature
			if relaxed_feature /= Void then
				create l_features_to_weaken.make_equal (2)
				l_features_to_weaken.force (relaxed_feature)
				create l_feature_table.make_equal (2)
				l_feature_table.force (l_features_to_weaken, True)
				l_feature_table.force (l_features_to_weaken.twin, False)
				relax_feature_contracts (l_feature_table)

				relaxed_test_case_monitor.set_relaxed_feature (relaxed_feature)
				relaxed_test_case_monitor.set_contract_expressions_for_features (test_case_monitor.contract_expressions_for_features)
				relaxed_test_case_monitor.collect
				trace_repository_from_relaxed_test_cases := trace_repository
			else
				create trace_repository_from_relaxed_test_cases.make (1)
			end
		end

	invariants_from_test_cases: DS_HASH_TABLE [TUPLE[passing, failing: TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]]], AFX_FEATURE_TO_MONITOR]
		do
			if invariants_from_test_cases_cache = Void then
				create invariants_from_test_cases_cache.make_equal (10)
			end
			Result := invariants_from_test_cases_cache
		end

	invariants_from_test_cases_cache: like invariants_from_test_cases

	invariants_from_relaxed_test_cases: DS_HASH_TABLE [TUPLE[passing, failing: TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]]], AFX_FEATURE_TO_MONITOR]
		do
			if invariants_from_relaxed_test_cases_cache = Void then
				create invariants_from_relaxed_test_cases_cache.make_equal (10)
			end
			Result := invariants_from_relaxed_test_cases_cache
		end

	invariants_from_relaxed_test_cases_cache: like invariants_from_relaxed_test_cases

	fixes_to_contracts: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]

	sort_fixes_to_contracts
			--
		local
			l_sorter: DS_QUICK_SORTER [AFX_CONTRACT_FIX_ACROSS_FEATURES]
		do
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [AFX_CONTRACT_FIX_ACROSS_FEATURES]}.make (
					agent (f1, f2: AFX_CONTRACT_FIX_ACROSS_FEATURES): BOOLEAN
						local
							l_set_size1, l_set_size2: INTEGER_32
						do
							Result := f1.rank < f2.rank
						end (?, ?)))
			l_sorter.sort (fixes_to_contracts)
		end

	store_fixes
		local
			l_report_path: PATH
			l_report_file: PLAIN_TEXT_FILE
			l_fix_index: INTEGER
			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
		do
			l_report_path := config.report_file_path
			create l_report_file.make_with_path (l_report_path)
			l_report_file.open_write
			from
				l_fix_index := 1
				fixes_to_contracts.start
			until
				l_fix_index > config.max_fix_candidate or else fixes_to_contracts.after
			loop
				l_fix := fixes_to_contracts.item_for_iteration

				l_report_file.put_string ("=============================================%N")
				l_report_file.put_string (l_fix.out)

				l_fix_index := l_fix_index + 1
				fixes_to_contracts.forth
			end
			l_report_file.close
		end

	generate_fix_suggestions
		local
			l_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_strengthener: AFX_TRACE_BASED_CONTRACT_STRENGTHENER
			l_weakener: AFX_TRACE_BASED_CONTRACT_WEAKENER
			l_regular_traces, l_relaxed_traces, l_failing_regular_traces, l_passing_regular_traces, l_all_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]

			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES

			l_strengthenings, l_weakenings: DS_ARRAYED_LIST [EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]]
		do
			create fixes_to_contracts.make_equal (64)

			create l_regular_traces.make_equal (trace_repository_from_test_cases.count + 1)
			trace_repository_from_test_cases.do_all (agent l_regular_traces.force_last)
			create l_relaxed_traces.make_equal (trace_repository_from_relaxed_test_cases.count + 1)
			trace_repository_from_relaxed_test_cases.do_all (agent l_relaxed_traces.force_last)
			create l_passing_regular_traces.make_equal (trace_repository_from_test_cases.count + 1)
			l_regular_traces.do_if (agent l_passing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_passing)
			create l_failing_regular_traces.make_equal (trace_repository_from_test_cases.count + 1)
			l_regular_traces.do_if (agent l_failing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_failing)
			create l_all_traces.make_equal (l_regular_traces.count + l_relaxed_traces.count + 1)
			l_regular_traces.do_all (agent l_all_traces.force_last)
			l_relaxed_traces.do_all (agent l_all_traces.force_last)

				-- Prefer weakening
			create l_weakener
			l_weakener.fix_traces (l_regular_traces, l_relaxed_traces, test_case_monitor.features_on_stack, test_case_monitor.feature_contracts)
			fixes_to_contracts.append_last (l_weakener.last_contract_fixes)


			create l_strengthener
			l_strengthener.fix_traces (l_passing_regular_traces, l_failing_regular_traces, l_relaxed_traces, test_case_monitor.features_on_stack)
			fixes_to_contracts.append_last (l_strengthener.last_contract_fixes)
		end

	prune_disjunctions_of_true_expressions (a_true_expressions: DS_LIST [EPA_AST_EXPRESSION])
			-- `a_true_expressions' should be ordered by the lengths of expressions.
		local
			l_remaining, l_removing: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_is_redundant: BOOLEAN
		do
			create l_remaining.make_equal (a_true_expressions.count + 1)
			create l_removing.make_equal (a_true_expressions.count + 1)
			from a_true_expressions.start
			until a_true_expressions.after
			loop
				l_is_redundant := False
				if attached {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION} a_true_expressions.item_for_iteration as lt_aspect
						and then lt_aspect.operator = {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else then
					if l_remaining.has (lt_aspect.left_operand) or else l_remaining.has (lt_aspect.right_operand) then
						l_is_redundant := True
					end
				end
				if l_is_redundant then
					a_true_expressions.remove_at
				else
					l_remaining.force (a_true_expressions.item_for_iteration)
					a_true_expressions.forth
				end
			end
		end

	strengthening_revisions: DS_ARRAYED_LIST [EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]]
		local
			l_features_on_stack: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_feature: AFX_FEATURE_TO_MONITOR
			l_signature: AFX_EXCEPTION_SIGNATURE
			l_features_to_extra_contracts_map: DS_HASH_TABLE [DS_ARRAYED_LIST[EPA_AST_EXPRESSION], AFX_FEATURE_TO_MONITOR]
			l_invariants_from_passing, l_invariants_from_failing, l_extra_contracts, l_extra_negated_contracts, l_extra_contracts_for_revision: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_suggestion_index: INTEGER
			l_suggestion: EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]
			l_extra_contracts_list: DS_ARRAYED_LIST[EPA_AST_EXPRESSION]
			l_extra_contract: EPA_AST_EXPRESSION
			l_revision: AFX_CONTRACT_FIX_PER_FEATURE
			l_expressions_in_order: DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
			l_suggestion_count: INTEGER
		do
			create Result.make_equal (10)
			l_features_on_stack := test_case_monitor.features_on_stack.twin
				-- Remove the failing feature is the exception was a precondition violation
			l_signature := session.exception_signature
			if l_signature.is_precondition_violation then
				l_features_on_stack.remove_first
			end

				-- Computer strengthenings to each feature
			create l_features_to_extra_contracts_map.make_equal (l_features_on_stack.count + 1)
			from l_features_on_stack.start
			until l_features_on_stack.after
			loop
				l_feature := l_features_on_stack.item_for_iteration
				l_invariants_from_passing := invariants_for_feature (l_feature, True, True,  True)
				l_invariants_from_failing := invariants_for_feature (l_feature, True, False, True)
				l_extra_contracts := l_invariants_from_passing.subtraction (l_invariants_from_failing)
--				if l_extra_contracts.is_empty then
--						-- If specifying how the states should be doesn't work,
--						-- we specify how the state shouldn't be.
--					l_extra_negated_contracts := l_invariants_from_failing.subtraction (l_invariants_from_passing)
--					create l_extra_contracts.make_equal (l_extra_negated_contracts.count + 1)
--					from l_extra_negated_contracts.start
--					until l_extra_negated_contracts.after
--					loop
--						l_extra_contracts.force (l_extra_negated_contracts.item_for_iteration.negated)
--						l_extra_negated_contracts.forth
--					end
--				end
				l_expressions_in_order := expressions_in_order (l_extra_contracts)
				prune_disjunctions_of_true_expressions (l_expressions_in_order)
				l_features_to_extra_contracts_map.force (l_expressions_in_order, l_feature)
				l_features_on_stack.forth
			end

			from
				l_suggestion_count := 1
				l_features_on_stack.start
			until
				l_features_on_stack.after
			loop
				l_feature := l_features_on_stack.item_for_iteration
				l_extra_contracts_list := l_features_to_extra_contracts_map.item (l_feature)
				if not l_extra_contracts_list.is_empty then
					l_suggestion_count := l_suggestion_count * l_extra_contracts_list.count
				end
				l_features_on_stack.forth
			end
				-- Produce 10 suggestions
			from l_suggestion_index := 0
			until l_suggestion_index >= l_suggestion_count or else l_suggestion_index > config.max_valid_fix_number
			loop
				create l_suggestion.make_equal (10)
				from l_features_on_stack.start
				until l_features_on_stack.after
				loop
					l_feature := l_features_on_stack.item_for_iteration
					l_extra_contracts_list := l_features_to_extra_contracts_map.item (l_feature)
					if not l_extra_contracts_list.is_empty then
						l_extra_contract := l_extra_contracts_list.item (l_suggestion_index \\ l_extra_contracts_list.count + 1)
						create l_extra_contracts_for_revision.make_equal (1)
						l_extra_contracts_for_revision.force_last (l_extra_contract)
						create l_revision.make (l_feature, True, l_extra_contracts_for_revision, Void)
						l_suggestion.force (l_revision)
					end
					l_features_on_stack.forth
				end
				Result.force_last (l_suggestion)
				l_suggestion_index := l_suggestion_index + 1
			end
		end

	expressions_in_order (a_exprs: EPA_HASH_SET[EPA_AST_EXPRESSION]): DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
		local
			l_sorter: DS_QUICK_SORTER[EPA_AST_EXPRESSION]
		do
			create Result.make_equal (a_exprs.count + 1)
			a_exprs.do_all (agent Result.force_last)
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [EPA_AST_EXPRESSION]}.make (agent (e1, e2: EPA_AST_EXPRESSION): BOOLEAN do Result := e1.text.count < e2.text.count end))
			l_sorter.sort (Result)
		end

	weakening_revisions: DS_ARRAYED_LIST [EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]]
		local
			l_signature: AFX_EXCEPTION_SIGNATURE
			l_features_on_stack: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_failing_feature: AFX_FEATURE_TO_MONITOR
			l_is_pre: BOOLEAN
			l_relaxed_invariants_from_passing, l_relaxed_invariants_from_failing, l_relaxed_contracts, l_necessary_contracts, l_extra_contracts_for_revision, l_contract_candidates: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_contract_candidate_strings, l_relaxed_contract_strings, l_clause_strings_to_remove, l_true_expression_strings: EPA_HASH_SET [STRING]
			l_violated_contracts: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_clause, l_negated_clause: EPA_AST_EXPRESSION
			l_remaining_repository: like trace_repository_from_relaxed_test_cases
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state: EPA_STATE
			l_inferred_pre, l_written_pre, l_expression_set: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_strengthening_revisions, l_weakening_revisions, l_temp_revsions: DS_ARRAYED_LIST [EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]]
			l_feature: AFX_FEATURE_TO_MONITOR
			l_invariants, l_remaining_contracts: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_relaxed_contracts_in_order, l_expressions_in_order: DS_ARRAYED_LIST [EPA_AST_EXPRESSION]



			l_features_to_extra_contracts_map: DS_HASH_TABLE [DS_ARRAYED_LIST[EPA_AST_EXPRESSION], AFX_FEATURE_TO_MONITOR]
			l_invariants_from_passing, l_invariants_from_failing, l_extra_contracts: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_suggestion_index, l_suggestion_count: INTEGER
			l_suggestion: EPA_HASH_SET [AFX_CONTRACT_FIX_PER_FEATURE]
			l_extra_contracts_list: DS_ARRAYED_LIST[EPA_AST_EXPRESSION]
			l_extra_contract, l_extra_contract_for_failing: EPA_AST_EXPRESSION
			l_revision: AFX_CONTRACT_FIX_PER_FEATURE
			l_extra_contracts_and_remaining_traces: DS_ARRAYED_LIST[TUPLE[extra_contract: EPA_AST_EXPRESSION; remaining_traces: DS_ARRAYED_LIST[AFX_PROGRAM_EXECUTION_TRACE]]]
			l_traces: DS_ARRAYED_LIST[AFX_PROGRAM_EXECUTION_TRACE]

			l_fixer: AFX_TRACE_BASED_CONTRACT_FIXER
			l_strengthener: AFX_TRACE_BASED_CONTRACT_STRENGTHENER
			l_weakener: AFX_TRACE_BASED_CONTRACT_WEAKENER
			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
		do
			create Result.make_equal (10)
			l_signature := session.exception_signature
			l_is_pre := l_signature.is_precondition_violation
			l_features_on_stack := test_case_monitor.features_on_stack.twin
			l_failing_feature := l_features_on_stack.first
				-- Weakest contract for the violated location.
			l_relaxed_invariants_from_passing := invariants_for_feature (l_failing_feature, False, True, l_is_pre)
			l_relaxed_invariants_from_failing := invariants_for_feature (l_failing_feature, False, False,l_is_pre)
					-- All invariants from passing can be used as the contract
					-- Invariants only from passing are 'necessary' to reject failure-inducing inputs.
			l_contract_candidates := l_relaxed_invariants_from_passing
			l_necessary_contracts := l_relaxed_invariants_from_passing.subtraction (l_relaxed_invariants_from_failing)

			l_relaxed_contracts := l_relaxed_invariants_from_passing.subtraction (l_relaxed_invariants_from_failing)
			l_relaxed_contracts_in_order := expressions_in_order (l_relaxed_contracts)

				create l_contract_candidate_strings.make_equal (l_relaxed_contracts.count + 1)
				l_relaxed_invariants_from_passing.do_all (agent (a_exp: EPA_AST_EXPRESSION; a_set: EPA_HASH_SET[STRING]) do a_set.force (a_exp.text) end (?, l_contract_candidate_strings))
					-- Contract to be weakened
				if l_is_pre then
					l_violated_contracts := test_case_monitor.feature_contracts.item (l_failing_feature).pre
				else
					l_violated_contracts := test_case_monitor.feature_contracts.item (l_failing_feature).post
				end
				from
					create l_clause_strings_to_remove.make_equal (l_violated_contracts.count + 1)
					create l_remaining_contracts.make_equal (l_violated_contracts.count + 1)
					l_violated_contracts.start
				until
					l_violated_contracts.after
				loop
					l_clause := l_violated_contracts.item_for_iteration
					if not l_contract_candidate_strings.has (l_clause.text) then
						l_clause_strings_to_remove.force (l_clause.text)
					else
						l_remaining_contracts.force (l_clause)
					end
					l_violated_contracts.forth
				end

					-- Removing all unnecessary clauses as a weakening revision
				create l_weakening_revisions.make_equal (2)
				from
					create l_expression_set.make_equal (l_clause_strings_to_remove.count + 1)
					l_clause_strings_to_remove.start
				until
					l_clause_strings_to_remove.after -- or else l_suggestion_index > 2
				loop
					create {EPA_AST_EXPRESSION}l_clause.make_with_text (l_failing_feature.context_class, l_failing_feature.feature_, l_clause_strings_to_remove.item_for_iteration, l_failing_feature.written_class)
					l_expression_set.force (l_clause)
					l_clause_strings_to_remove.forth
				end
				create l_revision.make (l_failing_feature, l_is_pre, Void, l_expression_set)
				create l_suggestion.make_equal (1)
				l_suggestion.force (l_revision)
				l_weakening_revisions.force_last (l_suggestion)

	-- Strengthen if necessary

					-- Failing test case traces satisfying 'l_clauses_to_remove'.
					-- Such remaining tests need to be rejected by strengthening the preconditions.
				create l_strengthening_revisions.make_equal (10)
				create l_remaining_repository.make (trace_repository_from_relaxed_test_cases.count + 1)
				create l_extra_contracts_and_remaining_traces.make (5)

---------------------
-- NOT FINISHED YET.
---------------------
				if l_remaining_contracts.is_empty then
					create l_traces.make (trace_repository_from_test_cases.count + 1)
					trace_repository_from_test_cases.failing_traces.do_all (agent l_traces.force_last)
--					l_extra_contracts_and_remaining_traces.force_last ([Void, l_traces])
				else
					from l_relaxed_contracts_in_order.start
					until l_relaxed_contracts_in_order.after
					loop
						l_extra_contract_for_failing := l_relaxed_contracts_in_order.item_for_iteration

						from trace_repository_from_test_cases.start
						until trace_repository_from_test_cases.after
						loop
							l_trace := trace_repository_from_test_cases.item_for_iteration
							if l_trace.is_failing then
								l_state := l_trace.last.state
								check l_state /= Void and then l_state.class_ ~ l_failing_feature.context_class and then l_state.feature_ ~ l_failing_feature.feature_ end
								l_true_expression_strings := true_expression_strings_from_state (l_state)
								if l_true_expression_strings.is_superset (l_clause_strings_to_remove) then
									l_remaining_repository.force (l_trace, l_trace.test_case)
								end
							end
						 	trace_repository_from_test_cases.forth
						end

						l_relaxed_contracts_in_order.forth
					end
				end


				if not l_remaining_repository.is_empty then
					 	-- Infer invariants for the features on callstack from the remaining failing tests.
					if l_is_pre then
					 	l_features_on_stack.remove_first
					end
					invariants_from_test_cases_cache := Void
					from l_remaining_repository.start
					until l_remaining_repository.after
					loop
						l_trace := l_remaining_repository.item_for_iteration
						from l_trace.start
						until l_trace.after
						loop
							l_state := l_trace.item_for_iteration.state
							create l_feature.make (l_state.feature_, l_state.class_)
							l_invariants := invariants_for_feature (l_feature, True, False, True)
							update_invariants (l_invariants, l_state, False)

							l_trace.forth
						end
						l_remaining_repository.forth
					end

						-- Computer strengthenings to each feature
					create l_features_to_extra_contracts_map.make_equal (l_features_on_stack.count + 1)
					from l_features_on_stack.start
					until l_features_on_stack.after
					loop
						l_feature := l_features_on_stack.item_for_iteration
						l_inferred_pre := invariants_for_feature (l_feature, True, False, True)
						l_written_pre := test_case_monitor.feature_contracts.item (l_feature).pre
						l_extra_contracts := l_inferred_pre.subtraction (l_written_pre)
						l_expressions_in_order := expressions_in_order (l_extra_contracts)
						prune_disjunctions_of_true_expressions (l_expressions_in_order)
						l_features_to_extra_contracts_map.force (l_expressions_in_order, l_feature)
						l_features_on_stack.forth
					end

					from
						l_suggestion_count := 1
						l_features_on_stack.start
					until
						l_features_on_stack.after
					loop
						l_feature := l_features_on_stack.item_for_iteration
						l_extra_contracts_list := l_features_to_extra_contracts_map.item (l_feature)
						if not l_extra_contracts_list.is_empty then
							l_suggestion_count := l_suggestion_count * l_extra_contracts_list.count
						end
						l_features_on_stack.forth
					end
						-- Produce 5 suggestions
					from l_suggestion_index := 0
					until l_suggestion_index >= l_suggestion_count or else l_suggestion_index > 5
					loop
						create l_suggestion.make_equal (10)
						from l_features_on_stack.start
						until l_features_on_stack.after
						loop
							l_feature := l_features_on_stack.item_for_iteration
							l_extra_contracts_list := l_features_to_extra_contracts_map.item (l_feature)
							if not l_extra_contracts_list.is_empty then
								l_extra_contract := l_extra_contracts_list.item (l_suggestion_index \\ l_extra_contracts_list.count + 1)
								create l_extra_contracts_for_revision.make_equal (1)
								l_extra_contracts_for_revision.force_last (l_extra_contract)
								create l_revision.make (l_feature, True, l_extra_contracts_for_revision, Void)
							end
							l_suggestion.force (l_revision)
							l_features_on_stack.forth
						end
						l_strengthening_revisions.force_last (l_suggestion)
						l_suggestion_index := l_suggestion_index + 1
					end

				end

				if l_strengthening_revisions.is_empty then
					Result := l_weakening_revisions
				else
					from l_weakening_revisions.start
					until l_weakening_revisions.after
					loop
						from l_strengthening_revisions.start
						until l_strengthening_revisions.after
						loop
							create l_suggestion.make_equal (10)
							l_suggestion.merge (l_weakening_revisions.item_for_iteration)
							l_suggestion.merge (l_strengthening_revisions.item_for_iteration)
							Result.force_last (l_suggestion)

							l_strengthening_revisions.forth
						end
						l_weakening_revisions.forth
					end
				end
--			end
		end

	true_expression_strings_from_state (a_state: EPA_STATE): EPA_HASH_SET [STRING]
		local
		do
			create Result.make_equal (a_state.count)
			from a_state.start
			until a_state.after
			loop
				if a_state.item_for_iteration.value.is_true_boolean then
					Result.force (a_state.item_for_iteration.expression.text)
				end
				a_state.forth
			end
		end

	invariants_for_feature (a_feature: AFX_FEATURE_TO_MONITOR; a_from_test_case, a_passing, a_pre: BOOLEAN): EPA_HASH_SET[EPA_AST_EXPRESSION]
		local
			l_invariants: like invariants_from_relaxed_test_cases
			l_entry: TUPLE[passing, failing: TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]]]
			l_pre_passing, l_pre_failing, l_post_passing, l_post_failing: EPA_HASH_SET[EPA_AST_EXPRESSION]
		do
			if a_from_test_case then
				l_invariants := invariants_from_test_cases
			else
				l_invariants := invariants_from_relaxed_test_cases
			end
			if not l_invariants.has (a_feature) then
				create l_pre_passing.make_equal (100)
				l_invariants.force ([[l_pre_passing.twin, l_pre_passing.twin], [l_pre_passing.twin, l_pre_passing.twin]], a_feature)
			end

			if a_passing then
				if a_pre then
					Result := l_invariants.item (a_feature).passing.pre
				else
					Result := l_invariants.item (a_feature).passing.post
				end
			else
				if a_pre then
					Result := l_invariants.item (a_feature).failing.pre
				else
					Result := l_invariants.item (a_feature).failing.post
				end
			end
		end

	remove_closed_feature_calls_from_failing_traces (a_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY)
		local
			l_test_info: EPA_TEST_CASE_INFO
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state, l_last_state, l_previous_state: AFX_PROGRAM_EXECUTION_STATE
			l_class_stack: DS_LINKED_LIST[CLASS_C]
			l_feature_stack: DS_LINKED_LIST[FEATURE_I]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_breakpoint: INTEGER
		do
			from
				a_repository.start
			until
				a_repository.after
			loop
				l_test_info := a_repository.key_for_iteration
				l_trace := a_repository.item_for_iteration

					-- Only remove closed states from failing traces
				if not l_trace.is_empty and then l_trace.is_failing then
					from
						l_previous_state := Void
						l_last_state := l_trace.last
						create l_class_stack.make_equal
						create l_feature_stack.make_equal
						l_trace.start
					until
						l_trace.after
					loop
						l_state := l_trace.item_for_iteration
						l_class := l_state.state.class_
						l_feature := l_state.state.feature_
						l_breakpoint := l_state.location.breakpoint_index

						if l_state /= l_last_state and then l_breakpoint /= 1 then
								-- Remove the openning state if the closing state is not the last state
							check l_previous_state /= Void and then l_previous_state.state.class_ ~ l_class and then l_previous_state.state.feature_ ~ l_feature and then l_previous_state.location.breakpoint_index = 1 end
							l_trace.remove_left
							l_trace.remove
							l_trace.back
							if not l_trace.is_empty then
								l_previous_state := l_trace.item_for_iteration
							else
								l_previous_state := Void
							end
						else
							l_previous_state := l_state
						end

						l_trace.forth
					end
				end

				a_repository.forth
			end
		end

	trace_repositories_from_features_map (a_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_features: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]): DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY, AFX_FEATURE_TO_MONITOR]
		local
			l_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_traces_for_features: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, AFX_FEATURE_TO_MONITOR]
			l_trace, l_distilled_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_feature: AFX_FEATURE_TO_MONITOR
		do
				-- Reserve in the Result one repository for each feature
			create Result.make_equal (10)
			from a_features.start
			until a_features.after
			loop
				l_feature := a_features.item_for_iteration
				create l_repository.make (200)
				Result.force (l_repository, l_feature)
				a_features.forth
			end

				-- Add
			from
				a_repository.start
			until
				a_repository.after
			loop
				l_trace := a_repository.item_for_iteration

				create l_traces_for_features.make_equal (a_features.count + 1)
				from a_features.start
				until a_features.after
				loop
					l_feature := a_features.item_for_iteration
					create l_distilled_trace.make (l_trace.test_case)
					if l_trace.is_passing then
						l_distilled_trace.set_status_as_passing
					else
						l_distilled_trace.set_status_as_failing
					end
					l_traces_for_features.force (l_distilled_trace, l_feature)
					Result.item (l_feature).force (l_distilled_trace, l_trace.test_case)

					a_features.forth
				end

				from l_trace.start
				until l_trace.after
				loop
					l_state := l_trace.item_for_iteration
					create l_feature.make (l_state.state.feature_, l_state.state.class_)
					l_traces_for_features.item (l_feature).force (l_state)

					l_trace.forth
				end
				a_repository.forth
			end

		end

	update_invariants (a_invariants: EPA_HASH_SET[EPA_AST_EXPRESSION]; a_state: EPA_STATE; a_is_merging: BOOLEAN)
			-- When 'a_is_merging' compute the union; otherwise, compute the intersection.
		local
			l_true_expressions: EPA_HASH_SET[EPA_AST_EXPRESSION]
		do
			create l_true_expressions.make_equal (a_state.count + 1)
			from a_state.start
			until a_state.after
			loop
				if a_state.item_for_iteration.value.is_true_boolean and then attached {EPA_AST_EXPRESSION} a_state.item_for_iteration.expression as lt_expr then
					l_true_expressions.force (lt_expr)
				end
				a_state.forth
			end
			if a_invariants.is_empty or else a_is_merging then
				a_invariants.merge (l_true_expressions)
			else
				a_invariants.intersect (l_true_expressions)
			end
		end

	update_values_of_old_expressions (a_traces: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY)
		local
			l_trace_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
		do
			from
				l_trace_cursor := a_traces.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item
				update_values_of_old_expressions_in_trace (l_trace)

				l_trace_cursor.forth
			end
		end

	update_values_of_old_expressions_in_trace (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
		local
			l_state, l_pre_state: AFX_PROGRAM_EXECUTION_STATE
			l_bp, l_pre_bp: INTEGER
			l_feature, l_pre_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_stack: DS_ARRAYED_STACK[AFX_PROGRAM_EXECUTION_STATE]
			l_evaluation, l_pre_evaluation: EPA_STATE
			l_equation: EPA_EQUATION
			l_expression_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_old_expression_evaluator: AFX_OLD_EXPRESSION_EVALUATOR
		do
			from
				create l_stack.make_equal (a_trace.count)
				create l_old_expression_evaluator
				a_trace.start
			until
				a_trace.after
			loop
				l_state := a_trace.item_for_iteration
				l_feature := l_state.location.context
				l_bp := l_state.location.breakpoint_index
				l_evaluation := l_state.state

				if l_bp = 1 then
					l_stack.force (l_state)
				else
					if not l_stack.is_empty then
							-- Exit state of feature
						l_pre_state := l_stack.item
						l_pre_evaluation := l_pre_state.state
						l_pre_bp := l_pre_state.location.breakpoint_index
						l_pre_feature := l_pre_state.location.context

						if l_pre_feature ~ l_feature and l_pre_bp = 1 then
								-- Matching entry state available
							from l_evaluation.start
							until l_evaluation.after
							loop
								l_equation := l_evaluation.item_for_iteration
								l_expression_text := l_equation.expression.text
								if l_expression_text.has_substring ("old") and then l_equation.value.is_nonsensical then
									l_old_expression_evaluator.evaluate (l_feature, l_expression_text, l_evaluation, l_pre_evaluation)
									l_value := l_old_expression_evaluator.last_value
									if l_value /= Void and then not l_value.is_nonsensical then
										l_equation.set_value (l_value)
									end
								end

								l_evaluation.forth
							end
							l_stack.remove
						end
					else
						a_trace.remove
						a_trace.back
					end
				end

				a_trace.forth
			end
		end

	contract_skeletons_for_features_cache: like contract_skeletons_for_features

	contract_skeletons_for_features: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_TO_MONITOR]
		local
			l_contract_expressions_for_features: DS_HASH_TABLE [TUPLE [pre, post: EPA_HASH_SET [EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_contract_skeletons_for_features: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_TO_MONITOR]
			l_repository, l_derived_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_skeleton_builder: AFX_DERIVED_STATE_SKELETON_BUILDER
		do
			if contract_skeletons_for_features_cache = Void then
				l_contract_expressions_for_features := test_case_monitor.contract_expressions_for_features
				from
					create l_skeleton_builder
					create l_contract_skeletons_for_features.make_equal (l_contract_expressions_for_features.count +1)
					l_contract_expressions_for_features.start
				until
					l_contract_expressions_for_features.after
				loop
					l_skeleton_builder.build_skeleton (l_contract_expressions_for_features.key_for_iteration, l_contract_expressions_for_features.item_for_iteration.post)
					l_contract_skeletons_for_features.force (l_skeleton_builder.last_derived_skeleton, l_contract_expressions_for_features.key_for_iteration)
					l_contract_expressions_for_features.forth
				end
				contract_skeletons_for_features_cache := l_contract_skeletons_for_features
			end
			Result := contract_skeletons_for_features_cache
		end



	build_derived_traces (a_traces: like trace_repository_from_test_cases; a_skeletons: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_TO_MONITOR]; a_use_aspect: BOOLEAN; a_should_remove_closed_feature_calls: BOOLEAN): like trace_repository_from_test_cases
		local
			l_contract_expressions_for_features: DS_HASH_TABLE [TUPLE [pre, post: EPA_HASH_SET [EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_contract_skeletons_for_features: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_TO_MONITOR]
			l_repository, l_derived_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_skeleton_builder: AFX_DERIVED_STATE_SKELETON_BUILDER

			l_trace_repositories_from_features_map: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY, AFX_FEATURE_TO_MONITOR]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_feature: AFX_FEATURE_TO_MONITOR
			l_invariants: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_repository_for_feature: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_is_from_test_case, l_is_pre, l_is_from_passing: BOOLEAN
		do
			update_values_of_old_expressions (a_traces)
			if a_should_remove_closed_feature_calls then
				remove_closed_feature_calls_from_failing_traces (a_traces)
			end
			Result := a_traces.derived_compound_repository (a_skeletons, a_use_aspect)
		end

	save_trace_repository_to_file (a_repository: like trace_repository_from_test_cases; a_name: STRING)
		local
			l_repository: like trace_repository_from_test_cases
			l_test: EPA_TEST_CASE_INFO
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_file_path: PATH
			l_file: PLAIN_TEXT_FILE
		do
			l_repository := a_repository
			l_file_path := config.log_directory
			l_file_path := l_file_path.extended (a_name + ".txt")
			create l_file.make_with_path (l_file_path)
			l_file.open_write
			from l_repository.start
			until l_repository.after
			loop
				l_file.put_string (l_repository.item_for_iteration.out)
				l_repository.forth
			end
			l_file.close
		end

	generate_fixes_to_contracts
		local
		do

		end

	relax_feature_contracts (a_feature_set: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN])
		local
			l_feature_contract_remover: EPA_FEATURE_CONTRACT_REMOVER
		do
			create l_feature_contract_remover
			l_feature_contract_remover.remove_contracts_of_features (a_feature_set)

				-- Compile the overriding classes into project.
			Eiffel_project.quick_melt (True, True, True)
			Eiffel_project.freeze
			Eiffel_project.call_finish_freezing_and_wait (True)
		end

	initialize_relaxed_feature
			--
		local
			l_relaxed_feature_name: STRING
			l_exception: DEVELOPER_EXCEPTION
			l_feature: FEATURE_I
			l_class: CLASS_C
		do
			relaxed_feature := test_case_monitor.features_on_stack.first
			if relaxed_feature.context_class = Void or else relaxed_feature.feature_ = Void
					or else (not relaxed_feature.context_class.valid_creation_procedure_32 (relaxed_feature.feature_.feature_name_32) and then not relaxed_feature.feature_.is_exported_for (System.any_class.compiled_class)) then
				relaxed_feature := Void
			else
				l_class := first_class_starts_with_name (relaxed_feature.context_class.name_in_upper)
				l_feature := l_class.feature_named_32 (relaxed_feature.feature_.feature_name_32)
				create relaxed_feature.make (l_feature, l_class)
			end
		end

	initialize_feature_under_test
			--
		local
			l_feature_name: STRING
			l_exception: DEVELOPER_EXCEPTION
			l_feature: FEATURE_I
			l_class: CLASS_C
		do
			feature_under_test := test_case_monitor.features_on_stack.last
			if feature_under_test.context_class = Void or else feature_under_test.feature_ = Void then
				feature_under_test := Void
			else
				l_class := first_class_starts_with_name (feature_under_test.context_class.name_in_upper)
				l_feature := l_class.feature_named_32 (feature_under_test.feature_.feature_name_32)
				create feature_under_test.make (l_feature, l_class)
			end
		end

	relaxed_feature: AFX_FEATURE_TO_MONITOR
			-- Feature whose contracts could be relaxed to remove the failure.

	feature_under_test: AFX_FEATURE_TO_MONITOR


	trace_repository_from_test_cases: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

	trace_repository_from_relaxed_test_cases: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

	trace_repository_for_fix_validation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

	test_case_monitor: AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS
		do
			if test_case_monitor_cache = Void then
				create test_case_monitor_cache.make
			end
			Result := test_case_monitor_cache
		end

	relaxed_test_case_monitor: AFX_RELAXED_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS
		do
			if relaxed_test_case_monitor_cache = Void then
				create relaxed_test_case_monitor_cache.make
			end
			Result := relaxed_test_case_monitor_cache
		end

	fix_validator: AFX_TEST_CASE_MONITOR_FOR_FIX_VALIDATION
		do
			if fix_validator_cache = Void then
				create fix_validator_cache.make
			end
			Result := fix_validator_cache
		end

feature{NONE} -- Cache

	test_case_monitor_cache: AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS
			-- Cache for `test_case_monitor'.

	relaxed_test_case_monitor_cache: AFX_RELAXED_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS

	fix_validator_cache: like fix_validator


end
