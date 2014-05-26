note
	description:
		"Graphical panel for AutoDebug tool"
	date: "$Date$"
	revision: "$Revision$"

class ES_ADB_TOOL_PANEL

inherit

	ES_ADB_ACTIONS

	ES_ADB_ACTION_PUBLISHER

	EB_TOOL
		redefine
			show,
			internal_recycle,
			close
		end

	SHARED_WORKBENCH

	EB_RECYCLER

	SHARED_EIFFEL_PROJECT

	ES_ADB_SHARED_INFO_CENTER

	ES_ADB_INTERFACE_STRINGS

create
	make

feature -- GUI element access

	widget: EV_VERTICAL_BOX
			-- Graphical object of `Current'

	settings_panel: ES_ADB_PANEL_SETTINGS
			-- Settings panel

	faults_panel: ES_ADB_PANEL_FAULTS
			-- Faults panel

	fixes_panel: ES_ADB_PANEL_FIXES
			-- Fixes panel

	output_panel: ES_ADB_PANEL_OUTPUT

	autodebug_notebook: EV_NOTEBOOK
			-- Notebook for autodebug tool panels

feature {NONE} -- Initialization

	build_interface
			-- <Precursor>
		do
			create widget
			create autodebug_notebook

			create settings_panel.make (Current)
			create faults_panel.make (Current)
			create fixes_panel.make (Current)
			create output_panel.make (Current)
			autodebug_notebook.extend (settings_panel)
			autodebug_notebook.extend (faults_panel)
			autodebug_notebook.extend (fixes_panel)
			autodebug_notebook.extend (output_panel)
				-- Setup tab names			
			autodebug_notebook.set_item_text (autodebug_notebook.i_th (1), Tab_name_setting)
			autodebug_notebook.set_item_text (autodebug_notebook.i_th (2), Tab_name_faults)
			autodebug_notebook.set_item_text (autodebug_notebook.i_th (3), Tab_name_fixes)
			autodebug_notebook.set_item_text (autodebug_notebook.i_th (4), Tab_name_output)
			autodebug_notebook.selection_actions.extend (agent on_tab_change)
			autodebug_notebook.select_item (settings_panel)
			widget.extend (autodebug_notebook)
--			install_agents (metric_manager)
--			if not window_manager.compile_start_actions.has (metric_manager.on_compile_start_agent) then
--				window_manager.compile_start_actions.extend (metric_manager.on_compile_start_agent)
--			end
			register_action (content.show_actions, agent on_select)

			notify_project_loaded_agent := agent notify_project_loaded
			notify_project_unloaded_agent := agent notify_project_unloaded
			eiffel_project.manager.load_agents.extend (notify_project_loaded_agent)
			eiffel_project.manager.close_agents.extend (on_project_unloaded_agent)
			if eiffel_project.manager.is_project_loaded then
				notify_project_loaded
			end
		end

feature -- Actions

	on_select
			-- AutoDebug tool has been selected, synchronize.
		do
			if content.is_visible then
				if workbench.eiffel_project /= Void and then workbench.eiffel_project.successful and then (not config.is_project_loaded or else not info_center.is_in_sync_with_project)  then
					info_center.on_project_loaded
				end
				on_tab_change
				set_title (Void)
			end
		end

	on_deselect
			-- AutoDebug tool has been deselected.
		do
			on_tab_change
		end

	show
			-- <Precursor>
		do
			Precursor {EB_TOOL}
			on_select
		end

	close
			-- <Precursor>
		do
			Precursor {EB_TOOL}
			on_deselect
		end

feature{NONE} -- Actions

	on_tab_change
			-- Action to be performed when selected tab changes
		local
			l_selected_index: INTEGER
			l_notebook: EV_NOTEBOOK
			l_panel: ES_ADB_PANEL_ABSTRACT
			i: INTEGER
			l_notebook_count: INTEGER
		do
			from
				l_notebook := autodebug_notebook
				l_selected_index := l_notebook.selected_item_index
				i := 1
				l_notebook_count := l_notebook.count
			until
				i > l_notebook_count
			loop
				l_panel ?= l_notebook @ i
				check l_panel /= Void end
				if is_shown and then i = l_selected_index then
					l_panel.set_is_selected (True)
					l_panel.on_select
				else
					l_panel.set_is_selected (False)
				end
				i := i + 1
			end
		end

	on_project_loaded
			-- Action to be performed when project loaded
		do
			info_center.on_project_loaded
			on_tab_change
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
			Info_center.on_project_unloaded
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		do
			compile_start_actions.call (Void)
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		do
			compile_stop_actions.call (Void)
		end

	on_debugging_start
			--
		do

		end

	on_debugging_stop
			--
		do

		end

	on_testing_start
			-- Action to be performed when debugging starts
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- Action to be performed when a new test case is generated
		do
		end

	on_testing_stop
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fixing_stop (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
		do
		end

feature{NONE} -- Implementation

	notify_project_loaded
			-- Notify `debugging_result_manager' that project has been loaded.
		do
			if not config.is_project_loaded or else not info_center.is_in_sync_with_project then
				on_project_loaded
			end
		end

	notify_project_unloaded
			-- Notify `debugging_result_manager' that project has been unloaded.
		do
			if config.is_project_loaded and then info_center.is_in_sync_with_project then
				on_project_unloaded
			end
		end

	notify_project_loaded_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of `notify_project_loaded'

	notify_project_unloaded_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of `notify_project_unloaded'

feature -- Title change

	is_tool_opened: BOOLEAN
			-- Is Current tool opened?
		do
			Result := content.is_visible
		end

	is_tool_visible: BOOLEAN
			-- Is Current tool visible?
		do
			Result := widget.is_displayed
		end

	set_title (a_result: STRING_GENERAL)
			-- Set title of Current tool.
			-- If `a_result' is not Void, display it on title.
		local
			l_name: STRING_32
		do
			l_name := Tool_name.as_string_32
			if is_tool_opened and then not is_tool_visible then
				if a_result /= Void then
					l_name.append (" - ")
					l_name.append (a_result.as_string_32)
				end
			end
			content.set_short_title (l_name)
		end

feature -- Basic operations

	is_debugging: BOOLEAN
			--
		do

		end

	is_project_loaded: BOOLEAN
			--
		do

		end

	is_eiffel_compiling: BOOLEAN
			--
		do

		end

	display_error_message
			-- Display error message from `metric_manager'.
		do
--			if not metric_manager.is_exit_requested then
--				if metric_manager.has_error then
--					show_error_message (agent metric_manager.last_error, agent metric_manager.clear_last_error, develop_window.window)
--				end
--			end
		end

feature {NONE} -- Memory management

	internal_recycle
			-- Remove all references to `Current', and leave `Current' in an
			-- unstable state, so that we know `Current' is not referenced any longer.
		do
--			settings_panel.recycle
--			faults_panel.recycle
--			fixes_panel.recycle

			settings_panel := Void
			faults_panel := Void
			fixes_panel := Void

--			uninstall_agents (metric_manager)
--			if notify_project_loaded_agent /= Void then
--				eiffel_project.manager.load_agents.prune_all (notify_project_loaded_agent)
--			end
--			eiffel_project.manager.close_agents.prune_all (notify_project_unloaded_agent)

			Precursor {EB_TOOL}
		end

--feature -- Access

--	autofix_results: HASH_TABLE [ES_EVE_AUTOFIX_RESULT, STRING]
--			-- Mapping from fault signatures to AutoFix results .
--			-- Key: fault signatures
--			-- Val: results from fixing
--		do
--			if autofix_results_cache = Void then
--				create autofix_results_cache.make (30)
--				autofix_results_cache.compare_objects
--			end
--			Result := autofix_results_cache
--		end

feature {NONE} -- Initialization

--    build_tool_interface (a_widget: like user_widget)
--            -- <Precursor>
--		do
--		end

--	on_after_initialized
--			-- <Precursor>
--		do
--			Precursor {ES_DOCKABLE_TOOL_PANEL}

--			reload_all_from_result_directory
--			user_widget.refresh_all
--		end

--feature -- Basic operation

--	reload (a_fault_signature: STRING)
--			-- Reload the result for `a_fault_signature'.
--		require
--			signature_not_empty: a_fault_signature /= Void and then not a_fault_signature.is_empty
--		local
--			l_result: ES_EVE_AUTOFIX_RESULT
--		do
--			if autofix_results.has (a_fault_signature) then
--				l_result := autofix_results.item (a_fault_signature)
--				l_result.reload
--			else
--				create l_result.make (a_fault_signature)
--				autofix_results.force (l_result, a_fault_signature)
--			end
--			user_widget.refresh (a_fault_signature)
--		end

--	reload_all
--			-- Reload all autofix results from AutoFix result directory.
--		do
--			reload_all_from_result_directory
--			user_widget.refresh_all
--		end

--feature {NONE} -- Implementation

--	reload_all_from_result_directory
--			-- Load all autofix_results from the default output directory of AutoFix.
--		local
--			l_result_dir: DIRECTORY
--			l_entry_name: STRING
--			l_fault_signature: STRING
--			l_result: ES_EVE_AUTOFIX_RESULT
--		do
--			autofix_results.wipe_out
--			if attached eiffel_project as lt_prj and then attached lt_prj.project_directory as lt_dir then
--				create l_result_dir.make_with_path (lt_dir.fixing_results_path)
--				if l_result_dir.exists then
--					l_result_dir.open_read
--					if not l_result_dir.is_closed then
--						from
--							l_result_dir.start
--							l_result_dir.readentry
--						until
--							l_result_dir.lastentry = Void
--						loop
--							l_entry_name := l_result_dir.lastentry.twin
--							if l_entry_name.ends_with (".afr") then
--								l_fault_signature := l_entry_name.substring (1, l_entry_name.count -4)
--								create l_result.make (l_fault_signature)
--								autofix_results.force (l_result, l_fault_signature)
--							end

--							l_result_dir.readentry
--						end
--					end
--				end
--			end
--		end

feature -- Access: Help

	help_context_id: STRING_32
			-- <Precursor>
		once
			Result := "26E2C799-B48A-C588-CDF1-DD47B1994B09"
		end

--feature {NONE} -- Cache

--	autofix_results_cache: like autofix_results
--			-- Cache for `autofix_results'.

feature {NONE} -- Factory

--    create_widget: ES_AUTOFIX_WIDGET
--            -- <Precursor>
--		do
----			create Result.make (Current)
--		end

    create_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
		do
			--| No tool bar
		end

    create_mini_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
        do
  			create Result.make (10)
        end


note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
