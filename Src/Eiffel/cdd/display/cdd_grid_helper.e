indexing
	description: "Objects that have sublines displaying attributes of a CDD_TEST_CASE"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_GRID_HELPER [reference G -> COMPARABLE, H -> CDD_GRID_LINE [G]]

feature -- Access

	first_subrow: CDD_GRID_ROW is
			-- First row of all subrows
		deferred
		ensure
			not_void_implies_not_destroyed: (Result /= Void) implies (not Result.is_destroyed)
			not_void_implies_is_parented: (Result /= Void) implies (Result.parent /= Void)
		end

	data_from_test_case (a_tc: CDD_TEST_CASE): G is
			-- Attribute of `a_tc' displayed in sublines of `Current'.
		require
			a_tc_not_void: a_tc /= Void
		deferred
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Access

	max_row_index: INTEGER is
			-- Maximum index for inserting a new row
			-- (Used to create a new last subrow)
		deferred
		end

feature {NONE} -- Cursor movement

	locate_position (some_data: G): CDD_GRID_ROW is
			-- Cursor which points to the correct position where an
			-- item containing `some_data' is or should be located.
		do
			from
				Result := first_subrow
			until
				Result = Void or some_data <= Result.grid_line.row_data
			loop
				Result := Result.next
			end
		end

feature {NONE} -- Element change

	insert_new_row (i: INTEGER) is
			-- Insert a new row into grid at position `i'.
		require
			valid_index: i > 0 and i <= max_row_index
		deferred
		ensure
			one_more: max_row_index = old max_row_index + 1
		end

	create_new_line (a_row_index: INTEGER; some_data: G) is
			-- Create a new line for displaying `some_data' with row at position `a_row_index'.
		require
			valid_row_index: a_row_index > 0 and a_row_index <= max_row_index
			some_data_not_void: some_data /= Void
		deferred
		ensure
			last_created_item_not_void: last_created_line /= Void
			last_created_item_valid: last_created_line.is_binded_to_grid and then last_created_line.grid_row.parent /= Void
			last_created_item_correct_row: last_created_line.grid_row.index = a_row_index
			last_created_item_correct_data: last_created_line.row_data = some_data
		end

	last_created_line: H
			-- Last line inserted by `create_new_item'

feature -- Element change

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Display `a_tc' in tree structure.
		require
			a_tc_not_void: a_tc /= Void
		local
			l_data: G
			l_row: CDD_GRID_ROW
			l_pos: INTEGER
			l_line: H
		do
			l_data := data_from_test_case (a_tc)
			l_row := locate_position (l_data)
			if l_row /= Void then
				l_pos := l_row.index
			else
				l_pos := max_row_index
			end
			if l_row = Void or else not l_row.grid_line.row_data.is_equal (l_data) then
				insert_new_row (l_pos)
				create_new_line (l_pos, l_data)
				l_line := last_created_line
			else
				l_line ?= l_row.grid_line
			end
			l_line.add_test_case (a_tc)
			if l_line.grid_row.is_expandable then
				l_line.grid_row.expand
			end
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove `a_tc' from tree structure.
		require
			a_tc_not_void: a_tc /= Void
		local
			l_row: CDD_GRID_ROW
		do
			l_row := locate_position (data_from_test_case (a_tc))
			l_row.grid_line.remove_test_case (a_tc)
			if l_row.subrow_count = 0 then
				l_row.parent.remove_row (l_row.index)
			end
		end

end -- Class CDD_GRID_HELPER
