note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY

inherit
	AFX_TEST_CASE_EXECUTION_EVENT_LISTENER
		undefine
			is_equal, copy
		end

	DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
		rename
			make as make_hash_table,
			make_default as make_default_hash_table
		end

	AFX_SHARED_SESSION
		undefine
			is_equal, copy
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
		end

	make_default
			-- Initialization
		do
			make_equal (Default_initial_size)
		end

feature -- Access

--	current_test_case: EPA_TEST_CASE_INFO
--			-- Test case information.

	current_trace: AFX_PROGRAM_EXECUTION_TRACE
			-- The current trace.
		require
			current_test_case_set: current_test_case /= Void
		do
			Result := item (current_test_case)
		end

	passing_traces: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			-- Passing traces in the repository.
		do
			if passing_traces_cache = Void then
				classify_traces_by_status
			end
			Result := passing_traces_cache
		ensure
			result_attached: Result /= Void
		end

	failing_traces: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
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

feature -- Derived repository

	derived_repository (a_derived_skeleton: EPA_STATE_SKELETON): AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			-- Trace reposiroty derived from the Current,
			-- using the derived skeleton `a_derived_skeleton'.
		do
			create Result.make (count)
			from start
			until after
			loop
				Result.force (item_for_iteration.derived_trace (a_derived_skeleton), key_for_iteration)
				forth
			end
		end

--	derivation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
--			-- Trace repository derived from the Current repository,
--			-- using skeletons built on the existing state expressioins to model states.
--		do
--			if config.is_program_state_extended then
--				create Result.make (count)
--				from start
--				until after
--				loop
--					Result.force (item_for_iteration.derivation, key_for_iteration)
--					forth
--				end
--			else
--				Result := Current
--			end
--		end

feature -- Execution event listener

	is_test_case_new (a_tc: EPA_TEST_CASE_INFO): BOOLEAN
			-- <Precursor>
		do
			Result := not has(a_tc)
		end

	on_new_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			start_trace (a_tc)
		end

	on_breakpoint_hit (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_index: INTEGER)
			-- <Precursor>
		local
			l_execution_state: AFX_PROGRAM_EXECUTION_STATE
		do
			create l_execution_state.make_with_state_and_bp_index (a_state, a_index)
			current_trace.extend (l_execution_state)
		end

	on_application_exit
			-- <Precursor>
		do
			-- Do nothing.
		end

feature{NONE} -- Implementation

	start_trace (a_tc: EPA_TEST_CASE_INFO)
			-- Start a new execution trace, for test case `a_tc', in the repository.
			-- Set the new trace as the current trace.
		require
			new_tc: not has (a_tc)
		local
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
		do
			create l_trace.make (a_tc)
			l_trace.set_status_as_passing

			force (l_trace, a_tc)
			set_current_test_case (a_tc)

			reset_trace_classification
		ensure
			repository_count_increase: count = old count + 1
			new_trace_in_repository: has (a_tc)
		end

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
			l_tc: EPA_TEST_CASE_INFO
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
		do
			create passing_traces_cache.make_equal (count)
			create failing_traces_cache.make_equal (count)

			l_cursor := new_cursor
			from start
			until after
			loop
				l_tc := key_for_iteration
				l_trace := item_for_iteration
				if l_trace.is_failing then
					failing_traces_cache.force (l_trace, l_tc)
				elseif l_trace.is_passing then
					passing_traces_cache.force (l_trace, l_tc)
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

feature -- Constant

	Default_initial_size: INTEGER = 10
			-- Default initial size for the repository.

feature{NONE} -- Cache

	current_test_case_cache: EPA_TEST_CASE_INFO
			-- Cache for `current_test_case'.

	passing_traces_cache: like passing_traces
			-- Cache for `passing_traces'.

	failing_traces_cache: like failing_traces
			-- Cache for `failing_traces'.


invariant

	valid_current_test_case: current_test_case /= Void implies has (current_test_case)

end
