note
	description: "Summary description for {AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER

feature -- Access

	state_outline_manager: detachable AFX_QUERY_STATE_OUTLINE_MANAGER
			-- Shared query state outline manager.
		do
		    Result := manager_cell.item
		end

feature --Setting

	set_state_manager (a_manager: like state_outline_manager)
			-- Set shared query state outline manager to be `a_manager'.
		do
		    manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = state_outline_manager
		end

feature{NONE} -- Implementation

	manager_cell: CELL[detachable AFX_QUERY_STATE_OUTLINE_MANAGER]
			-- Storage for shared query state outline manager.
		once
		    create Result.put (Void)
		ensure
		    manager_cell_not_void: Result /= Void
		end

end
