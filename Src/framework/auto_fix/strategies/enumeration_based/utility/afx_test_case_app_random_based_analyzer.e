note
	description: "Summary description for {AFX_TEST_CASE_APP_RANDOM_BASED_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_APP_RANDOM_BASED_ANALYZER

inherit

	AFX_TEST_CASE_APP_ANALYZER
		rename
			test_case_info_skeleton as old_test_case_info_skeleton,
			on_application_stopped as old_on_application_stopped,
			collect_exception_info as old_collect_exception_info,
			test_case_execution_status as test_case_execution_status_collector,
			test_case_start_actions as old_test_case_start_actions,
			test_case_breakpoint_hit_actions as old_test_case_breakpoint_hit_actions,
			application_exited_actions as old_application_exited_actions,
			make as old_make,
			config as old_config
		redefine
			execute,
			generate_fixes,
			validate_fixes
		end

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_EXECUTION_MODE

	SHARED_SERVER

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

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
			create exception_spots.make (5)
			exception_spots.compare_objects
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

	analyze_test_cases1
			-- Analyze the execution of test cases.
		local
			l_intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
		do
			create l_intra_feature_trace_collector.make
			l_intra_feature_trace_collector.collect_trace
			l_trace_repository := trace_repository

			create l_trace_analyzer
			l_trace_analyzer.set_breakpoint_index_range (
						[exception_spot.recipient_ast_structure.first_breakpoint_slot_number,
						 exception_spot.recipient_ast_structure.last_breakpoint_slot_number])
			l_trace_analyzer.collect_statistics_from_trace_repository ({AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

			create l_ranker
			l_ranker.compute_ranks

			create l_invariant_detecter.make
			l_invariant_detecter.detect
		end

	execute
			-- <Precursor>
		local
			l_fixes: DS_LINKED_LIST [AFX_FIX]
		do
			initialize_logging
			event_actions.notify_on_session_starts

				-- Compile project			
			compile_project (eiffel_project, True)

				-- Start test case analysis
			event_actions.notify_on_test_case_analysis_starts
			analyze_test_cases1
			event_actions.notify_on_test_case_analysis_ends

				-- Generate and store fixes.
			event_actions.notify_on_fix_generation_starts
			generate_fixes
			store_fixes (fixes, "fixes.txt")
			event_actions.notify_on_fix_generation_ends (fixes.count)

				-- Validate generated fixes.
			event_actions.notify_on_fix_validation_starts
			validate_fixes
			event_actions.notify_on_fix_validation_ends

				-- Generate profiling data about AutoFix.
			event_actions.notify_on_report_generation_starts
			sort_valid_fixes
			store_fixes (valid_fixes, "valid_fixes.txt")
			event_actions.notify_on_report_generation_ends

			event_actions.notify_on_session_ends
		end

feature{NONE} -- Implementation

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

	generate_fixes
			-- <Precursor>
		local
			l_gen: AFX_RANDOM_BASED_FIX_GENERATOR
			l_text_equal_fixes: HASH_TABLE [INTEGER, STRING]
			l_fix: AFX_FIX
			l_text: STRING
			l_count: INTEGER
		do
			create fixes.make
			create l_gen.make
			l_gen.generate

--			fixes.append (l_gen.fixes)
			-- Use only the first 20 fixes for debugging.
			from
				l_gen.fixes.start
			until
				l_gen.fixes.after
			loop
				fixes.force_last (l_gen.fixes.item_for_iteration)
				l_gen.fixes.forth
			end

				-- Remove syntactially equivalent fixes.
			create l_text_equal_fixes.make (fixes.count)
			l_text_equal_fixes.compare_objects
			from
				fixes.start
			until
				fixes.after
			loop
				l_fix := fixes.item_for_iteration
				l_text := l_fix.text
				if l_text_equal_fixes.has (l_text) then
					fixes.remove_at
				else
					l_text_equal_fixes.put (1, l_text)
					fixes.forth
				end
			end
		end

	validate_fixes
			-- Validate `fix_skeletons'.
			-- (from AFX_TEST_CASE_APP_ANALYZER)
		local
			l_validator: AFX_FIX_VALIDATOR
			l_spot: AFX_EXCEPTION_SPOT
		do
			check exception_spot /= Void end
			create l_validator.make (config, exception_spot, fixes, test_case_execution_status)
			l_validator.validate
		end

feature{NONE} -- Cache

	valid_fixes_cache: DS_LINKED_LIST [AFX_FIX]
			-- Cache for `valid_fixes'.

end
