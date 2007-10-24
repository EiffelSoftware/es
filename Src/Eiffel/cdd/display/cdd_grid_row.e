indexing
	description: "Objects that represent a row in a CDD_GRID object"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID_ROW

inherit
	EV_GRID_ROW
		rename
			data as grid_line,
			set_data as set_grid_line
		redefine
			grid_line,
			parent
		end

create
	{CDD_GRID} default_create


feature -- Access

	is_binded: BOOLEAN is
			-- Is `Current' binded to some grid_line?
		do
			Result := grid_line /= Void
		ensure
			correct_result: Result = (grid_line /= Void)
		end


	grid_line: CDD_GRID_LINE [COMPARABLE]
			-- CDD_GRID_LINE associated to `Current'

	parent: CDD_GRID is
			-- Grid in which `Current' is displayed
		do
			Result ?= Precursor
		end


	next: like Current is
			-- Next row in grid, which lies at same tree depth as `Current',
			-- Void if there is none
		require
			not_destroyed: not is_destroyed
			is_parented: parent /= Void
		local
			i: INTEGER
		do
			i := index + subrow_count_recursive + 1
			if i <= parent.row_count and then parent.row (i).parent_row = parent_row then
				Result := parent.row (i)
			end
		end

end -- Class CDD_GRID_ROW
