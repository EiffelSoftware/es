note
	description: "Summary description for {AFX_EXECUTION_TRACE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXECUTION_TRACE_ANALYZER

feature -- Access

	trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY assign set_trace_repository
			-- Repository of execution traces.

	ranking: DS_ARRAYED_LIST [TUPLE [INTEGER, EPA_EXPRESSION, REAL]]
			-- Ranking of <breakpoint_index, expression> pairs in descending order of their suspiciousness values.
			-- [breakpoint_index, expression, suspiciousness_value]
		do
			if ranking_cache = Void then
				create ranking_cache.make (20)
			end
			Result := ranking_cache
		end

	statistic_collection: DS_HASH_TABLE [AFX_EXECUTION_TRACE_STATISTIC, STRING]
			-- Collection of statistics from `trace_repository'.
		require
			trace_repository_attached: trace_repository /= Void
		local
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_statistic: AFX_EXECUTION_TRACE_STATISTIC
		do
			if statistic_collection_cache = Void then
				create statistic_collection_cache.make_equal (trace_repository.count)

				from trace_repository.start
				until trace_repository.after
				loop
					l_trace := trace_repository.item_for_iteration

					check unique_id: not statistic_collection_cache.has (l_trace.id) end
					create l_statistic.make_from_trace (l_trace)
					statistic_collection_cache.force (l_statistic, l_trace.id)

					trace_repository.forth
				end
			end
			Result := statistic_collection_cache
		end

feature -- Basic operation

	compute_ranking
			-- Compute a ranking of suspicious program states, and make the result
			--		available in `ranking'.
		require
			trace_repository_not_empty: trace_repository /= VOid and then not trace_repository.is_empty
		deferred
		end

	reset_analyzer
			-- Reset analyzer.
		do
			statistic_collection_cache := Void
			ranking_cache := Void
		end

feature -- Status set

	set_trace_repository (a_repository: like trace_repository)
			-- Set `trace_repository'.
		require
			repository_attached: a_repository /= Void
		do
			trace_repository := a_repository

			reset_analyzer
		end

feature{NONE} -- Implementation

	ranking_cache: like ranking
			-- Cache for `ranking'.

	statistic_collection_cache: like statistic_collection
			-- Cache for `statistic_collection'.

end
