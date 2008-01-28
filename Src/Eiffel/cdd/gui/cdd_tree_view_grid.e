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

	EB_EDITOR_TOKEN_GRID_SUPPORT
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

			set_column_count_to (1)
			column (1).set_title ("")
			column (1).set_width (300)

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
				Result := new_token_item (l_node)
			end
		end


	new_token_item (a_node: CDD_TREE_NODE): EB_GRID_EDITOR_TOKEN_ITEM is
			-- New item for displaying in the tree
		require
			a_node_not_void: a_node /= Void
		local
			l_root, l_p1, l_p2: CDD_TREE_NODE
			l_tag, l_tooltip: STRING
			i, l_sec: INTEGER
			l_universe: UNIVERSE_I
			l_list: LIST [CLASS_I]
			l_class: CLASS_I
			l_eclass: CLASS_C
			l_feature: E_FEATURE
			l_dt: DT_DATE_TIME
			l_regex: RX_PCRE_REGULAR_EXPRESSION
			l_tag_list: DS_LINEAR [STRING]
		do
			from
				l_root := a_node
				l_tag := a_node.tag
				i := 1
			until
				l_root.parent = Void
			loop
				i := i + 1
				l_root := l_root.parent
				l_tag := l_root.tag + "." + l_tag
				if l_p1 = Void then
					l_p1 := l_root
					l_p2 := l_root.parent
				end
			end
			create Result
			token_writer.new_line
			l_universe := tree_view.filtered_view.test_suite.cdd_manager.project.universe

					-- Are we displaying a class?
			if	not a_node.is_leaf and ((i = 1 and (tree_view.view_code = {CDD_TREE_VIEW}.name_view_code
						or tree_view.view_code = {CDD_TREE_VIEW}.covers_view_code)) or
					(i = 2 and tree_view.view_code = {CDD_TREE_VIEW}.tags_view_code and then
					(l_p1.tag.is_case_insensitive_equal ("covers") or l_p1.tag.is_case_insensitive_equal ("name")))) then
				Result.set_pixmap (pixmaps.icon_pixmaps.class_normal_icon)
				l_list := l_universe.classes_with_name (a_node.tag)
				if not l_list.is_empty then
					l_class := l_list.first
					Result.set_pixmap (pixmap_from_class_i (l_class))
					token_writer.add_class (l_class)
				end

					-- Are we displaying a routine?
			elseif	not a_node.is_leaf and ((i = 2 and (tree_view.view_code = {CDD_TREE_VIEW}.covers_view_code)) or
					(i = 3 and then tree_view.view_code = {CDD_TREE_VIEW}.tags_view_code and then
					l_p2.tag.is_case_insensitive_equal ("covers"))) then
				Result.set_pixmap (pixmaps.icon_pixmaps.feature_routine_icon_buffer)
				l_list := l_universe.classes_with_name (l_p1.tag)
				if not l_list.is_empty and then l_list.first.is_compiled then
					l_eclass := l_list.first.compiled_class
					l_feature := l_eclass.feature_with_name (a_node.tag)
					if l_feature /= Void then
						token_writer.process_feature_text (a_node.tag, l_feature, False)
						Result.set_pixmap (pixmap_from_e_feature (l_feature))
					end
				end

					-- Are we displaying a call stack id (extraction date/time)?
			elseif	not a_node.is_leaf and ((i = 1 and tree_view.view_code = {CDD_TREE_VIEW}.failure_view_code) or
					(i = 2 and then tree_view.view_code = {CDD_TREE_VIEW}.tags_view_code and then
					l_p1.tag.is_case_insensitive_equal ("failure"))) then
				if a_node.tag.is_integer then
					l_sec := a_node.tag.to_integer
					create l_dt.make_from_epoch (l_sec)
					token_writer.process_basic_text (l_dt.out)
				end

					-- Are we displaying a call stack element?
			elseif a_node.is_leaf and ((i = 2 and tree_view.view_code = {CDD_TREE_VIEW}.failure_view_code) or
					(i = 3 and then tree_view.view_code = {CDD_TREE_VIEW}.tags_view_code and then
					l_p2.tag.is_case_insensitive_equal ("failure"))) then
				l_tag_list := a_node.test_routine.tags_with_prefix ("covers.")
				if not l_tag_list.is_empty then
					create l_regex.make
					l_regex.compile ("^covers\.([a-zA-Z][a-zA-Z0-9_]*)\.([a-zA-Z][a-zA-Z0-9_]*)")
					l_regex.match (l_tag_list.first)
					if l_regex.match_count > 2 then
						l_list := l_universe.classes_with_name (l_regex.captured_substring (1))
						if not l_list.is_empty and then l_list.first.is_compiled then
							l_eclass := l_list.first.compiled_class
							l_feature := l_eclass.feature_with_name (l_regex.captured_substring (2))
							if l_feature /= Void then
								token_writer.process_basic_text (a_node.tag + ": ")
								token_writer.process_feature_text (l_feature.name, l_feature, False)
								token_writer.process_basic_text (" (")
								token_writer.process_class_name_text (l_list.first.name, l_list.first, False)
								token_writer.process_basic_text (")")
							end
						end
					end
				end

					-- Are we displaying a test routine?
			elseif a_node.is_leaf then
				l_eclass := a_node.test_routine.test_class.compiled_class
				Result.set_spacing (4)
				if l_eclass /= Void then
					l_feature := l_eclass.feature_with_name (a_node.test_routine.name)
				end
				if l_feature /= Void then
					token_writer.process_feature_text (a_node.tag, l_feature, False)
				else
					token_writer.process_basic_text (a_node.tag)
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
			end

				-- We did not display any of the above, so lets
				-- just simply add the node tag
			if token_writer.last_line.content.is_empty then
				token_writer.process_basic_text (a_node.tag)
			end
				-- Add tooltip and failing routine count if necessary
			if not a_node.is_leaf then
				Result.set_tooltip (l_tag)
				if a_node.failure_count > 0 then
					token_writer.process_basic_text (" (" + a_node.failure_count.out + ")")
				end
			else
				if a_node.test_routine.outcomes.is_empty then
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_test_icon)
				elseif a_node.test_routine.outcomes.last.is_fail then
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_test_fail_icon)
				elseif a_node.test_routine.outcomes.last.is_pass then
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_test_pass_icon)
				else
					Result.set_pixmap (pixmaps.icon_pixmaps.cdd_test_unresolved_icon)
				end
			end
			Result.set_text_with_tokens (token_writer.last_line.content)
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
