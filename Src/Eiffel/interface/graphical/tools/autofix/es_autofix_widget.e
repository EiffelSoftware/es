note
	description: "AutoFix tool GUI widget"

class
	ES_AUTOFIX_WIDGET

inherit
	EV_HORIZONTAL_BOX

	EXCEPTIONS
		undefine default_create, is_equal, copy end

create
	make

feature{NONE} -- Initialization

	make (a_panel: ES_EVE_AUTOFIX_TOOL_PANEL)
			-- Initialization
		require
			panel_attached: a_panel /= Void
		do
			default_create
			panel := a_panel
			build_interface
		ensure
			panel_set: panel = a_panel
		end

feature -- Access

	panel: ES_EVE_AUTOFIX_TOOL_PANEL
			-- Panel where the widget resides.

	autofix_results: HASH_TABLE[ES_EVE_AUTOFIX_RESULT, STRING]
			-- Results of AutoFix.
		do
			Result := panel.autofix_results
		end

feature -- GUI elements

	refresh_button: EV_BUTTON
			-- Button to refresh all results.

	faults_combo: EV_COMBO_BOX
			-- Combo-box listing all the faults.

	fixes_list: EV_LIST
			-- List showing all the fixes for a fault from `faults_combo'.

	apply_fix_button: EV_BUTTON
			-- Button to apply the current selected fix.

	unapply_fix_button: EV_BUTTON
			-- Button to unapply the fix, if it's applied before.

	code_diff_widget: ES_EVE_CODE_DIFF_WIDGET
			-- Widget for showing the faulty code and the fixed code side-by-side.

	split_area: EV_HORIZONTAL_SPLIT_AREA
			-- Horizontal split area.

feature -- GUI labels

	faults_label_text: STRING = "Faults"
			-- Label text shown above the faults combo-box.

	refresh_button_text: STRING = "Refresh"
			-- Text for the `Refresh' button.

	fixes_label_text: STRING = "Valid fixes"
			-- Label text shown above the fixes list-box.

	apply_fix_button_text: STRING = "Apply"
			-- Text for the `Apply' button.

	unapply_fix_button_text: STRING = "Revert"
			-- Text for the `Revert' button.

	before_fixing_label_text: STRING = "Before fixing"
			-- Label text above the before-fixing code.

	after_fixing_label_text: STRING = "After fixing"
			-- Label text above the after-fixing code.

feature {NONE} -- Implementation

	build_interface
		local
			l_left_frame, l_right_frame: EV_FRAME
			l_v_box: EV_VERTICAL_BOX
			l_h_box: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
			l_toolbar: SD_TOOL_BAR
			l_button: SD_TOOL_BAR_BUTTON
		do
			create l_v_box
			l_v_box.set_minimum_size (152, 200)
			l_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			create l_label.make_with_text (faults_label_text)
			l_label.align_text_left
			create refresh_button.make_with_text_and_action (refresh_button_text, agent panel.refresh_all_autofix_results)
			create l_h_box
			l_h_box.extend (l_label)
			l_h_box.extend (refresh_button)
			l_h_box.disable_item_expand (refresh_button)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)
			create faults_combo.make_with_text ("--")
			faults_combo.set_minimum_size (150, 30)
			faults_combo.disable_edit
			l_v_box.extend (faults_combo)
			l_v_box.disable_item_expand (faults_combo)
			create l_label.make_with_text (fixes_label_text)
			l_label.set_minimum_height (32)
			l_label.align_text_left
			create apply_fix_button.make_with_text_and_action (apply_fix_button_text, agent on_apply_fix)
			create unapply_fix_button.make_with_text_and_action (unapply_fix_button_text, agent on_unapply_fix)
			create l_h_box
			l_h_box.extend (l_label)
			l_h_box.extend (apply_fix_button)
			l_h_box.disable_item_expand (apply_fix_button)
			l_h_box.extend (unapply_fix_button)
			l_h_box.disable_item_expand (unapply_fix_button)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)
			create fixes_list
			fixes_list.set_minimum_size (150, 120)
			fixes_list.disable_multiple_selection
			l_v_box.extend (fixes_list)
			create l_left_frame
			l_left_frame.set_minimum_size (150, 200)
			l_left_frame.extend (l_v_box)

			create code_diff_widget.make ("Fix Detail", before_fixing_label_text, after_fixing_label_text)
			code_diff_widget.set_minimum_size (200, 200)

			create split_area
			split_area.set_first (l_left_frame)
			split_area.set_second (code_diff_widget)
			extend (split_area)
		end

feature -- Actions

	refresh_result (a_fault_signature: STRING)
			-- Refresh the result for `a_fault_signature'.
		require
			signature_not_empty: a_fault_signature /= Void and then not a_fault_signature.is_empty
			result_available: panel.autofix_results.has (a_fault_signature)
		local
			l_list_item, l_result_item: EV_LIST_ITEM
			l_result: ES_EVE_AUTOFIX_RESULT
		do
			l_result := panel.autofix_results.item (a_fault_signature)
			l_result_item := faults_combo.retrieve_item_by_data (l_result, False)
			if l_result_item = Void then
				create l_result_item.make_with_text (l_result.short_summary_text)
				l_result_item.set_data (l_result)
				l_result_item.select_actions.extend (agent on_fault_selected (l_result))
				l_result_item.deselect_actions.extend (agent on_fault_selected (Void))
				faults_combo.extend (l_result_item)
			else
				l_result_item.set_text (l_result.short_summary_text)
			end

			fixes_list.wipe_out
			l_result_item.enable_select
		end

	refresh_all
			-- Clean out the current GUI contents, and fill with data from `autofix_results'.
		local
			l_item_text: STRING
			l_list_item: EV_LIST_ITEM
			l_list_items: ARRAYED_LIST [EV_LIST_ITEM]
			l_fault, l_first_fault: STRING
			l_result: ES_EVE_AUTOFIX_RESULT
			l_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION
		do
			fixes_list.wipe_out
			faults_combo.wipe_out

			if not autofix_results.is_empty then
				from autofix_results.start
				until autofix_results.after
				loop
					l_fault := autofix_results.key_for_iteration
					l_result := autofix_results.item_for_iteration

						-- Prepare the list item for the `faults_list'.
					create l_list_item.make_with_text (l_result.short_summary_text)
					l_list_item.set_data (l_result)
					l_list_item.select_actions.extend (agent on_fault_selected (l_result))
					l_list_item.deselect_actions.extend (agent on_fault_selected (Void))
					faults_combo.extend (l_list_item)

					autofix_results.forth
				end
			else
				create l_list_item.make_with_text ("-- No AutoFix Available --")
				l_list_item.select_actions.extend (agent on_fault_selected (Void))
				faults_combo.extend (l_list_item)
			end

			faults_combo.first.enable_select
		end

feature -- Actions

	on_fault_selected (a_result: ES_EVE_AUTOFIX_RESULT)
			-- Action to perform when a fault is selected from `faults_combo'.
		local
			l_result: ES_EVE_AUTOFIX_RESULT
			l_fault: STRING
			l_list_item: EV_LIST_ITEM
			l_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION
		do
			if a_result = Void then
				fixes_list.wipe_out
				code_diff_widget.set_hunk (Void)
			else
				if a_result /= previously_selected_result then
						-- Refresh the 'fixes_list'.				
					fixes_list.wipe_out

					if not a_result.is_empty then
						from a_result.start
						until a_result.after
						loop
							l_suggestion := a_result.item_for_iteration

							create l_list_item.make_with_text (l_suggestion.short_summary_text)
							l_list_item.set_data (l_suggestion)
							l_list_item.select_actions.extend (agent on_fix_selected (l_suggestion))
							l_list_item.deselect_actions.extend (agent on_fix_selected (Void))
							fixes_list.extend (l_list_item)

							a_result.forth
						end
					else
						create l_list_item.make_with_text ("-- No Valid Fix Available --")
						l_list_item.select_actions.extend (agent on_fix_selected (Void))
						fixes_list.extend (l_list_item)
					end
--					fixes_list.first.enable_select
				end
			end

			previously_selected_result := a_result
			update_buttons
		end

	on_fix_selected (a_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION)
			-- Action to perform when a fix has been selected.
		do
			if a_suggestion = Void then
				code_diff_widget.set_hunk (Void)
				apply_fix_button.hide
			else
				code_diff_widget.set_hunk (a_suggestion)
				if a_suggestion.parent /= Void and then not a_suggestion.parent.is_fixed then
					apply_fix_button.show
				else
					apply_fix_button.hide
				end
			end
			update_buttons
		end

	on_unapply_fix
			-- Unapply the fix.
		local
			l_applied_fix_index: INTEGER
			l_applied_fix: ES_EVE_AUTOFIX_FIXING_SUGGESTION
			l_result: ES_EVE_AUTOFIX_RESULT
		do
			l_result ?= faults_combo.selected_item.data
			check l_result /= Void end
			l_applied_fix_index := l_result.fix_index_applied

			l_result.revert

				-- Update GUI.
			faults_combo.selected_item.set_text (l_result.short_summary_text)
			if fixes_list.count >= l_applied_fix_index and then attached fixes_list[l_applied_fix_index] as lt_item
					and then attached {ES_EVE_AUTOFIX_FIXING_SUGGESTION} lt_item.data as lt_data then
				lt_item.set_text (lt_data.short_summary_text)
			end
			update_buttons
		end

	on_apply_fix
			-- Apply the fix.
		local
			l_result: ES_EVE_AUTOFIX_RESULT
			l_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION
			l_retried: BOOLEAN
			l_information_dialog: EV_INFORMATION_DIALOG
		do
			if not l_retried then
				l_result ?= faults_combo.selected_item.data
				check l_result /= Void end
				l_suggestion ?= fixes_list.selected_item.data
				check l_suggestion /= Void end

					-- Apply the fix.
				l_suggestion.apply
			end

				-- Update GUI.
			faults_combo.selected_item.set_text (l_result.short_summary_text)
			fixes_list.selected_item.set_text (l_suggestion.short_summary_text)
			update_buttons
		rescue
			if attached {ES_EVE_AUTOFIX_EXCEPTION} exception_manager.last_exception.original as lt_ex then
				create l_information_dialog
				l_information_dialog.set_text ("AutoFix failed to apply the chosen fix due to %N%T" + lt_ex.reason + "%NThe system is not changed.")
				l_information_dialog.show_modal_to_window (panel.window_manager.last_focused_development_window.window)
			end
		end

	update_buttons
			-- Update the show/hide status of buttons.
		local
			l_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION
			l_result: ES_EVE_AUTOFIX_RESULT
		do
			if attached fixes_list.selected_item as lt_item and then attached {ES_EVE_AUTOFIX_FIXING_SUGGESTION} lt_item.data as lt_fix
					and then not lt_fix.parent.is_fixed then
				apply_fix_button.show
			else
				apply_fix_button.hide
			end

			if attached faults_combo.selected_item as lt_item and then attached {ES_EVE_AUTOFIX_RESULT} lt_item.data as lt_result
					and then lt_result.is_fixed and then lt_result.backup_class_file /= Void then
				unapply_fix_button.show
			else
				unapply_fix_button.hide
			end
		end

feature {NONE} -- Implementation

	previously_selected_result: ES_EVE_AUTOFIX_RESULT
			-- Previously selected result in `faults_combo'.

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
