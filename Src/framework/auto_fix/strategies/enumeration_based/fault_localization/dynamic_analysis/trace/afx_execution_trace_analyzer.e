note
	description: "Summary description for {AFX_EXECUTION_TRACE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXECUTION_TRACE_ANALYZER

inherit

	AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE

	AFX_SHARED_SESSION

	AFX_UTILITY

feature -- Access

	statistics_from_passing: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistics on occurrences of <exp, val> at each breakpoint from all passing test cases.

	statistics_from_failing: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistics on occurrences of <exp, val> at each breakpoint from all failing test cases.

feature -- Interesting breakpoints per feature

	breakpoints_for_features: DS_HASH_TABLE [DS_LINEAR [INTEGER], AFX_FEATURE_TO_MONITOR]
			-- Map from features to the set of breakpoints to analyze for those features.
		do
			if breakpoints_for_features_cache = Void then
				create breakpoints_for_features_cache.make_equal (5)
			end
			Result := breakpoints_for_features_cache
		end

	add_breakpoints_for_feature (a_breakpoints: DS_LINEAR [INTEGER]; a_feature: AFX_FEATURE_TO_MONITOR)
			--
		require
			a_breakpoints /= Void
			a_feature /= Void
			not breakpoints_for_features.has (a_feature)
		do
			breakpoints_for_features.force (a_breakpoints, a_feature)
		end

feature{NONE} -- Interesting breakpoints per feature (implementation)

	breakpoints_for_features_cache: like breakpoints_for_features
			-- Cache for `breakpoints_for_features'.

feature -- Basic operation

	collect_statistics_from_trace_repository (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_merge_mode: INTEGER)
			-- Collect statistics from `a_trace_repository'.
		require
			trace_repository_attached: a_trace_repository /= Void
			is_valid_merge_mode: is_valid_merge_mode (a_merge_mode)
		local
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_statistics_from_passing, l_statistics_from_failing, l_statistics: AFX_EXECUTION_TRACE_STATISTICS
		do
			create statistics_from_passing.make_trace_unspecific (10)
			create statistics_from_failing.make_trace_unspecific (10)

			from a_trace_repository.start
			until a_trace_repository.after
			loop
				l_trace := a_trace_repository.item_for_iteration

				l_statistics := l_trace.statistics
				if l_trace.is_passing then
					statistics_from_passing.merge (l_statistics, a_merge_mode)
				elseif l_trace.is_failing then
					statistics_from_failing.merge (l_statistics, a_merge_mode)
				end

				a_trace_repository.forth
			end

			prune_uninteresting_statistics (statistics_from_passing)
			prune_uninteresting_statistics (statistics_from_failing)
		end

feature{NONE} -- Implementation

	prune_uninteresting_statistics (a_statistics: AFX_EXECUTION_TRACE_STATISTICS)
			-- Remove statistics about breakpoint indexes out of the valid range.
			-- `a_statistics': the statistics to change.
		require
			statistics_attached: a_statistics /= Void
		local
			l_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]

			l_set: DS_HASH_SET [AFX_PROGRAM_LOCATION]
			l_table_cursor: DS_HASH_TABLE_CURSOR [EPA_HASH_SET [AFX_FIXING_TARGET], AFX_PROGRAM_LOCATION]
			l_key: AFX_PROGRAM_LOCATION
		do
			l_map := features_to_monitor_by_names (breakpoints_for_features.keys)

			from
				create l_set.make (a_statistics.count)
				l_table_cursor := a_statistics.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_key := l_table_cursor.key

				if not l_map.has (l_key.context.qualified_feature_name) or else not breakpoints_for_features.item (l_map.item (l_key.context.qualified_feature_name)).has (l_key.breakpoint_index) then
					l_set.force (l_key)
				end

				l_table_cursor.forth
			end

			l_set.do_all (agent a_statistics.remove)
		end

end

