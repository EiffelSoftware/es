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
			collect_exception_info as old_collect_exception_info,
			test_case_execution_status as test_case_execution_status_collector
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

feature -- Basic operations

	execute
			-- <Precursor>
		local
			l_intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
			l_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
		do
			initialize_logging

			event_actions.notify_on_session_starts

			-- Compile project			
			compile_project (eiffel_project, True)

			-- Start test case analysis
			event_actions.notify_on_test_case_analysis_starts

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

--			l_invariants_from_passing := invariants_from_passing
--			l_invariants_from_failing := invariants_from_failing
			event_actions.notify_on_test_case_analysis_ends

--			from
--				l_ranking_cursor := l_program_state_expression_ranking.new_cursor
--				l_ranking_cursor.start
--			until
--				l_ranking_cursor.after
--			loop
--				l_target := l_ranking_cursor.item
--				l_expressions := l_target.expressions
--				from
--					l_expression_cursor := l_expressions.new_cursor
--					l_expression_cursor.start
--				until
--					l_expression_cursor.after
--				loop
--					l_target_objects := l_expression_cursor.item.immediate_target_objects

--					l_expression_cursor.forth
--				end
--				l_ranking_cursor.forth
--			end

			-- Generate fixes.
			event_actions.notify_on_fix_generation_starts
--			create l_invariant_finder.make
--			l_invariant_finder.set_trace_repository (l_localizer.trace_repository)
--			l_invariant_finder.detect

--			from l_ranking.start
--			until l_ranking.after
--			loop
--				l_target := l_ranking.item_for_iteration

--				l_class := l_target.context_class
--				l_feature := l_target.context_feature
--				l_bp_index := l_target.bp_index
--				l_invariants := l_invariant_finder.invariants_at (l_class, l_feature, l_bp_index, Invariant_passing_only)

--				l_ranking.forth
--			end
			generate_fixes


			-- Store fixes in files.
			store_fixes (fixes)
			event_actions.notify_on_fix_generation_ends (fixes.count)

			-- Validate generated fixes.
			event_actions.notify_on_fix_validation_starts
			validate_fixes
			event_actions.notify_on_fix_validation_ends

			event_actions.notify_on_session_ends
		end

feature{NONE} -- Implementation

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
				fixes.count >= 20 or else l_gen.fixes.after
			loop
				fixes.force (l_gen.fixes.item_for_iteration)
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
					fixes.remove
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

end
