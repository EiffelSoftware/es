note
	description: "Summary description for {AFX_SHARED_DYNAMIC_ANALYSIS_REPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

inherit
	ANY
		undefine
			is_equal,
			copy
		end

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	AFX_SHARED_STATIC_ANALYSIS_REPORT

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

feature -- Access

	trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			-- Traces collected by monitoring program execution.
		do
			Result := trace_repository_cell.item
		ensure
			result_attached: Result /= Void
		end

	statistics_from_passing: AFX_EXECUTION_TRACE_STATISTICS
			-- Number of hits of an expression at a breakpoint slot from all passing test cases.
		do
			Result := statistics_from_passing_cell.item
		end

	statistics_from_failing: AFX_EXECUTION_TRACE_STATISTICS
			-- Number of hits of an expression at a breakpoint slot from all failing test cases.
		do
			Result := statistics_from_failing_cell.item
		end

	set_statistics_from_passing (a_sta: like statistics_from_passing)
			-- Set `statistics_from_passing'.
		do
			statistics_from_passing_cell.put (a_sta)
		end

	set_statistics_from_failing (a_sta: like statistics_from_failing)
			-- Set `statistics_from_failing'.
		do
			statistics_from_failing_cell.put (a_sta)
		end

	test_case_execution_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING_8]
			-- Table of test case execution status (including both passing and failing test cases)
			-- Key is test case uuid, value is the execution status of that test case.
		do
			Result := test_case_execution_status_cell.item
		ensure
			result_attached: Result /= Void
		end

	fixing_target_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- List of fixing targets.
		do
			Result := fixing_target_list_cell.item
		ensure
			result_attached: Result /= Void
		end

	set_fixing_target_list (a_list: like fixing_target_list)
			-- Set `fixing_target_list'.
		require
			list_attached: a_list /= Void
		do
			fixing_target_list_cell.put (a_list)
		end

	fixing_target_list_cell: CELL [DS_ARRAYED_LIST [AFX_FIXING_TARGET]]
			-- Cell for `fixing_target_list'.
		once
			create Result.put (Void)
		end

	ranking_of_program_state_aspects: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- List of program state aspects as fixing targets, in decreasing order of suspiciousness value.
			-- Refer to {AFX_RANK_SORTER} for the sorting criteria.
		require
			trace_repository_attached: trace_repository /= Void
		do
			Result := ranking_of_program_state_aspects_cell.item
		ensure
			result_attached: Result /= Void
		end

	ranking_of_program_state_expressions: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- List of program state expressions as fixing targets, in decreasing order of suspiciousness value.
			-- Refer to {AFX_RANK_SORTER} for the sorting criteria.
		require
			trace_repository_attached: trace_repository /= Void
--		local
--			l_program_state_expression_ranker: AFX_PROGRAM_STATE_EXPRESSION_RANKING
		do
--			if ranking_of_program_state_expressions_cell.item = Void then
--				create l_program_state_expression_ranker
--				l_program_state_expression_ranker.compute_ranking
--			end
			Result := ranking_of_program_state_expressions_cell.item
		end

	invariants_from_passing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
			-- Invariants inferred based on passing executions.
		require
			trace_repository_attached: trace_repository /= Void
		do
--			if invariants_from_passing_cell.item = Void then
--				invariants_from_passing_cell.put (invariant_detector.invariants_from_traces (trace_repository.passing_traces))
--			end
			Result := invariants_from_passing_cell.item
		end

	invariants_from_failing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
			-- Invariants inferred based on failing executions.
		require
			trace_repository_attached: trace_repository /= Void
		do
--			if invariants_from_failing_cell.item = Void then
--				invariants_from_failing_cell.put (invariant_detector.invariants_from_traces (trace_repository.failing_traces))
--			end
			Result := invariants_from_failing_cell.item
		end

feature -- Reset

	reset_report
			-- Reset the dynamic analysis report.
		do
			reset_trace_repository
			reset_test_case_execution_status
			reset_ranking_of_program_state_aspects
			reset_ranking_of_program_state_expressions
			reset_invariants
			ranking_of_program_state_aspects_cell.put (Void)
			ranking_of_program_state_expressions_cell.put (Void)
			invariants_from_passing_cell.put (Void)
			invariants_from_failing_cell.put (Void)
		end

	reset_trace_repository
			-- Reset `trace_repository' to be an empty repository.
		do
			set_trace_repository (create {AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY}.make_default)
		end

	reset_test_case_execution_status
			-- Reset `test_case_execution_status' to contain no status information.
		local
			l_table: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING_8]
		do
			create l_table.make (20)
			l_table.compare_objects
			set_test_case_execution_status (l_table)
		end

	reset_ranking_of_program_state_aspects
			-- Reset `ranking_of_program_state_aspects' to be an empty list.
		do
			set_ranking_of_program_state_aspects (create {DS_ARRAYED_LIST [AFX_FIXING_TARGET]}.make_default)
		end

	reset_ranking_of_program_state_expressions
			-- Reset `ranking_of_program_state_expressions' to be an empty list.
		do
			set_ranking_of_program_state_expressions (create {DS_ARRAYED_LIST [AFX_FIXING_TARGET]}.make_default)
		end

	reset_invariants
			-- Reset invariant information.
		local
			l_table: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
		do
			create l_table.make_equal (10)
			invariants_from_passing_cell.put (l_table)
			create l_table.make_equal (10)
			invariants_from_failing_cell.put (l_table)
		end

feature -- Basic operation

	invariants_at (a_class: CLASS_C; a_feature: FEATURE_I; a_bp_index: INTEGER; a_mode: INTEGER): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Invariants inferred at the breakpoint `a_bp_index' in `a_class'.`a_feature'.
			-- `a_mode' indicates which kind of invariants to return.
		require
			context_attached: a_class /= Void and then a_feature /= Void
			valid_index: a_bp_index > 0
			valid_mode: is_valid_invariant_access_mode (a_mode)
			trace_repository_attached: trace_repository /= Void
			invariants_available: invariants_from_failing /= Void and then invariants_from_passing /= Void
		local
			l_ppt: DKN_PROGRAM_POINT
			l_ppt_name: STRING
			l_invariants_from_passing, l_invariants_from_failing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
			l_invariants_p, l_invariants_f: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_invariants: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			l_ppt_name := a_class.name.as_upper + "." + a_feature.feature_name_32.as_lower + ":::" + a_bp_index.out
			create l_ppt.make_with_type (l_ppt_name, {DKN_CONSTANTS}.point_program_point)

			-- Invariants at `a_class'.`a_feature'::: `a_bp_index', from passing executions.
			l_invariants_from_passing := invariants_from_passing
			if l_invariants_from_passing.has (l_ppt) then
				l_invariants_p := l_invariants_from_passing.item (l_ppt)
			end

			-- Invariants at `a_class'.`a_feature':::`a_bp_index', from failing executions.
			l_invariants_from_failing := invariants_from_failing
			if l_invariants_from_failing.has (l_ppt) then
				l_invariants_f := l_invariants_from_failing.item (l_ppt)
			end

			-- Invariants.
			inspect a_mode
			when Invariant_passing_all then
				l_invariants := l_invariants_p
			when Invariant_passing_only then
				if attached l_invariants_p and then attached l_invariants_f then
					l_invariants := l_invariants_p.subtraction (l_invariants_f)
				else
					l_invariants := l_invariants_p
				end
			when Invariant_failing_all then
				l_invariants := l_invariants_f
			when Invariant_failing_only then
				if attached l_invariants_f and then attached l_invariants_p then
					l_invariants := l_invariants_f.subtraction (l_invariants_p)
				else
					l_invariants := l_invariants_f
				end
			end
			Result := l_invariants

--			-- Invariants as {EPA_PROGRAM_STATE_EXPRESSIONS}.
--			create Result.make (1)
--			Result.set_equality_tester (breakpoint_unspecific_equality_tester)
--			if l_invariants /= Void then
--				Result.resize (l_invariants.count)
--				l_invariants.do_all (agent Result.force)
--			end
		end


feature -- Status set

	set_trace_repository (a_repository: like trace_repository)
			-- Set `trace_repository'.
		require
			repository_attached: a_repository /= Void
		do
			trace_repository_cell.put (a_repository)
		end

	set_test_case_execution_status (a_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING_8])
			-- Set `test_case_execution_status'.
		require
			status_attached: a_status /= Void
		do
			test_case_execution_status_cell.put (a_status)
		end

	set_ranking_of_program_state_aspects (a_ranking: like ranking_of_program_state_aspects)
			-- Set `ranking_of_program_state_aspects'.
		require
			ranking_attached: a_ranking /= Void
		do
			ranking_of_program_state_aspects_cell.put (a_ranking)
		end

	set_ranking_of_program_state_expressions (a_ranking: like ranking_of_program_state_expressions)
			-- Set `ranking_of_program_state_expressions'.
		require
			ranking_attached: a_ranking /= Void
		do
			ranking_of_program_state_expressions_cell.put (a_ranking)
		end

feature{NONE} -- Storage

--	invariant_detector: AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER
--			-- Shared invariant detector.
--		once
--			create Result.make
--		end

--	intra_feature_trace_collector: AFX_INTRA_FEATURE_TRACE_COLLECTOR
--			-- Shared trace collector.
--		once
--			create Result.make
--		end

	trace_repository_cell : CELL [AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY]
			-- Storage for the shared `trace_repository'.
		once
			create Result.put (Void)
		end

	statistics_from_passing_cell: CELL [AFX_EXECUTION_TRACE_STATISTICS]
			-- Cell for `statistics_from_passing'.
		once
			create Result.put (Void)
		end

	statistics_from_failing_cell: CELL [AFX_EXECUTION_TRACE_STATISTICS]
			-- Cell for `statistics_from_failing'.
		once
			create Result.put (Void)
		end

	test_case_execution_status_cell: CELL [HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING_8]]
			-- Storage for `test_case_execution_status'.
		once
			create Result.put (Void)
		end

	ranking_of_program_state_aspects_cell: CELL [DS_ARRAYED_LIST [AFX_FIXING_TARGET]]
			-- Storage for the shared `ranking_of_program_state_aspects'.
		once
			create Result.put (Void)
		end

	ranking_of_program_state_expressions_cell: CELL [DS_ARRAYED_LIST [AFX_FIXING_TARGET]]
			-- Storage for the shared `ranking_of_program_state_expressions'.
		once
			create Result.put (Void)
		end

	invariants_from_passing_cell: CELL [DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]]
			-- Storage for `invariants_from_passing'.
		once
			create Result.put (Void)
		end

	invariants_from_failing_cell: CELL [DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]]
			-- Storage for `invariants_from_failing'.
		once
			create Result.put (Void)
		end

end
