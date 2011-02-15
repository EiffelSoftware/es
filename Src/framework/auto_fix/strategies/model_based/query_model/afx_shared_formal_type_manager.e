note
	description: "Summary description for {AFX_SHARED_FORMAL_TYPE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_FORMAL_TYPE_MANAGER

feature -- Access

	formal_type_manager: detachable AFX_FORMAL_TYPE_MANAGER
			-- Shared formal type manager.
		do
		    Result := manager_cell.item
		end

feature --Setting

	set_formal_type_manager (a_manager: like formal_type_manager)
			-- Set shared formal type manager to be `a_manager'.
		do
		    manager_cell.put (a_manager)
		ensure
		    manager_set: a_manager = formal_type_manager
		end

feature{NONE} -- Implementation

	manager_cell: CELL[detachable AFX_FORMAL_TYPE_MANAGER]
			-- Internal storage for shared manager.
		once
		    create Result.put (Void)
		ensure
		    manager_cell_not_void: Result /= Void
		end

end
