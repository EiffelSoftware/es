note
	description: "Summary description for {AFX_INTERPRETER}."
	author: ""
	date: ""
	revision: ""

class AFX_FIX_SELECTOR

create
	default_create
	
feature -- Access

	is_contract_enabled: BOOLEAN
			-- Is contract enabled in the feature?
		do
			Result := is_contract_enabled_cell.item
		end
		
	selected_fix_id: INTEGER
			-- ID of the fix currently active.
		do
			Result := selected_fix_id_cell.item
		end
		
feature -- Set

	set_contract_enabled (a_flag: BOOLEAN)
			-- Set `is_contract_enabled'.
		do
			is_contract_enabled_cell.put (a_flag)
		end

	select_fix_with_id (a_id: INTEGER)
			-- Select the fix with `a_id' as active.
		do
			selected_fix_id_cell.put (a_id)
		end
		
feature -- Storage

	is_contract_enabled_cell: CELL[BOOLEAN]
			-- Storage for `is_contract_enabled'.
		once
			create Result.put (True)
		end

	selected_fix_id_cell: CELL[INTEGER]
			-- Storage for the selected fix id cell.
		once
			create Result.put (0)
		end
		
end