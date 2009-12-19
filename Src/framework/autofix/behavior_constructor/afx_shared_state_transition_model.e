note
	description: "Summary description for {AFX_SHARED_STATE_TRANSITION_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_STATE_TRANSITION_MODEL

feature -- Access

	state_transition_summary_manager: detachable AFX_FORWARD_STATE_TRANSITION_MODEL
			-- Shared state transition summary manager.
		do
		    Result := state_transition_summary_manager_cell.item
		end

feature --Setting

	set_state_transition_summary_manager (a_manager: like state_transition_summary_manager)
			-- Set state transition summary manager to be `a_manager'.
		do
		    state_transition_summary_manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = state_transition_summary_manager
		end

feature{NONE} -- Implementation

	state_transition_summary_manager_cell: CELL[detachable AFX_FORWARD_STATE_TRANSITION_MODEL]
			-- Internal storage.
		once
		    create Result.put (Void)
		ensure
		    state_transition_summary_manager_cell_not_void: Result /= Void
		end

end
