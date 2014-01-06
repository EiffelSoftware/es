note
	description: "[
		Command to launch Code Analyzer.
		
		Can be added to toolbars and menus.
		Can be executed using stones.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CODE_ANALYSIS_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item,
			initialize_sd_toolbar_item
		end

	SHARED_EIFFEL_PROJECT

	SHARED_ERROR_HANDLER

	COMPILER_EXPORTER

	EB_SHARED_WINDOW_MANAGER

create
	make

feature {NONE} -- Initialization

	make
			-- Creation method.
		local
			e: ES_CA_FIX_EXECUTOR
		do
			enable_sensitive
			set_up_menu_items
		end

feature -- Execution

	execute
			-- Execute when no stone is provided. The whole system will be analyzed.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_analyze_all)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_analyze_all)
					l_save_confirm.show_on_active_window
				else
					compile_and_analyze_all
				end
			end
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT)
			-- Execute with `a_stone'.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_analyze (a_stone))
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_analyze (a_stone))
					l_save_confirm.show_on_active_window
				else
					compile_and_analyze (a_stone)
				end
			end
		end

feature {ES_CODE_ANALYSIS_BENCH_HELPER} -- Basic operations

	save_compile_and_analyze_all
		do
			window_manager.save_all_before_compiling
			compile_and_analyze_all
		end

	compile_and_analyze_all
		local
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
			l_dialog: ES_INFORMATION_PROMPT
		do
				-- Make a list of all the changed classes in case we only analyze them.
			create previously_changed_classes.make
			across eiffel_universe.all_classes as l_classes loop
				if l_classes.item.changed then
					previously_changed_classes.extend (l_classes.item)
				end
			end
				-- Compile the project and only analyze if the compilation was successful.
			eiffel_project.quick_melt (True, True, True)
			if eiffel_project.successful then
				create l_helper
				if l_helper.code_analyzer.is_running then
					create l_dialog.make_standard ("Code analysis is already running.%NPlease%
						% wait until the current analysis has finished.")
					l_dialog.show_on_active_window
				else
						-- Detection of changes 

						-- If we did a system analysis recently then only add modified classes.
--					if last_was_analyze_all then
--						create l_dialog.make_standard ("Since you are doing an analysis of the %
--							%system again, only recently changed classes will be analyzed.")
--							l_dialog.show_on_active_window
--						analyze_changed_classes
--					else
						analyze_all
--					end
					last_was_analyze_all := True
				end
			end
		end

	last_was_analyze_all: BOOLEAN

	previously_changed_classes: LINKED_LIST [CLASS_I]

	save_compile_and_analyze (a_stone: STONE)
			-- Save modified windows, compile project and perform analysis.
		do
			window_manager.save_all_before_compiling
			compile_and_analyze (a_stone)
		end

	compile_and_analyze (a_stone: STONE)
			-- Compile project and perform analysis.
		local
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
			l_dialog: ES_INFORMATION_PROMPT
		do
			-- Compile the project and only analyze if the compilation was successful.
			eiffel_project.quick_melt (True, True, True)
			if eiffel_project.successful then
				create l_helper
				if l_helper.code_analyzer.is_running then
					create l_dialog.make_standard ("Code analysis is already running.%NPlease wait until the current analysis has finished.")
					l_dialog.show_on_active_window
				else
					perform_analysis (a_stone)
				end
			end
		end

	analyze_all
		local
			l_cluster: CLUSTER_I
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
			l_scope_label: EV_LABEL
		do
			create l_helper
			code_analyzer := l_helper.code_analyzer
			code_analyzer.clear_classes_to_analyze
			code_analyzer.rule_violations.wipe_out
			code_analyzer.add_whole_system

			disable_tool_button
			window_manager.display_message ("Code analysis running...")
			code_analyzer.add_completed_action (agent analysis_completed)
			code_analyzer.analyze
			l_scope_label := ca_tool.panel.scope_label
			l_scope_label.set_text ("System")
			l_scope_label.set_tooltip ("The whole system was analyzed recently.")
			l_scope_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (30, 30, 30))
		end

	analyze_changed_classes
		local
			l_cluster: CLUSTER_I
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
			l_scope_label: EV_LABEL
		do
			create l_helper
			code_analyzer := l_helper.code_analyzer
			code_analyzer.clear_classes_to_analyze
			code_analyzer.add_classes (previously_changed_classes)
			across previously_changed_classes as l_changed loop
				code_analyzer.rule_violations.remove (l_changed.item.compiled_class)
			end

			disable_tool_button
			window_manager.display_message ("Code analysis running...")
			code_analyzer.add_completed_action (agent analysis_completed)
			code_analyzer.analyze
			l_scope_label := ca_tool.panel.scope_label
			l_scope_label.set_text ("System")
			l_scope_label.set_tooltip ("The whole system was analyzed recently.")
			l_scope_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (30, 30, 30))
		end

	last_scope_label: EV_LABEL

	perform_analysis (a_stone: STONE)
			-- Analyze `a_stone' only.
		local
			l_cluster: CLUSTER_I
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
			l_scope_label: EV_LABEL
		do
			last_was_analyze_all := False

			create l_helper
			code_analyzer := l_helper.code_analyzer
			code_analyzer.clear_classes_to_analyze
			code_analyzer.rule_violations.wipe_out

			l_scope_label := ca_tool.panel.scope_label

			if attached {CLASSC_STONE} a_stone as s then
				code_analyzer.add_class (s.class_i)
				l_scope_label.set_text (s.class_name)
				l_scope_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (140, 140, 255))
				l_scope_label.set_pebble (s)
				l_scope_label.set_pick_and_drop_mode
				l_scope_label.set_tooltip ("Class that has been analyzed recently.")
			elseif attached {CLUSTER_STONE} a_stone as s then
				if s.is_cluster then
					code_analyzer.add_cluster (s.cluster_i)
				else
					code_analyzer.add_group (s.group)
				end
				l_scope_label.set_text (s.stone_name)
				l_scope_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 140, 140))
				l_scope_label.set_pebble (s)
				l_scope_label.set_pick_and_drop_mode
				l_scope_label.set_tooltip ("Cluster that has been analyzed recently.")
			elseif attached {DATA_STONE} a_stone as s then
				if attached {LIST [CONF_GROUP]} s.data as g then
					from
						g.start
					until
						g.after
					loop
						if attached {CLUSTER_I} g.item_for_iteration as c then
							code_analyzer.add_cluster (c)
						end
						g.forth
					end
					l_scope_label.set_text (s.stone_name)
					l_scope_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (140, 255, 140))
					l_scope_label.set_pebble (s)
					l_scope_label.set_pick_and_drop_mode
					l_scope_label.set_tooltip ("Configuration group that has been analyzed recently.")
				end
			end

			disable_tool_button
			window_manager.display_message ("Code analysis running...")
			code_analyzer.add_completed_action (agent analysis_completed)
			code_analyzer.analyze
		end

	analysis_completed (a_success: BOOLEAN)
		local
			l_violation_exists: BOOLEAN
		do
			event_list.prune_event_items (event_context_cookie)

			across code_analyzer.rule_violations as l_viol_list loop
				across l_viol_list.item as l_viol loop
					event_list.put_event_item (event_context_cookie, create {CA_RULE_VIOLATION_EVENT}.make (l_viol.item))
					l_violation_exists := True
				end
			end

			if not l_violation_exists then
				event_list.put_event_item (event_context_cookie, create {CA_NO_ISSUES_EVENT}.make)
			end

			show_ca_tool

			enable_tool_button
			window_manager.display_message ("Code Analysis has terminated.")
		end

	event_context_cookie: UUID
			-- Context cookie for Code Analysis events.
		local
			l_generator: UUID_GENERATOR
		once
			create l_generator
			Result := l_generator.generate_uuid
		end

	ca_tool: detachable ES_CODE_ANALYSIS_TOOL
			-- Proof tool (if applicable).
		local
			l_tool: ES_TOOL [EB_TOOL]
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if not l_window.is_recycled and then l_window.is_visible and then l_window = window_manager.last_focused_development_window then
				l_tool := l_window.shell_tools.tool ({ES_CODE_ANALYSIS_TOOL})
				if attached {ES_CODE_ANALYSIS_TOOL} l_tool as l_ca_tool then
					Result := l_ca_tool
				else
					check False end
				end
			end
		end

	show_ca_tool
			-- Shows the proof tool
		local
			l_tool: ES_CODE_ANALYSIS_TOOL
		do
			l_tool := ca_tool
			if l_tool /= Void and then not l_tool.is_recycled then
				l_tool.show (True)
			end
		end

	disable_tool_button
			-- Disable proof button on tool.
		local
			l_tool: ES_CODE_ANALYSIS_TOOL
		do
			l_tool := ca_tool
			if l_tool /= Void and then l_tool.is_tool_instantiated then
				ca_tool.panel.run_analysis_button.disable_sensitive
			end
		end

	enable_tool_button
			-- Enable proof button on tool.
		local
			l_tool: ES_CODE_ANALYSIS_TOOL
		do
			l_tool := ca_tool
			if l_tool /= Void and then l_tool.is_tool_instantiated then
				ca_tool.panel.run_analysis_button.enable_sensitive
			end
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute)

			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	initialize_sd_toolbar_item (a_item: EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON; display_text: BOOLEAN)
			-- <Precursor>
		do
			Precursor (a_item, display_text)
			a_item.set_menu_function (agent drop_down_menu)
		end

feature -- Status report

	droppable (a_pebble: ANY): BOOLEAN
			-- Can user drop `a_pebble' on `Current'?
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_data_stone: DATA_STONE
			l_list: LIST [CONF_GROUP]
		do
			Result :=
				(attached {CLASSC_STONE} a_pebble) or else
				(attached {CLUSTER_STONE} a_pebble) or else
				(attached {DATA_STONE} a_pebble as s and then attached {LIST [CONF_GROUP]} s.data)
		end

feature {NONE} -- Implementation

	code_analyzer: CA_CODE_ANALYZER
			-- Code Analyzer instance

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.view_flat_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.view_flat_icon_buffer
		end

	analyze_current_item
			-- Proof current item
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			last_execution := agent analyze_current_item
--			analyze_current_item_item.enable_select
--			analyze_parent_item_item.disable_select
--			analyze_system_item.disable_select

			l_window := window_manager.last_focused_development_window
			if droppable (l_window.stone) then
				execute_with_stone (l_window.stone)
			end
		end

	analyze_parent_cluster
			-- Proof parent cluster of window item.
		local
			l_window: EB_DEVELOPMENT_WINDOW
			l_cluster_stone: CLUSTER_STONE
		do
			last_execution := agent analyze_parent_cluster
--			analyze_current_item_item.disable_select
--			analyze_parent_item_item.enable_select
--			analyze_system_item.disable_select

			l_window := window_manager.last_focused_development_window
			if attached {CLASSC_STONE} l_window.stone as l_stone then
				create l_cluster_stone.make (l_stone.group)
				execute_with_stone (l_cluster_stone)
			elseif attached {CLUSTER_STONE} l_window.stone as l_stone then
				if l_stone.cluster_i.parent_cluster /= Void then
					create l_cluster_stone.make (l_stone.cluster_i.parent_cluster)
				end
				execute_with_stone (l_cluster_stone)
			end
		end

--	execute_proof_system
--			-- Proof whole system (excluding libraries).
--		do
--			last_execution := agent execute_proof_system
--			proof_current_item_item.disable_select
--			proof_parent_item_item.disable_select
--			proof_system_item.enable_select

--			execute_with_stone (Void)
--		end

	execute_last_action
			-- Execute same action as last time.
		do
			last_execution.call ([])
		end

feature {NONE} -- Implementation

	frozen service_consumer: SERVICE_CONSUMER [EVENT_LIST_S]
			-- Access to an event list service {EVENT_LIST_S} consumer.
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	frozen event_list: EVENT_LIST_S
			-- Access to an event list service.
		do
			check service_consumer.is_service_available end
			Result := service_consumer.service
		end

	set_up_menu_items
			-- Set up menu items of proof button
		do
			last_execution := agent analyze_current_item
			create analyze_system_item.make_with_text_and_action ("Analyze whole system", agent analyze_all)
--			analyze_system_item.toggle
			create analyze_current_item_item.make_with_text_and_action ("Analyze current item", agent analyze_current_item)
			create analyze_parent_item_item.make_with_text_and_action ("Analyze parent cluster of current item", agent analyze_parent_cluster)

		end

	drop_down_menu: EV_MENU
			-- Drop down menu for `new_sd_toolbar_item'.
		once
			create Result
			Result.extend (analyze_system_item)
			Result.extend (analyze_current_item_item)
			Result.extend (analyze_parent_item_item)
		ensure
			not_void: Result /= Void
		end

	last_execution: PROCEDURE [ANY, TUPLE []]
			-- Last executed actions

	analyze_current_item_item: EV_MENU_ITEM
			-- Menu item to analyze current item

	analyze_parent_item_item: EV_MENU_ITEM
			-- Menu item to analyze parent item

	analyze_system_item: EV_MENU_ITEM
			-- Menu item to analyze system

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			Result := "Run Code Analysis"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := "Analyze whole system"
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := "Run Code Analysis"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := "Run code analyzer."
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "Code Analysis"
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
