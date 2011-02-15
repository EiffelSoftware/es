note
	description: "Summary description for {AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

feature -- Access

	boolean_state_outline_manager: detachable AFX_BOOLEAN_STATE_OUTLINE_MANAGER
			-- Shared boolean state outline manager.
		do
		    Result := boolean_manager_cell.item
		end

feature --Setting

	set_boolean_state_manager (a_manager: like boolean_state_outline_manager)
			-- Set the shared boolean state outline manager to be `a_manager'.
		do
		    boolean_manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = boolean_state_outline_manager
		end

feature{NONE} -- Implementation

	boolean_manager_cell: CELL[detachable AFX_BOOLEAN_STATE_OUTLINE_MANAGER]
			-- Internal storage for shared boolean state outline manager.
		once
		    create Result.put (Void)
		ensure
		    boolean_manager_cell_not_void: Result /= Void
		end

end
