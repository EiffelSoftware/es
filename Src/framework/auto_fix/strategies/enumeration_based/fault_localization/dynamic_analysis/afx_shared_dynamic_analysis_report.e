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

	all_test_cases: LINKED_LIST [EPA_TEST_CASE_INFO]
			-- All test cases.
		do
			Result := all_test_cases_cell.item
		end

	all_passing_test_cases: LINKED_LIST [EPA_TEST_CASE_INFO]
			-- All passing test cases.
		do
			Result := all_passing_test_cases_cell.item
		end

	all_failing_test_cases: LINKED_LIST [EPA_TEST_CASE_INFO]
			-- All failing test cases.
		do
			Result := all_failing_test_cases_cell.item
		end

	test_case_execution_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_SUMMARY, EPA_TEST_CASE_INFO]
			-- Table of test case execution status (including both passing and failing test cases)
			-- Key is test case, value is the execution status of that test case.
		require
			trace_repository_attached: trace_repository /= Void
		local
			l_repository_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			l_test_case: EPA_TEST_CASE_INFO
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_entry_state, l_exit_state: EPA_STATE
			l_exception: AFX_EXCEPTION_SIGNATURE
			l_summary: AFX_TEST_CASE_EXECUTION_SUMMARY
		do
			Result := test_case_execution_status_cell.item
			if Result = Void then
				create Result.make (trace_repository.count + 1)
				from
					l_repository_cursor := trace_repository.new_cursor
					l_repository_cursor.start
				until
					l_repository_cursor.after
				loop
					l_test_case := l_repository_cursor.key
					l_trace := l_repository_cursor.item

					if not l_trace.is_empty then
						l_entry_state := l_trace.first.state
						l_exit_state := l_trace.last.state
						l_exception := l_trace.exception_signature

						if l_trace.is_passing then
							create l_summary.make_passing (l_test_case, l_entry_state, l_exit_state)
						elseif l_trace.is_failing then
							create l_summary.make_failing (l_test_case, l_entry_state, l_exception)
						end
						Result.force (l_summary, l_test_case)
					end

					l_repository_cursor.forth
				end
				set_test_case_execution_status (Result)
			end
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

	register_invariants (a_passing, a_failing: DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS])
			-- Register `a_passing' and `a_failing' as the passing and failing invariants.
		do
			invariants_from_passing_cell.put (a_passing)
			invariants_from_failing_cell.put (a_failing)
		end

	invariants_from_passing (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): DS_HASH_TABLE [EPA_STATE, INTEGER]
			-- Invariants inferred based on passing executions.
		require
			feature_attached: a_feature /= Void
		do
			Result := invariants_from_passing_cell.item.item (a_feature)
		end

	invariants_from_failing (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): DS_HASH_TABLE [EPA_STATE, INTEGER]
			-- Invariants inferred based on failing executions.
		require
			feature_attached: a_feature /= Void
		do
			Result := invariants_from_failing_cell.item.item (a_feature)
		end

feature -- Reset

	reset_report
			-- Reset the dynamic analysis report.
		do
			reset_trace_repository
			reset_test_case_execution_status
			reset_invariants
		end

	reset_trace_repository
			-- Reset `trace_repository' to be an empty repository.
		do
			set_trace_repository (create {AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY}.make_default)
		end

	reset_test_case_execution_status
			-- Reset `test_case_execution_status' to contain no status information.
		do
			set_test_case_execution_status (Void)
		end

	reset_invariants
			-- Reset invariant information.
		do
			invariants_from_passing_cell.put (Void)
			invariants_from_failing_cell.put (Void)
		end

feature -- Basic operation

	invariants_at (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_bp_index: INTEGER; a_mode: INTEGER): EPA_STATE
			-- Invariants inferred at the breakpoint `a_bp_index' in `a_feature'.
			-- `a_mode' indicates which kind of invariants to return.
		require
			feature_attached: a_feature /= Void
			valid_index: a_bp_index > 0
			valid_mode: is_valid_invariant_access_mode (a_mode)
			invariants_available: invariants_from_failing (a_feature) /= Void and then invariants_from_passing (a_feature) /= Void
		local
			l_ppt: DKN_PROGRAM_POINT
			l_ppt_name: STRING
			l_invariants_from_passing, l_invariants_from_failing: DS_HASH_TABLE [EPA_STATE, INTEGER]
			l_invariants_p, l_invariants_f: EPA_STATE
		do
				-- Invariants from passing executions.
			l_invariants_from_passing := invariants_from_passing (a_feature)
			if l_invariants_from_passing.has (a_bp_index) then
				l_invariants_p := l_invariants_from_passing.item (a_bp_index)
			end

				-- Invariants from failing executions.
			l_invariants_from_failing := invariants_from_failing (a_feature)
			if l_invariants_from_failing.has (a_bp_index) then
				l_invariants_f := l_invariants_from_failing.item (a_bp_index)
			end

				-- Result invariants.
			inspect a_mode
			when Invariant_passing_all then
				Result := l_invariants_p
			when Invariant_passing_only then
				if attached l_invariants_p and then attached l_invariants_f then
					Result := l_invariants_p.subtraction (l_invariants_f)
				else
					Result := l_invariants_p
				end
			when Invariant_failing_all then
				Result := l_invariants_f
			when Invariant_failing_only then
				if attached l_invariants_f and then attached l_invariants_p then
					Result := l_invariants_f.subtraction (l_invariants_p)
				else
					Result := l_invariants_f
				end
			end
		end


feature -- Status set

	set_trace_repository (a_repository: like trace_repository)
			-- Set `trace_repository'.
		require
			repository_attached: a_repository /= Void
		do
			trace_repository_cell.put (a_repository)
		end

	set_test_case_execution_status (a_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_SUMMARY, EPA_TEST_CASE_INFO])
			-- Set `test_case_execution_status'.
		require
			status_attached: a_status /= Void
		local
			l_all, l_passing, l_failing: LINKED_LIST [EPA_TEST_CASE_INFO]
			l_tc: EPA_TEST_CASE_INFO
		do
			test_case_execution_status_cell.put (a_status)
			if a_status /= Void then
				create l_all.make
				create l_passing.make
				create l_failing.make
				from
					a_status.start
				until
					a_status.after
				loop
					l_tc := a_status.key_for_iteration
					l_all.extend (l_tc)
					if a_status.item_for_iteration.is_passing then
						l_passing.extend (l_tc)
					else
						l_failing.extend (l_tc)
					end
					a_status.forth
				end
			end
			all_test_cases_cell.put (l_all)
			all_passing_test_cases_cell.put (l_passing)
			all_failing_test_cases_cell.put (l_failing)
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

	set_fixing_target_list (a_list: like fixing_target_list)
			-- Set `fixing_target_list'.
		require
			list_attached: a_list /= Void
		do
			fixing_target_list_cell.put (a_list)
		end


feature{NONE} -- Storage

	trace_repository_cell : CELL [AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY]
			-- Storage for the shared `trace_repository'.
		once
			create Result.put (Void)
		end

	test_case_execution_status_cell: CELL [HASH_TABLE [AFX_TEST_CASE_EXECUTION_SUMMARY, EPA_TEST_CASE_INFO]]
			-- Storage for `test_case_execution_status'.
		once
			create Result.put (Void)
		end

	all_test_cases_cell: CELL[LINKED_LIST [EPA_TEST_CASE_INFO]]
			-- Storage for `all_test_cases'.
		once
			create Result.put (Void)
		end

	all_passing_test_cases_cell: CELL [LINKED_LIST [EPA_TEST_CASE_INFO]]
			-- Storage for `all_test_cases'.
		once
			create Result.put (Void)
		end

	all_failing_test_cases_cell: CELL [LINKED_LIST [EPA_TEST_CASE_INFO]]
			-- Storage for `all_test_cases'.
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

	fixing_target_list_cell: CELL [DS_ARRAYED_LIST [AFX_FIXING_TARGET]]
			-- Cell for `fixing_target_list'.
		once
			create Result.put (Void)
		end

	invariants_from_passing_cell: CELL [DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]]
			-- Storage for `invariants_from_passing'.
		once
			create Result.put (Void)
		end

	invariants_from_failing_cell: CELL [DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]]
			-- Storage for `invariants_from_failing'.
		once
			create Result.put (Void)
		end

end
