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
			internal_recycle
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

			build_filter_box
			build_toolbar
			build_grids
			build_status_bar

			update_button_state
		ensure then
			cdd_manager_set: cdd_manager = develop_window.eb_debugger_manager.cdd_manager
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
			create l_label.make_with_text ("Filter")
			l_hbox.extend (l_label)
			l_hbox.disable_item_expand (l_label)

			create filter_box
			create l_item.make_with_text ("All")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Failing%T%T%T%T(outcome.fail)")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Unresolved%T%T%T(outcome.unresolved)")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Extracted Test Cases%T(type.extracted)")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Manual Test Cases%T%T(type.manual)")
			filter_box.extend (l_item)
			create l_item.make_with_text ("Synthesized Test Cases%T(type.synthesized)")
			filter_box.extend (l_item)
			filter_box.set_text ("")
			l_hbox.extend (filter_box)
			filter_box.return_actions.extend (agent update_filter)
			filter_box.select_actions.extend (agent select_filter_text)
			filter_box.drop_actions.extend (agent drop_class_on_filter)

			create toggle_filter_button.make_with_text ("Restrict")
			toggle_filter_button.select_actions.extend (agent toggle_filter)
			toggle_filter_button.set_tooltip ("Only execute filtered test routines")
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
			l_hbox: EV_HORIZONTAL_BOX
			l_toolbar: EV_TOOL_BAR
			l_sep: EV_TOOL_BAR_SEPARATOR
			l_label: EV_LABEL
		do
			create l_hbox
			l_hbox.set_padding (6)
			create l_toolbar

			create debug_button
			debug_button.select_actions.extend (agent debug_test_routine)
			debug_button.set_tooltip ("Debug selected test routine")
			debug_button.set_pixmap (pixmaps.icon_pixmaps.cdd_debug_icon)
			l_toolbar.extend (debug_button)

			create l_sep
			l_toolbar.extend (l_sep)

			create toggle_execution_button
			toggle_execution_button.set_pixmap (pixmaps.icon_pixmaps.cdd_execute_icon)
			toggle_execution_button.select_actions.extend (agent toggle_execution)
			toggle_execution_button.set_tooltip ("Enable/Disable automatic background execution of tests")
			--l_tbutton.set_pixmap (pixmaps.icon_pixmaps.tool_breakpoints_icon)
			l_toolbar.extend (toggle_execution_button)

			create toggle_extraction_button
			toggle_extraction_button.set_pixmap (pixmaps.icon_pixmaps.cdd_extract_icon)
			toggle_extraction_button.select_actions.extend (agent toggle_extraction)
			toggle_extraction_button.set_tooltip ("Enable/Disable automatic extraction of new test cases")
			l_toolbar.extend (toggle_extraction_button)

			create l_sep
			l_toolbar.extend (l_sep)

			create new_test_routine_button
			new_test_routine_button.set_tooltip ("Create new manual test class")
			new_test_routine_button.select_actions.extend (agent create_new_test_routine)
			new_test_routine_button.set_pixmap (pixmaps.icon_pixmaps.cdd_new_test_icon)
			l_toolbar.extend (new_test_routine_button)

			l_hbox.extend (l_toolbar)

			create l_label.make_with_text ("View")
			l_hbox.extend (l_label)
			l_hbox.disable_item_expand (l_label)

			create tree_view_box
			tree_view_box.disable_edit
			tree_view_box.set_minimum_width (140)
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Type"))
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Outcome"))
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Testcase"))
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Tested Class"))
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Tag"))
			tree_view_box.extend (create {EV_LIST_ITEM}.make_with_text ("Failure"))
			tree_view_box.i_th (3).enable_select
			l_hbox.extend (tree_view_box)
			l_hbox.disable_item_expand (tree_view_box)
			tree_view_box.select_actions.extend (agent select_view)

			widget.extend (l_hbox)
			widget.disable_item_expand (l_hbox)
		end

	build_grids is
			-- Create `grid' and add it to `widget'.
		require
			widget_not_void: widget /= Void
		local
			l_tree_view: CDD_TREE_VIEW
			l_filter: CDD_FILTERED_VIEW
			l_split_area: EV_VERTICAL_SPLIT_AREA
			l_notebook: EV_NOTEBOOK
		do
				-- Build main grid
			create l_filter.make (cdd_manager.test_suite)
			create l_tree_view.make (l_filter)
			create grid.make (l_tree_view, develop_window)
			grid.row_select_actions.force (agent update_related_grid)
			grid.row_deselect_actions.force (agent update_related_grid)

				-- Build details view and related grid
			create l_notebook


			create details_text
			details_text.set_font (preferences.editor_data.font)
			details_text.disable_edit
			details_text.disable_word_wrapping
			l_notebook.extend (details_text)
			l_notebook.set_item_text (details_text, "Details")

			create l_filter.make (cdd_manager.test_suite)
			create l_tree_view.make (l_filter)
			l_tree_view.set_view_code ({CDD_TREE_VIEW}.failure_view_code)
			create related_grid.make (l_tree_view, develop_window)
			l_notebook.extend (related_grid)
			l_notebook.set_item_text (related_grid, "Related")

				-- And put them into a split area
			create l_split_area
			l_split_area.extend (grid)
			l_split_area.extend (l_notebook)
			widget.extend (l_split_area)
			l_split_area.resize_actions.force (agent resize_grids (l_split_area, ?, ?, ?, ?))
		end

	build_status_bar is
			-- Add status bar containing `status_label' to `widget'
		require
			widget_not_void: widget /= Void
		local
			l_frame: EV_FRAME
			l_status_bar: EV_STATUS_BAR
		do
			create l_status_bar
			l_status_bar.set_border_width (2)

			create l_frame
			l_frame.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			create status_label
			status_label.align_text_left
			l_frame.extend (status_label)
			l_status_bar.extend (l_frame)

			create l_frame
			l_frame.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			create testing_label
			testing_label.set_minimum_width (100)
			testing_label.align_text_right
			l_frame.extend (testing_label)
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

	update_testing_label is
			-- Update `testing_label' to current test
			-- execution status
		local
			l_exec: CDD_TEST_EXECUTOR
			l_label: STRING
		do
			l_exec := cdd_manager.background_executor
			if l_exec.is_executing then
				create l_label.make (20)
				if l_exec.fail_count > 0 then
					testing_label.set_foreground_color (stock_colors.red)
					l_label.append_integer (l_exec.fail_count)
					l_label.append_character ('/')
					l_label.append_integer (l_exec.index)
					l_label.append (" tests fail")
				else
					testing_label.set_foreground_color (stock_colors.black)
					l_label.append_integer (l_exec.index)
					l_label.append_character ('/')
					l_label.append_integer (l_exec.test_routines.count)
					l_label.append (" tested")
				end
				testing_label.set_text (l_label)
			end
		end

	update_button_state is
			-- Update the state of toolbar buttons according to
			-- the state of `cdd_manager'.
		do
--			toggle_extraction_button.select_actions.block
--			toggle_execution_button.select_actions.block
--			toggle_filter_button.select_actions.block
			if cdd_manager.is_project_initialized then
				debug_button.enable_sensitive
				toggle_extraction_button.enable_sensitive
				toggle_execution_button.enable_sensitive
				toggle_filter_button.enable_sensitive
				new_test_routine_button.enable_sensitive
				if cdd_manager.is_extracting_enabled then
					toggle_extraction_button.enable_select
				else
					toggle_extraction_button.disable_select
				end
				if cdd_manager.is_executing_enabled then
					toggle_execution_button.enable_select
				else
					toggle_execution_button.disable_select
				end
			else
				debug_button.disable_sensitive
				toggle_extraction_button.disable_sensitive
				toggle_execution_button.disable_sensitive
				toggle_filter_button.disable_sensitive
				new_test_routine_button.disable_sensitive
			end
--			toggle_extraction_button.select_actions.resume
--			toggle_execution_button.select_actions.resume
--			toggle_filter_button.select_actions.resume
		end


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
			when {CDD_STATUS_UPDATE}.manager_update_code then
				update_button_state
			when {CDD_STATUS_UPDATE}.executor_step_code then
				l_exec := cdd_manager.background_executor
				if not l_exec.has_next_step then
					--run_button.enable_sensitive
					show_message ("Finished executing")
					progress_bar.set_proportion (0.0)
				else
					update_testing_label
					--run_button.disable_sensitive
					if l_exec.is_compiling then
						show_message ("Compiling interpreter")
					else
						l_label := "Testing " + l_exec.current_test_routine.test_class.test_class_name
						l_label.append ("." + l_exec.current_test_routine.name)
						show_message (l_label)
						progress_bar.set_proportion (l_exec.index / l_exec.test_routines.count)
					end
				end
			when {CDD_STATUS_UPDATE}.executor_filter_change then
				l_exec := cdd_manager.background_executor
				if l_exec.filter = grid.tree_view.filtered_view then
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
			end
		end

	internal_recycle is
			-- Unsubscribe all observing agents.
		do
			cdd_manager.status_update_actions.prune_all (internal_status_update_action)
			if cdd_manager.is_project_initialized then
				if cdd_manager.background_executor.filter = grid.tree_view.filtered_view then
					cdd_manager.background_executor.reset_filter
				end
			end
			Precursor
		end

feature {NONE} -- Access (Widgets)

	grid: CDD_TREE_VIEW_GRID
			-- Grid displaying test routines corresponding
			-- to filter and view defined in `filter_box' and
			-- `tree_view_box'

	related_grid: CDD_TREE_VIEW_GRID
			-- Grid displaying related test routines
			-- for selected routine in `grid'

	details_text: EV_TEXT
			-- Text field for displaying details of a
			-- selected test routine in `grid'

	filter_box: EV_COMBO_BOX
			-- Combo box for defining filter

	tree_view_box: EV_COMBO_BOX
			-- Drop down menu for choosing view

	status_label: EV_LABEL
			-- Label describing current tester status

	testing_label: EV_LABEL
			-- Label containing current test outcome information

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR
			-- Progress bar showing progress of test executor

feature {NONE} -- Access (Buttons)

	toggle_filter_button: EV_TOGGLE_BUTTON
			-- Button for setting current filter as test executors filter

	debug_button: EV_TOOL_BAR_BUTTON
			-- Button for running test executor

	toggle_extraction_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling extraction

	toggle_execution_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling automatic execution

	new_test_routine_button: EV_TOOL_BAR_BUTTON
			-- Button for creating new test routine

feature {NONE} -- Implementation (Grids)

	resize_grids (a_split_area: EV_SPLIT_AREA; a_x, a_y, a_width, a_height: INTEGER) is
			-- Make sure `a_split_area' keeps its proportions.
		require
			a_split_area_not_void: a_split_area /= Void
		do
			a_split_area.set_proportion (0.7)
		end

	update_related_grid (a_row: EV_GRID_ROW) is
			-- Update `related_grid' according to selected
			-- row in `grid'.
		local
			l_node: CDD_TREE_NODE
			l_test_routine: CDD_TEST_ROUTINE
			l_outcome: CDD_TEST_EXECUTION_RESPONSE
			l_list: DS_ARRAYED_LIST [STRING]
			l_regex: RX_PCRE_REGULAR_EXPRESSION
			l_tag: STRING
		do
			if a_row.is_selected then
				l_node ?= a_row.data
				if l_node.is_leaf then
					l_test_routine := l_node.test_routine
				end
			end

				-- Update `details_text'
			details_text.set_text ("")
			if l_test_routine /= Void then
				if l_test_routine.outcomes.is_empty then
					details_text.append_text ("Test routine has not been executed yet")
				else
					l_outcome := l_test_routine.outcomes.last
					details_text.append_text (l_outcome.out)
					if l_outcome.is_fail then
						details_text.append_text ("%N%N%NStack trace:%N")
						details_text.append_text (l_outcome.test_response.exception.exception_trace)
					end
				end
			end

				-- Update `related_grid'
			if l_test_routine /= Void then
				l_list := l_test_routine.tags_with_prefix ("failure.")
				if not l_list.is_empty then
					create l_regex.make
					l_regex.compile ("^failure\.([0-9]+)")
					l_regex.match (l_list.first)
					if l_regex.has_matched then
						l_tag := "failure."
						l_regex.append_captured_substring_to_string (l_tag, 1)
					else
						l_list := Void
					end
				else
					l_list := Void
				end
			end
			if l_tag = Void then
				l_tag := "_none_"
			end
			create l_list.make (1)
			l_list.force_first (l_tag)
			related_grid.tree_view.filtered_view.set_filters (l_list)
		end

feature {NONE} -- Implementation (Buttons)

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
				if cdd_manager.background_executor.filter /= grid.tree_view.filtered_view then
					cdd_manager.background_executor.set_filter (grid.tree_view.filtered_view)
				end
			elseif cdd_manager.background_executor.filter = grid.tree_view.filtered_view then
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

	toggle_execution is
			-- Enable/Disable execution of tests.
		do
			if cdd_manager.is_executing_enabled then
				cdd_manager.disable_executing
			else
				cdd_manager.enable_executing
			end
		end

	create_new_test_routine is
			-- Show dialog for creating new test class
		local
			l_dialog: CDD_CREATE_TEST_ROUTINE_DIALOG
		do
			create l_dialog.make_default (develop_window.history_manager.target, cdd_manager)
			l_dialog.call_default
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

feature {NONE} -- Filter / Tree view

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
			grid.tree_view.filtered_view.set_filters (l_tags)
		end

	select_filter_text is
		do
			if filter_box.selected_item = filter_box.i_th (1) then
				filter_box.set_text ("")
			elseif filter_box.selected_item = filter_box.i_th (2) then
				filter_box.set_text ("outcome.fail")
			elseif filter_box.selected_item = filter_box.i_th (3) then
				filter_box.set_text ("outcome.unresolved")
			elseif filter_box.selected_item = filter_box.i_th (4) then
				filter_box.set_text ("type.extracted")
			elseif filter_box.selected_item = filter_box.i_th (5) then
				filter_box.set_text ("type.manual")
			elseif filter_box.selected_item = filter_box.i_th (6) then
				filter_box.set_text ("type.synthesized")
			else
				check
					dead_end: False
				end
			end
			update_filter
		end

	drop_class_on_filter (a_stone: CLASSI_STONE) is
			-- Set appropriate filter text for `a_stone'.
		require
			a_stone_not_void: a_stone /= Void
		local
			l_eclass: EIFFEL_CLASS_C
			l_list: DS_ARRAYED_LIST [STRING]
		do
			l_eclass ?= a_stone.class_i.compiled_class
			create l_list.make (1)
			if l_eclass /= Void and then cdd_manager.test_suite.has_test_case_for_class (l_eclass) then
				l_list.put_first ("name." + l_eclass.name_in_upper)
			else
				l_list.put_first ("covers." + a_stone.class_i.name)
			end
			filter_box.set_text (l_list.first)
			grid.tree_view.filtered_view.set_filters (l_list)
		end

	select_view is
			-- Set view in `tree_view' corresponding to
			-- selected item of `tree_view_box'.
		do
			if tree_view_box.selected_item = tree_view_box.i_th (1) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.type_view_code)
			elseif tree_view_box.selected_item = tree_view_box.i_th (2) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.outcome_view_code)
			elseif tree_view_box.selected_item = tree_view_box.i_th (3) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.name_view_code)
			elseif tree_view_box.selected_item = tree_view_box.i_th (4) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.covers_view_code)
			elseif tree_view_box.selected_item = tree_view_box.i_th (5) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.tags_view_code)
			elseif tree_view_box.selected_item = tree_view_box.i_th (6) then
				grid.tree_view.set_view_code ({CDD_TREE_VIEW}.failure_view_code)
			else
				check
					dead_end: False
				end
			end
		end

feature {NONE} -- Implementation

	stock_colors: EV_STOCK_COLORS is
			-- Predefined colors
		once
			create Result
		end

invariant

	cdd_manager_not_void: cdd_manager /= Void
	internal_status_update_action_not_void: internal_status_update_action /= Void

		-- Widgets
	grid_not_void: grid /= Void
	related_grid_not_void: related_grid /= Void
	details_text_not_void: details_text /= Void
	filter_box_not_void: filter_box /= Void
	tree_view_box_not_void: tree_view_box /= Void
	status_label_not_void: status_label /= Void
	testing_label_not_void: testing_label /= Void
	debug_button_not_void: debug_button /= Void
	toggle_filter_button_not_void: toggle_filter_button /= Void
	progress_bar_not_void: progress_bar /= Void

	toggle_extraction_button_not_void: toggle_extraction_button /= Void
	toggle_execution_button_not_void: toggle_execution_button /= Void
	new_test_routine_button_not_void: new_test_routine_button /= Void

end
