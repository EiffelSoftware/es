indexing
	description: "Objects that represent a graphical view of some filter/tree view"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINES_VIEW

inherit

	EV_VERTICAL_BOX
		redefine
			destroy
		end

create
	make

feature {NONE} -- Initialization

	make (a_tree_view: like tree_view) is
			-- Initialize `Current' to display test routines of `a_tree_view'.
		require
			a_tree_view_not_void: a_tree_view /= Void
		do
			tree_view := a_tree_view
			create {DS_ARRAYED_LIST [STRING]} predefined_filter_tags.make_from_linear (tree_view.filtered_view.filters)
			default_create
			build_interface
		ensure
			tree_view_set: tree_view = a_tree_view
			correct_predefined_filter_tags: predefined_filter_tags.is_equal (tree_view.filtered_view.filters)
		end

	build_interface is
			-- Initialize widgets.
		do
			create text_field
			extend (text_field)
			disable_item_expand (text_field)

			create grid
			grid.enable_tree
			grid.set_dynamic_content_function (agent fetch_grid_item)
			grid.enable_partial_dynamic_content
			grid.set_column_count_to (2)
			grid.column (1).set_title ("Tests")
			grid.column (1).set_width (200)
			grid.column (2).set_title ("Outcome")
			extend (grid)

			refresh

			tree_view.change_actions.extend (agent refresh)
		end

feature -- Access

	filter_tags: DS_LINEAR [STRING] is
			-- Tags used in the filter
		do
			Result := tree_view.filtered_view.filters
		ensure
			tags_of_filter: Result = tree_view.filtered_view.filters
			contains_predefined: predefined_filter_tags.for_all (agent (a_tag: STRING; a_list: DS_LINEAR [STRING]): BOOLEAN
				do
					Result := a_list.has (a_tag)
				end (?, Result))
		end

feature {NONE} -- Implementation (Access)

	predefined_filter_tags: DS_LINEAR [STRING]
			-- Tags which where defined in the filter at creation time

	tree_view: CDD_TREE_VIEW
			-- Tree view providing test routines which should be displayed by `Current'

	text_field: EV_TEXT_FIELD
			-- Text field for entering filter query

	grid: CDD_GRID
			-- Grid for displaying `filter' results

	last_added_rows_count: INTEGER
			-- Number of rows added by the last call to `add_rows_recursive'?

	stock_colors: EV_STOCK_COLORS is
			-- Predefined colors
		once
			create Result
		end

feature {NONE} -- Implementation (Basic operations)

	refresh is
			-- Build grid.
		local
			i: INTEGER
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
			l_stack: DS_LINKED_STACK [DS_LINEAR_CURSOR [CDD_TREE_NODE]]
			l_row: EV_GRID_ROW
			l_node: CDD_TREE_NODE
			l_item: EV_GRID_LABEL_ITEM
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			last_added_rows_count := 0
			add_rows_recursive (Void, tree_view.nodes)
		end

	add_rows_recursive (a_parent: EV_GRID_ROW; a_list: DS_LINEAR [CDD_TREE_NODE]) is
			-- Add subrows for `a_parent' into `grid' corresponding to `a_list'.
			-- If `a_parent' is Void, simply add unparented rows to `grid'.
			-- Set `last_added_rows_count' to total number of rows added.
		require
			a_list_not_void: a_list /= Void
			a_list_valid: not a_list.has (Void)
			a_parent_not_void_implies_valid: (a_parent /= Void) implies (grid.row (a_parent.index) = a_parent)
		local
			i, l_old_count: INTEGER
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
			l_row: EV_GRID_ROW
		do
			if not a_list.is_empty then
				if a_parent = Void then
					i := 1
					grid.insert_new_rows (a_list.count, i)
				else
					i := a_parent.index + 1
					grid.insert_new_rows_parented (a_list.count, i, a_parent)
				end
				l_cursor := a_list.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					l_row := grid.row (i)
					l_row.set_data (l_cursor.item)
					if not l_cursor.item.is_leaf then
						l_row.ensure_expandable
						l_old_count := last_added_rows_count
						add_rows_recursive (l_row, l_cursor.item.children)
						i := i + last_added_rows_count - l_old_count
					end
					i := i + 1
					l_cursor.forth
				end
				last_added_rows_count := last_added_rows_count + a_list.count
			end
		ensure
			count_greater_or_equal_list_count: last_added_rows_count >= a_list.count
			valid_count: grid.row_count = old grid.row_count + last_added_rows_count - old last_added_rows_count
		end

	fetch_grid_item (a_col, a_row: INTEGER): EV_GRID_LABEL_ITEM is
			-- Grid item for row and column at `a_row' and `a_col'
		require
			a_row_valid: a_row > 0 and a_row <= grid.row_count
			a_col_valid: a_col > 0 and a_col <= grid.column_count
		local
			l_node: CDD_TREE_NODE
			l_tooltip: STRING
			l_last: CDD_TEST_EXECUTION_RESPONSE
		do
			create Result
			l_node := grid.row (a_row).tree_node
			if l_node /= Void then
				if a_col = 1 then
					Result.text.append (l_node.tag)
				else
					if l_node.is_leaf then
						if l_node.test_routine.outcomes.is_empty then
							Result.text.append ("not tested yet")
							Result.set_foreground_color (stock_colors.grey)
						else
							l_last := l_node.test_routine.outcomes.last
							l_tooltip := l_last.out
							if l_last.is_fail then
								Result.text.append ("FAIL")
								Result.set_foreground_color (stock_colors.red)
							elseif l_last.is_pass then
								Result.text.append ("PASS")
								Result.set_foreground_color (stock_colors.green)
							else
								Result.text.append ("UNRESOLVED")
								Result.set_foreground_color (stock_colors.grey)
							end
							Result.set_tooltip (l_tooltip)
						end
					end
				end
			end
		ensure
			not_void: Result /= Void
		end

	update_filter is
			-- Update filter tags of `filter' corresponding
			-- to `test_field' and rebuild filter.
		local
			l_tags: DS_LIST [STRING]
			l_new_tags: STRING
			l_start, l_end: INTEGER
		do
			l_tags := tree_view.filtered_view.filters
			l_tags.wipe_out
			l_new_tags := text_field.text
			from
				l_tags.extend_first (predefined_filter_tags)
			until
				l_start > l_new_tags.count
			loop
				if l_end > l_start then
					if l_new_tags.item (l_end).is_space then
						l_tags.put_last (l_new_tags.substring (l_start, l_end - 1))
						l_start := l_end
					else
						l_end := l_end + 1
					end
				elseif l_new_tags.item (l_start).is_space then
					l_start := l_start + 1
				else
					l_end := l_start + 1
				end
			end
		end

feature {NONE} -- Destruction

	destroy is
			-- Tell `filter' to no longer observer test suite.
		do
			Precursor
			tree_view.disable_observing
		end

invariant

	tree_view_not_void: tree_view /= Void
	predefined_filter_tags_valid: predefined_filter_tags /= Void and then not predefined_filter_tags.has (Void)

	text_field_not_void: text_field /= Void
	grid_not_void: grid /= Void

end
