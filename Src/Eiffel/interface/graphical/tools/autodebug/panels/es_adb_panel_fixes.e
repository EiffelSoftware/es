
class ES_ADB_PANEL_FIXES

inherit

	ES_ADB_PANEL_FIXES_IMP

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
			create difference_background_color.make_with_8_bit_rgb (255, 255, 0)

			clear_information_display_widget
			enable_information_display_widget (False)
			enable_command_invocation_widget (False)

			register_event_handlers

			Info_center.extend (Current)
		end

feature{NONE} -- Update GUI

	clear_information_display_widget
			-- <Precursor>
		do
			evgrid_fixes.remove_rows (1, evgrid_fixes.row_count)
			clear_diff
		end

	enable_information_display_widget (a_flag: BOOLEAN)
			-- <Precursor>
		do
			if a_flag then
				evgrid_fixes.enable_sensitive
			else
				evgrid_fixes.disable_sensitive
			end
		end

	enable_command_invocation_widget (a_flag: BOOLEAN)
			-- <Precursor>
		do
			if a_flag then
				if attached evgrid_fixes.selected_rows as lt_rows and then not lt_rows.is_empty
						and then attached {ES_ADB_FIX} lt_rows.first.data as lt_fix
						and then not lt_fix.fault.is_fixed
				then
					evbutton_apply.enable_sensitive
				else
					evbutton_apply.disable_sensitive
				end
			else
				evbutton_apply.disable_sensitive
			end
		end

	clear_diff
			-- Clear the diff information from UI.
		do
			ebsmart_source.load_text ("")
			ebsmart_target.load_text ("")
		end

feature -- ADB Actions

	on_project_loaded
			-- <Precursor>
		do
			enable_information_display_widget (True)
		end

	on_project_unloaded
			-- <Precursor>
		do
			clear_internal_state
			clear_information_display_widget
			enable_information_display_widget (False)
			enable_command_invocation_widget (False)
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
			clear_internal_state
			clear_information_display_widget
			enable_command_invocation_widget (False)
		end

	on_debugging_stop
			-- <Precursor>
		do
			enable_command_invocation_widget (True)
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
		local
			l_row_for_fault, l_row_for_fix: EV_GRID_ROW
			l_subrow_index, l_subrow_count: INTEGER
		do
			if fault_to_row_table.has (a_fault) then
				l_row_for_fault := fault_to_row_table.item (a_fault)
					-- Wipe out subrows for fixes.
				evgrid_fixes.remove_rows (l_row_for_fault.index + 1, l_row_for_fault.index + l_row_for_fault.subrow_count)
					-- Update fault status.
				update_fault_status (a_fault)
			end
		end

	on_fixing_stop
			-- <Precursor>
		do
		end

	on_continuation_debugging_start
			-- <Precursor>
		do
			enable_command_invocation_widget (False)
		end

	on_continuation_debugging_stop
			-- <Precursor>
		do
			enable_command_invocation_widget (True)
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
			l_row_for_fault, l_row_for_fix: EV_GRID_ROW
			l_count, l_insertion_position: INTEGER
		do
			l_fault := a_fix.fault
				-- Locate the row for the fault.

			if fault_to_row_table.has (l_fault) then
				l_row_for_fault := fault_to_row_table.item (l_fault)
			else
					-- If not present, add the row at the right position and initialize it
				l_count := evgrid_fixes.row_count
				l_insertion_position := first_row (evgrid_fixes,
						agent (a_row: EV_GRID_ROW; a_sig_id: STRING): BOOLEAN do Result := attached {ES_ADB_FAULT} a_row.data as lt_fault and then lt_fault.signature.id.is_greater_equal (a_sig_id) end (?, l_fault.signature.id))
				if l_insertion_position = 0 then
					l_insertion_position := evgrid_fixes.row_count + 1
				end

				evgrid_fixes.set_row_count_to (l_count + 1)
				evgrid_fixes.move_row (l_count + 1, l_insertion_position)

				l_row_for_fault := evgrid_fixes.row (l_insertion_position)
				l_row_for_fault.set_data (l_fault)
				l_row_for_fault.set_item (column_fault, create {EV_GRID_LABEL_ITEM}.make_with_text (l_fault.signature.id))
				l_row_for_fault.set_item (column_type, create {EV_GRID_LABEL_ITEM})
				l_row_for_fault.set_item (Column_nature, create {EV_GRID_LABEL_ITEM})
				l_row_for_fault.set_item (Column_is_proper, create {EV_GRID_LABEL_ITEM})
				l_row_for_fault.set_item (Column_status, create {EV_GRID_LABEL_ITEM})
				l_row_for_fault.show

				fault_to_row_table.force (l_row_for_fault, l_fault)
			end

				-- Locate where to insert the new fix
			l_insertion_position := first_subrow (l_row_for_fault,
					agent (a_subrow: EV_GRID_ROW; a_ranking: REAL): BOOLEAN do Result := attached {ES_ADB_FIX} a_subrow.data as lt_fix and then lt_fix.ranking > a_ranking end (?, a_fix.ranking))
			if l_insertion_position = 0 then
				l_insertion_position := l_row_for_fault.subrow_count + 1
			end
			l_row_for_fault.insert_subrow (l_insertion_position)
			l_row_for_fix := l_row_for_fault.subrow (l_insertion_position)
			l_row_for_fix.set_data (a_fix)
			l_row_for_fix.set_item (column_fault, create {EV_GRID_LABEL_ITEM}.make_with_text (a_fix.fix_id_string))
			l_row_for_fix.set_item (column_type, create {EV_GRID_LABEL_ITEM}.make_with_text (a_fix.type))
			l_row_for_fix.set_item (column_nature, create {EV_GRID_LABEL_ITEM}.make_with_text (a_fix.nature_of_change_string))
			l_row_for_fix.set_item (Column_is_proper, create {EV_GRID_LABEL_ITEM})
			l_row_for_fix.set_item (column_status, create {EV_GRID_LABEL_ITEM})
			l_row_for_fix.show
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
			update_fix_status (a_fix)
			update_fault_status (a_fix.fault)
		end

	on_output (a_line: STRING)
			-- <Precursor>
		do
		end

feature -- GUI actions

	register_event_handlers
			-- Register event handlers.
		do
			evgrid_fixes.row_select_actions.extend (agent on_row_select)
			evgrid_fixes.row_deselect_actions.extend (agent on_row_deselect)
			evbutton_apply.select_actions.extend (agent on_apply)
		end

	on_apply
			-- Action to perform when the 'Apply' button is clicked.
		local
			l_class_to_fix: CLASS_C
			l_new_body_text, l_new_class_content: STRING
			l_match_list: LEAF_AS_LIST
			l_routine_body_as: ROUT_BODY_AS
			l_copied_class_path, l_original_class_path: PATH
			l_copied_class_path_str, l_original_class_path_str: STRING
			l_original_class_date: INTEGER
			l_file: PLAIN_TEXT_FILE


			l_exception: ES_EVE_AUTOFIX_EXCEPTION
			l_should_preceed, l_should_backup, l_retried: BOOLEAN
			l_backup_dir_name: DIRECTORY_NAME
			l_origin_file_name, l_backup_file_name: FILE_NAME
			l_result_file_lines: DS_LINKED_LIST[STRING]
			l_content, l_line: STRING
			l_error_msg: STRING
			l_dir: DIRECTORY
			l_date_time: DATE_TIME
			l_date: DATE
			l_time_stamp: STRING
		do
			if not evgrid_fixes.selected_rows.is_empty and then attached evgrid_fixes.selected_rows.first as lt_row then
				if attached {ES_ADB_FIX_IMPLEMENTATION} lt_row.data as lt_fix then
					if is_approved_by_user (Msg_apply_fix) then
						l_class_to_fix := lt_fix.fault.recipient_class_and_feature.written_class
						l_original_class_path := info_center.config.working_directory.original_file_path (l_class_to_fix.lace_class.file_name)
						lt_fix.apply (l_original_class_path)
						if lt_fix.has_been_applied then
							info_center.on_fix_applied (lt_fix)
							on_row_select (lt_row)
						else
							if lt_fix.error_message /= Void then
								display_message (lt_fix.error_message)
							end
						end

					end
				elseif attached {ES_ADB_FIX_CONTRACT} lt_row.data as lt_fix then
					if is_approved_by_user (Msg_set_contract_fix_applied) then
						lt_fix.apply
						info_center.on_fix_applied (lt_fix)
						on_row_select (lt_row)
					end
				end
			end
		end

	on_row_select (a_row: EV_GRID_ROW)
			-- Action to perform when `a_row' is selected.
		do
			if attached {ES_ADB_FIX} a_row.data as lt_fix then
				show_diff (lt_fix)
				if not tool_panel.is_external_process_running and then not lt_fix.fault.is_fixed and then attached {ES_ADB_FIX_IMPLEMENTATION} lt_fix then
					enable_command_invocation_widget (True)
				end
			end
		end

	on_row_deselect (a_row: EV_GRID_ROW)
			-- Action to perform when `a_row' is deselected.
		do
			clear_diff
			if not tool_panel.is_external_process_running then
				enable_command_invocation_widget (False)
			end
		end

feature{NONE} -- Access

	fault_to_row_table: DS_HASH_TABLE [EV_GRID_ROW, ES_ADB_FAULT]
			-- Table mapping faults to rows in `evgrid_fixes'.
		do
			if fault_to_row_table_internal = Void then
				create fault_to_row_table_internal.make_equal (64)
			end
			Result := fault_to_row_table_internal
		end

	difference_background_color: EV_COLOR
			-- Background color of the differences.

feature{NONE} -- Implementation

	clear_internal_state
			-- Clear panel internal state.
		do
			fault_to_row_table_internal := Void
		end

	update_fault_status (a_fault: ES_ADB_FAULT)
			-- Update the status display of `a_fault'.
		require
			a_fault /= Void and then fault_to_row_table.has (a_fault)
		local
			l_row: EV_GRID_ROW
		do
			if fault_to_row_table.has (a_fault) then
				l_row := fault_to_row_table.item (a_fault)
				check attached {EV_GRID_LABEL_ITEM} l_row.item (column_status) as lt_label_item then
					lt_label_item.set_text (a_fault.status_string)
				end
			end
		end

	update_fix_status (a_fix: ES_ADB_FIX)
			-- Update the status display of `a_fix'.
		require
			a_fix /= Void
		local
			l_fault: ES_ADB_FAULT
			l_row_for_fault, l_row_for_fix: EV_GRID_ROW
			l_subrow_index, l_subrow_count: INTEGER

			l_row: EV_GRID_ROW
		do
			l_fault := a_fix.fault
			if fault_to_row_table.has (l_fault) then
				l_row_for_fault := fault_to_row_table.item (l_fault)
				from
					l_subrow_count := l_row_for_fault.subrow_count
					l_subrow_index := 1
				until
					l_subrow_index > l_subrow_count or else l_row_for_fix /= Void
				loop
					l_row := l_row_for_fault.subrow (l_subrow_index)
					if attached {ES_ADB_FIX} l_row.data as lt_fix and then lt_fix.fix_id_string ~ a_fix.fix_id_string then
						l_row_for_fix := l_row
					end
					l_subrow_index := l_subrow_index + 1
				end
			end
			if l_row_for_fix /= Void then
				check attached {EV_GRID_LABEL_ITEM} l_row_for_fix.item (column_status) as lt_label_item then
					if a_fix.has_been_applied then
						lt_label_item.set_text ("Applied")
					else
						lt_label_item.set_text ("")
					end
				end
			end
		end

	show_diff (a_fix: ES_ADB_FIX)
			-- Update the widget view to reflect hunk.
		local
			l_hunk: ES_EVE_CODE_DIFF_HUNK
			l_segs: LINKED_LIST [TUPLE [start: INTEGER_32; finish: INTEGER_32]]
			l_cur_line, l_start_line, l_finish_line: INTEGER_32
			l_character_format: EV_CHARACTER_FORMAT
			l_format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION
		do
			l_hunk := a_fix.hunk

			ebsmart_source.load_text (l_hunk.base_code_with_padding)
			ebsmart_target.load_text (l_hunk.diff_code_with_padding)
			l_character_format := Highlighting_format.character_format
			l_format_range := Highlighting_format.format_range
			l_segs := l_hunk.different_line_segments
			from
				l_segs.start
			until
				l_segs.after
			loop
				l_start_line := l_segs.item_for_iteration.start
				l_finish_line := l_segs.item_for_iteration.finish
				from
					l_cur_line := l_start_line
				until
					l_cur_line >= l_finish_line
				loop
					ebsmart_target.select_lines (l_cur_line, l_cur_line)
					ebsmart_target.text_displayed.selection_start.line.content.do_all (agent {EDITOR_TOKEN}.set_background_color (difference_background_color))
					l_cur_line := l_cur_line + 1
				end
				ebsmart_target.deselect_all
				l_segs.forth
			end
		end

	Highlighting_format: TUPLE [character_format: EV_CHARACTER_FORMAT; format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION]
			-- Objects used for highlighting code differences.
		local
			l_character_format: EV_CHARACTER_FORMAT
			l_font: EV_FONT
			l_background_color: EV_COLOR
			l_format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION
		once
			l_font := ebsmart_source.font
			create l_font.make_with_values (l_font.family, {EV_FONT_CONSTANTS}.weight_bold, l_font.shape, l_font.height)
			create l_character_format.make_with_font (l_font)
			create l_background_color.make_with_8_bit_rgb (255, 255, 0)
			l_character_format.set_background_color (l_background_color)
			create l_format_range.make_with_flags ({EV_CHARACTER_FORMAT_CONSTANTS}.background_color | {EV_CHARACTER_FORMAT_CONSTANTS}.font_weight)
			Result := [l_character_format, l_format_range]
		end

feature{NONE} -- Cache

	fault_to_row_table_internal: like fault_to_row_table


;note
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
