note
	description: "Summary description for {AFX_STATE_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_SERVER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			create state.make (10)
			state.compare_objects
		end

feature -- Access

	state_for_fault (a_tc: EPA_TEST_CASE_INFO): detachable like state_type
			-- State invariants from passing an failing test cases for the fault indicated in `a_tc'
		do
			Result := state.item (a_tc)
		end

feature -- Status report

	hast_state_for_fault (a_tc: EPA_TEST_CASE_INFO): BOOLEAN
			 -- Does state information for the fault indicated in `a_tc'
			 -- exist?
		do
			Result := state.has (a_tc)
		end

feature -- Setting

	put_state_for_fault (a_tc: EPA_TEST_CASE_INFO; a_state: like state_type)
			-- Associate fault indicated in `a_tc' with state `a_state'.
		do
			state.force (a_state, a_tc)
		end

	state: HASH_TABLE [like state_type, EPA_TEST_CASE_INFO]
			-- State information for each fault identified by the key of the table.
			-- The key is a fault identifier, see {AFX_TEST_CASE_INFO} for details.
			-- Value is a pair of states, one for passing test cases, and one for failing test cases.

feature -- Access

	state_type: TUPLE [passing: AFX_DAIKON_RESULT; failing: AFX_DAIKON_RESULT]
			-- Type anchor

end
