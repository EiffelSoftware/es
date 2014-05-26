
class ES_ADB_PANEL_FAULTS

inherit

	ES_ADB_PANEL_FAULTS_IMP

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

			reset_info_widgets (False)
			reset_command_widgets (False)
			register_event_handlers

			Info_center.extend (Current)
		end

	reset_info_widgets (a_flag: BOOLEAN)
			--
		local
		do
			if a_flag then
				evgrid_faults.enable_sensitive
				enable_toggle_button (evtoggle_show_to_be_attempted, config.should_show_not_yet_attempted)
				enable_toggle_button (evtoggle_show_candidate_fix_available, config.should_show_candidate_fix_available)
				enable_toggle_button (evtoggle_show_candidate_fix_unavailable, config.should_show_candidate_fix_unavailable)
				enable_toggle_button (evtoggle_show_candidate_fix_accepted, config.should_show_candidate_fix_accepted)
				enable_toggle_button (evtoggle_show_manually_fixed, config.should_show_manually_fixed)
			else
				evgrid_faults.disable_sensitive
				evgrid_faults.remove_rows (1, evgrid_faults.row_count)
				evtoggle_show_to_be_attempted.disable_select
				evtoggle_show_to_be_attempted.disable_sensitive
				evtoggle_show_candidate_fix_available.disable_select
				evtoggle_show_candidate_fix_available.disable_sensitive
				evtoggle_show_candidate_fix_unavailable.disable_select
				evtoggle_show_candidate_fix_unavailable.disable_sensitive
				evtoggle_show_candidate_fix_accepted.disable_select
				evtoggle_show_candidate_fix_accepted.disable_sensitive
				evtoggle_show_manually_fixed.disable_select
				evtoggle_show_manually_fixed.disable_sensitive
			end
		end

	enable_toggle_button (a_toggle: EV_TOGGLE_BUTTON; a_flag: BOOLEAN)
		do
			a_toggle.enable_sensitive
			if a_flag then
				a_toggle.enable_select
			else
				a_toggle.disable_select
			end
		end

	selected_fault_in_grid: ES_ADB_FAULT
			--
		do
			if attached evgrid_faults.selected_rows as lt_rows and then not lt_rows.is_empty and then attached {ES_ADB_FAULT} lt_rows.first.data as lt_fault then
				Result := lt_fault
			end
		end

	reset_command_widgets (a_flag: BOOLEAN)
			--
		local
		do
			if a_flag then
				evbutton_fix_all_to_be_attempted.enable_sensitive
				if attached {ES_ADB_FAULT} selected_fault_in_grid as lt_fault and then lt_fault.status = {ES_ADB_FAULT}.status_not_yet_attempted then
					evbutton_fix_selected.enable_sensitive
				else
					evbutton_fix_selected.disable_sensitive
				end
			else
				evbutton_fix_all_to_be_attempted.disable_sensitive
				evbutton_fix_selected.disable_sensitive
			end
		end

	register_event_handlers
		local
		do
			evgrid_faults.pointer_double_press_item_actions.extend (agent on_grid_events_item_pointer_double_press)

			evtoggle_show_to_be_attempted.select_actions.extend (agent on_visibility_changed)
			evtoggle_show_candidate_fix_available.select_actions.extend (agent on_visibility_changed)
			evtoggle_show_candidate_fix_unavailable.select_actions.extend (agent on_visibility_changed)
			evtoggle_show_candidate_fix_accepted.select_actions.extend (agent on_visibility_changed)
			evtoggle_show_manually_fixed.select_actions.extend (agent on_visibility_changed)

			evbutton_fix_selected.select_actions.extend (agent on_fix_selected)
			evbutton_fix_all_to_be_attempted.select_actions.extend (agent on_fix_all_to_be_attempted)
		end

	on_fix_selected
			--
		local
			l_fault: ES_ADB_FAULT
		do
			l_fault := selected_fault_in_grid
			check l_fault /= Void then
					-- Fix the fault.
			end
		end

	on_fix_all_to_be_attempted
			--
		local
			l_all_to_be_attempted: DS_ARRAYED_LIST [ES_ADB_FAULT]
			l_cursor: DS_HASH_TABLE_CURSOR [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
		do
				-- Collect the faults to be attempted.
			create l_all_to_be_attempted.make_equal (info_center.fault_repository.count)
			from
				l_cursor := info_center.fault_repository.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.status = {ES_ADB_FAULT}.status_not_yet_attempted then
					l_all_to_be_attempted.force_last (l_cursor.item)
				end
				l_cursor.forth
			end

				-- Fix the faults.
		end

	on_grid_events_item_pointer_double_press (a_x: INTEGER_32; a_y: INTEGER_32; a_button: INTEGER_32; a_item: EV_GRID_ITEM)
			--
		local
		do
			if a_item /= Void and then attached a_item.row as lt_row then
				if attached {ES_ADB_FAULT} lt_row.data as lt_fault then
					if not lt_fault.fixes.is_empty then
						-- Switch to panel fix and show corresponding fixes.
					end
				end
			end
		end

	is_fault_visible (a_fault: ES_ADB_FAULT): BOOLEAN
		do
			Result := a_fault.status = {ES_ADB_FAULT}.status_not_yet_attempted and then config.should_show_not_yet_attempted
						or else a_fault.status = {ES_ADB_FAULT}.status_candidate_fix_available and then config.should_show_candidate_fix_available
						or else a_fault.status = {ES_ADB_FAULT}.status_candidate_fix_unavailable and then config.should_show_candidate_fix_unavailable
						or else a_fault.status = {ES_ADB_FAULT}.status_candidate_fix_accepted and then config.should_show_candidate_fix_accepted
						or else a_fault.status = {ES_ADB_FAULT}.status_manually_fixed and then config.should_show_manually_fixed
		end


	on_visibility_changed
			--
		local
			l_index, l_count, l_sub_index, l_sub_count: INTEGER
			l_visible_sub_rows: INTEGER
			l_row, l_sub_row: EV_GRID_ROW
		do
			config.set_show_not_yet_attempted (evtoggle_show_to_be_attempted.is_selected)
			config.set_show_candidate_fix_available (evtoggle_show_candidate_fix_available.is_selected)
			config.set_show_candidate_fix_unavailable (evtoggle_show_candidate_fix_unavailable.is_selected)
			config.set_show_candidate_fix_accepted (evtoggle_show_candidate_fix_accepted.is_selected)
			config.set_show_manually_fixed (evtoggle_show_candidate_fix_accepted.is_selected)

			from
				l_index := 1
				l_count := evgrid_faults.row_count
			until
				l_index > l_count
			loop
				l_row := evgrid_faults.row (l_index)
				if attached {STRING} l_row.data as lt_feature then
					update_feature_row (l_row)
				elseif attached {ES_ADB_FAULT} l_row.data as lt_fault then
					-- Do nothing. Such rows are handled as subrows.
				end

				l_index := l_index + 1
			end
		end

	update_feature_row (a_row: EV_GRID_ROW)
			--
		require
			a_row /= Void and then attached {STRING} a_row.data
		local
			l_index, l_count, l_sub_index, l_sub_count: INTEGER
			l_visible_sub_rows: INTEGER
			l_total_failing_tests: INTEGER
			l_row, l_sub_row: EV_GRID_ROW
		do
			check attached {STRING} a_row.data as lt_feature then
				from
					l_sub_index := 1
					l_sub_count := a_row.subrow_count
					l_visible_sub_rows := 0
				until
					l_sub_index > l_sub_count
				loop
					l_sub_row := a_row.subrow (l_sub_index)
					check attached {ES_ADB_FAULT} l_sub_row.data as lt_fault then
						if is_fault_visible (lt_fault) then
							l_sub_row.show
							l_visible_sub_rows := l_visible_sub_rows + 1
						else
							l_sub_row.hide
						end
					end
					l_sub_index := l_sub_index + 1
				end

				if l_visible_sub_rows = 0 then
					a_row.hide
				else
					check attached {EV_GRID_LABEL_ITEM} a_row.item (column_fault) as lt_label_item then
						lt_label_item.set_text (l_visible_sub_rows.out)
					end
					a_row.show
				end
			end
		end

feature -- Actions

	on_project_loaded
			-- Action to be performed when project loaded
		do
			reset_info_widgets (True)
			reset_command_widgets (True)
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
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
			reset_command_widgets (False)
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
		local
			l_label_item: EV_GRID_LABEL_ITEM
			l_signature: EPA_TEST_CASE_SIGNATURE
			l_feature_under_test_str: STRING
			l_feature_under_test: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_index, l_count, l_insert_position: INTEGER
			l_row, l_row_for_feature, l_row_for_fault: EV_GRID_ROW
			l_fault: ES_ADB_FAULT
			l_was_row_visible, l_was_sub_row_visible: BOOLEAN
			l_text: STRING
			l_left_par_index, l_right_par_index: INTEGER
		do
			l_signature := a_test.test_case_signature
			l_feature_under_test_str := l_signature.class_and_feature_under_test
			create l_feature_under_test.make_from_names (l_signature.feature_under_test, l_signature.class_under_test)

				-- Locate the row corresponding to the feature
			from
				l_index := 1
				l_count := evgrid_faults.row_count
			until
				l_index > l_count or else l_row_for_feature /= Void or else l_insert_position /= 0
			loop
				l_row := evgrid_faults.row (l_index)
				if attached {STRING} l_row.data as lt_feature then
					if lt_feature ~ l_feature_under_test_str then
						l_row_for_feature := l_row
					elseif lt_feature.is_greater (l_feature_under_test_str) then
						l_insert_position := l_index
					else
						l_index := l_index + 1
					end
				else
					l_index := l_index + 1
				end
			end

			if l_signature.is_passing and then l_row_for_feature /= Void then
					-- Update number of passing tests for the feature
				check attached {EV_GRID_LABEL_ITEM} l_row_for_feature.item (column_passing) as lt_label_item then
					lt_label_item.set_text (info_center.passing_test_case_count_for_feature (l_feature_under_test).out)
				end

			elseif l_signature.is_failing then
				l_fault := info_center.fault_with_signature (l_signature)

				if l_row_for_feature = Void then
						-- Insert a row at the right position for the feature
					evgrid_faults.set_row_count_to (l_count + 1)
					l_row_for_feature := evgrid_faults.row (l_count + 1)
					l_row_for_feature.set_data (l_feature_under_test_str)

					create l_label_item.make_with_text (l_feature_under_test_str)
					l_label_item.align_text_left
					l_row_for_feature.set_item (column_class_and_feature_under_test, l_label_item)

					create l_label_item.make_with_text ("0")
					l_label_item.align_text_center
					l_row_for_feature.set_item (column_fault, l_label_item)

					create l_label_item.make_with_text (info_center.passing_test_case_count_for_feature (l_feature_under_test).out)
					l_label_item.align_text_center
					l_row_for_feature.set_item (column_passing, l_label_item)

					create l_label_item.make_with_text ("0")
					l_label_item.align_text_center
					l_row_for_feature.set_item (column_failing, l_label_item)

					create l_label_item.make_with_text ("")
					l_row_for_feature.set_item (column_status, l_label_item)

					create l_label_item.make_with_text ("")
					l_row_for_feature.set_item (column_info, l_label_item)

					if l_insert_position /= 0 then
						evgrid_faults.move_row (l_count + 1, l_insert_position)
					end
				end

					-- Locate the subrow for fault
				from
					l_insert_position := 0
					l_index := 1
					l_count := l_row_for_feature.subrow_count
				until
					l_index > l_count or else l_row_for_fault /= Void or else l_insert_position /= 0
				loop
					l_row := l_row_for_feature.subrow (l_index)
					check attached {ES_ADB_FAULT} l_row.data as lt_fault then
						if lt_fault.signature ~ a_test.test_case_signature then
							l_row_for_fault := l_row
						elseif lt_fault.signature.id.is_greater (a_test.test_case_signature.id) then
							l_insert_position := l_index
						else
							l_index := l_index + 1
						end
					end
				end
				if l_row_for_fault = Void then
					l_row_for_feature.insert_subrow (l_index)
					l_row_for_fault := l_row_for_feature.subrow (l_index)
					l_row_for_fault.set_data (l_fault)

					l_row_for_fault.set_item (column_class_and_feature_under_test, create {EV_GRID_LABEL_ITEM}.make_with_text (""))

					create l_label_item.make_with_text (l_signature.id)
					l_row_for_fault.set_item (column_fault, l_label_item)

					l_row_for_fault.set_item (column_passing, create {EV_GRID_LABEL_ITEM}.make_with_text (""))

					create l_label_item.make_with_text ("0")
					l_label_item.align_text_center
					l_row_for_fault.set_item (column_failing, l_label_item)

					l_row_for_fault.set_item (column_status, create {EV_GRID_LABEL_ITEM}.make_with_text (l_fault.status_string))

					l_row_for_fault.set_item (column_info, create {EV_GRID_LABEL_ITEM}.make_with_text (l_signature.out))
				end
				check attached {EV_GRID_LABEL_ITEM} l_row_for_fault.item (column_failing) as lt_label_item then
					lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
				end
				check attached {EV_GRID_LABEL_ITEM} l_row_for_feature.item (column_failing) as lt_label_item then
					lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
				end
				update_feature_row (l_row_for_feature)
			end
		end

	on_testing_stop
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_signature: EPA_TEST_CASE_SIGNATURE
			l_feature_under_test_str: STRING
			l_feature_under_test: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_index, l_count, l_insert_position: INTEGER
			l_row, l_row_for_feature, l_row_for_fault: EV_GRID_ROW
			l_fault: ES_ADB_FAULT
		do
			l_signature := a_fix.fault.signature
			l_feature_under_test_str := l_signature.class_and_feature_under_test
			create l_feature_under_test.make_from_names (l_signature.feature_under_test, l_signature.class_under_test)

				-- Locate the row corresponding to the feature
			from
				l_index := 1
				l_count := evgrid_faults.row_count
			until
				l_index > l_count or else l_row_for_feature /= Void
			loop
				l_row := evgrid_faults.row (l_index)
				if attached {STRING} l_row.data as lt_feature then
					if lt_feature ~ l_feature_under_test_str then
						l_row_for_feature := l_row
					else
						l_index := l_index + 1
					end
				else
					l_index := l_index + 1
				end
			end

			check l_row_for_feature /= Void end

			l_fault := a_fix.fault

				-- Locate the subrow for fault
			from
				l_index := 1
				l_count := l_row_for_feature.subrow_count
			until
				l_index > l_count or else l_row_for_fault /= Void
			loop
				l_row := l_row_for_feature.subrow (l_index)
				check attached {ES_ADB_FAULT} l_row.data as lt_fault then
					if lt_fault = a_fix.fault then
						l_row_for_fault := l_row
					else
						l_index := l_index + 1
					end
				end
			end
			check l_row_for_fault /= Void end

				-- Update fault info
			check attached {EV_GRID_LABEL_ITEM} l_row_for_fault.item (column_status) as lt_label_item then
				lt_label_item.set_text (a_fix.fault.status_string)
			end
		end

	on_fixing_stop (a_fault: ES_ADB_FAULT)
		do
		end

	on_output (a_line: STRING)
		do
		end

feature -- Access

	faults: DS_ARRAYED_LIST [ES_ADB_FAULT]

feature -- Status report

	has_no_fault: BOOLEAN
			-- <Precursor>
		do
			Result := faults.is_empty
		end

	populate_grid
			-- <Precursor>
		local
			l_lab: EV_GRID_LABEL_ITEM
			l_last_sort_column: INTEGER_32
			l_last_sort_order: INTEGER_32
		do
			if is_initialized then
				l_last_sort_column := grid_wrapper.last_sorted_column
				if l_last_sort_column > 0 then
					l_last_sort_order := grid_wrapper.column_sort_info.item (l_last_sort_column).current_order
				end
			end
			if l_last_sort_column = 0 then
				l_last_sort_column := column_class_and_feature_under_test
				l_last_sort_order := {EVS_GRID_TWO_WAY_SORTING_ORDER}.ascending_order
			end

				-- Remove all rows, reorder the faults, and then add the rows back to grid.

			if has_no_fault then
				evgrid_faults.insert_new_row (1)
				create l_lab.make_with_text (Grid_no_fault)
				evgrid_faults.set_item (1, 1, l_lab)
			end
		end

feature {NONE} -- Recycle

	internal_recycle
			-- To be called when the button has became useless.
		do
--			preferences.metric_tool_data.unit_order_preference.change_actions.prune_all (on_unit_order_change_agent)
--			uninstall_agents (metric_tool)
--			domain_selector.recycle
--			metric_selector.recycle
		end

feature{NONE} -- Implementation

	update_ui
			-- <Precursor>
		do
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
