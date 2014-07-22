
class ES_ADB_PANEL_FAULTS

inherit

	ES_ADB_PANEL_FAULTS_IMP
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

			Info_center.extend (Current)
		end

feature{NONE} -- Update GUI

	clear_information_display_widget
			-- Clear all information displayed on panel.
		do
			evgrid_faults.remove_rows (1, evgrid_faults.row_count)
		end

	enable_information_display_widget (a_flag: BOOLEAN)
			-- Enable/Disable the widgets related to information display.
		do
			if a_flag then
				evgrid_faults.enable_sensitive
				evbutton_filter_by_approachability.enable_sensitive
				evbutton_filter_by_fixes.enable_sensitive
			else
				evgrid_faults.disable_sensitive
				evbutton_filter_by_approachability.disable_sensitive
				evbutton_filter_by_fixes.disable_sensitive
			end
		end

	enable_command_invocation_widget (a_flag: BOOLEAN)
			-- Enable/Disable the widgets related to command invocation.
		do
			if a_flag then
				if has_to_be_attempted then
					evbutton_fix_all_to_be_attempted.enable_sensitive
				else
					evbutton_fix_all_to_be_attempted.disable_sensitive
				end

				if attached {ES_ADB_FAULT} selected_fault_in_grid as lt_fault and then is_fault_approachable (lt_fault) then
					evbutton_fix_selected.enable_sensitive
				else
					evbutton_fix_selected.disable_sensitive
				end

				if attached {ES_ADB_FAULT} selected_fault_in_grid as lt_fault and then not lt_fault.is_fixed then
					evbutton_mark_as_manually_fixed.enable_sensitive
				else
					evbutton_mark_as_manually_fixed.disable_sensitive
				end
			else
				evbutton_fix_all_to_be_attempted.disable_sensitive
				evbutton_fix_selected.disable_sensitive
				evbutton_mark_as_manually_fixed.disable_sensitive
			end
		end

	clear_internal_state
			-- Clear panel internal state.
		do
			fault_to_row_table_internal := Void
			feature_to_row_table_internal := Void
		end

feature -- ADB Actions

	on_project_loaded
			-- <Precursor>
		do
			enable_information_display_widget (True)
			enable_command_invocation_widget (True)
		end

	on_project_unloaded
			-- <Precursor>
		do
			clear_information_display_widget
			clear_internal_state
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
			clear_information_display_widget
			clear_internal_state
			enable_command_invocation_widget (False)
		end

	on_debugging_stop
			-- <Precursor>
		do
			enable_command_invocation_widget (True)
			update_has_to_be_attempted
		end

	on_testing_start
			-- <Precursor>
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		local
			l_label_item: EV_GRID_LABEL_ITEM
			l_signature: EPA_TEST_CASE_SIGNATURE
			l_feature_under_test_str: STRING
			l_feature_under_test: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_index, l_count, l_insert_position: INTEGER
			l_row, l_row_for_feature, l_row_for_fault: EV_GRID_ROW
			l_fault: ES_ADB_FAULT
			l_was_row_visible, l_was_sub_row_visible: BOOLEAN
			l_text, l_info: STRING
			l_left_par_index, l_right_par_index: INTEGER
			l_is_new_feature_row, l_is_new_fault_row: BOOLEAN
		do
			l_signature := a_test.test_case_signature
			l_feature_under_test_str := l_signature.class_and_feature_under_test

				-- Locate the row corresponding to the feature
			if feature_to_row_table.has (l_feature_under_test_str) then
				l_row_for_feature := feature_to_row_table.item (l_feature_under_test_str)
			end

			if l_signature.is_passing and then l_row_for_feature /= Void then
					-- Update number of passing tests for the feature
				check attached {EV_GRID_LABEL_ITEM} l_row_for_feature.item (column_passing) as lt_label_item then
					lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
				end

			elseif l_signature.is_failing then
				l_fault := info_center.fault_with_signature (l_signature, True)

				if l_row_for_feature = Void then
					l_is_new_feature_row := True
					l_count := evgrid_faults.row_count
					l_insert_position := first_row (evgrid_faults,
							agent (a_row: EV_GRID_ROW; a_feature_str: STRING): BOOLEAN
								do Result := attached {STRING} a_row.data as lt_feature_str and then lt_feature_str.is_greater_equal (a_feature_str) end (?, l_feature_under_test_str))
					if l_insert_position = 0 then
						l_insert_position := evgrid_faults.row_count + 1
					end
						-- Insert a row at the right position for the feature
					evgrid_faults.set_row_count_to (l_count + 1)
					l_row_for_feature := evgrid_faults.row (l_count + 1)
					l_row_for_feature.set_data (l_feature_under_test_str)
					evgrid_faults.move_row (l_count + 1, l_insert_position)
					feature_to_row_table.force (l_row_for_feature, l_feature_under_test_str)

					create l_label_item.make_with_text (l_feature_under_test_str)
					l_label_item.align_text_left
					l_row_for_feature.set_item (column_class_and_feature_under_test, l_label_item)

					create l_label_item.make_with_text ("0")
					l_row_for_feature.set_item (column_fault, l_label_item)

					create l_label_item.make_with_text (info_center.passing_test_case_count_for_feature (l_signature.class_and_feature_under_test).out)
					l_row_for_feature.set_item (column_passing, l_label_item)

					create l_label_item.make_with_text ("0")
					l_row_for_feature.set_item (column_failing, l_label_item)

					create l_label_item.make_with_text ("")
					l_row_for_feature.set_item (column_status, l_label_item)

					create l_label_item.make_with_text ("")
					l_row_for_feature.set_item (column_info, l_label_item)
				end

				if fault_to_row_table.has (l_fault) then
					l_row_for_fault := fault_to_row_table.item (l_fault)
				else
					l_is_new_fault_row := True
						-- Locate the subrow for fault
					l_count := l_row_for_feature.subrow_count
					l_insert_position := first_subrow (l_row_for_feature,
							agent (a_subrow: EV_GRID_ROW; a_sig_id: STRING): BOOLEAN do Result := attached {ES_ADB_FAULT} a_subrow.data as lt_fault and then lt_fault.signature.id.is_greater_equal (a_sig_id) end (?, a_test.test_case_signature.id))
					if l_insert_position = 0 then
						l_insert_position := l_row_for_feature.subrow_count + 1
					end

					l_row_for_feature.insert_subrow (l_insert_position)
					l_row_for_fault := l_row_for_feature.subrow (l_insert_position)
					fault_to_row_table.force (l_row_for_fault, l_fault)
					l_row_for_fault.set_data (l_fault)

					l_row_for_fault.set_item (column_class_and_feature_under_test, create {EV_GRID_LABEL_ITEM}.make_with_text (""))

					create l_label_item.make_with_text (l_signature.id)
					l_row_for_fault.set_item (column_fault, l_label_item)

					l_row_for_fault.set_item (column_passing, create {EV_GRID_LABEL_ITEM}.make_with_text (""))

					create l_label_item.make_with_text ("0")
					l_row_for_fault.set_item (column_failing, l_label_item)

					l_row_for_fault.set_item (column_status, create {EV_GRID_LABEL_ITEM}.make_with_text (l_fault.status_string))

					l_info := l_signature.out
					l_info.replace_substring_all ("%N", "; ")
					l_row_for_fault.set_item (column_info, create {EV_GRID_LABEL_ITEM}.make_with_text (l_info))

				end

				check attached {EV_GRID_LABEL_ITEM} l_row_for_fault.item (column_failing) as lt_label_item then
					lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
				end
				if l_is_new_fault_row then
					if is_fault_visible (l_fault) then
						l_row_for_fault.show
							-- #(failing tests) of the feature + 1
						check attached {EV_GRID_LABEL_ITEM} l_row_for_feature.item (column_failing) as lt_label_item then
							lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
						end
							-- #(faults) of the feature + 1
						check attached {EV_GRID_LABEL_ITEM} l_row_for_feature.item (column_fault) as lt_label_item then
							lt_label_item.set_text ((lt_label_item.text.to_integer + 1).out)
						end
					else
						l_row_for_fault.hide
					end
					if not has_to_be_attempted then
						update_has_to_be_attempted
					end
				end
			end
		end

	on_testing_stop
			-- <Precursor>
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
			update_fault_status (a_fault)
		end

	on_fixing_stop
			-- <Precursor>
		do
		end

	on_continuation_debugging_start
			-- <Precursor>
		do
			tool_panel.set_external_process_running (True)
			tool_panel.save_settings
			enable_command_invocation_widget (False)
		end

	on_continuation_debugging_stop
			-- <Precursor>
		do
			tool_panel.set_external_process_running (False)
			enable_command_invocation_widget (True)
			evbutton_fix_selected.set_text (button_text_fix_selected)
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
			l_row: EV_GRID_ROW
		do
			update_fault_status (a_fix.fault)
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
			l_row: EV_GRID_ROW
		do
			update_fault_status (a_fix.fault)
			update_has_to_be_attempted
			if attached evgrid_faults.selected_rows as lt_rows and then not lt_rows.is_empty and then attached {ES_ADB_FAULT} lt_rows.first.data as lt_fault then
				on_row_selected (lt_rows.first)
			end
		end

	on_output (a_line: STRING)
			-- <Precursor>
		do
		end

feature{NONE} -- ADB action implementation

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

feature{ES_ADB_PANEL_FIXES} -- GUI actions

	has_row_for_fault (a_fault: ES_ADB_FAULT): BOOLEAN
			-- Has current a row associated with `a_fault'?
		do
			Result := fault_to_row_table.has (a_fault)
		end

	on_select_row (a_fault: ES_ADB_FAULT)
			-- Select the row associated with `a_fault'.
		require
			has_row_for_fault (a_fault)
		local
			l_row: EV_GRID_ROW
		do
			l_row := fault_to_row_table.item (a_fault)
			evgrid_faults.select_row (l_row.index)
		end

feature{NONE} -- GUI actions

	register_event_handlers
			-- Register event handlers for the panel.
		do
			evgrid_faults.row_select_actions.extend (agent on_row_selected)
			evgrid_faults.row_deselect_actions.extend (agent on_row_deselected)
			evgrid_faults.pointer_double_press_item_actions.extend (agent on_grid_events_item_pointer_double_press)

			evmenucheck_implementation_fixable.select_actions.extend (agent on_visibility_changed)
			evmenucheck_contract_fixable.select_actions.extend (agent on_visibility_changed)
			evmenucheck_not_fixable.select_actions.extend (agent on_visibility_changed)

			evmenucheck_to_be_fixed.select_actions.extend (agent on_visibility_changed)
			evmenucheck_candidate_fix_available.select_actions.extend (agent on_visibility_changed)
			evmenucheck_candidate_fix_unavailable.select_actions.extend (agent on_visibility_changed)
			evmenucheck_candidate_fix_accepted.select_actions.extend (agent on_visibility_changed)
			evmenucheck_manually_fixed.select_actions.extend (agent on_visibility_changed)

			evbutton_fix_selected.select_actions.extend (agent on_fix_selected)
			evbutton_fix_all_to_be_attempted.select_actions.extend (agent on_fix_all_to_be_attempted)
			evbutton_mark_as_manually_fixed.select_actions.extend (agent on_mark_fault_as_manually_fixed)
		end

	on_row_selected (a_row: EV_GRID_ROW)
			-- Action to perform when `a_row' is selected.
		local
			l_fault: ES_ADB_FAULT
		do
			if not tool_panel.is_external_process_running then
				if attached {ES_ADB_FAULT} a_row.data as lt_fault and then is_fault_approachable (lt_fault) and then not lt_fault.is_fixed then
					evbutton_fix_selected.enable_sensitive
				else
					evbutton_fix_selected.disable_sensitive
				end
				if attached {ES_ADB_FAULT} a_row.data as lt_fault and then not lt_fault.is_fixed then
					evbutton_mark_as_manually_fixed.enable_sensitive
				else
					evbutton_mark_as_manually_fixed.disable_sensitive
				end
			end
		end

	on_row_deselected (a_row: EV_GRID_ROW)
			-- Action to perform when `a_row' is deselected.
		do
			evbutton_fix_selected.disable_sensitive
			evbutton_mark_as_manually_fixed.disable_sensitive
		end

	on_grid_events_item_pointer_double_press (a_x: INTEGER_32; a_y: INTEGER_32; a_button: INTEGER_32; a_item: EV_GRID_ITEM)
			-- Action to perform when user double press on the grid.
		local
			l_fixes_panel: ES_ADB_PANEL_FIXES
		do
			if a_item /= Void and then attached a_item.row as lt_row then
				if attached {ES_ADB_FAULT} lt_row.data as lt_fault then
					if not lt_fault.fixes.is_empty then
							-- Switch to panel fix and show corresponding fixes.
						l_fixes_panel := tool_panel.fixes_panel
						tool_panel.autodebug_notebook.select_item (l_fixes_panel)
						if l_fixes_panel.has_row_for_fault (lt_fault) then
							l_fixes_panel.on_select_row (lt_fault)
						end
					end
				end
			end
		end

	on_mark_fault_as_manually_fixed
			-- Mark the currently selected fault as being manually fixed.
		local
			l_fault: ES_ADB_FAULT
			l_manual_fix: ES_ADB_FIX_MANUAL
			l_row: EV_GRID_ROW
		do
			l_fault := selected_fault_in_grid
			if l_fault /= Void and then not l_fault.is_fixed then
				l_row := fault_to_row_table.item (l_fault)
				l_manual_fix := l_fault.manual_fix
				info_center.on_valid_fix_found (l_manual_fix)
				info_center.on_fix_applied (l_manual_fix)
				evgrid_faults.select_row (l_row.index)
				on_row_selected (l_row)
			end
		end

	on_visibility_changed
			-- Action to perform when the filtering condition is changed.
		local
			l_index, l_count, l_sub_index, l_sub_count: INTEGER
			l_visible_sub_rows: INTEGER
			l_row, l_sub_row: EV_GRID_ROW
		do
			config.set_show_implementation_fixable (evmenucheck_implementation_fixable.is_selected)
			config.set_show_contract_fixable (evmenucheck_contract_fixable.is_selected)
			config.set_show_not_fixable (evmenucheck_not_fixable.is_selected)

			config.set_show_to_be_fixed (evmenucheck_to_be_fixed.is_selected)
			config.set_show_candidate_fix_available (evmenucheck_candidate_fix_available.is_selected)
			config.set_show_candidate_fix_unavailable (evmenucheck_candidate_fix_unavailable.is_selected)
			config.set_show_candidate_fix_accepted (evmenucheck_candidate_fix_accepted.is_selected)
			config.set_show_manually_fixed (evmenucheck_candidate_fix_accepted.is_selected)

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

	on_fix_selected
			-- Action to perform when `AutoFix selected' button is clicked.
		local
			l_text: STRING
			l_fault: ES_ADB_FAULT
			l_faults: DS_ARRAYED_LIST [ES_ADB_FAULT]
			l_should_continue: BOOLEAN
			l_fixing_task: ES_ADB_PROCESS_SEQUENCE_FOR_FIXING
		do
			l_text := evbutton_fix_selected.text
			if l_text ~ Button_text_fix_selected then
				l_fault := selected_fault_in_grid
				check l_fault /= Void then
					if l_fault.is_not_yet_attempted then
						l_should_continue := True
					else
						l_should_continue := is_approved_by_user ({ES_ADB_INTERFACE_STRINGS}.Msg_discard_existing_fixing_results)
					end
					if l_should_continue then
						info_center.on_continuation_debugging_start
						evbutton_fix_selected.set_text (Button_text_fix_selected_stop)
						evbutton_fix_selected.enable_sensitive

						create l_faults.make_equal (1)
						l_faults.force_last (l_fault)

						create l_fixing_task.make (l_faults, True)
						create forwarding_task.make (l_fixing_task)
						forwarding_task.on_terminate_actions.extend (agent info_center.on_continuation_debugging_stop)
						forwarding_task.start

					end
				end

			elseif l_text ~ Button_text_fix_selected_stop then
				forwarding_task.cancel
				info_center.on_continuation_debugging_stop
			end
		end

	on_fix_all_to_be_attempted
			-- Action to perform when 'AutoFix all' is clicked.
		local
			l_text: STRING
			l_all_to_be_attempted: DS_ARRAYED_LIST [ES_ADB_FAULT]
			l_cursor: DS_HASH_TABLE_CURSOR [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
			l_fixing_task: ES_ADB_PROCESS_SEQUENCE_FOR_FIXING
		do
			l_text := evbutton_fix_all_to_be_attempted.text
			if l_text ~ Button_text_fix_all then
				info_center.on_continuation_debugging_start
				evbutton_fix_all_to_be_attempted.set_text (button_text_fix_all_stop)
				evbutton_fix_all_to_be_attempted.enable_sensitive

					-- Collect the faults to be attempted.
				create l_all_to_be_attempted.make_equal (info_center.fault_repository.count)
				from
					l_cursor := info_center.fault_repository.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					if is_fault_to_be_attempted_and_approachable (l_cursor.item) then
						l_all_to_be_attempted.force_last (l_cursor.item)
					end
					l_cursor.forth
				end

				if not l_all_to_be_attempted.is_empty then
					create l_fixing_task.make (l_all_to_be_attempted, True)
					create forwarding_task.make (l_fixing_task)
					forwarding_task.on_terminate_actions.extend (agent do info_center.on_continuation_debugging_stop; evbutton_fix_all_to_be_attempted.set_text (button_text_fix_all) end)
					forwarding_task.start

				else
					info_center.on_continuation_debugging_stop
					evbutton_fix_all_to_be_attempted.set_text (button_text_fix_all)
				end
			else
				forwarding_task.cancel
				info_center.on_continuation_debugging_stop
			end
		end

feature{NONE} -- GUI action implementation

	is_fault_approachable (a_fault: ES_ADB_FAULT): BOOLEAN
			-- Is `a_fault' AutoFix-able?
		require
			a_fault /= Void
		do
			Result := not a_fault.is_fixed and then a_fault.is_approachable_per_config (config)
		end

	is_fault_visible (a_fault: ES_ADB_FAULT): BOOLEAN
			-- Is `a_fault' visible according to the current filter?
		do
			Result := (a_fault.is_exception_type_in_scope_of_contract_fixing and then config.should_show_contract_fixable
						or else a_fault.is_exception_type_in_scope_of_implementation_fixing and then config.should_show_implementation_fixable
						or else not a_fault.is_exception_type_in_scope_of_contract_fixing and then not a_fault.is_exception_type_in_scope_of_implementation_fixing and then config.should_show_not_fixable)
					  and then
					  ((a_fault.is_not_yet_attempted or not a_fault.is_approachable) and then config.should_show_to_be_fixed
					  	or else a_fault.is_candidate_fix_available and then config.should_show_candidate_fix_available
					  	or else a_fault.is_candidate_fix_unavailable and then config.should_show_candidate_fix_unavailable
					  	or else a_fault.is_candidate_fix_accepted and then config.should_show_candidate_fix_accepted
					  	or else a_fault.is_manually_fixed and then config.should_show_manually_fixed)
		end


	update_feature_row (a_row: EV_GRID_ROW)
			-- Update feature information at `a_row'.
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

	selected_fault_in_grid: ES_ADB_FAULT
			-- Fault currently selected in grid.
		do
			if attached evgrid_faults.selected_rows as lt_rows and then not lt_rows.is_empty and then attached {ES_ADB_FAULT} lt_rows.first.data as lt_fault then
				Result := lt_fault
			end
		end

	set_has_to_be_attempted (a_flag: BOOLEAN)
			-- Set `has_to_be_attempted' with `a_flag'.
			-- Enable/Disable `evbutton_fix_all_to_be_attempted' accordingly.
		do
			has_to_be_attempted := a_flag
			if not tool_panel.is_external_process_running then
				if has_to_be_attempted then
					evbutton_fix_all_to_be_attempted.enable_sensitive
				else
					evbutton_fix_all_to_be_attempted.disable_sensitive
				end
			end
		end


	is_fault_to_be_attempted_and_approachable (a_fault: ES_ADB_FAULT): BOOLEAN
			-- Is `a_fault' to-be-attempted, and approachable with `config'?
		do
			Result := a_fault.is_not_yet_attempted and then a_fault.is_approachable_per_config (config)
		end

	update_has_to_be_attempted
			-- Update `has_to_be_attempted' to reflect the status of faults in grid.
		local
			l_has_to_be_attempted: BOOLEAN
			l_fault_cursor: DS_HASH_TABLE_CURSOR [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
			l_fault: ES_ADB_FAULT
		do
			from
				l_has_to_be_attempted := False
				l_fault_cursor := info_center.fault_repository.new_cursor
				l_fault_cursor.start
			until
				l_fault_cursor.after or else l_has_to_be_attempted
			loop
				if is_fault_to_be_attempted_and_approachable (l_fault_cursor.item) then
					l_has_to_be_attempted := True
				end
				l_fault_cursor.forth
			end
			set_has_to_be_attempted (l_has_to_be_attempted)
		end

feature -- Config <-> GUI sync

	propogate_values_from_config_to_ui
			-- <Precursor>
		do
				enable_check_menu_item (evmenucheck_implementation_fixable, True, config.should_show_implementation_fixable)
				enable_check_menu_item (evmenucheck_contract_fixable, True, config.should_show_contract_fixable)
				enable_check_menu_item (evmenucheck_not_fixable, True, config.should_show_not_fixable)

				enable_check_menu_item (evmenucheck_to_be_fixed, True, config.should_show_to_be_fixed)
				enable_check_menu_item (evmenucheck_candidate_fix_available, True, config.should_show_candidate_fix_available)
				enable_check_menu_item (evmenucheck_candidate_fix_unavailable, True, config.should_show_candidate_fix_unavailable)
				enable_check_menu_item (evmenucheck_candidate_fix_accepted, True, config.should_show_candidate_fix_accepted)
				enable_check_menu_item (evmenucheck_manually_fixed, True, config.should_show_manually_fixed)
		end

	propogate_values_from_ui_to_config
			-- Propogate changes from UI to config.
		do
			config.set_show_implementation_fixable (evmenucheck_implementation_fixable.is_selected)
			config.set_show_contract_fixable (evmenucheck_contract_fixable.is_selected)
			config.set_show_not_fixable (evmenucheck_not_fixable.is_selected)

			config.set_show_to_be_fixed (evmenucheck_to_be_fixed.is_selected)
			config.set_show_candidate_fix_available (evmenucheck_candidate_fix_available.is_selected)
			config.set_show_candidate_fix_unavailable (evmenucheck_candidate_fix_unavailable.is_selected)
			config.set_show_candidate_fix_accepted (evmenucheck_candidate_fix_accepted.is_selected)
			config.set_show_manually_fixed (evmenucheck_manually_fixed.is_selected)
		end

feature{NONE} -- Config <-> GUI sync implementation

	enable_check_menu_item (a_item: EV_CHECK_MENU_ITEM; a_is_sensitive, a_is_selected: BOOLEAN)
			-- Set status of `a_item', using `a_is_sensitive' and `a_is_selected'.
		require
			a_item /= Void
		do
			if a_is_sensitive then
				a_item.enable_sensitive
				if a_is_selected then
					a_item.enable_select
				else
					a_item.disable_select
				end
			else
				a_item.disable_select
				a_item.disable_sensitive
			end
		end

feature{NONE} -- Implementation

	has_to_be_attempted: BOOLEAN assign set_has_to_be_attempted
			-- Has the grid some fault with status 'to-be-attempted'?

	forwarding_task: ES_ADB_OUTPUT_RETRIEVER
			-- Task to forward the process output to `info_center'.

	fault_to_row_table: DS_HASH_TABLE [EV_GRID_ROW, ES_ADB_FAULT]
			-- Table mapping faults to their associated rows.
		do
			if fault_to_row_table_internal = Void then
				create fault_to_row_table_internal.make_equal (64)
			end
			Result := fault_to_row_table_internal
		end

	feature_to_row_table: DS_HASH_TABLE [EV_GRID_ROW, STRING]
			-- Table mapping features to their associated rows.
		do
			if feature_to_row_table_internal = Void then
				create feature_to_row_table_internal.make_equal (64)
			end
			Result := feature_to_row_table_internal
		end

feature{NONE} -- Cache

	fault_to_row_table_internal: like fault_to_row_table
			-- Cache for `fault_to_row_table'.

	feature_to_row_table_internal: like feature_to_row_table
			-- Cache for `feature_to_row_table'.



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
