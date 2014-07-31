
class
	ES_ADB_PANEL_SETTINGS

inherit

	ES_ADB_PANEL_SETTINGS_IMP
		redefine
			propogate_values_from_ui_to_config,
			propogate_values_from_config_to_ui
		end

	ES_ADB_ACTIONS
		undefine
			copy,
			default_create,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_tool: like tool_panel)
			-- Initialization
		require
			a_tool /= Void
		do
			set_tool_panel (a_tool)
			default_create

			clear_information_display_widget
			enable_information_display_widget (False)
			enable_command_invocation_widget (False)

			register_event_handlers

			info_center.extend (Current)
		end

feature{NONE} -- Update UI

	clear_information_display_widget
			-- Clear the contents of config widgets.
		do
			evtext_group_to_add.set_text ("")
			evlist_groups_to_debug.wipe_out
			evtext_working_directory.set_text ("")
			evtext_testing_cutoff_time.set_text ("")
			evtext_testing_seed.set_text ("")
			evtext_fixing_cutoff_time.set_text ("")
			evtext_fixing_number_of_fixes.set_text ("")
			evtext_fixing_passing_tests.set_text ("")
			evtext_fixing_failing_tests.set_text ("")
		end

	enable_information_display_widget (a_flag: BOOLEAN)
			-- Enable/Disable config widgets.
		do
			if a_flag then
				evtext_group_to_add.enable_sensitive
				on_group_to_add_changed
				evlist_groups_to_debug.remove_selection
				evlist_groups_to_debug.enable_sensitive
				on_list_content_changed
				evtext_working_directory.enable_sensitive
				evbutton_browse.enable_sensitive
				evcombo_testing_session_type.enable_sensitive
				evtext_testing_cutoff_time.enable_sensitive
				evtext_testing_seed.enable_sensitive
				evcheckbutton_testing_use_fixed_seed.enable_sensitive
				evcombo_start_fixing_type.enable_sensitive
				evtext_fixing_cutoff_time.enable_sensitive
				evtext_fixing_number_of_fixes.enable_sensitive
				evcheckbutton_fixing_contracts.enable_sensitive
				evcheckbutton_fixing_implementation.enable_sensitive
				evtext_fixing_passing_tests.enable_sensitive
				evtext_fixing_failing_tests.enable_sensitive
			else
				evtext_group_to_add.disable_sensitive
				evbutton_add.disable_sensitive
				evlist_groups_to_debug.remove_selection
				evlist_groups_to_debug.disable_sensitive
				evlist_classes_in_group.hide
				evbutton_remove.disable_sensitive
				evbutton_remove_all.disable_sensitive
				evtext_working_directory.disable_sensitive
				evbutton_browse.disable_sensitive
				evcombo_testing_session_type.disable_sensitive
				evtext_testing_cutoff_time.disable_sensitive
				evtext_testing_seed.disable_sensitive
				evcheckbutton_testing_use_fixed_seed.disable_sensitive
				evcombo_start_fixing_type.disable_sensitive
				evtext_fixing_cutoff_time.disable_sensitive
				evtext_fixing_number_of_fixes.disable_sensitive
				evcheckbutton_fixing_contracts.disable_sensitive
				evcheckbutton_fixing_implementation.disable_sensitive
				evtext_fixing_passing_tests.disable_sensitive
				evtext_fixing_failing_tests.disable_sensitive
			end
		end

	enable_command_invocation_widget (a_flag: BOOLEAN)
			-- Enable/Disable all command widgets on the panel.
		do
			if a_flag then
				evbutton_load_config.enable_sensitive
				evbutton_save_config.enable_sensitive
				update_evbutton_start (workbench.eiffel_project /= Void and workbench.eiffel_project.successful)
			else
				evbutton_load_config.disable_sensitive
				evbutton_save_config.disable_sensitive
				evbutton_start.disable_sensitive
			end
		end

	update_evbutton_start (a_flag: BOOLEAN)
			-- Enable/Disable `evbutton_start'.
		do
			if a_flag then
				evbutton_start.enable_sensitive
			else
				evbutton_start.disable_sensitive
			end
		end

feature -- ADB Action

	on_project_loaded
			-- <Precursor>
		do
			propogate_values_from_config_to_ui

			enable_information_display_widget (True)
			enable_command_invocation_widget (True)
		end

	on_project_unloaded
			-- <Precursor>
		do
			propogate_values_from_ui_to_config
			config.save
			config.unload

			enable_information_display_widget (False)
			enable_command_invocation_widget (False)
			clear_information_display_widget
		end

	on_compile_start
			-- <Precursor>
		do
		end

	on_compile_stop
			-- <Precursor>
		do
		end

	on_debugging_start
			-- <Precursor>
		do
			tool_panel.set_external_process_running (True)
			on_save_settings
			enable_information_display_widget (False)
			enable_command_invocation_widget (False)
			evbutton_start.set_text (button_text_stop)
			evbutton_start.enable_sensitive
		end

	on_debugging_stop
			-- <Precursor>
		do
			evbutton_start.set_text (button_text_start)
			enable_information_display_widget (True)
			enable_command_invocation_widget (True)
			tool_panel.set_external_process_running (False)
		end

	on_testing_start
			-- <Precursor>
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		do
		end

	on_testing_stop
			-- <Precursor>
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do

		end

	on_fixing_stop
			-- <Precursor>
		do
		end

	on_continuation_debugging_start
			-- <Precursor>
		do
			on_save_settings
			enable_information_display_widget (False)
			enable_command_invocation_widget (False)
		end

	on_continuation_debugging_stop
			-- <Precursor>
		do
			enable_information_display_widget (True)
			enable_command_invocation_widget (True)
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
			-- <Precursor>
		do
		end

feature -- UI Actions

	register_event_handlers
			-- Register handlers to UI events.
		local
		do
			evtext_group_to_add.change_actions.extend (agent on_group_to_add_changed)
			evtext_group_to_add.key_press_actions.extend (agent on_group_to_add_enter)
			evlist_groups_to_debug.select_actions.extend (agent on_select_group)
			evlist_groups_to_debug.deselect_actions.extend (agent on_deselect_group)
			evbutton_add.select_actions.extend (agent on_add)
			evbutton_remove.select_actions.extend (agent on_remove)
			evbutton_remove_all.select_actions.extend (agent on_remove_all)
			evbutton_browse.select_actions.extend (agent on_browse)
			evcheckbutton_testing_use_fixed_seed.select_actions.extend (agent on_use_fixed_seed_change)

			evbutton_load_config.select_actions.extend (agent on_load_settings)
			evbutton_save_config.select_actions.extend (agent on_save_settings)
			evbutton_start.select_actions.extend (agent on_start)
		end

	on_group_to_add_changed
			-- Action to perform when the text in `evtext_group_to_add' is changed.
		local
			l_text: STRING
		do
			l_text := evtext_group_to_add.text
			if not l_text.is_empty then
				evbutton_add.enable_sensitive
			else
				evbutton_add.disable_sensitive
			end
		end

	on_group_to_add_enter (a_key: EV_KEY)
			-- Action to perform when `a_key' is pressed in `evtext_group_to_add'.
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_enter then
				on_add
			end
		end

	on_list_content_changed
			-- Action to perform when the content of `evlist_groups_to_debug' is changed.
		do
			if evlist_groups_to_debug.is_empty then
				evbutton_remove_all.disable_sensitive
				evbutton_start.disable_sensitive
			else
				evbutton_remove_all.enable_sensitive
				evbutton_start.enable_sensitive
			end
		end

	on_add
			-- Action to perform when "Add" button is clicked.
		local
			l_text: STRING
			l_group_item: EV_LIST_ITEM
		do
			l_text := evtext_group_to_add.text.twin
			l_text.prune_all (' ')
			l_text.prune_all ('%T')
			if not l_text.is_empty then
				if not config.class_groups.has (l_text) then
					create l_group_item.make_with_text (l_text)
					evlist_groups_to_debug.force (l_group_item)
					config.add_class_group (l_text)

					on_list_content_changed
				end
			end
			evtext_group_to_add.set_text ("")
		end

	on_select_group
			-- Action to perform when a group in `evlist_groups_to_debug' is selected.
		do
			if attached evlist_groups_to_debug.selected_item as lt_list_item then
				evbutton_remove.enable_sensitive
				display_group_detail (lt_list_item.text, True)
			end
		end

	on_deselect_group
			-- Action to perform when a group in `evlist_groups_to_debug' is deselected.
		do
			evbutton_remove.disable_sensitive
			display_group_detail (Void, False)
		end

	on_remove
			-- Action to perform when "Remove" button is clicked.
		local
			l_text: STRING
		do
			if attached evlist_groups_to_debug.selected_item as lt_selected_item then
				l_text := lt_selected_item.text
				evlist_groups_to_debug.go_i_th (evlist_groups_to_debug.index_of (lt_selected_item, 1))
				evlist_groups_to_debug.remove
				config.remove_class_group (l_text)

				on_list_content_changed
			end
		end

	on_remove_all
			-- Action to perform when "Remove all" button is clicked.
		do
			evlist_groups_to_debug.wipe_out
			config.remove_all_class_groups

			on_list_content_changed
		end

	on_browse
			-- Browse for a location.
		local
			l_str: STRING
			l_dir: DIRECTORY
			l_path: PATH
			l_file: RAW_FILE
			l_new_path_str: STRING
		do
				-- Get current working directory, or the default one when the current does not exist.
			if evtext_working_directory /= Void then
				l_str := evtext_working_directory.text
				create l_dir.make (l_str)
				if not l_dir.exists then
					l_str := Void
				end
			end
			if l_str = Void then
				l_str := config.default_working_directory.out
			end

				-- Path string of the new working directory.
			Browse_dialog.set_start_directory (l_str)
			Browse_dialog.show_modal_to_window (tool_window)
			if attached Browse_dialog.path as lt_path and then not lt_path.is_empty then
				create l_dir.make_with_path (lt_path)
				if l_dir.is_empty then
					l_str := lt_path.out
				else
					if is_approved_by_user ({ES_ADB_INTERFACE_STRINGS}.Msg_delete_directory_content) then
						l_dir.recursive_delete
						l_dir.recursive_create_dir
						l_str := lt_path.out
					end
				end
			end

			evtext_working_directory.set_text (l_str)
		end

	on_use_fixed_seed_change
			-- Action to perform when `evcheckbutton_testing_use_fixed_seed' is selected/deselected.
		do
			if evcheckbutton_testing_use_fixed_seed.is_selected then
				evtext_testing_seed.enable_sensitive
			else
				evtext_testing_seed.disable_sensitive
			end
		end

	on_load_settings
			-- Action to perform when `evbutton_load_settings' is clicked.
		do
			tool_panel.load_settings
		end

	on_save_settings
			-- Action to perform when `evbutton_save_settings' is clicked.
		do
			tool_panel.save_settings
		end

	on_start
			-- Action to perform when "Start/Stop" button is clicked.
		local
			l_text: STRING
			l_confirmation_dialog: EV_CONFIRMATION_DIALOG
			l_should_continue: BOOLEAN
			l_debugging_task: ES_ADB_PROCESS_SEQUENCE_FOR_DEBUGGING
		do
			l_text := evbutton_start.text
			if l_text ~ button_text_start then
				if info_center.fault_repository.is_empty and then info_center.test_cases.is_empty then
					l_should_continue := True
				else
					l_should_continue := is_approved_by_user ({ES_ADB_INTERFACE_STRINGS}.Msg_remove_existing_debugging_results)
				end
				if l_should_continue then
					config.working_directory.clear
					copy_project (workbench.eiffel_project, config.working_directory)

					info_center.on_debugging_start

					if is_project_copied_into_working_dir then
						create l_debugging_task.make
						create forwarding_task.make (l_debugging_task)
						forwarding_task.on_terminate_actions.extend (agent info_center.on_debugging_stop)
						forwarding_task.start
					else
						display_message ({ES_ADB_INTERFACE_STRINGS}.Msg_failed_to_copy_project)
						info_center.on_debugging_stop
					end
				end

			elseif l_text ~ button_text_stop then
				forwarding_task.cancel
				info_center.on_debugging_stop
			end
		end

feature{NONE} -- Access

	forwarding_task: ES_ADB_OUTPUT_RETRIEVER
			-- Task to forward the process output to `info_center'.

feature{NONE} -- Action implementation

	last_selected_group: STRING
			-- The group whose classes are displayed in `evlist_classes_in_group'.

	display_group_detail (a_group: STRING; a_show: BOOLEAN)
			-- Display the classes in `a_group' in `evlist_classes_in_group'.
		local
			l_classes: DS_HASH_SET [CLASS_C]
			l_cursor: DS_HASH_SET_CURSOR [CLASS_C]
			l_detail: STRING
			l_detail_item: EV_LIST_ITEM
		do
			if a_show then

				if last_selected_group = Void or else a_group /~ last_selected_group then
					last_selected_group := a_group

					evlist_classes_in_group.wipe_out
					l_classes := config.groups_to_classes.item (a_group)
					if l_classes.is_empty then
						create l_detail_item.make_with_text ("< No class found in the group >")
						evlist_classes_in_group.force (l_detail_item)
					else
						create l_detail.make (64)
						from
							l_cursor := l_classes.new_cursor
							l_cursor.start
						until
							l_cursor.after
						loop
							if l_cursor.item /= Void then
								create l_detail_item.make_with_text (l_cursor.item.name_in_upper)
								evlist_classes_in_group.force (l_detail_item)
							end
							l_cursor.forth
						end
					end
				end

				evlist_classes_in_group.show
			else
				evlist_classes_in_group.hide
			end
		end

	Browse_dialog: EV_DIRECTORY_DIALOG
			-- Dialog to browse to a library
		local
			l_dir: DIRECTORY
			l_str: STRING
		once
			create Result
			if evtext_working_directory /= Void then
				l_str := evtext_working_directory.text
				create l_dir.make (l_str)
				if not l_dir.exists then
					l_str := Void
				end
			end
			if l_str = Void then
				l_str := config.default_working_directory.out
			end
			Result.set_start_directory (l_str)
		ensure
			result_not_void: Result /= Void
		end

feature{NONE} -- UI/Config sync

	propogate_values_from_config_to_ui
			-- <Precursor>
		local
			l_config: like config
			l_class_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_list_item: EV_LIST_ITEM
		do
			l_config := config

			evlist_groups_to_debug.wipe_out
			from
				l_class_cursor := l_config.class_groups.new_cursor
				l_class_cursor.start
			until
				l_class_cursor.after
			loop
				create l_list_item.make_with_text (l_class_cursor.item)
				evlist_groups_to_debug.force (l_list_item)
				l_class_cursor.forth
			end
			on_list_content_changed

			evtext_working_directory.set_text (l_config.working_directory.root_dir.out)

			if l_config.is_each_session_testing_one_class then
				evcombo_testing_session_type.set_text (combobox_text_test_session_type_one_class)
			elseif l_config.is_each_session_testing_one_group then
				evcombo_testing_session_type.set_text (combobox_text_test_session_type_one_group)
			elseif l_config.is_each_session_testing_all_classes then
				evcombo_testing_session_type.set_text (combobox_text_test_session_type_all_classes)
			end

			evtext_testing_cutoff_time.set_text (l_config.max_session_length_for_testing.out)
			evtext_testing_seed.set_text (l_config.fixed_seed.out)
			if l_config.should_use_fixed_seed_in_testing then
				evcheckbutton_testing_use_fixed_seed.enable_select
				evtext_testing_seed.enable_sensitive
			else
				evcheckbutton_testing_use_fixed_seed.disable_select
				evtext_testing_seed.disable_sensitive
			end

			if l_config.is_starting_fixing_after_each_testing_session then
				evcombo_start_fixing_type.set_text (combobox_text_start_fixing_type_after_each_testing_session)
			elseif l_config.is_starting_fixing_after_all_testing_sessions then
				evcombo_start_fixing_type.set_text (combobox_text_start_fixing_type_after_all_testing_sessions)
			elseif l_config.is_starting_fixing_manually then
				evcombo_start_fixing_type.set_text (combobox_text_start_fixing_type_manually)
			end

			evtext_fixing_cutoff_time.set_text (l_config.max_session_length_for_fixing.out)
			evtext_fixing_number_of_fixes.set_text (l_config.max_nbr_fix_candidates.out)
			if l_config.should_fix_implementation then
				evcheckbutton_fixing_implementation.enable_select
			else
				evcheckbutton_fixing_implementation.disable_select
			end
			if l_config.should_fix_contracts then
				evcheckbutton_fixing_contracts.enable_select
			else
				evcheckbutton_fixing_contracts.disable_select
			end
			evtext_fixing_passing_tests.set_text (l_config.max_nbr_passing_tests.out)
			evtext_fixing_failing_tests.set_text (l_config.max_nbr_failing_tests.out)
		end

	propogate_values_from_ui_to_config
			-- <Precursor>
		local
			l_config: like config
			l_working_dir: ES_ADB_WORKING_DIRECTORY
			l_testing_session_type_str: STRING
			l_start_fixing_type_str: STRING
		do
			l_config := config

			propogate_class_groups_from_ui_to_config
			create l_working_dir.make (create {PATH}.make_from_string (evtext_working_directory.text))
			l_config.set_working_directory (l_working_dir)
			l_testing_session_type_str := evcombo_testing_session_type.text
			if l_testing_session_type_str ~ combobox_text_test_session_type_one_class then
				config.set_testing_session_type ({ES_ADB_CONFIG}.Testing_session_type_one_class)
			elseif l_testing_session_type_str ~ combobox_text_test_session_type_one_group then
				config.set_testing_session_type ({ES_ADB_CONFIG}.Testing_session_type_one_group)
			elseif l_testing_session_type_str ~ combobox_text_test_session_type_all_classes then
				config.set_testing_session_type ({ES_ADB_CONFIG}.Testing_session_type_all_classes)
			end
			l_config.set_max_session_length_for_testing (evtext_testing_cutoff_time.text.to_integer)
			l_config.set_use_fixed_seed_in_testing (evcheckbutton_testing_use_fixed_seed.is_selected)
			l_config.set_fixed_seed (evtext_testing_seed.text.to_integer)
			l_start_fixing_type_str := evcombo_start_fixing_type.text
			if l_start_fixing_type_str ~ combobox_text_start_fixing_type_after_each_testing_session then
				config.set_start_fixing_type ({ES_ADB_CONFIG}.start_fixing_type_after_each_testing_session)
			elseif l_start_fixing_type_str ~ combobox_text_start_fixing_type_after_all_testing_sessions then
				config.set_start_fixing_type ({ES_ADB_CONFIG}.start_fixing_type_after_all_testing_sessions)
			elseif l_start_fixing_type_str ~ combobox_text_start_fixing_type_manually then
				config.set_start_fixing_type ({ES_ADB_CONFIG}.start_fixing_type_manually)
			end
			l_config.set_max_session_length_for_fixing (evtext_fixing_cutoff_time.text.to_integer)
			l_config.set_max_nbr_fix_candidates (evtext_fixing_number_of_fixes.text.to_integer)
			l_config.set_fix_implementation (evcheckbutton_fixing_implementation.is_selected)
			l_config.set_fix_contracts (evcheckbutton_fixing_contracts.is_selected)
			l_config.set_max_nbr_passing_tests (evtext_fixing_passing_tests.text.to_integer)
			l_config.set_max_nbr_failing_tests (evtext_fixing_failing_tests.text.to_integer)
		end

	propogate_class_groups_from_ui_to_config
			-- Update `config' using the class groups in the UI.
		local
			l_config: like config
			l_list_item: EV_LIST_ITEM
			l_classes: DS_ARRAYED_LIST [STRING]
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_class: STRING
		do
			l_config := config
			l_config.remove_all_class_groups

			from
				evlist_groups_to_debug.start
				create l_classes.make_equal (evlist_groups_to_debug.count)
			until
				evlist_groups_to_debug.after
			loop
				l_list_item := evlist_groups_to_debug.item_for_iteration
				l_config.add_class_group (l_list_item.text)
				evlist_groups_to_debug.forth
			end
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
