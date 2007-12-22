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
			-- Initialize `Current' without predefined filter tags.
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
			-- Initialize widgets
		do
			create text_field
			extend (text_field)
			disable_item_expand (text_field)

			create grid
			grid.enable_tree
			--grid.set_dynamic_content_function (agent compute_grid_item)
			--grid.enable_partial_dynamic_content
			grid.set_column_count_to (2)
			grid.column (1).set_title ("Tests")
			grid.column (1).set_width (250)
			grid.column (2).set_title ("Outcome")
			extend (grid)

			tree_view.enable_observing
			tree_view.change_actions.extend (agent refresh)

			refresh
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

feature {NONE} -- Implementation

	predefined_filter_tags: DS_LINEAR [STRING]
			-- Tags which where defined in the filter at creation time

	tree_view: CDD_TREE_VIEW
			-- Tree view providing test routines which should be displayed by `Current'

	text_field: EV_TEXT_FIELD
			-- Text field for entering filter query

	grid: EV_GRID
			-- Grid for displaying `filter' results

feature {NONE} -- Implementation

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

			if tree_view.nodes.count > 0 then
				create l_stack.make
				l_cursor := tree_view.nodes.new_cursor
				from
					l_cursor.start
					l_stack.put (l_cursor)
					grid.insert_new_rows (tree_view.nodes.count, 1)
				until
					l_stack.is_empty
				loop
					if l_stack.item.after then
						l_stack.remove
					else
						i := i + 1
						l_row := grid.row (i)
						l_node := l_stack.item.item
						create l_item.make_with_text (l_node.tag)
						l_row.set_item (1, l_item)
						if l_node.is_leaf then
							if l_node.test_routine.outcomes.is_empty then
								create l_item.make_with_text ("not tested yet")
							elseif l_node.test_routine.outcomes.first.is_fail then
								create l_item.make_with_text ("FAIL")
								l_item.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 0, 0))
							elseif l_node.test_routine.outcomes.first.is_pass then
								create l_item.make_with_text ("PASS")
								l_item.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 1, 1))
							else
								create l_item.make_with_text ("UNRESOLVED")
							end
							l_row.set_item (2, l_item)
						end
						if not l_stack.item.item.is_leaf and then l_stack.item.item.children.count > 0 then
							grid.insert_new_rows_parented (l_stack.item.item.children.count, i+1, l_row)
							l_stack.put (l_stack.item.item.children.new_cursor)
							l_stack.item.start
							l_row.ensure_expandable
						end
						l_stack.item.forth
					end
				end
			end
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
