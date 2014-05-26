
class
	ES_ADB_PANEL_SETTINGS

inherit

	ES_ADB_PANEL_SETTINGS_IMP

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

			clear_config_widgets (False)
			enable_config_widgets (False)
			enable_command_widgets (False)
			register_event_handlers

			info_center.extend (Current)
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
			l_confirmation_dialog: EV_CONFIRMATION_DIALOG
		do
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
			Browse_dialog.set_start_directory (l_str)
			Browse_dialog.show_modal_to_window (tool_window)
			if attached Browse_dialog.path as lt_path and then not lt_path.is_empty then
				create l_dir.make_with_path (lt_path)
				if not l_dir.is_empty then
					l_confirmation_dialog := confirmation_dialog
					l_confirmation_dialog.set_text ({ES_ADB_INTERFACE_STRINGS}.Msg_delete_directory_content)
					l_confirmation_dialog.show_modal_to_window (tool_window)
					if l_confirmation_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok.as_string_32 then
						l_dir.recursive_delete
						l_dir.recursive_create_dir
					end
				end
				evtext_working_directory.set_text (lt_path.out)
			end
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
		local
		do
			check workbench.eiffel_project /= Void then
				config.load (workbench.eiffel_project)
				propogate_values_from_config_to_ui
			end
		end

	on_save_settings
			-- Action to perform when `evbutton_save_settings' is clicked.
		do
			propogate_values_from_ui_to_config
			config.save
		end

	on_start
			-- Action to perform when "Start/Stop" button is clicked.
		local
			l_text: STRING
			l_command_line: STRING
			l_processes: DS_ARRAYED_LIST [ES_ADB_PROCESS]
		do
			l_text := evbutton_start.text
			if l_text ~ button_text_start then
				enable_config_widgets (False)
				enable_command_widgets (False)
				on_save_settings

				if not is_project_copied_into_working_dir then
					copy_project (workbench.eiffel_project, config.working_directory)
				end
				if is_project_copied_into_working_dir then
					create output_buffer.make
					create forwarding_task.make (output_buffer)
					rota.run_task (forwarding_task)

					l_processes := prepare_testing_processes
					create process_launcher.make (l_processes, output_buffer)
					process_launcher.launch
				end

				evbutton_start.set_text (button_text_stop)
				evbutton_start.enable_sensitive

			elseif l_text ~ button_text_stop then
				process_launcher.cancel
				evbutton_start.set_text (button_text_start)
				enable_config_widgets (True)
				enable_command_widgets (True)
			end
		end

	on_testing_finished
			--
		local
		do
			
		end

feature{NONE} -- Action implementation

	frozen rota: detachable ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end

	forwarding_task: ES_ADB_PROCESS_OUTPUT_FORWARDING_TASK
			-- Task to forward the process output to `info_center'.

	process_launcher: ES_ADB_EXTERNAL_PROCESS_LAUNCHER
			-- Launcher of all external processes.

	output_buffer: ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER
			-- Buffer to collect outputs from external processes.

	prepare_testing_processes: DS_ARRAYED_LIST [ES_ADB_PROCESS]
			-- List of testing processes to be launched.
		local
			l_classes_to_test_in_sessions: DS_ARRAYED_LIST [DS_HASH_SET [CLASS_C]]
			l_classes_cursor: DS_ARRAYED_LIST_CURSOR [DS_HASH_SET [CLASS_C]]
			l_process: ES_ADB_PROCESS
			l_command_line: STRING
		do
			l_classes_to_test_in_sessions := config.classes_to_test_in_sessions
			create Result.make_equal (l_classes_to_test_in_sessions.count + 1)
			from
				l_classes_cursor := l_classes_to_test_in_sessions.new_cursor
				l_classes_cursor.start
			until
				l_classes_cursor.after
			loop
				l_command_line := command_line_for_testing_classes (l_classes_cursor.item)
				create l_process.make (l_command_line, Void, config.max_session_length_for_testing)
				Result.force_last (l_process)

				l_classes_cursor.forth
			end
		end

	command_line_for_testing_classes (a_classes: DS_HASH_SET [CLASS_C]): STRING
			-- Command line string for testing `a_classes'.
		require
			a_classes /= Void and then not a_classes.is_empty
		local
			l_cursor: DS_HASH_SET_CURSOR [CLASS_C]
			l_seed: STRING
			l_time: INTEGER
		do
			l_time := config.max_session_length_for_testing * a_classes.count
			if config.should_use_fixed_seed_in_testing then
				l_seed := "-seed " + config.fixed_seed.out
			else
				l_seed := ""
			end

			create Result.make_empty
			Result := "%"" + eve_path.out + "%" "
					+ "-project_path %"" + project_path_in_working_directory.out + "%" "
					+ "-config %"" + ecf_path_in_working_directory.out + "%" "
					+ "-target " + target_of_project + " "
					+ "-auto_test -i -f --agents none --integer-bounds -512,512 --state argumentless --serialization passing,failing --retrieve-serialization-online "
					+ "-t " + l_time.out + " "
					+ l_seed + " "
					+ "--output-test-case-online %"" + config.working_directory.testing_result_dir.out + "%" ";

			from
				l_cursor := a_classes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (" " + l_cursor.item.name_in_upper)
				l_cursor.forth
			end
		end

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
							create l_detail_item.make_with_text (l_cursor.item.name_in_upper)
							evlist_classes_in_group.force (l_detail_item)
							l_cursor.forth
						end
					end
				end

				evlist_classes_in_group.show
			else
				evlist_classes_in_group.hide
			end
		end

	last_selected_group: STRING
			-- The group whose classes are displayed in `evlist_classes_in_group'.

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

	confirmation_dialog: EV_CONFIRMATION_DIALOG
		once
			create Result
		end

feature -- ADB Action

	on_project_loaded
			-- Action to be performed when project loaded
		do
			clear_config_widgets (True)
			enable_config_widgets (True)
			propogate_values_from_config_to_ui
			enable_command_widgets (True)
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
			propogate_values_from_ui_to_config
			config.save
			clear_config_widgets (False)
			enable_config_widgets (False)
			enable_command_widgets (False)
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		do
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		do
		end

	on_debugging_start
			-- Action to be performed when debugging starts
		do

		end

	on_debugging_stop
			-- Action to be performed when debugging stops.
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

feature{NONE} -- Update UI

	update_ui
			-- <Precursor>
		do
			-- Do nothing
		end

	clear_config_widgets (a_flag: BOOLEAN)
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

	enable_config_widgets (a_flag: BOOLEAN)
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
				evcheckbutton_testing_use_fixed_seed.enable_select
				evcheckbutton_testing_use_fixed_seed.enable_sensitive
				evtext_fixing_cutoff_time.enable_sensitive
				evtext_fixing_number_of_fixes.enable_sensitive
				evcheckbutton_fixing_contracts.enable_select
				evcheckbutton_fixing_contracts.enable_sensitive
				evcheckbutton_fixing_implementation.enable_select
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
				evcheckbutton_testing_use_fixed_seed.disable_select
				evcheckbutton_testing_use_fixed_seed.disable_sensitive
				evtext_fixing_cutoff_time.disable_sensitive
				evtext_fixing_number_of_fixes.disable_sensitive
				evcheckbutton_fixing_contracts.disable_select
				evcheckbutton_fixing_contracts.disable_sensitive
				evcheckbutton_fixing_implementation.disable_select
				evcheckbutton_fixing_implementation.disable_sensitive
				evtext_fixing_passing_tests.disable_sensitive
				evtext_fixing_failing_tests.disable_sensitive
			end
		end

	enable_command_widgets (a_flag: BOOLEAN)
			-- Enable, if `a_flag', all command widgets on the panel.
			-- Otherwise disable.
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

			if l_config.testing_session_type = {ES_ADB_CONFIG}.testing_session_type_one_class then
				evcombo_testing_session_type.set_text (combobox_text_one_class)
			elseif l_config.testing_session_type = {ES_ADB_CONFIG}.testing_session_type_one_group then
				evcombo_testing_session_type.set_text (combobox_text_one_group)
			elseif l_config.testing_session_type = {ES_ADB_CONFIG}.testing_session_type_all_classes then
				evcombo_testing_session_type.set_text (combobox_text_all_classes)
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
			-- Propogate changes from UI to config.
		local
			l_config: like config
			l_working_dir: ES_ADB_WORKING_DIRECTORY
			l_testing_session_type_str: STRING
		do
			l_config := config

			propogate_class_groups_from_ui_to_config
			create l_working_dir.make (create {PATH}.make_from_string (evtext_working_directory.text))
			l_config.set_working_directory (l_working_dir)
			l_testing_session_type_str := evcombo_testing_session_type.text
			if l_testing_session_type_str ~ Combobox_text_one_class then
				config.set_testing_session_type (1)
			elseif l_testing_session_type_str ~ Combobox_text_one_group then
				config.set_testing_session_type (2)
			elseif l_testing_session_type_str ~ Combobox_text_all_classes then
				config.set_testing_session_type (3)
			end
			l_config.set_max_session_length_for_testing (evtext_testing_cutoff_time.text.to_integer)
			l_config.set_use_fixed_seed_in_testing (evcheckbutton_testing_use_fixed_seed.is_selected)
			l_config.set_fixed_seed (evtext_testing_seed.text.to_integer)
			l_config.set_max_session_length_for_fixing (evtext_fixing_cutoff_time.text.to_integer)
			l_config.set_max_nbr_fix_candidates (evtext_fixing_number_of_fixes.text.to_integer)
			l_config.set_fix_implementation (evcheckbutton_fixing_implementation.is_selected)
			l_config.set_fix_contracts (evcheckbutton_fixing_contracts.is_selected)
			l_config.set_max_nbr_passing_tests (evtext_fixing_passing_tests.text.to_integer)
			l_config.set_max_nbr_failing_tests (evtext_fixing_failing_tests.text.to_integer)
		end

	propogate_class_groups_from_ui_to_config
			--
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
