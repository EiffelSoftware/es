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
		end

create
	make

feature {NONE} -- Initialization

	build_interface is
			-- Initialize all widgets for `Current'.
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
			--enable_editor_token_pnd
			--enable_ctrl_right_click_to_open_new_window
			l_names := << "All", "Failing", "Unresolved" >>
			from
				i := 1
			until
				i > l_names.count
			loop
				create l_vbox
				notebook.extend (l_vbox)
				notebook.set_item_text (l_vbox, l_names.item (i))
				if i = 1 then
					--l_vbox.extend (grid)
				end
				i := i + 1
			end
			--notebook.selection_actions.extend (agent select_tab)
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
			create tool_bar

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


			tool_bar.extend (run_button)
			tool_bar.extend (examine_button)
			tool_bar.extend (delete_button)
			tool_bar.extend (toggle_testing_button)
		end

feature -- Access

	title: STRING is "Testing"
			-- Title describing `Current'

	widget: EV_VERTICAL_BOX
			-- Main widget for visualizing `Current'

feature {NONE} -- Widgets

	tool_bar: EV_TOOL_BAR
			-- Toolbar for control buttons

	notebook: EV_NOTEBOOK
			-- Notebook for displaying different view tabs

	status_bar: EV_STATUS_BAR
			-- Bar for displaying different status messages

	status_label: EV_LABEL
			-- Label describing current tester status

feature {NONE} -- Buttons

	toggle_testing_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling testing

	run_button: EV_TOOL_BAR_BUTTON
			-- Button for debugging test case

	examine_button: EV_TOOL_BAR_BUTTON
			-- Button for examinating a test case

	delete_button: EV_TOOL_BAR_BUTTON
			-- Button for deleting a single test case

end
