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
			l_h_box.set_padding (l_h_padding)
			create evtoggle_show_to_be_attempted.make_with_text (toggle_text_show_to_be_attempted)
			create evtoggle_show_candidate_fix_available.make_with_text (toggle_text_show_candidate_fix_available)
			create evtoggle_show_candidate_fix_unavailable.make_with_text (toggle_text_show_candidate_fix_unavailable)
			create evtoggle_show_candidate_fix_accepted.make_with_text (toggle_text_show_candidate_fix_accepted)
			create evtoggle_show_manually_fixed.make_with_text (toggle_text_show_manual_fixed)

			l_h_box.extend (evtoggle_show_to_be_attempted)
			l_h_box.disable_item_expand (evtoggle_show_to_be_attempted)

			create l_separator
			l_h_box.extend (l_separator)
			l_h_box.disable_item_expand (l_separator)

			l_h_box.extend (evtoggle_show_candidate_fix_available)
			l_h_box.disable_item_expand (evtoggle_show_candidate_fix_available)
			l_h_box.extend (evtoggle_show_candidate_fix_unavailable)
			l_h_box.disable_item_expand (evtoggle_show_candidate_fix_unavailable)
			l_h_box.extend (evtoggle_show_candidate_fix_accepted)
			l_h_box.disable_item_expand (evtoggle_show_candidate_fix_accepted)

			create l_separator
			l_h_box.extend (l_separator)
			l_h_box.disable_item_expand (l_separator)

			l_h_box.extend (evtoggle_show_manually_fixed)
			l_h_box.disable_item_expand (evtoggle_show_manually_fixed)

			extend (l_h_box)
			disable_item_expand (l_h_box)

			create l_h_box
			l_h_box.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			create evgrid_faults
			l_grid := evgrid_faults
			l_grid.enable_row_separators
			l_grid.enable_single_row_selection
--			l_grid.enable_column_separators
			l_grid.set_column_count_to (Last_column)
			l_col := l_grid.column (1)
			l_col.set_width (0)
			l_col := l_grid.column (column_class_and_feature_under_test)
			l_col.set_title (grid_column_text_class_and_feature_under_test)
			l_col.set_width (100)
			l_col := l_grid.column (column_fault)
			l_col.set_title (grid_column_text_fault)
			l_col.set_width (200)
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
				-- Right align
			create l_label.make_with_text("")
			l_h_box.extend (l_label)
			create evbutton_fix_all_to_be_attempted.make_with_text (Button_text_fix_all)
			create evbutton_fix_selected.make_with_text (button_text_fix_selected)
			l_h_box.extend (evbutton_fix_all_to_be_attempted)
			l_h_box.disable_item_expand (evbutton_fix_all_to_be_attempted)
			l_h_box.extend (evbutton_fix_selected)
			l_h_box.disable_item_expand (evbutton_fix_selected)
			extend (l_h_box)
			disable_item_expand (l_h_box)

		end

feature{NONE} -- Implementation

	internal_grid_wrapper: EVS_GRID_WRAPPER [EV_GRID_ROW]

	grid_wrapper: EVS_GRID_WRAPPER [EV_GRID_ROW]
			--
		do
			if internal_grid_wrapper = Void then
				create internal_grid_wrapper.make (evgrid_faults)
			end
			Result := internal_grid_wrapper
		end

	enable_sorting
			-- Copied from ES_BREAKPOINTS_TOOL_PANEL.enable_sorting.
		local
			l_wrapper: like grid_wrapper
			l_sort_info: EVS_GRID_TWO_WAY_SORTING_INFO [EV_GRID_ROW]
			l_column: EV_GRID_COLUMN
		do
			l_wrapper := grid_wrapper
			l_wrapper.enable_auto_sort_order_change
			if l_wrapper.sort_action = Void then
				l_wrapper.set_sort_action (agent sort_handler)
			end

				-- Fake sorting routine.
				-- Sorting is handled by 'sort_handler'.
			create l_sort_info.make (agent (a_row, a_other_row: EV_GRID_ROW; a_order: INTEGER): BOOLEAN do Result := False end, {EVS_GRID_TWO_WAY_SORTING_ORDER}.descending_order)
			l_sort_info.enable_auto_indicator

			l_wrapper.set_sort_info (column_class_and_feature_under_test, l_sort_info)
			l_wrapper.set_sort_info (column_fault, l_sort_info)
			l_wrapper.set_sort_info (column_passing, l_sort_info)
			l_wrapper.set_sort_info (column_failing, l_sort_info)
			l_wrapper.set_sort_info (column_status, l_sort_info)
		end

	disable_sorting
			--
		local
			l_wrapper: like grid_wrapper
		do
			l_wrapper := internal_grid_wrapper
			if l_wrapper /= Void then
				l_wrapper.wipe_out_sorted_columns
				l_wrapper.disable_auto_sort_order_change
				l_wrapper.set_sort_action (Void)
				internal_grid_wrapper := Void
			end

		end

	sort_handler (a_column_list: LIST [INTEGER_32]; a_comparator: AGENT_LIST_COMPARATOR [EV_GRID_ROW])
			--
		local
			l_style: EV_POINTER_STYLE
		do
			l_style := pointer_style
			set_pointer_style ((create {EV_STOCK_PIXMAPS}).busy_cursor)

			populate_grid

			set_pointer_style (l_style)
		end

	has_no_fault: BOOLEAN
			--
		deferred
		end

	populate_grid
			--
		deferred
		end

feature -- Status report

    is_initializing: BOOLEAN
            -- Indicates if the user interface is currently being initialized

feature{NONE} -- GUI elements

	evbutton_fix_all_to_be_attempted: EV_BUTTON

	evbutton_fix_selected: EV_BUTTON

	evtoggle_show_candidate_fix_accepted: EV_TOGGLE_BUTTON

	evtoggle_show_manually_fixed: EV_TOGGLE_BUTTON

	evtoggle_show_to_be_attempted: EV_TOGGLE_BUTTON

	evtoggle_show_candidate_fix_available: EV_TOGGLE_BUTTON

	evtoggle_show_candidate_fix_unavailable: EV_TOGGLE_BUTTON

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
