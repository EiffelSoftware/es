note
	description: "Summary description for {AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER

feature -- access

	state_outline_manager: detachable AFX_QUERY_STATE_OUTLINE_MANAGER
			-- current state outline manager
		do
		    Result := manager_cell.item
		end

feature --setting

	set_state_manager (a_manager: like state_outline_manager)
			-- set `a_manager' to be current manager
		do
		    manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = state_outline_manager
		end

feature{NONE} -- implementation

	manager_cell: CELL[detachable AFX_QUERY_STATE_OUTLINE_MANAGER]
			-- once cell
		once
		    create Result.put (Void)
		ensure
		    manager_cell_not_void: Result /= Void
		end

end
