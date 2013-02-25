note
	description: "[Summary description for {AFX_FIX_PROPOSER}.]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_PROPOSER

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

feature -- Basic operations

	execute
			-- <Precursor>
		local
			l_file: PLAIN_TEXT_FILE
			l_validator: AFX_FIX_VALIDATOR
		do
			reset_report
			session.initialize_logging
			session.start

			event_actions.notify_on_session_starts

				-- HACK: force re-compiling the root class by "touch"ing it, otherwise expression evaluation might fail.
			create l_file.make_with_name (root_class_of_system.file_name)
			l_file.touch

				-- Compile project		
			compile_project (eiffel_project, True)

				-- Start test case analysis
			event_actions.notify_on_test_case_analysis_starts
			analyze_test_cases
			event_actions.notify_on_test_case_analysis_ends

				-- Generate and store fixes.
			event_actions.notify_on_fix_generation_starts
			generate_fixes
			store_fixes (fixes, "fixes.txt")
			event_actions.notify_on_fix_generation_ends (fixes)

				-- Validate generated fixes.
			check exception_signature /= Void end
			create l_validator.make (fixes)
			event_actions.notify_on_fix_validation_starts(l_validator.melted_fixes)
			l_validator.validate
			event_actions.notify_on_fix_validation_ends(l_validator.valid_fixes)

				-- Generate profiling data about AutoFix.
			event_actions.notify_on_report_generation_starts
			sort_valid_fixes
			store_fixes (valid_fixes, "valid_fixes.txt")
			event_actions.notify_on_report_generation_ends

			event_actions.notify_on_session_ends
			session.clean_up
		end

feature{NONE} -- Implementation

	store_fixes (a_fixes: DS_LINKED_LIST [AFX_FIX]; a_file_name: STRING)
			-- Store fixes in to files.
		local
			l_big_file: PLAIN_TEXT_FILE
			l_file_name: PATH
		do
			create l_big_file.make_with_path (config.data_directory.extended (a_file_name))
			l_big_file.create_read_write
			a_fixes.do_all (agent store_fix_in_file (config.fix_directory, ?, False, l_big_file))
			l_big_file.close
		end

	trace_collector: AFX_TRACE_COLLECTOR
			-- Collector to collect traces.
		do
			if trace_collector_cache = Void then
				if config.is_fixing_contracts_enabled then
					create {AFX_INTER_FEATURE_TRACE_COLLECTOR} trace_collector_cache.make
				else
					create {AFX_INTRA_FEATURE_TRACE_COLLECTOR} trace_collector_cache.make
				end
			end
			Result := trace_collector_cache
		end

	analyze_test_cases
			-- Analyze the execution of test cases.
		local
			l_trace_collector: AFX_TRACE_COLLECTOR
			l_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
		do
			trace_collector.collect
			l_trace_repository := trace_repository
			progression_monitor.set_progression (progression_monitor.progression_test_case_analysis_execution_end)

			if session.should_continue then
				if config.is_using_random_based_strategy then
					create l_trace_analyzer
					l_trace_analyzer.set_breakpoint_index_range (
								[exception_recipient_feature.first_breakpoint_in_body,
								exception_recipient_feature.last_breakpoint_in_body])
					l_trace_analyzer.collect_statistics_from_trace_repository ({AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

					create l_ranker
					l_ranker.compute_ranks
				elseif config.is_using_model_based_strategy and then config.is_daikon_enabled then
					create l_invariant_detecter
					l_invariant_detecter.detect
				end
			end
		end

	generate_fixes
			-- <Precursor>
		local
			l_generator: AFX_FIX_GENERATOR
			l_text_equal_fixes: HASH_TABLE [INTEGER, STRING]
			l_fix: AFX_FIX
			l_text: STRING
			l_count: INTEGER
			l_fixes: like fixes
		do
			if session.should_continue then
				if config.is_using_random_based_strategy then
					create {AFX_RANDOM_BASED_FIX_GENERATOR} l_generator
				elseif config.is_using_model_based_strategy then
					create {AFX_ASSERTION_VIOLATION_FIX_GENERATOR} l_generator
				end
				l_generator.generate

				if session.should_continue then
					l_fixes := fixes
					l_fixes.append_last (l_generator.fixes)

						-- Remove syntactially equivalent fixes.
					create l_text_equal_fixes.make (l_fixes.count)
					l_text_equal_fixes.compare_objects
					from
						l_fixes.start
					until
						l_fixes.after
					loop
						l_fix := l_fixes.item_for_iteration
						l_text := l_fix.text
						if l_text_equal_fixes.has (l_text) then
							l_fixes.remove_at
						else
							l_text_equal_fixes.put (1, l_text)
							l_fixes.forth
						end
					end
				end
			end
		end

--	validate_fixes
--			-- Validate `fix_skeletons'.
--		local
--			l_validator: AFX_FIX_VALIDATOR
--		do
--			check exception_signature /= Void end
--			create l_validator.make (fixes)
--			l_validator.validate
--		end

feature{NONE} -- Auxiliary

	fixes: DS_LINKED_LIST [AFX_FIX]
			-- Generated fixes
		do
			if fixes_cache = Void then
				create fixes_cache.make
			end
			Result := fixes_cache
		ensure
			result_attached: Result /= Void
		end

	valid_fixes: DS_LINKED_LIST [AFX_FIX]
			-- List of valid fixes.
		do
			if valid_fixes_cache = Void then
				create valid_fixes_cache.make
			end
			Result := valid_fixes_cache
		end

	sort_valid_fixes
			-- Sort valid fixes into `valid_fixes'.
		local
			l_sorter: DS_QUICK_SORTER [AFX_FIX]
		do
			fixes.do_if (agent valid_fixes.force_last, agent (a_fix: AFX_FIX): BOOLEAN do Result := a_fix.is_valid end)
			create l_sorter.make (
				create {AGENT_BASED_EQUALITY_TESTER [AFX_FIX]}.make (
					agent (af, bf: AFX_FIX): BOOLEAN
						do
							Result := (af.ranking.post_validation_score + af.ranking.pre_validation_score)
								<
								(bf.ranking.post_validation_score + bf.ranking.pre_validation_score)
						end))
			l_sorter.sort (valid_fixes)
		end

feature{NONE} -- Cache

	trace_collector_cache: AFX_TRACE_COLLECTOR
			-- Cache for `trace_collector'.

	valid_fixes_cache: DS_LINKED_LIST [AFX_FIX]
			-- Cache for `valid_fixes'.

	fixes_cache: DS_LINKED_LIST[AFX_FIX]
			-- Cache for 'fixes'.

end
