note
	description: "Summary description for {ES_ADB_PANEL_FIXES_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_PANEL_FIXES_IMP

inherit
	EV_HORIZONTAL_BOX
		redefine
			initialize
		end

	ES_ADB_PANEL_ABSTRACT

	ES_ADB_INTERFACE_STRINGS

feature{NONE} -- Initialization

	initialize
			-- <Precursor>
		local
			l_grid: EV_GRID
			l_col: EV_GRID_COLUMN
			l_frame: EV_FRAME
			l_v_box: EV_VERTICAL_BOX
			l_h_box: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
			l_h_padding, l_v_padding: INTEGER
			l_split: EV_HORIZONTAL_SPLIT_AREA
		do
			Precursor{EV_HORIZONTAL_BOX}
			l_h_padding := {ES_UI_CONSTANTS}.horizontal_padding
			l_v_padding := {ES_UI_CONSTANTS}.vertical_padding
			set_padding (l_h_padding)

			create l_split
			extend (l_split)

			create l_h_box
			l_h_box.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			create evgrid_fixes
			evgrid_fixes.set_minimum_width (670)
			l_grid := evgrid_fixes
			l_grid.enable_row_separators
			l_grid.enable_single_row_selection
			l_grid.set_column_count_to (Last_column)
			l_col := l_grid.column (1)
			l_col.set_width (0)
			l_col := l_grid.column (Column_fault)
			l_col.set_title (Grid_column_text_fault)
			l_col.set_width (200)
			l_col := l_grid.column (Column_type)
			l_col.set_title (Grid_column_text_type)
			l_col.set_width (150)
			l_col := l_grid.column (Column_nature)
			l_col.set_title (Grid_column_text_nature)
			l_col.set_width (150)
--			l_col := l_grid.column (Column_is_proper)
--			l_col.set_title (Grid_column_text_is_proper)
--			l_col.set_width (100)
			l_col := l_grid.column (Column_status)
			l_col.set_title (Grid_column_text_status)
			l_col.set_width (70)
			l_grid.enable_tree
			l_grid.enable_row_height_fixed
			l_h_box.extend (l_grid)
			l_split.set_first (l_h_box)

			create l_v_box
			l_v_box.set_padding (l_v_padding)
			create l_h_box
			create l_label.make_with_text (Label_text_before_fix)
			l_h_box.extend (l_label)
			create l_label.make_with_text (Label_text_after_fix)
			l_h_box.extend (l_label)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)
			create l_h_box
			l_h_box.set_padding (l_h_padding)
			create ebsmart_source.make (tool_panel.develop_window)
			ebsmart_source.disable_editable
			ebsmart_source.disable_line_numbers
			ebsmart_source.set_read_only (True)
			ebsmart_source.widget.set_background_color (l_h_box.background_color)
--			create ebsmart_source
--			ebsmart_source.disable_edit
--			ebsmart_source.set_background_color (l_h_box.background_color)
			ebsmart_source.widget.set_border_width (1)
			l_h_box.extend (ebsmart_source.widget)
			create ebsmart_target.make (tool_panel.develop_window)
			ebsmart_target.disable_editable
			ebsmart_target.disable_line_numbers
			ebsmart_target.set_read_only (True)
			ebsmart_target.widget.set_background_color (l_h_box.background_color)
			ebsmart_target.widget.set_border_width (1)
			l_h_box.extend (ebsmart_target.widget)
			l_v_box.extend (l_h_box)
			create l_h_box
			create l_label.make_with_text ("")
			l_h_box.extend (l_label)
			create evbutton_apply.make_with_text (Button_text_apply)
			evbutton_apply.set_minimum_width (80)
			l_h_box.extend (evbutton_apply)
			l_h_box.disable_item_expand (evbutton_apply)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)
			create l_frame.make_with_text (Frame_text_fix)
			l_frame.set_minimum_width (300)
			l_frame.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			l_frame.extend (l_v_box)
			l_split.set_second (l_frame)
		end

feature -- GUI elements

	evgrid_fixes: EV_GRID

	ebsmart_source: EB_SMART_EDITOR
--	ebsmart_source: EV_RICH_TEXT

	ebsmart_target: EB_SMART_EDITOR
--	ebsmart_target: EV_RICH_TEXT

	evbutton_apply: EV_BUTTON

feature -- Constant

	Column_fault: INTEGER = 2
	Column_type: INTEGER = 3
	Column_nature: INTEGER = 4
--	Column_is_proper: INTEGER = 5
	Column_status: INTEGER = 5
	Last_column: INTEGER = 5

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
