note
	description: "Summary description for {AFX_SHARED_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER

feature -- access

	state_transition_summary_manager: detachable AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER
			-- current state outline manager
		do
		    Result := state_transition_summary_manager_cell.item
		end

feature --setting

	set_state_transition_summary_manager (a_manager: like state_transition_summary_manager)
			-- set `a_manager' to be current manager
		do
		    state_transition_summary_manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = state_transition_summary_manager
		end

feature{NONE} -- implementation

	state_transition_summary_manager_cell: CELL[detachable AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER]
			-- once cell
		once
		    create Result.put (Void)
		ensure
		    state_transition_summary_manager_cell_not_void: Result /= Void
		end

end
