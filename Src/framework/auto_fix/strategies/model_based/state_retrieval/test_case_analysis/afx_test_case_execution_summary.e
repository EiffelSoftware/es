note
	description: "Summary description for {AFX_TEST_CASE_EXECUTION_STATUS_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_EXECUTION_SUMMARY

inherit
	HASHABLE

	AFX_STATE_DISTANCE_CALCULATOR

create
	make, make_passing, make_failing

feature{NONE} -- Initialization

	make (a_tc: EPA_TEST_CASE_INFO; a_entry_state, a_exit_state: EPA_STATE)
			-- Initialization.
		do
			test_case := a_tc
			entry_state := a_entry_state
			exit_state := a_exit_state
		end

	make_passing (a_tc: EPA_TEST_CASE_INFO; a_entry_state, a_exit_state: EPA_STATE)
			-- Initialization.
		do
			test_case := a_tc
			is_passing := True
			entry_state := a_entry_state
			exit_state := a_exit_state
		end

	make_failing (a_tc: EPA_TEST_CASE_INFO; a_entry_state: EPA_STATE; a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Initialization.
		do
			test_case := a_tc
			is_passing := False
			entry_state := a_entry_state
			exception_signature := a_signature
		end

feature -- Access

	test_case: EPA_TEST_CASE_INFO
			-- Test case related to the execution summary.

	entry_state: EPA_STATE
			-- State when test case starts.

	exit_state: EPA_STATE
			-- State when test case terminates.

	exception_signature: AFX_EXCEPTION_SIGNATURE
			-- Signature of the exception in case of a failing test case.

feature -- Status report

	is_passing: BOOLEAN
			-- Is the execution passing?

feature -- Basic operation

	exit_state_distance (other: like Current): INTEGER_32
			-- Distance between exit_state and `other'.exit_state
		require
			exit_state_attached: exit_state /= Void
			other_exit_state_attached: other.exit_state /= Void
		do
			Result := distance (exit_state, other.exit_state)
		end

feature -- Status set

	set_entry_state (a_state: EPA_STATE)
			-- Set `entry_state'.
		do
			entry_state := a_state
		end

	set_exit_state (a_state: EPA_STATE)
			-- Set `exit_state'.
		do
			exit_state := a_state
		end

feature -- Access

	hash_code: INTEGER_32
			-- Hash code value
		do
			Result := test_case.id.hash_code
		end


end
