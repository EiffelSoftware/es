indexing
	description: "[
			Objects that represent a special grid for displaying
			cdd tree view nodes. Items are loaded dynamically and
			changes in the tree view are updated incrementally.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_VIEW_GRID

inherit

	ES_GRID
		redefine
			destroy
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EVS_GRID_PND_SUPPORT
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_tree_view: like tree_view; a_window: like development_window) is
			-- Initialize `Current' with `a_tree_view'.
		require
			a_tree_view_not_void: a_tree_view /= Void
			a_window_not_void: a_window /= Void
		do
			tree_view := a_tree_view
			development_window := a_window
			internal_grid := Current
			internal_update_agent := agent update_grid_incremental
			default_create
			build
		ensure
			tree_view_set: tree_view = a_tree_view
			window_set: development_window = a_window
		end

	build is
			-- Set up `Current' to display contents of `tree_view'.
		do
			enable_tree
			hide_tree_node_connectors
			set_dynamic_content_function (agent fetch_grid_item)
			enable_partial_dynamic_content
			enable_single_row_selection
			row_expand_actions.extend (agent add_subrows)

			enable_grid_item_pnd_support
			set_focused_selection_color (preferences.editor_data.selection_background_color)
			set_non_focused_selection_color (preferences.editor_data.focus_out_selection_background_color)
			row_select_actions.extend (agent highlight_row)
			row_deselect_actions.extend (agent dehighlight_row)
			focus_in_actions.extend (agent change_focus)
			focus_out_actions.extend (agent change_focus)
			set_focused_selection_text_color (preferences.editor_data.selection_text_color)

			set_column_count_to (2)
			column (1).set_title ("")
			column (1).set_width (200)
			column (2).set_title ("Outcome")
			column (2).set_width (45)

			tree_view.add_client
			tree_view.change_actions.extend (internal_update_agent)
		end

feature -- Access

	tree_view: CDD_TREE_VIEW
			-- View beeing displayed in grid

	development_window: EB_DEVELOPMENT_WINDOW
			-- Window which displays `Current'

feature {NONE} -- Grid manipulation

	refresh_grid is
			-- Build grid.
		do
			development_window.lock_update
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			if tree_view.nodes.count > 0 then
				grid.insert_new_rows (tree_view.nodes.count, 1)
				fill_rows (tree_view.nodes, 1)
			end
			development_window.unlock_update
		end

	 add_subrows (a_parent: EV_GRID_ROW) is
			-- Add subrows for `a_parent' into `grid' corresponding to `a_list'.
			-- If `a_parent' is Void, simply add unparented rows to `grid'.
			-- Set `last_added_rows_count' to total number of rows added.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_valid: grid.row (a_parent.index) = a_parent
		local
			l_node: CDD_TREE_NODE
		do
				-- Make sure
			if a_parent.subrow_count = 0 then
				l_node ?= a_parent.data
				check
					node_valid: l_node /= Void and then not l_node.is_leaf
				end
				a_parent.insert_subrows (l_node.children.count, 1)
				fill_rows (l_node.children, a_parent.index + 1)
			end
		end

	fill_rows (a_list: DS_LINEAR [CDD_TREE_NODE]; a_pos: INTEGER) is
			-- Set `data' field from rows in grid for each node
			-- in `a_list' starting from `a_pos'.
		require
			a_list_not_void: a_list /= Void
			a_list_valid: not a_list.has (Void)
			a_pos_valid: a_pos > 0 and a_pos <= grid.row_count
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
			l_row: EV_GRID_ROW
			i: INTEGER
		do
			l_cursor := a_list.new_cursor
			from
				l_cursor.start
				i := a_pos
			until
				l_cursor.after
			loop
				l_row := grid.row (i)
				l_row.set_data (l_cursor.item)
				if not l_cursor.item.is_leaf then
					l_row.ensure_expandable

						-- Expand root nodes by default
					if l_row.parent_row = Void then
						l_row.expand
					end
				end
				i := i + 1 + l_row.subrow_count_recursive
				l_cursor.forth
			end
		end

	highlight_row (a_row: EV_GRID_ROW) is
			-- Make `a_row' look like it is fully selected.
		require
			a_row_not_void: a_row /= Void
		do
			if grid.has_focus then
				a_row.set_background_color (preferences.editor_data.selection_background_color)
			else
				a_row.set_background_color (preferences.editor_data.focus_out_selection_background_color)
			end
		end

	dehighlight_row (a_row: EV_GRID_ROW) is
			-- Make `a_row' look like it is not selected.
		require
			a_row_not_void: a_row /= Void
		do
			a_row.set_background_color (preferences.editor_data.class_background_color)
		end

	change_focus is
			-- Make sure all selected rows have correct background color.
		local
			l_selected: LIST [EV_GRID_ROW]
		do
			l_selected := grid.selected_rows
			from
				l_selected.start
			until
				l_selected.after
			loop
				highlight_row (l_selected.item)
				l_selected.forth
			end
		end

feature {NONE} -- Incremental update

	internal_update_agent: PROCEDURE [like Current, TUPLE [DS_LINEAR [CDD_TREE_NODE_UPDATE]]]
			-- Agent called when `tree_view' updates

	update_grid_incremental (an_update_list: DS_LINEAR [CDD_TREE_NODE_UPDATE]) is
			-- Incrementally update `grid'.
		require
			an_update_list_valid: an_update_list = Void or else not an_update_list.has (Void)
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE_UPDATE]
		do
			if an_update_list /= Void then
				development_window.lock_update
				l_cursor := an_update_list.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					process_update (l_cursor.item)
					l_cursor.forth
				end
				development_window.unlock_update
			else
				refresh_grid
			end
		end

	process_update (an_update: CDD_TREE_NODE_UPDATE) is
			-- Modify `grid' according to `an_update'..
		require
			an_update_not_void: an_update /= Void
		local
			l_path: DS_LIST_CURSOR [INTEGER]
			l_row: EV_GRID_ROW
			l_abort: BOOLEAN
		do
			l_path := an_update.path.new_cursor
			from
				l_path.start
			until
				(an_update.is_added and l_path.is_last) or
				l_path.after or l_abort
			loop
				if l_row = Void then
					l_row := subrow (l_path.item)
				elseif l_row.subrow_count > 0 then
					l_row := l_row.subrow (l_path.item)
				else
					l_abort := True
				end
				l_row.clear
				l_path.forth
			end
			if not l_abort then
				if an_update.is_added then
						-- NOTE: need to be careful when parent row
						-- already contains new node because of previous
						-- updates or parent is not expanded and does not
						-- contain any subrows
					if l_row = Void or else l_row.subrow_count > 0 then
						if l_row /= Void then
							if l_row.subrow_count < l_path.item or else l_row.subrow (l_path.item).data /= an_update.node then
								l_row.insert_subrow (l_path.item)
							end
							l_row := l_row.subrow (l_path.item)
						else
							l_row := subrow (l_path.item)
							if l_row /= Void then
								grid.insert_new_row (l_row.index)
								l_row := grid.row (l_row.index - 1)
							else
								grid.insert_new_row (grid.row_count + 1)
								l_row := grid.row (grid.row_count)
							end
						end
						l_row.set_data (an_update.node)
						if not an_update.node.is_leaf then
							l_row.ensure_expandable
						end
					end
				elseif an_update.is_removed then
					grid.remove_row (l_row.index)
				elseif an_update.is_changed then
					-- Nothing to do...
				else
					check
						dead_end: False
					end
				end
			end
		end

	subrow (i: INTEGER): EV_GRID_ROW is
			-- `i'-th unparented row in `grid'.
			-- Void if i is too large.
		require
			valid_index: i > 0
		local
			j, pos: INTEGER
		do
			from
				j := 1
				pos := 1
			until
				j = i
			loop
				pos := pos + 1 + grid.row (pos).subrow_count_recursive
				j := j + 1
			end
			if pos <= grid.row_count then
				Result := grid.row (pos)
			end
		ensure
			valid_result: Result /= Void implies (Result.parent_row = Void and Result.parent = grid)
		end

feature {NONE} -- Dynamic grid items

	fetch_grid_item (a_col, a_row: INTEGER): EV_GRID_ITEM is
			-- Grid item for row and column at `a_row' and `a_col'
		require
			a_row_valid: a_row > 0 and a_row <= grid.row_count
			a_col_valid: a_col > 0 and a_col <= grid.column_count
		local
			l_node: CDD_TREE_NODE
		do
			l_node ?= grid.row (a_row).data
			if l_node /= Void then
				if a_col = 1 then
					Result := new_tree_node_item (l_node)
				elseif l_node.is_leaf then
					Result := new_outcome_item (l_node.test_routine)
				end
			end
		end

	new_tree_node_item (a_node: CDD_TREE_NODE): EB_GRID_EDITOR_TOKEN_ITEM is
			-- Item displaying clickable content of `a_node'
		require
			a_node_not_void: a_node /= Void
		local
			l_class: EIFFEL_CLASS_C
			l_feature: E_FEATURE
			l_tooltip: STRING
		do
			create Result
			token_writer.new_line
			if a_node.is_leaf then
				l_class := a_node.test_routine.test_class.compiled_class
				if l_class /= Void then
					l_feature := l_class.feature_with_name (a_node.test_routine.name)
				end
				if l_feature /= Void then
					token_writer.process_feature_text (a_node.tag, l_feature, False)
					Result.set_pixmap (pixmap_from_e_feature (l_feature))
				else
					token_writer.process_basic_text (a_node.tag)
					Result.set_pixmap (pixmaps.icon_pixmaps.feature_routine_icon)
				end
				l_tooltip := "Tags: "
				a_node.test_routine.tags.do_all_with_index (agent (a_tooltip, a_tag: STRING; an_index: INTEGER)
					do
						if an_index > 1 then
							a_tooltip.append (", ")
							if (an_index \\ 5) = 0 then
								a_tooltip.append ("%N")
							end
						end
						a_tooltip.append (a_tag)
					end (l_tooltip, ?, ?))
				Result.set_tooltip (l_tooltip)
			else
--				if a_node.has_test_class then
--					token_writer.add_class (a_node.eiffel_class)
--					Result.set_pixmap (pixmap_from_class_i (a_node.eiffel_class))
--				elseif a_node.has_feature and then a_node.eiffel_feature.e_feature /= Void then
--					token_writer.add_feature (a_node.eiffel_feature.e_feature, a_node.tag)
--					Result.set_pixmap (pixmap_from_e_feature (a_node.eiffel_feature.e_feature))
--				else
					token_writer.process_basic_text (a_node.tag)
--				end
				token_writer.process_basic_text (" (" + a_node.test_routine_count.out + ")")
			end
			Result.set_text_with_tokens (token_writer.last_line.content)
		ensure
			not_void: Result /= Void
		end

	new_outcome_item (a_test_routine: CDD_TEST_ROUTINE): EV_GRID_LABEL_ITEM is
			-- Grid item showing last outcome of `a_test_routine'
		require
			a_test_routine_not_void: a_test_routine /= Void
		local
			l_last: CDD_TEST_EXECUTION_RESPONSE
			l_tooltip: STRING
		do
			create Result
			if a_test_routine.outcomes.is_empty then
				Result.text.append ("not tested yet")
				Result.set_foreground_color (stock_colors.grey)
			else
				l_last := a_test_routine.outcomes.last
				l_tooltip := l_last.out
				if l_last.is_fail then
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_fail_icon)
				elseif l_last.is_pass then
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_pass_icon)
				else
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_unresolved_icon)
				end
				Result.set_tooltip (l_tooltip)
			end
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Implementation

	stock_colors: EV_STOCK_COLORS is
			-- Predefined colors
		once
			create Result
		end

	token_writer: EB_EDITOR_TOKEN_GENERATOR is
			-- Tokenwriter for clickable items
		once
			create Result.make
		end

feature {NONE} -- Destruction

	destroy is
			-- Remove `internal_update_agent' from
			-- observer list in `tree_view'
		do
			tree_view.change_actions.prune_all (internal_update_agent)
			tree_view.remove_client
			Precursor {ES_GRID}
		end

invariant
	tree_view_not_void: tree_view /= Void
	internal_update_agent_not_void: internal_update_agent /= Void
	--not_destroyed_implies_observing: (not is_destroyed) implies tree_view.is_observing

end
