indexing
	description: "Summary description for {SAT_SHARED_EDITOR_TOKEN_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_SHARED_EDITOR_TOKEN_CONSTANTS

feature -- Access

	is_visited: BOOLEAN is
			-- Is visited?
		do
			Result := visited_cell.item
		end

feature -- Setting

	set_visited (b: BOOLEAN) is
			-- Set `is_visited' with `b'.
		do
			visited_cell.put (b)
		end

feature{NONE} -- Implementation

	visited_cell: CELL [BOOLEAN] is
		once
			create Result.put (False)
		end

end
