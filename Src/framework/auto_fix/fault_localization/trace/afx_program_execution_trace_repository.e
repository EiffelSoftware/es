note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

inherit
	DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, STRING]
		rename
			make as make_hash_table,
			make_default as make_default_hash_table
		end

create
	make, make_default

feature -- Initialization

	make (a_size: INTEGER)
			-- Initialization.
		require
			size_big_enough: a_size > 0
		do
			make_equal (a_size)
			reset_trace_classification
		end

	make_default
			-- Initialization
		do
			make_equal (Default_initial_size)
			reset_trace_classification
		end

feature -- Access

	current_trace_id: STRING
			-- ID of the current trace.
		do
			Result := current_trace_id_cache
		end

	current_trace: AFX_PROGRAM_EXECUTION_TRACE
			-- The current trace.
		require
			current_trace_id_set: is_current_trace_id_set
		do
			Result := item (current_trace_id)
		end

	passing_traces: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, STRING]
			-- Passing traces in the repository.
		do
			if passing_traces_cache = Void then
				classify_traces_by_status
			end
			Result := passing_traces_cache
		ensure
			result_attached: Result /= Void
		end

	failing_traces: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, STRING]
			-- Failing traces in the repository.
		do
			if failing_traces_cache = Void then
				classify_traces_by_status
			end
			Result := failing_traces_cache
		ensure
			result_attached: Result /= Void
		end

	number_of_passing_traces: INTEGER
			-- Number of passing traces in the repository.
		do
			Result := passing_traces.count
		end

	number_of_failing_traces: INTEGER
			-- Number of failing traces in the repository.
		do
			Result := failing_traces.count
		end

feature -- Interpretation

	interpretation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			-- Interpretation of the current trace repository w.r.t. skeletons associated with the corresponding features.
		do
			create Result.make (count)
			from start
			until after
			loop
				Result.force (item_for_iteration.interpretation, key_for_iteration)
				forth
			end
		end

feature -- Status report

	is_current_trace_id_set: BOOLEAN
			-- Is `current_trace_id' set, i.e. can be used to get `current_trace'?
		do
			Result := current_trace_id /= Void and then has (current_trace_id)
		end

feature -- Operation

	start_trace_for_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- Start a new execution trace for `a_tc' in the repository.
			-- Set the new trace as the current trace.
		require
			new_id: a_tc /= Void and then not has (a_tc.uuid)
		do
			start_trace_with_id (a_tc.uuid)
			reset_trace_classification
		ensure
			repository_count_increase: count = old count + 1
			new_trace_in_repository: has (a_tc.uuid)
		end

	start_trace_with_id (a_id: STRING)
			-- Start a new execution trace, with `a_id', in the repository.
			-- Set the new trace as the current trace.
		require
			new_id: not has (a_id)
		local
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
		do
			create l_trace.make_with_id (a_id)
			l_trace.set_status_as_passing

			force (l_trace, a_id)
			set_current_trace_id (a_id)

			reset_trace_classification
		ensure
			repository_count_increase: count = old count + 1
			new_trace_in_repository: has (a_id)
		end

	extend_current_trace_with_execution_state (a_tc: EPA_TEST_CASE_INFO; a_execution_state: AFX_PROGRAM_EXECUTION_STATE)
			-- Extend current trace with `a_execution_state'.
		require
			current_trace_set: is_current_trace_id_set
			same_tc_id: a_tc /= Void and then current_trace_id = a_tc.uuid
		do
			current_trace.extend (a_execution_state)
		end

	extend_current_trace_with_state_and_index (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_index: INTEGER)
			-- Extend current trace with `a_state' and `a_index'.
		require
			current_trace_set: is_current_trace_id_set
			same_tc_id: a_tc /= Void and then current_trace_id = a_tc.uuid
		local
			l_execution_state: AFX_PROGRAM_EXECUTION_STATE
		do
			create l_execution_state.make_with_state_and_bp_index (a_state, a_index)
			current_trace.extend (l_execution_state)
		ensure
			current_trace_id_unchanged: old current_trace_id = current_trace_id
			repository_count_unchanged: old count = count
		end

feature{NONE} -- Implementation

	reset_trace_classification
			-- Reset the classification of traces by their statuses.
		do
			passing_traces_cache := Void
			failing_traces_cache := Void
		end

	classify_traces_by_status
			-- Classify traces into `passing_traces' and `failing_traces' by the status of the traces.
		require
			passing_traces_cache_void: passing_traces_cache = Void
			failing_traces_cache_void: failing_traces_cache = Void
		local
			l_id: STRING
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, STRING]
		do
			create passing_traces_cache.make_equal (count)
			create failing_traces_cache.make_equal (count)

			l_cursor := new_cursor
			from start
			until after
			loop
				l_id := key_for_iteration
				l_trace := item_for_iteration
				if l_trace.is_failing then
					failing_traces_cache.force (l_trace, l_id)
				elseif l_trace.is_passing then
					passing_traces_cache.force (l_trace, l_id)
				else
					check False end
				end
				forth
			end
			current.go_to (l_cursor)
		ensure
			passing_traces_cache_initialized: passing_traces_cache /= Void
			failing_traces_cache_initialized: failing_traces_cache /= Void
		end

feature{NONE} -- Status set

	set_current_trace_id (a_id: STRING)
			-- Set `current_trace_id'.
		require
			has_id: has (a_id)
		do
			current_trace_id_cache := a_id
		end

feature -- Constant

	Default_initial_size: INTEGER = 10
			-- Default initial size for the repository.

feature{NONE} -- Cache

	current_trace_id_cache: STRING
			-- Cache for `current_trace_id'.

	passing_traces_cache: like passing_traces
			-- Cache for `passing_traces'.

	failing_traces_cache: like failing_traces
			-- Cache for `failing_traces'.


end
