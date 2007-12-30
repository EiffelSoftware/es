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
			cdd_manager := develop_window.eb_debugger_manager.cdd_manager

			create widget
			create notebook_cell
			create notebook
			create enable_button.make_with_text ("Enable CDD")
			enable_button.select_actions.extend (agent toggle_cdd)
			build_status_bar
			build_mini_toolbar

			widget.extend (notebook_cell)
			widget.extend (status_bar)
			widget.disable_item_expand (status_bar)

			if cdd_manager.is_cdd_enabled then
				update_status (create {CDD_STATUS_UPDATE}.make_with_code ({CDD_STATUS_UPDATE}.enable_cdd_code))
			else
				update_status (create {CDD_STATUS_UPDATE}.make_with_code ({CDD_STATUS_UPDATE}.disable_cdd_code))
			end

			internal_status_update_action := agent update_status
			cdd_manager.status_update_actions.extend (internal_status_update_action)
		ensure then
			cdd_manager_set: cdd_manager = develop_window.eb_debugger_manager.cdd_manager
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
		local
			l_sep: SD_TOOL_BAR_SEPARATOR
		do
			create mini_toolbar.make

			create run_button.make
			run_button.set_tooltip ("Run test cases")
			run_button.set_pixmap (pixmaps.mini_pixmaps.general_next_icon)
			run_button.select_actions.extend (agent toggle_testing)

			create stop_button.make
			stop_button.set_tooltip ("Cancel execution")
			stop_button.set_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
			stop_button.select_actions.extend (agent toggle_testing)

			create toggle_extraction_button.make
			toggle_extraction_button.set_tooltip ("Enable/Disable extraction")
			toggle_extraction_button.set_pixmap (pixmaps.mini_pixmaps.general_toogle_icon)
			toggle_extraction_button.select_actions.extend (agent toggle_extraction)

			create toggle_cdd_button.make
			toggle_cdd_button.set_tooltip ("Enable/Disable CDD")
			toggle_cdd_button.set_pixmap (pixmaps.mini_pixmaps.general_toogle_icon)
			toggle_cdd_button.select_actions.extend (agent toggle_cdd)

			mini_toolbar.extend (run_button)
			mini_toolbar.extend (stop_button)
			create l_sep.make
			mini_toolbar.extend (l_sep)
			mini_toolbar.extend (toggle_cdd_button)
			mini_toolbar.extend (toggle_extraction_button)
			create l_sep.make
			mini_toolbar.extend (l_sep)

			mini_toolbar.compute_minimum_size
		ensure then
			mini_toolbar_not_void: mini_toolbar /= Void
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
			l_label: STRING
		do
			inspect
				an_update.code
			when {CDD_STATUS_UPDATE}.enable_cdd_code then
					-- Build notebook tabs
				notebook_cell.wipe_out
				notebook_cell.extend (notebook)

				add_notebook_tab ("All", Void)
				add_notebook_tab ("Failing", "outcome.fail")
				add_notebook_tab ("Unresolved", "outcome.unresolved")

				status_label.set_text ("CDD enabled")
				run_button.enable_sensitive
				stop_button.disable_sensitive
				toggle_cdd_button.enable_select
				toggle_extraction_button.enable_sensitive
				if cdd_manager.is_extracting_enabled then
					toggle_extraction_button.enable_select
				else
					toggle_extraction_button.disable_select
				end
			when {CDD_STATUS_UPDATE}.disable_cdd_code then
					-- Recycle notebook tabs and show enable button
				recycle_notebook_tabs

				notebook_cell.wipe_out
				notebook_cell.extend (enable_button)

				status_label.set_text ("CDD disabled")
				run_button.disable_sensitive
				stop_button.disable_sensitive
				toggle_cdd_button.disable_select
				toggle_extraction_button.disable_select
				toggle_extraction_button.disable_sensitive
			when {CDD_STATUS_UPDATE}.enable_extracting_code then
				status_label.set_text ("Extraction enabled")
				toggle_extraction_button.enable_select
			when {CDD_STATUS_UPDATE}.disable_extracting_code then
				status_label.set_text ("Extraction disabled")
				toggle_extraction_button.disable_select
			when {CDD_STATUS_UPDATE}.executor_step_code then
				l_exec := cdd_manager.background_executor
				if not l_exec.has_next_step then
					run_button.enable_sensitive
					stop_button.disable_sensitive
					status_label.set_text ("Finished executing")
				else
					run_button.disable_sensitive
					stop_button.enable_sensitive
					if l_exec.is_compiling then
						status_label.set_text ("Compiling interpreter")
					else
						l_label := "Testing " + l_exec.current_test_routine.test_class.test_class_name
						l_label.append ("." + l_exec.current_test_routine.name)
						status_label.set_text (l_label)
					end
				end
			when {CDD_STATUS_UPDATE}.execution_error_code then
				status_label.set_text ("An execution error has occured...")
			else
				status_label.set_text ("Unknown update code: " + an_update.code.out)
			end
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
			l_filtered_view.enable_observing
			if a_filter_tag /= Void then
				l_filtered_view.filters.put_last (a_filter_tag)
			end
			create l_tree_view.make (l_filtered_view)
			l_tree_view.enable_observing
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

			recycle_notebook_tabs

			-- TODO: Recycle all widgets!

			cdd_manager.status_update_actions.prune (internal_status_update_action)
		end

	recycle_notebook_tabs is
			-- Remove all notebook tabs and recycle them
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
		ensure
			notebook_empty: notebook.is_empty
		end

feature {NONE} -- Implementation (Widgets)

	mini_toolbar: SD_TOOL_BAR
			-- Toolbar for control buttons

	notebook_cell: EV_CELL
			-- Cell containing `notebook' if cdd is enabled,
			-- otherwise button for enabling cdd

	notebook: EV_NOTEBOOK
			-- Notebook for displaying different view tabs

	status_bar: EV_STATUS_BAR
			-- Bar for displaying different status messages

	status_label: EV_LABEL
			-- Label describing current tester status

feature {NONE} -- Implementation (Buttons)

	enable_button: EV_BUTTON
			-- Button for enabling cdd

	run_button: SD_TOOL_BAR_BUTTON
			-- Button for running test executor

	stop_button: SD_TOOL_BAR_BUTTON
			-- Button for canceling test executor

	toggle_cdd_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Button for enabling/disabling testing

	toggle_extraction_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Button for examinating a test case

feature {NONE} -- Implementation (Button functionality)

	toggle_cdd is
			-- Disable/Enable CDD.
		do
			if cdd_manager /= Void then
				if cdd_manager.is_cdd_enabled then
					if cdd_manager.can_disable_cdd then
						cdd_manager.disable_cdd
					end
				else
					if cdd_manager.can_enable_cdd then
						cdd_manager.enable_cdd
					end
				end
			end
		end

	toggle_extraction is
			-- Enable/Disable extraction of test cases.
		do
			if cdd_manager.is_cdd_enabled then
				if cdd_manager.is_extracting_enabled then
					cdd_manager.disable_extracting
				else
					cdd_manager.enable_extracting
				end
			end
		end

	toggle_testing is
			-- Start/Cancel testing
		do
			if cdd_manager.is_cdd_enabled then
				if cdd_manager.background_executor.has_next_step then
					cdd_manager.background_executor.cancel
				else
					cdd_manager.background_executor.start
				end
			end
		end

invariant

	notbook_cell_not_void: notebook_cell /= Void
	notebook_not_void: notebook /= Void
	enable_button_not_void: enable_button /= Void
	mini_toolbar_not_void: mini_toolbar /= Void
	status_bar_not_void: status_bar /= Void
	status_label_not_void: status_label /= Void

	enable_button_not_void: enable_button /= Void
	run_button_not_void: run_button /= Void
	stop_button_not_void: stop_button /= Void
	toggle_testing_button_not_void: toggle_cdd_button /= Void
	toggle_extraction_button_not_void: toggle_extraction_button /= Void

	internal_status_update_action_not_void: internal_status_update_action /= Void
	cdd_manager_not_void: cdd_manager /= Void
	recycled_xor_subscribed: is_recycled xor (cdd_manager.status_update_actions.has (internal_status_update_action))


end
