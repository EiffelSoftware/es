indexing
	description: "Objects that represent grids containing rows of type CDD_GRID_ROW"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID

inherit
	EV_GRID
		redefine
			row_type,
			row
		end

feature -- Access

	row_type: CDD_GRID_ROW
			-- Row type for EV_GRID

	row (a_row: INTEGER): like row_type is
			-- Row at index `a_row'.
		do
			Result ?= Precursor (a_row)
		end

end
