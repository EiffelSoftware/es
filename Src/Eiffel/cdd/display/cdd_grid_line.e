indexing
	description: "Objects that represent sortable grid rows"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_GRID_LINE [reference G -> COMPARABLE]

inherit

	EB_GRID_ROW
		redefine
			grid_row
		end

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			is_equal,
			copy
		end

feature {NONE} -- Initialization

	make_with_row (a_row: like grid_row; some_data: like row_data) is
			-- Set 'data' to 'some_data'
		require
			a_row_not_void: a_row /= Void
			some_data_not_void: some_data /= Void
			valid_row: a_row.parent /= Void
		do
			set_grid_row (a_row)
			row_data := some_data

		ensure
			data_set: row_data = some_data
		end

feature -- Access

	max_row_index: INTEGER is
			-- Maximum index for inserting a new row.
		do
			Result := grid_row.index + grid_row.subrow_count_recursive + 1
		end

	grid: CDD_GRID is
			-- CDD_TREE instance of parent_tree
		do
			Result := grid_row.parent
		ensure
			not_void: Result /= Void
		end

	grid_row: CDD_GRID_ROW
			-- CDD_GRID_ROW row associated with current

	row_data: G
			-- Comparable user data

	first_subrow: like grid_row is
			-- First subrow of `grid_row', Void if `grid_row' has no subrows
		do
			if grid_row.subrow_count > 0 then
				Result := grid.row (grid_row.index + 1)
			end
		end

	name_item: EB_GRID_EDITOR_TOKEN_ITEM is
			-- Item which displayes the name of `grid_row'.
		do
			Result ?= grid_row.item (1)
			if Result = Void then
				create Result
				grid_row.set_item (1, Result)
			end
		ensure
			result_not_void: Result /= Void
		end

feature -- Element change

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Display `a_tc' in tree structure.
		require
			a_tc_not_void: a_tc /= Void
		deferred
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove `a_tc' from tree structure.
		require
			a_tc_not_void: a_tc /= Void
		deferred
		end


	insert_new_row (i: INTEGER) is
			-- Insert new subrow of `grid_row' into `grid' at index `i'.
		do
			grid.insert_new_row_parented (i, grid_row)
		end

	unattach is
			-- Set `grid_line' of `grid_row' to Void and remove other dependencies if there are any.
		do
			grid_row.set_grid_line (Void)
		ensure
			not_attached: grid_row.grid_line = Void
		end

feature {NONE} -- Implementation


invariant
	data_not_void: row_data /= Void
	grid_row_has_parent: grid_row.parent /= Void
	grid_is_cdd_grid: grid /= Void
	valid_name_item: name_item /= Void and then grid_row.item (1) = name_item

end -- Class CDD_GRID_LINE
