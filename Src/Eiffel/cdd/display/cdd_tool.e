indexing
	description: "Tool for displaying testing results"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TOOL

inherit

	EB_TOOL
		rename
			manager as window
		redefine
			make
		end

	EB_EDITOR_TOKEN_GRID_SUPPORT
		redefine
			grid
		end

create
	make

feature {NONE} -- Initialization

	make (a_window: like window) is
			--
		do
			manager := a_window.eb_debugger_manager.cdd_manager
			Precursor {EB_TOOL} (a_window)

			internal_refresh_agent := agent refresh
			internal_add_test_case_agent := agent add_test_case
			internal_remove_test_case_agent := agent remove_test_case
			internal_testing_status_agent := agent update_testing_status
			manager.refresh_actions.extend (internal_refresh_agent)
			manager.update_state_actions.extend (internal_testing_status_agent)

			refresh
		end

	build_interface is
			-- Build `widget' for displaying and controlling testing.
		do
			create widget
			build_notebook
			build_status_bar
			build_tool_bar
		end

	build_notebook is
			-- Build notebook for view selection containing the grid
		require
			widget_not_viod: widget /= Void
		local
			l_vbox: EV_VERTICAL_BOX
			i: INTEGER
			l_names: ARRAY [STRING]
		do
			create notebook
			create grid.make_with_tool (Current)
			enable_editor_token_pnd
			enable_ctrl_right_click_to_open_new_window
			l_names := << "Hierarchy", "Failures" >>
			from
				i := 1
			until
				i > 2
			loop
				create l_vbox
				notebook.extend (l_vbox)
				notebook.set_item_text (l_vbox, l_names.item (i))
				if i = 1 then
					l_vbox.extend (grid)
				end
				i := i + 1
			end
			notebook.selection_actions.extend (agent select_tab)
			widget.extend (notebook)
		end

	build_status_bar is
			-- Create 'status_bar' and extend
		require
			widget_not_void: widget /= Void
		local
			l_frame: EV_FRAME
		do
			create status_bar

			create l_frame
			create status_label.make_with_text ("")
			status_label.align_text_left
			l_frame.extend (status_label)
			status_bar.extend (l_frame)

			widget.extend (status_bar)
			widget.disable_item_expand (status_bar)
		end

	build_tool_bar is
			-- Create widgets for displaying a tool bar
		do
			create mini_tool_bar

			create run_button
			run_button.set_tooltip ("Run test case in debugger")
			run_button.set_pixmap (pixmaps.mini_pixmaps.general_next_icon)
			run_button.select_actions.extend (agent on_run_button)
			run_button.disable_sensitive

			create examine_button
			examine_button.set_tooltip ("Fix selected test case")
			examine_button.set_pixmap (pixmaps.mini_pixmaps.general_search_icon)
			examine_button.select_actions.extend (agent on_examinate_button)
			examine_button.disable_sensitive

			create delete_button
			delete_button.set_tooltip ("Remove test case")
			delete_button.set_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
			delete_button.select_actions.extend (agent on_delete_button)
			delete_button.drop_actions.extend (agent on_drop_class)
			delete_button.enable_sensitive

			create toggle_testing_button
			toggle_testing_button.set_pixmap (pixmaps.mini_pixmaps.general_toogle_icon)
			toggle_testing_button.select_actions.extend (agent on_toggle_testing_button)
			toggle_testing_button.enable_sensitive


			mini_tool_bar.extend (run_button)
			mini_tool_bar.extend (examine_button)
			mini_tool_bar.extend (delete_button)
			mini_tool_bar.extend (toggle_testing_button)
		end

	build_explorer_bar_item (an_explorer_bar: EB_EXPLORER_BAR) is
			-- Create `explorer_bar_item' and add it to the explorer bar.
		do
			create explorer_bar_item.make_with_mini_toolbar (an_explorer_bar, widget, title, True, mini_tool_bar)
			explorer_bar_item.set_menu_name (title)
			explorer_bar_item.set_pixmap (pixmaps.icon_pixmaps.tool_feature_icon)
			an_explorer_bar.add (explorer_bar_item)
		end

feature -- Access

	title: STRING is "Testing"

	widget: EV_VERTICAL_BOX

	manager: CDD_MANAGER
			-- Manager for test suite operations

feature -- Status setting

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Add `a_tc' to `grid'.
		require
			a_tc_not_void: a_tc /= Void
		do
			refresh_grid
			status_label.set_text ("Added " + a_tc.tester_class.name)
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove `a_tc' from `grid'.
		require
			a_tc_not_void: a_tc /= Void
		do
			refresh_grid
			status_label.set_text ("Removed " + a_tc.tester_class.name)
		end

	refresh is
			-- Redraw all widgets according to new test suite status.
		local
			l_ts: CDD_TEST_SUITE
		do
			window.lock_update
			if manager.is_testing_enabled then
				l_ts := manager.test_suite
				if not l_ts.add_test_case_actions.has (internal_add_test_case_agent) then
					l_ts.add_test_case_actions.extend (internal_add_test_case_agent)
				end
				if not l_ts.remove_test_case_actions.has (internal_remove_test_case_agent) then
					l_ts.remove_test_case_actions.extend (internal_remove_test_case_agent)
				end
				toggle_testing_button.select_actions.block
				toggle_testing_button.enable_select
				toggle_testing_button.set_tooltip ("Disable cdd-testing")
				toggle_testing_button.select_actions.resume
				notebook.enable_sensitive
				grid.enable_sensitive
				refresh_grid
			else
				toggle_testing_button.select_actions.block
				toggle_testing_button.disable_select
				toggle_testing_button.set_tooltip ("Enable cdd-testing")
				toggle_testing_button.select_actions.resume
				notebook.disable_sensitive
				grid.disable_sensitive
				grid.remove_and_clear_all_rows
			end
			window.unlock_update
		end

	update_testing_status (a_message: STRING) is
			-- Adapt widgets to current testing status.
		require
			manager.is_testing_enabled
			a_message_not_void: a_message /= Void
		do
			status_label.set_text (a_message)
			if manager.is_debugging or selected_test_case = Void then
				run_button.disable_sensitive
			else
				run_button.enable_sensitive
			end
			if not manager.is_running and notebook.selected_item_index = 2 then
				refresh_grid
			end
		end

	recycle is
			-- Prune 'Current' from manager and tester and remove widgets.
		do
			manager.refresh_actions.prune (internal_refresh_agent)
			manager.update_state_actions.prune (internal_testing_status_agent)
			if manager.is_testing_enabled then
				manager.test_suite.add_test_case_actions.prune (internal_add_test_case_agent)
				manager.test_suite.remove_test_case_actions.prune (internal_remove_test_case_agent)
			end
			grid.wipe_out
		end

feature {CDD_GRID_TEST_CASE_LINE} -- Selection

	selected_test_case: CDD_TEST_CASE
			-- Currently selected test case in tree, Void if no test case is selected

	select_test_case (a_tc: CDD_TEST_CASE) is
			-- Actions performed when test case item in tree is selected.
		require
			valid_test_case: a_tc /= Void
		do
			selected_test_case := a_tc
			run_button.enable_sensitive
			if not a_tc.is_verified then
				examine_button.enable_sensitive
			end
		ensure
			test_case_selected: selected_test_case = a_tc
		end

	deselect_test_case is
			-- Actions performed when item in tree is deselected.
		do
			selected_test_case := Void
			run_button.disable_sensitive
			examine_button.disable_sensitive
		ensure
			nothing_selected: selected_test_case = Void
		end

feature {NONE} -- Button events

	on_toggle_testing_button is
			-- Actions performed when toggle testing button is pressed.
		local
			l_wd: EV_WARNING_DIALOG
		do
			if manager.is_testing_enabled then
				-- Disable
				if manager.is_running then
					toggle_testing_button.enable_select
					create l_wd.make_with_text ("Cannot disable cdd-testing at the moment because some cdd activity is currently ongoing. Please try again later.")
					l_wd.show_modal_to_window (window.window)
				else
					manager.disable_testing
				end
			else
				-- Enable
				if manager.can_enable_testing then
					manager.enable_testing
				else
					toggle_testing_button.disable_select
					create l_wd.make_with_text ("Can not add cdd_testing cluster because compiled configuration is not up to date, please recompile.")
					l_wd.show_modal_to_window (window.window)
				end
			end
		end

	on_run_button is
			-- Run selected test case in the debugger.
		require
			manager_not_debugging: not manager.is_debugging
			test_case_selected: selected_test_case /= Void
		local
			l_id: EV_INFORMATION_DIALOG
		do
			if manager.can_start_debugging then
				manager.start_debugging (selected_test_case)
			else
				create l_id.make_with_text ("Not able to run the test case in the debugger - sorry")
			end
		end

	on_examinate_button is
			-- Try to examinate selected test case
		require
			test_case_selected: selected_test_case /= Void
		local
			l_ed: EV_ERROR_DIALOG
			l_id: EV_INFORMATION_DIALOG
		do
			if manager.can_start_examinating then
				create l_id.make_with_text ("This will fix your test case. Please enter same input as in the last run.")
				l_id.show_modal_to_window (window.window)
				if selected_test_case /= Void and manager.can_start_examinating then
					manager.examinate_test_case (selected_test_case)
				end
			else
				create l_ed.make_with_text ("Can not fix test case. Make sure application is not running!")
				l_ed.show_modal_to_window (window.window)
			end
		end

	on_delete_button is
			-- If test case is selected, ask user if he wants to delete it.
		local
			l_msg: STRING
			l_cd: EV_CONFIRMATION_DIALOG
		do
			if selected_test_case /= Void then
				confirm_delete (selected_test_case)
			end
		end

	on_drop_class (a_stone: CLASSI_STONE) is
			-- Remove associated class of `a_stone' from test suite.
		local
			l_tc: CDD_TEST_CASE
		do
			l_tc := manager.test_suite.test_case_for_class (a_stone.class_i)
			if l_tc /= Void then
				confirm_delete (l_tc)
			end
		end

	confirm_delete (a_tc: CDD_TEST_CASE) is
			-- Ask user if he really wants to delete `a_tc'?
		require
			a_tc_not_void: a_tc /= Void
		local
			l_msg: STRING
			l_cd: EV_CONFIRMATION_DIALOG
		do
			l_msg := "Test case " + a_tc.tester_class.name + " will be permanently%N removed from the system and from the disc.%N%N%
					%Are you sure this is what you want?"
			create l_cd.make_with_text_and_actions (l_msg, << agent try_remove_test_case (a_tc) >>)
			l_cd.show_modal_to_window (window.window)
		end

	try_remove_test_case (a_tc: CDD_TEST_CASE) is
			-- If test suite still contains `a_tc' remove it.
		require
			a_tc_not_void: a_tc /= Void
		do
			if manager.test_suite.test_cases.has (a_tc) then
				manager.remove_test_case (a_tc)
			end
		ensure
			removed: not manager.test_suite.test_cases.has (a_tc)
		end

feature {NONE} -- Action implementation

	internal_refresh_agent: PROCEDURE [like Current, TUPLE]
			-- Agent called when test suite is refreshed

	internal_add_test_case_agent: PROCEDURE [like Current, TUPLE [CDD_TEST_CASE]]
			-- Agent called when test case is added

	internal_remove_test_case_agent: PROCEDURE [like Current, TUPLE [CDD_TEST_CASE]]
			-- Agent called when test case was removed

	internal_testing_status_agent: PROCEDURE [like Current, TUPLE [STRING]]
			-- Agent called when testing status changes

feature {NONE} -- Implementation

	mini_tool_bar: EV_TOOL_BAR
			-- Toolbar

	toggle_testing_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling testing

	run_button: EV_TOOL_BAR_BUTTON
			-- Button for debugging test case

	examine_button: EV_TOOL_BAR_BUTTON
			-- Button for examinating a test case

	delete_button: EV_TOOL_BAR_BUTTON
			-- Button for deleting a single test case

	status_bar: EV_STATUS_BAR
			-- Status bar showing the current tester status

	status_label: EV_LABEL
			-- Label describing current tester status

	notebook: EV_NOTEBOOK
			-- Notebook for different test case listing

	grid: CDD_GRID
			-- Grid for hierarchically displaying test cases

feature {NONE} -- Implementation

	select_tab is
			-- Change test case listing.
		local
			l_vbox: EV_VERTICAL_BOX
		do
			grid.parent.wipe_out
			l_vbox ?= notebook.selected_item
			l_vbox.extend (grid)
			refresh_grid
		end

	refresh_grid is
			-- Remove all rows of `grid' and insert new ones according to
			-- test suite status and selected notebook tab.
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
			l_tc: CDD_TEST_CASE
			l_select: INTEGER
		do
			grid.remove_and_clear_all_rows
			l_select := notebook.selected_item_index
			from
				l_cursor := manager.test_suite.test_cases.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_tc := l_cursor.item
				if (l_select = 2 and l_tc.status = l_tc.fail_code) or l_select = 1 then
					grid.add_test_case (l_tc)
				end
				l_cursor.forth
			end
		end

invariant
	manager_not_void: manager /= Void
	widget_not_void: widget /= Void
	valid_grid: grid /= Void
	valid_mini_tool_bar: mini_tool_bar /= Void
	enable_testing_button_valid: toggle_testing_button /= Void
	run_button_valid: run_button /= Void
	delete_button_valid: delete_button /= Void
	status_bar_valid: status_bar /= Void
	status_label_valid: status_label /= Void
	examine_button_not_void: examine_button /= Void

end
