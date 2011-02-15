note
	description: "Summary description for {AFX_EXECUTION_TRACE_ANALYZER}."
	author: ""
	date: "$Date: 2010-10-14 11:28:34 +0200 (ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¥ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¨ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¥ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ, 14 ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¥ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¦ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ 2010) $"
	revision: "$Revision$"

class
	AFX_EXECUTION_TRACE_ANALYZER

inherit

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE

	AFX_SHARED_SESSION

feature -- Access

	breakpoint_index_range: TUPLE [min, max: INTEGER] assign set_breakpoint_index_range
			-- Breakpoint index range.
			-- Only states between `min' to `max' would be ranked.

	number_of_passing_traces: INTEGER
			-- Number of passing traces considered in analysis.
		require
			trace_repository_attached: trace_repository /= Void
		do
			Result := trace_repository.number_of_passing_traces
		end

	number_of_failing_traces: INTEGER
			-- Number of failing traces considered in analysis.
		require
			trace_repository_attached: trace_repository /= Void
		do
			Result := trace_repository.number_of_failing_traces
		end

feature -- Status report

	is_breakpoint_index_range_valid: BOOLEAN
			-- Is `breakpoint_index_range' denoting a valid range?
		do
			Result := breakpoint_index_range.min > 0 and breakpoint_index_range.min <= breakpoint_index_range.max
		end

	is_breakpoint_within_range (a_bp_index: INTEGER): BOOLEAN
			-- Is breakpoint index `a_bp_index' within the range of `breakpoint_index_range'?
		do
			Result := a_bp_index >= breakpoint_index_range.min and then a_bp_index <= breakpoint_index_range.max
		end

feature -- Basic operation

	collect_statistics_from_trace_repository (a_merge_mode: INTEGER)
			-- Collect statistics from `trace_repository'.
		require
			trace_repository_attached: trace_repository /= Void
			is_valid_merge_mode: is_valid_merge_mode (a_merge_mode)
		local
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_statistics_from_passing, l_statistics_from_failing, l_statistics: AFX_EXECUTION_TRACE_STATISTICS
		do
			create l_statistics_from_passing.make_trace_unspecific (10)
			create l_statistics_from_failing.make_trace_unspecific (10)

			from trace_repository.start
			until trace_repository.after
			loop
				l_trace := trace_repository.item_for_iteration

				l_statistics := l_trace.statistics
				if l_trace.is_passing then
					l_statistics_from_passing.merge (l_statistics, a_merge_mode)
				elseif l_trace.is_failing then
					l_statistics_from_failing.merge (l_statistics, a_merge_mode)
				else
					check False end
				end

				trace_repository.forth
			end

			remove_statistics_out_of_valid_breakpoint_index_range (l_statistics_from_passing)
			remove_statistics_out_of_valid_breakpoint_index_range (l_statistics_from_failing)

			set_statistics_from_passing (l_statistics_from_passing)
			set_statistics_from_failing (l_statistics_from_failing)
		end

	clear_statistics
			-- Clear all statistic information from the analyzer.
		do
			set_statistics_from_passing (Void)
			set_statistics_from_failing (Void)
		end

feature -- Status set

	set_breakpoint_index_range (a_range: like breakpoint_index_range)
			-- Set `breakpoint_index_range'.
		require
			valid_range: a_range.min > 0 and a_range.min <= a_range.max
		do
			breakpoint_index_range := a_range
		ensure
			breakpoint_index_range_valid: is_breakpoint_index_range_valid
		end

feature{NONE} -- Implementation

	remove_statistics_out_of_valid_breakpoint_index_range (a_statistics: AFX_EXECUTION_TRACE_STATISTICS)
			-- Remove statistics about breakpoint indexes out of the valid range.
			-- `a_statistics': the statistics to change.
		require
			statistics_attached: a_statistics /= Void
		local
			l_set: DS_HASH_SET [INTEGER]
			l_table_cursor: DS_HASH_TABLE_CURSOR [EPA_HASH_SET [AFX_FIXING_TARGET], INTEGER_32]
			l_key: INTEGER
		do
			if is_breakpoint_index_range_valid then
				create l_set.make (a_statistics.count)
				from
					l_table_cursor := a_statistics.new_cursor
					l_table_cursor.start
				until
					l_table_cursor.after
				loop
					l_key := l_table_cursor.key
					if not is_breakpoint_within_range (l_key) then
						l_set.force (l_key)
					end
					l_table_cursor.forth
				end

				l_set.do_all (agent a_statistics.remove)
			end
		end

--feature{NONE} -- Access

--	statistics_from_passing: AFX_EXECUTION_TRACE_STATISTICS
--			-- Number of hits of an expression at a breakpoint slot from all passing test cases.
--		do
--			if statistics_from_passing_cache = VOid then
--				create statistics_from_passing_cache.make_trace_unspecific (10)
--			end
--			Result := statistics_from_passing_cache
--		end

--	statistics_from_failing: AFX_EXECUTION_TRACE_STATISTICS
--			-- Number of hits of an expression at a breakpoint slot from all failing test cases.
--		do
--			if statistics_from_failing_cache = VOid then
--				create statistics_from_failing_cache.make_trace_unspecific (10)
--			end
--			Result := statistics_from_failing_cache
--		end

--feature{NONE} -- Cache

--	statistics_from_passing_cache: like statistics_from_passing
--			-- Cache for `number_of_hits_from_passing'.

--	statistics_from_failing_cache: like statistics_from_failing
--			-- Cache for `number_of_hits_from_failing'.

end
