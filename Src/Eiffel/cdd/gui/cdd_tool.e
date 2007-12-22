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

create
	make

feature {NONE} -- Initialization

	build_interface is
			-- Initialize all widgets for `Current'.
		do
			create widget
			create notebook
			create enable_button.make_with_text ("Enable CDD")
			build_status_bar
			build_mini_toolbar

			internal_refresh_action := agent refresh
			cdd_manager.refresh_actions.extend (internal_refresh_action)
			refresh
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
		end

	build_mini_toolbar is
			-- Create widgets for displaying a tool bar
		do
			create mini_toolbar

			create run_button
			run_button.set_tooltip ("Run test case in debugger")
			run_button.set_pixmap (pixmaps.mini_pixmaps.general_next_icon)
			--run_button.select_actions.extend (agent on_run_button)
			run_button.disable_sensitive

			create examine_button
			examine_button.set_tooltip ("Fix selected test case")
			examine_button.set_pixmap (pixmaps.mini_pixmaps.general_search_icon)
			--examine_button.select_actions.extend (agent on_examinate_button)
			examine_button.disable_sensitive

			create delete_button
			delete_button.set_tooltip ("Remove test case")
			delete_button.set_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
			--delete_button.select_actions.extend (agent on_delete_button)
			--delete_button.drop_actions.extend (agent on_drop_class)
			delete_button.enable_sensitive

			create toggle_testing_button
			toggle_testing_button.set_pixmap (pixmaps.mini_pixmaps.general_toogle_icon)
			--toggle_testing_button.select_actions.extend (agent on_toggle_testing_button)
			toggle_testing_button.enable_sensitive


			mini_toolbar.extend (run_button)
			mini_toolbar.extend (examine_button)
			mini_toolbar.extend (delete_button)
			mini_toolbar.extend (toggle_testing_button)
			mini_toolbar.extend (create {EV_TOOL_BAR_SEPARATOR})
		ensure then
			mini_toolbar_not_void: mini_toolbar /= Void
		end

feature -- Access

	title: STRING is "Testing"
			-- Title describing `Current'

	widget: EV_VERTICAL_BOX
			-- Main widget for visualizing `Current'

	is_enabled: BOOLEAN is
			-- Do we currently display test suite information?
		do
			Result := not widget.is_empty and then widget.first = notebook
		end

	is_disabled: BOOLEAN is
			-- Do we currently display a button for enabling cdd?
		do
			Result := not widget.is_empty and then widget.first = enable_button
		end

feature {NONE} -- Implementation

	internal_refresh_action: PROCEDURE [ANY, TUPLE]
			-- Agent called when `cdd_manager' refreshes its status

feature {NONE} -- Implementation

	refresh is
			-- Check whether cdd has been enabled/disabled in the mean while
			-- and update widgets in `Current'.
		do
			if cdd_manager.is_cdd_enabled then
				if not is_enabled then
					enable
				end
			else
				if not is_disabled then
					disable
				end
			end
		end

	enable is
			-- Enable the display of test routines, outcomes, etc.
		require
			not_enabled: not is_enabled
		do
			widget.wipe_out
			widget.extend (notebook)
			widget.extend (status_bar)
			widget.disable_item_expand (status_bar)

			add_notebook_tab ("All", Void)
			add_notebook_tab ("Failing", "outcome:fail")
			add_notebook_tab ("Unresolved", "outcome:unresolved")
		end

	disable is
			-- Remove all cdd specific information an display an `enable cdd' button.
		require
			not_disabled: not is_disabled
		local
			l_item: EV_WIDGET
		do
			from
			until
				notebook.is_empty
			loop
				l_item := notebook.first
				notebook.prune (l_item)
				l_item.destroy
			end
			widget.wipe_out
			widget.extend (enable_button)
			status_label.set_text ("CDD disabled")
			widget.extend (status_bar)
			widget.disable_item_expand (status_bar)
		end

	add_notebook_tab (a_name, a_filter_tag: STRING) is
			-- Add a new tab to `notebook' displaying test routines with predefined tag `a_filter_tag'.
		require
			a_name_not_void: a_name /= Void
		local
			l_filtered_view: CDD_FILTERED_VIEW
			l_tree_view: CDD_TREE_VIEW
			l_routines_view: CDD_TEST_ROUTINES_VIEW
		do
			create l_filtered_view.make (cdd_manager.test_suite)
			if a_filter_tag /= Void then
				l_filtered_view.filters.put_last (a_filter_tag)
			end
			create l_tree_view.make (l_filtered_view)
			create l_routines_view.make (l_tree_view)
			notebook.extend (l_routines_view)
			notebook.set_item_text (l_routines_view, a_name)
		ensure
			notebook_extended: notebook.count = old notebook.count + 1
		end

	internal_recycle is
			-- Unsubscribe all observing agents.
		do
			Precursor
			if is_enabled then
				disable
			end
			if cdd_manager /= Void then
				cdd_manager.refresh_actions.prune (internal_refresh_action)
			end
		end

feature {NONE} -- Widgets

	cdd_manager: CDD_MANAGER is
			-- Current cdd manager containing cdd status and test suite
		do
			if develop_window /= Void then
				Result := develop_window.eb_debugger_manager.cdd_manager
			end
		end

	mini_toolbar: EV_TOOL_BAR
			-- Toolbar for control buttons

	notebook: EV_NOTEBOOK
			-- Notebook for displaying different view tabs

	status_bar: EV_STATUS_BAR
			-- Bar for displaying different status messages

	status_label: EV_LABEL
			-- Label describing current tester status

feature {NONE} -- Buttons

	enable_button: EV_BUTTON
			-- Button for enabling cdd

	toggle_testing_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling testing

	run_button: EV_TOOL_BAR_BUTTON
			-- Button for debugging test case

	examine_button: EV_TOOL_BAR_BUTTON
			-- Button for examinating a test case

	delete_button: EV_TOOL_BAR_BUTTON
			-- Button for deleting a single test case

invariant

	notebook_not_void: notebook /= Void
	enable_button_not_void: enable_button /= Void
	mini_toolbar_not_void: mini_toolbar /= Void
	status_bar_not_void: status_bar /= Void
	status_label_not_void: status_label /= Void

	enable_button_not_void: enable_button /= Void
	toggle_testing_button_not_void: toggle_testing_button /= Void
	run_button_not_void: run_button /= Void
	examine_button_not_void: examine_button /= Void
	delete_button_not_void: delete_button /= Void

	enabled_xor_disabled: is_enabled xor is_disabled

	internal_refresh_action_not_void: internal_refresh_action /= Void
	recycled_xor_subscribed: is_recycled xor cdd_manager.refresh_actions.has (internal_refresh_action)
	not_enabled_implies_notbook_empty: (not is_enabled) implies notebook.is_empty

end
