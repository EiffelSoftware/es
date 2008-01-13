indexing
	description: "Objects that represent a tool widget for displaying test routines and outcomes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TOOL

inherit

	EB_TOOL
		rename
			title_for_pre as title
		redefine
			build_mini_toolbar,
			mini_toolbar,
			internal_recycle
		end

	EVS_GRID_PND_SUPPORT
		rename
			internal_grid as grid
		export
			{NONE} all
		redefine
			grid
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	build_interface is
			-- Initialize all widgets for `Current'.
		do
			cdd_manager := develop_window.eb_debugger_manager.cdd_manager
			internal_status_update_action := agent update_status
			cdd_manager.status_update_actions.extend (internal_status_update_action)

			create widget

			build_mini_toolbar
			build_filter_box
			build_toolbar
			build_grids
			build_status_bar
		ensure then
			cdd_manager_set: cdd_manager = develop_window.eb_debugger_manager.cdd_manager
		end

	build_mini_toolbar is
			-- Create widgets for displaying a tool bar
		local
			l_sep: SD_TOOL_BAR_SEPARATOR
		do
			create mini_toolbar.make

			create toggle_extraction_button.make
			toggle_extraction_button.set_tooltip ("Enable/Disable extraction")
			toggle_extraction_button.set_pixmap (pixmaps.mini_pixmaps.general_toogle_icon)
			toggle_extraction_button.select_actions.extend (agent toggle_extraction)

			mini_toolbar.extend (toggle_extraction_button)
			create l_sep.make
			mini_toolbar.extend (l_sep)

			mini_toolbar.compute_minimum_size
		ensure then
			mini_toolbar_not_void: mini_toolbar /= Void
		end

	build_filter_box is
			-- Build `filter_box' and add it to `widget'.
		require
			widget_not_void: widget /= Void
		local
			l_item: EV_LIST_ITEM
			l_hbox: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
		do
			create l_hbox
			l_hbox.set_padding (10)
			l_hbox.set_border_width (5)
			create l_label.make_with_text ("Filter ")
			l_hbox.extend (l_label)
			l_hbox.disable_item_expand (l_label)

			create filter_box
			filter_box.set_text ("")
			create l_item.make_with_text ("All")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Failing%T%T(outcome.fail)")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Unresolved%T(outcome.unresolved)")
			filter_box.extend (l_item)
			l_hbox.extend (filter_box)
			filter_box.return_actions.extend (agent update_filter)
			filter_box.select_actions.extend (agent select_filter_text)

			create toggle_filter_button.make_with_text ("Exec Set")
			toggle_filter_button.select_actions.extend (agent toggle_filter)
			toggle_filter_button.set_tooltip ("Only execute visible test routines")
			--l_button.set_pixmap (pixmaps.icon_pixmaps.debug_stop_icon)
			if not cdd_manager.is_project_initialized then
				toggle_filter_button.disable_sensitive
			end
			l_hbox.extend (toggle_filter_button)
			l_hbox.disable_item_expand (toggle_filter_button)

			widget.extend (l_hbox)
			widget.disable_item_expand (l_hbox)
		end

	build_toolbar is
			-- Create toolbar containing buttons.
		require
			widget_not_void: widget /= Void
		local
			l_toolbar: EV_TOOL_BAR
			l_sep: EV_TOOL_BAR_SEPARATOR
			l_button: EV_TOOL_BAR_BUTTON
			l_tbutton: EV_TOOL_BAR_TOGGLE_BUTTON

		do
			create l_toolbar

			create debug_button.make_with_text ("Debug")
			debug_button.select_actions.extend (agent debug_test_routine)
			debug_button.set_tooltip ("Debug selected test routine")
			--debug_button.set_pixmap (pixmaps.mini_pixmaps.general_next_icon)
			if not cdd_manager.is_project_initialized then
				debug_button.disable_sensitive
			end
			l_toolbar.extend (debug_button)

			create l_sep
			l_toolbar.extend (l_sep)

			create l_button.make_with_text ("New")
			l_button.set_tooltip ("Create new manual test class")
			--l_button.set_pixmap (pixmaps.icon_pixmaps.debug_stop_icon)
			l_toolbar.extend (l_button)

			create l_sep
			l_toolbar.extend (l_sep)

			create l_tbutton.make_with_text ("Execution")
			l_tbutton.set_tooltip ("Turn background execution on/off")
			--l_tbutton.set_pixmap (pixmaps.icon_pixmaps.debug_run_without_breakpoint_icon)
			l_toolbar.extend (l_tbutton)
			l_tbutton.enable_select

			create l_tbutton.make_with_text ("Extraction")
			l_tbutton.set_tooltip ("Turn extraction of new test cases on/off")
			--l_tbutton.set_pixmap (pixmaps.icon_pixmaps.tool_breakpoints_icon)
			l_toolbar.extend (l_tbutton)
			l_tbutton.enable_select

			widget.extend (l_toolbar)
			widget.disable_item_expand (l_toolbar)
		end

	build_grids is
			-- Create `grid' and add it to `widget'.
		require
			widget_not_void: widget /= Void
		local
			l_filter: CDD_FILTERED_VIEW
			l_split_area: EV_VERTICAL_SPLIT_AREA
			l_notebook: EV_NOTEBOOK
			l_cell: EV_CELL
		do
			create l_split_area

			create grid
			grid.enable_tree
			grid.enable_single_row_selection
			grid.set_dynamic_content_function (agent fetch_grid_item)
			grid.enable_partial_dynamic_content
			grid.hide_tree_node_connectors
			enable_grid_item_pnd_support
			grid.set_focused_selection_color (preferences.editor_data.selection_background_color)
			grid.set_non_focused_selection_color (preferences.editor_data.focus_out_selection_background_color)
			grid.row_select_actions.extend (agent highlight_row)
			grid.row_deselect_actions.extend (agent dehighlight_row)
			grid.focus_in_actions.extend (agent change_focus)
			grid.focus_out_actions.extend (agent change_focus)
			grid.set_focused_selection_text_color (preferences.editor_data.selection_text_color)

			grid.set_column_count_to (4)
			grid.column (1).set_title ("")
			grid.column (1).set_width (200)
			grid.column (2).set_title ("Outcome")
			grid.column (2).set_width (45)
			grid.column (3).set_title ("Class")
			grid.column (3).set_width (170)
			grid.column (4).set_title ("Feature")
			grid.column (4).set_width (170)

			l_split_area.extend (grid)

			create l_filter.make (cdd_manager.test_suite)
			create tree_view.make (l_filter)
			tree_view.add_client
			refresh_grid
			tree_view.change_actions.extend (agent refresh_grid)

			create l_notebook
			create l_cell
			l_notebook.extend (l_cell)
			l_notebook.set_item_text (l_cell, "Trace")
			create l_cell
			l_notebook.extend (l_cell)
			l_notebook.set_item_text (l_cell, "Related")

			l_split_area.extend (l_notebook)
			l_split_area.set_proportion (0.3)

			widget.extend (l_split_area)
		end

	build_status_bar is
			-- Add status bar containing `status_label' to `widget'
		require
			widget_not_void: widget /= Void
		local
			l_frame: EV_FRAME
			l_status_bar: EV_STATUS_BAR

			l_label: EV_LABEL
		do
			create l_status_bar
			l_status_bar.set_border_width (2)

			create l_frame
			l_frame.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			create status_label.make_with_text ("")
			status_label.align_text_left
			l_frame.extend (status_label)
			l_status_bar.extend (l_frame)

			create l_frame
			l_frame.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			create l_label.make_with_text ("3/10 Tests Fail")
			l_frame.extend (l_label)
			l_status_bar.extend (l_frame)
			l_status_bar.disable_item_expand (l_frame)

			create l_frame
			l_frame.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			l_frame.set_minimum_width (100)
			create progress_bar
			progress_bar.set_proportion (0.0)
			l_frame.extend (progress_bar)
			l_status_bar.extend (l_frame)
			l_status_bar.disable_item_expand (l_frame)

			widget.extend (l_status_bar)
			widget.disable_item_expand (l_status_bar)
		end

feature -- Access

	title: STRING is "Testing"
			-- Title describing `Current'

	widget: EV_VERTICAL_BOX
			-- Main widget for visualizing `Current'

feature {NONE} -- Implementation (Access)

	cdd_manager: CDD_MANAGER
			-- Current cdd manager containing cdd status and test suite

	internal_status_update_action: PROCEDURE [like Current, TUPLE [CDD_STATUS_UPDATE]]
			-- Agent called when `cdd_manager' triggers an update event

feature {NONE} -- Implementation (Basic functionality)

	update_status (an_update: CDD_STATUS_UPDATE) is
			-- Apopt widgets to `an_update'.
		require
			an_update_not_void: an_update /= Void
		local
			l_exec: CDD_TEST_EXECUTOR
			l_debug: CDD_TEST_DEBUGGER
			l_label: STRING
		do
			inspect
				an_update.code
			when {CDD_STATUS_UPDATE}.project_initialize_code then
				debug_button.enable_sensitive
				toggle_filter_button.enable_sensitive
			when {CDD_STATUS_UPDATE}.enable_extracting_code then
				show_message ("Extraction enabled")
				toggle_extraction_button.enable_select
			when {CDD_STATUS_UPDATE}.disable_extracting_code then
				show_message ("Extraction disabled")
				toggle_extraction_button.disable_select
			when {CDD_STATUS_UPDATE}.executor_step_code then
				l_exec := cdd_manager.background_executor
				if not l_exec.has_next_step then
					--run_button.enable_sensitive
					show_message ("Finished executing")
					progress_bar.set_proportion (0.0)
				else
					--run_button.disable_sensitive
					if l_exec.is_compiling then
						show_message ("Compiling interpreter")
					else
						l_label := "Testing " + l_exec.current_test_routine.test_class.test_class_name
						l_label.append ("." + l_exec.current_test_routine.name)
						show_message (l_label)
						progress_bar.set_proportion (l_exec.index / l_exec.count)
					end
				end
			when {CDD_STATUS_UPDATE}.executor_filter_change then
				l_exec := cdd_manager.background_executor
				if l_exec.filter = tree_view.filtered_view then
					toggle_filter_button.enable_select
				else
					toggle_filter_button.disable_select
				end
			when {CDD_STATUS_UPDATE}.debugger_step_code then
				l_debug := cdd_manager.debug_executor
				if l_debug.is_running then
					l_label := "Debugging " + l_debug.current_test_routine.test_class.test_class_name
					l_label.append ("." + l_debug.current_test_routine.name)
					show_message (l_label)
				else
					show_message ("Finished debugging")
				end
			when {CDD_STATUS_UPDATE}.execution_error_code then
				show_message ("An execution error has occured...")
			else
				show_message ("Unknown update code: " + an_update.code.out)
			end
		end

	internal_recycle is
			-- Unsubscribe all observing agents.
		do
			cdd_manager.status_update_actions.prune (internal_status_update_action)
			if cdd_manager.is_project_initialized then
				if cdd_manager.background_executor.filter = tree_view.filtered_view then
					cdd_manager.background_executor.reset_filter
				end
			end
			tree_view.remove_client
			Precursor
		end

feature {NONE} -- Implementation (Widgets)

	mini_toolbar: SD_TOOL_BAR
			-- Toolbar for control buttons

	filter_box: EV_COMBO_BOX
			-- Combo box for defining filter

	grid: ES_GRID
			-- Grid for displaying `filter' results

	status_label: EV_LABEL
			-- Label describing current tester status

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR
			-- Progress bar showing progress of test executor

feature {NONE} -- Implementation (Buttons)

	toggle_filter_button: EV_TOGGLE_BUTTON
			-- Button for setting current filter as test executors filter

	debug_button: EV_TOOL_BAR_BUTTON
			-- Button for running test executor

	toggle_extraction_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Button for examinating a test case

feature {NONE} -- Implementation

	debug_test_routine is
			-- Run currently selected test routine in debugger.
		local
			l_selected: LIST [EV_GRID_ROW]
			l_tree_node: CDD_TREE_NODE
		do
			l_selected := grid.selected_rows
			if l_selected.count = 1 then
				l_tree_node ?= l_selected.first.data
			end
			if l_tree_node /= Void and then l_tree_node.is_leaf then
				if cdd_manager.debug_executor.can_start then
					cdd_manager.debug_executor.start (l_tree_node.test_routine)
				else
					show_error ("Unable to start debugger: make sure debugger is not running and system is not beeing compiled")
				end
			else
				show_error ("Please select a test routine")
			end
		end

	toggle_filter is
			-- (Un)set current filter in test executor.
		do
			if toggle_filter_button.is_selected then
				cdd_manager.background_executor.set_filter (tree_view.filtered_view)
			else
				cdd_manager.background_executor.reset_filter
			end
		end

	toggle_extraction is
			-- Enable/Disable extraction of test cases.
		do
			if cdd_manager.is_extracting_enabled then
				cdd_manager.disable_extracting
			else
				cdd_manager.enable_extracting
			end
		end

	show_message (a_msg: STRING) is
			-- Display `a_msg' in `status_label'.
		require
			a_msg_not_void: a_msg /= Void
		do
			status_label.set_text (a_msg)
			status_label.set_foreground_color (stock_colors.black)
		end

	show_error (an_error: STRING) is
			-- Display `an_error' in `status_label'.
		require
			an_error_not_void: an_error /= Void
		do
			status_label.set_text (an_error)
			status_label.set_foreground_color (stock_colors.red)
		end

feature {NONE} -- Implementation (grid)

	tree_view: CDD_TREE_VIEW
			-- Tree view providing test routines which should be displayed by `Current'

	last_added_rows_count: INTEGER
			-- Number of rows added by the last call to `add_rows_recursive'?

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

	refresh_grid is
			-- Build grid.
		do
			develop_window.lock_update
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			last_added_rows_count := 0
			add_rows_recursive (Void, tree_view.nodes)
			develop_window.unlock_update
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
				if a_parent /= Void then
					a_parent.expand
				end
			end
		ensure
			count_greater_or_equal_list_count: last_added_rows_count >= a_list.count
			valid_count: grid.row_count = old grid.row_count + last_added_rows_count - old last_added_rows_count
		end

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
					inspect
						a_col
					when 2 then
						Result := new_outcome_item (l_node.test_routine)
					when 3 then
						Result := new_class_item (l_node.test_routine)
					when 4 then
						Result := new_feature_item (l_node.test_routine)
					else
						Result := empty_item
					end
				else
					Result := empty_item
				end
			else
				Result := empty_item
			end
		ensure
			not_void: Result /= Void
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
				token_writer.process_basic_text (a_node.tag)
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
					Result.text.append ("FAIL")
					Result.set_foreground_color (stock_colors.red)
					Result.select_actions.extend (agent (an_item: EV_GRID_LABEL_ITEM)
						do
							an_item.set_foreground_color (an_item.foreground_color)
						end)
				elseif l_last.is_pass then
					Result.text.append ("PASS")
					Result.set_foreground_color (stock_colors.green)
				else
					Result.text.append ("UNRESOLVED")
					Result.set_foreground_color (stock_colors.dark_yellow)
				end
				Result.set_tooltip (l_tooltip)
			end
		ensure
			not_void: Result /= Void
		end

	new_class_item (a_test_routine: CDD_TEST_ROUTINE): EB_GRID_EDITOR_TOKEN_ITEM is
			-- Grid item displaying class of `a_test_routine'
		do
			create Result.make_with_text ("TODO")
		ensure
			not_void: Result /= Void
		end

	new_feature_item (a_test_routine: CDD_TEST_ROUTINE): EB_GRID_EDITOR_TOKEN_ITEM is
			-- Grid item displaying feature of `a_test_routine'
		do
			create Result.make_with_text ("TODO")
		ensure
			not_void: Result /= Void
		end

	empty_item: EV_GRID_ITEM is
			-- Empty grid item
		do
			create Result
		ensure
			not_void: Result /= Void
		end

	update_filter is
			-- Update filter tags of `filter' corresponding
			-- to `test_field' and rebuild filter.
		local
			l_tags: DS_ARRAYED_LIST [STRING]
			tokens: LIST [STRING_32]
		do
			create l_tags.make_default
			tokens := filter_box.text.split (' ')
			from
				tokens.start
			until
				tokens.off
			loop
				if not tokens.item.is_empty then
					l_tags.force_last (tokens.item)
				end
				tokens.forth
			end
			tree_view.filtered_view.set_filters (l_tags)
		end

	select_filter_text is
		do
			if filter_box.text.is_equal ("All") then
				filter_box.set_text ("")
			elseif filter_box.text.is_equal ("Failing%T%T(outcome.fail)") then
				filter_box.set_text ("outcome.fail")
			elseif filter_box.text.is_equal ("Unresolved%T(outcome.unresolved)") then
				filter_box.set_text ("outcome.unresolved")
			else
				check
					dead_end: False
				end
			end
			update_filter
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


invariant

	cdd_manager_not_void: cdd_manager /= Void
	internal_status_update_action_not_void: internal_status_update_action /= Void

	tree_view_not_void: tree_view /= Void

		-- Widgets
	mini_toolbar_not_void: mini_toolbar /= Void
	filter_box_not_void: filter_box /= Void
	grid_not_void: grid /= Void
	status_label_not_void: status_label /= Void
	debug_button_not_void: debug_button /= Void
	toggle_filter_button_not_void: toggle_filter_button /= Void
	progress_bar_not_void: progress_bar /= Void


	toggle_extraction_button_not_void: toggle_extraction_button /= Void

end
