note
	description: "MySQL Result Cursor Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT_CURSOR

inherit
	ITERATION_CURSOR [MYSQL_RESULT]
		redefine
			target
		end

create
	make

feature -- Access

	item: MYSQL_RESULT
			-- Item at current cursor position
		do
			target.go_i_th (cursor_index)
			Result := target
		end

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		do
			Result := target.row_count <= cursor_index
		end

feature {NONE} -- Implementation

	target: MYSQL_RESULT
			-- <Precursor>

end
