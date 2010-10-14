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
			make as make_hash_table
		end

create
	make

feature -- Initialization

	make
			-- Initialization
		do
			make_equal (Default_initial_size)
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


end
