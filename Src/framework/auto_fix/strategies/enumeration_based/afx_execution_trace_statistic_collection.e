note
	description: "Summary description for {AFX_EXECUTION_TRACE_STATISTIC_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXECUTION_TRACE_STATISTIC_COLLECTION

inherit
	DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_TABLE [REAL, STRING],  EPA_EXPRESSION], INTEGER]
--	DS_HASH_TABLE [AFX_EXECUTION_TRACE_STATISTIC, STRING]

create
	make_with_default_capacity, make_with_capacity

feature -- Initialization

	make_with_default_capacity
			-- Initialization.
		do
			initial_capacity := default_capacity
		end

	make_with_capacity (a_capacity: INTEGER)
			-- Initialization.
		require
			valid_capacity: a_capacity > 0
		do
			initial_capacity := a_capacity
		end

feature -- Access

	statistic_collection: DS_HASH_TABLE [AFX_EXECUTION_TRACE_STATISTIC, STRING]
			-- Collection of statistics.
			-- Key: trace id.
			-- Val: statistic from the trace.
		do
			if statistic_collection_cache = Void then
				create statistic_collection_cache.make_equal (initial_capacity)
			end

			Result := statistic_collection_cache
		end

	statistics_table: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_TABLE [REAL, STRING],  EPA_EXPRESSION], INTEGER]
			-- Table of statistics.
			-- Occurrence <- Trace_id <- Expression <- Breakpoint_index
		do
			if statistics_table_cache = Void then
				create statistics_table_cache.make_equal (20)
			end

			Result := statistics_table_cache
		end

feature -- Basic operation

	reset_collection
			-- Wipe out all statistics from the collection.
		do
			statistic_collection_cache := Void
			statistics_table_cache := Void
		end

	add_statistic (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Add statistic information regarding a trace `a_trace'.
		require
			trace_attached: a_trace /= Void
			unique_id: not statistic_collection.has (a_trace.id)
		local
			l_statistic: AFX_EXECUTION_TRACE_STATISTIC
		do
			create l_statistic.make_from_trace (a_trace)
			statistic_collection.force (l_statistic, a_trace.id)
		end

	statistics_as_nested_table: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_TABLE [REAL, STRING],  EPA_EXPRESSION], INTEGER]

feature{NONE} -- Implementation

	initial_capacity: INTEGER
			-- Initial capacity of the collection.

feature{NONE} -- Cache

	statistic_collection_cache: like statistic_collection
			-- Cache for `statistic_collection'.

	statistics_table_cache: like statistics_table
			-- Cache for `statistics_table'.

end
