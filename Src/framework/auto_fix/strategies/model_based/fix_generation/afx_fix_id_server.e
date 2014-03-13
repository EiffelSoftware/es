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
			fix_id_cell.put (fix_id_cell.item + 1)
			Result := fix_id_cell.item
		end

feature -- Operation

	reset_fix_id
			-- Reset fix ID server.
		do
			fix_id_cell.put (0)
		end

feature{NONE} -- Implementation

	fix_id_cell: CELL [INTEGER]
			-- Cell to store next fix ID
		once
			create Result.put (0)
		end
end
