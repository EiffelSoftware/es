note
	description: "Summary description for {ES_ADB_FAULTS_PANEL_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_PANEL_FAULTS_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize
		end

	ES_ADB_PANEL_ABSTRACT

	ES_ADB_INTERFACE_STRINGS

feature{NONE} -- Initialization

	initialize
			-- <Precursor>
		local
			l_v_box, l_internal_v_box: EV_VERTICAL_BOX
			l_h_box, l_internal_h_box: EV_HORIZONTAL_BOX
			l_col: EV_GRID_COLUMN
			l_grid: EV_GRID
			l_h_padding, l_v_padding: INTEGER

			l_label: EV_LABEL
			l_separator: EV_HORIZONTAL_SEPARATOR
		do
			Precursor{EV_VERTICAL_BOX}
			l_h_padding := {ES_UI_CONSTANTS}.horizontal_padding
			l_v_padding := {ES_UI_CONSTANTS}.vertical_padding
			set_padding (l_v_padding)

			create l_h_box
			l_h_box.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			create evgrid_faults
			l_grid := evgrid_faults
			l_grid.enable_row_separators
			l_grid.enable_single_row_selection
			l_grid.set_column_count_to (Last_column)
			l_col := l_grid.column (1)
			l_col.set_width (0)
			l_col := l_grid.column (column_class_and_feature_under_test)
			l_col.set_title (grid_column_text_class_and_feature_under_test)
			l_col.set_width (300)
			l_col := l_grid.column (column_fault)
			l_col.set_title (grid_column_text_fault)
			l_col.set_width (400)
			l_col := l_grid.column (column_passing)
			l_col.set_title (grid_column_text_passing_tests)
			l_col.set_width (100)
			l_col := l_grid.column (column_failing)
			l_col.set_title (grid_column_text_failing_tests)
			l_col.set_width (100)
			l_col := l_grid.column (column_status)
			l_col.set_title (grid_column_text_status)
			l_col.set_width (100)
			l_col := l_grid.column (column_info)
			l_col.set_title (grid_column_text_info)
			l_col.set_width (300)
			l_grid.enable_tree
			l_grid.enable_row_height_fixed
			l_h_box.extend (l_grid)
			extend (l_h_box)

				-- Buttons
			create l_h_box
			l_h_box.set_padding (l_h_padding)

				-- Popup menu
			create evmenu_approchability
			create evmenu_fixes

			create evmenucheck_implementation_fixable.make_with_text (Menu_text_automatic_implementation_fixable)
			evmenu_approchability.extend (evmenucheck_implementation_fixable)
			create evmenucheck_contract_fixable.make_with_text (Menu_text_automatic_specification_fixable)
			evmenu_approchability.extend (evmenucheck_contract_fixable)
			create evmenucheck_not_fixable.make_with_text (Menu_text_not_automatic_fixable)
			evmenu_approchability.extend (evmenucheck_not_fixable)

			create evmenucheck_not_yet_attempted.make_with_text (Menu_text_not_yet_attempted)
			evmenu_fixes.extend (evmenucheck_not_yet_attempted)
			create evmenucheck_candidate_fix_available.make_with_text (Menu_text_candidate_fix_available)
			evmenu_fixes.extend (evmenucheck_candidate_fix_available)
			create evmenucheck_candidate_fix_unavailable.make_with_text (Menu_text_candidate_fix_unavailable)
			evmenu_fixes.extend (evmenucheck_candidate_fix_unavailable)
			create evmenucheck_candidate_fix_accepted.make_with_text (Menu_text_candidate_fix_accepted)
			evmenu_fixes.extend (evmenucheck_candidate_fix_accepted)
			create evmenucheck_manually_fixed.make_with_text (Menu_text_manually_fixed)
			evmenu_fixes.extend (evmenucheck_manually_fixed)

			create evbutton_filter_by_approachability.make_with_text (Button_text_filter_by_approachability)
			evbutton_filter_by_approachability.set_minimum_width (120)
			evbutton_filter_by_approachability.select_actions.extend (agent evmenu_approchability.show_at (evbutton_filter_by_approachability, evbutton_filter_by_approachability.width, 0))
			create evbutton_filter_by_fixes.make_with_text (Button_text_filter_by_fixes)
			evbutton_filter_by_fixes.set_minimum_width (120)
			evbutton_filter_by_fixes.select_actions.extend (agent evmenu_fixes.show_at (evbutton_filter_by_fixes, evbutton_filter_by_fixes.width, 0))
			l_h_box.extend (evbutton_filter_by_approachability)
			l_h_box.disable_item_expand (evbutton_filter_by_approachability)
			l_h_box.extend (evbutton_filter_by_fixes)
			l_h_box.disable_item_expand (evbutton_filter_by_fixes)

				-- Right align
			create l_label.make_with_text("")
			l_h_box.extend (l_label)
			create evbutton_fix_all_to_be_attempted.make_with_text (Button_text_fix_all)
			create evbutton_fix_selected.make_with_text (button_text_fix_selected)
			create evbutton_mark_as_manually_fixed.make_with_text (Button_text_mark_as_manually_fixed)
			l_h_box.extend (evbutton_fix_all_to_be_attempted)
			l_h_box.disable_item_expand (evbutton_fix_all_to_be_attempted)
			l_h_box.extend (evbutton_fix_selected)
			l_h_box.disable_item_expand (evbutton_fix_selected)
			l_h_box.extend (evbutton_mark_as_manually_fixed)
			l_h_box.disable_item_expand (evbutton_mark_as_manually_fixed)
			extend (l_h_box)
			disable_item_expand (l_h_box)

		end

feature{NONE} -- GUI elements

	evbutton_fix_all_to_be_attempted: EV_BUTTON
	evbutton_fix_selected: EV_BUTTON
	evbutton_mark_as_manually_fixed: EV_BUTTON

	evbutton_filter_by_approachability: EV_BUTTON
	evbutton_filter_by_fixes: EV_BUTTON

	evmenu_approchability: EV_MENU
	evmenucheck_all_approchability: EV_CHECK_MENU_ITEM
	evmenucheck_implementation_fixable: EV_CHECK_MENU_ITEM
	evmenucheck_contract_fixable: EV_CHECK_MENU_ITEM
	evmenucheck_not_fixable: EV_CHECK_MENU_ITEM

	evmenu_fixes: EV_MENU
	evmenucheck_all_fixes: EV_CHECK_MENU_ITEM
	evmenucheck_not_yet_attempted: EV_CHECK_MENU_ITEM
	evmenucheck_candidate_fix_available: EV_CHECK_MENU_ITEM
	evmenucheck_candidate_fix_unavailable: EV_CHECK_MENU_ITEM
	evmenucheck_candidate_fix_accepted: EV_CHECK_MENU_ITEM
	evmenucheck_manually_fixed: EV_CHECK_MENU_ITEM

	evgrid_faults: EV_GRID

feature -- Constants

	Column_class_and_feature_under_test: INTEGER = 2
	Column_fault: INTEGER = 3
	Column_passing: INTEGER = 4
	Column_failing: INTEGER = 5
	Column_status: INTEGER = 6
	Column_info: INTEGER = 7
	Last_column: INTEGER = 7

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
