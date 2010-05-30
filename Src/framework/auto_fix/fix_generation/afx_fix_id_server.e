note
	description: "Summary description for {AFX_FIX_ID_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_ID_SERVER

feature -- Access

	next_fix_id: INTEGER
			-- Next fix ID
		do
			Result := fix_id_cell.item
			fix_id_cell.put (Result + 1)
		end

feature{NONE} -- Implementation

	fix_id_cell: CELL [INTEGER]
			-- Cell to store next fix ID
		once
			create Result.put (1)
		end
end
