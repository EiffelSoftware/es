note
	description: "Summary description for {AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

feature -- access

	boolean_state_outline_manager: detachable AFX_BOOLEAN_STATE_OUTLINE_MANAGER
			-- current state outline manager
		do
		    Result := boolean_manager_cell.item
		end

feature --setting

	set_boolean_state_manager (a_manager: like boolean_state_outline_manager)
			-- set `a_manager' to be current manager
		do
		    boolean_manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = boolean_state_outline_manager
		end

feature{NONE} -- implementation

	boolean_manager_cell: CELL[detachable AFX_BOOLEAN_STATE_OUTLINE_MANAGER]
			-- once cell
		once
		    create Result.put (Void)
		ensure
		    boolean_manager_cell_not_void: Result /= Void
		end

end
