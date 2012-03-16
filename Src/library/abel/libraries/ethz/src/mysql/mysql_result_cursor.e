note
	description: "MySQL Result Cursor Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT_CURSOR

inherit
	ITERATION_CURSOR [ARRAY [STRING]]
		redefine
			target
		end

create
	make

feature -- Access

	item: ARRAY [STRING]
			-- Item at current cursor position
		do
			Result := item_internal
		end

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		do
			Result := target.row_count + 1 <= cursor_index
		end

feature {NONE} -- Implementation

	target: MYSQL_RESULT
			-- <Precursor>

	item_internal: ARRAY [STRING]
			-- Item at current cursor position
		require
			mysql_client_is_connected: target.mysql_client.is_connected
			is_open: target.is_open
		local
			i: INTEGER
			l_count: INTEGER
			l_target: like target
		do
			l_target := target
			l_target.go_i_th (cursor_index)
			create Result.make_filled (Void, 1, l_target.column_count)
			across 1 |..| l_target.column_count as l_indexes loop
				i := l_indexes.item
				Result.put (l_target.at (i), i)
			end
		end

end
