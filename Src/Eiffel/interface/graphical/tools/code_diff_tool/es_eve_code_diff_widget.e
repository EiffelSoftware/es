note
	description: "Code diff tool GUI widget"

class
	ES_EVE_CODE_DIFF_WIDGET

inherit
	EV_FRAME
		redefine
			initialize,
			is_in_default_state
		end

create
	make

feature{NONE} -- Initialization

	make (a_title, a_base_label, a_diff_label: STRING; a_panel: ES_EVE_AUTOFIX_TOOL_PANEL)
			-- Initialization
		require
			title_not_empty: a_title /= Void and then not a_title.is_empty
			base_label_attached: a_base_label /= Void
			diff_label_attached: a_diff_label /= Void
		do
			title := a_title.twin
			base_code_label_text := a_base_label.twin
			diff_code_label_text := a_diff_label.twin
			panel := a_panel
			create difference_background_color.make_with_8_bit_rgb (255, 255, 0)

			default_create
		ensure
			title_set: title /= Void and then title ~ a_title
			base_label_set: base_code_label /= Void and then base_code_label.text ~ a_base_label
			diff_label_set: diff_code_label /= Void and then diff_code_label.text ~ a_diff_label
			base_text_editor_attached: base_text_editor /= Void
			diff_text_editor_attached: diff_text_editor /= Void
		end

	initialize
			-- <Precursor>
		local
			l_horizontal_box: EV_HORIZONTAL_BOX
			l_vertical_box: EV_VERTICAL_BOX
		do
			set_text (title)
			create l_horizontal_box
			l_horizontal_box.set_padding_width (3)
			l_horizontal_box.set_border_width (3)

			create l_vertical_box
			l_vertical_box.set_padding_width (3)
			l_vertical_box.set_border_width (3)
			create base_code_label.make_with_text (base_code_label_text)
			l_vertical_box.extend (base_code_label)
			l_vertical_box.disable_item_expand (base_code_label)
			create base_text_editor.make (panel.develop_window)
			base_text_editor.disable_editable
			base_text_editor.widget.set_background_color (l_vertical_box.background_color)
			base_text_editor.widget.set_border_width (1)
			l_vertical_box.extend (base_text_editor.widget)
			l_horizontal_box.extend (l_vertical_box)

			create l_vertical_box
			l_vertical_box.set_padding_width (3)
			l_vertical_box.set_border_width (3)
			create diff_code_label.make_with_text (diff_code_label_text)
			l_vertical_box.extend (diff_code_label)
			l_vertical_box.disable_item_expand (diff_code_label)
			create diff_text_editor.make (panel.develop_window)
			diff_text_editor.disable_editable
			diff_text_editor.widget.set_background_color (l_vertical_box.background_color)
			diff_text_editor.widget.set_border_width (1)
			l_vertical_box.extend (diff_text_editor.widget)
			l_horizontal_box.extend (l_vertical_box)

			extend (l_horizontal_box)
			Precursor {EV_FRAME}
		end

feature -- Data model

	hunk: ES_EVE_CODE_DIFF_HUNK assign set_hunk
			-- The hunk associated with the widget.

feature -- Status set

	set_hunk (a_hunk: ES_EVE_CODE_DIFF_HUNK)
			-- Set `hunk' with `a_hunk'.
		do
			hunk := a_hunk
			update_view
		ensure
			hunk_set: hunk = a_hunk
		end

feature {NONE} -- GUI elements

	panel: ES_EVE_AUTOFIX_TOOL_PANEL
			-- AutoFix tool panel.

	base_code_label: EV_LABEL
			-- Label for the base code.

	diff_code_label: EV_LABEL
			-- Label for the diff code.

	base_text_editor: EB_SMART_EDITOR
			-- Rich text control for the base code.

	diff_text_editor: EB_SMART_EDITOR
			-- Rich text control for the diff code.

feature {NONE} -- GUI texts

	title: STRING
			-- Title of the widget.

	base_code_label_text: STRING

	diff_code_label_text: STRING

	difference_background_color: EV_COLOR
			-- Background color of the differences.

feature {NONE} -- Implementation

	update_view
			-- Update the widget view to reflect `hunk'.
		local
			l_segs: LINKED_LIST [TUPLE[start: INTEGER; finish: INTEGER]]
			l_cur_line, l_start_line, l_finish_line: INTEGER
			l_start_pos, l_finish_pos: INTEGER
			l_character_format: EV_CHARACTER_FORMAT
			l_format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION
			l_stone: FEATURE_STONE
		do
			if hunk = Void then
				base_text_editor.load_text ("")
				diff_text_editor.load_text ("")
			else
				base_text_editor.text_displayed.set_feature_for_click (hunk.context_feature.e_feature.written_feature)
				base_text_editor.text_displayed.enable_feature_click
				create l_stone.make (hunk.context_feature.e_feature.written_feature)
				base_text_editor.set_stone (l_stone)
				base_text_editor.load_text (hunk.base_code_with_padding)

					-- Regular text
				diff_text_editor.text_displayed.set_feature_for_click (hunk.context_feature.e_feature.written_feature)
				diff_text_editor.text_displayed.enable_feature_click
				create l_stone.make (hunk.context_feature.e_feature.written_feature)
				diff_text_editor.set_stone (l_stone)
				diff_text_editor.load_text (hunk.diff_code_with_padding)

					-- Difference in highlight
				l_character_format := highlighting_format.character_format
				l_format_range := highlighting_format.format_range
				l_segs := hunk.different_line_segments
				from l_segs.start
				until l_segs.after
				loop
					l_start_line := l_segs.item_for_iteration.start
					l_finish_line := l_segs.item_for_iteration.finish

					from l_cur_line := l_start_line
					until l_cur_line >= l_finish_line
					loop
							-- Highlight the fix.
						diff_text_editor.select_lines (l_cur_line, l_cur_line)
						diff_text_editor.text_displayed.selection_start.line.content.do_all (agent {EDITOR_TOKEN}.set_background_color (difference_background_color))

						l_cur_line := l_cur_line + 1
					end
					diff_text_editor.deselect_all

					l_segs.forth
				end
			end
		end

	highlighting_format: TUPLE[character_format: EV_CHARACTER_FORMAT; format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION]
			-- Objects used for highlighting code differences.
		local
			l_character_format: EV_CHARACTER_FORMAT
			l_font: EV_FONT
			l_background_color: EV_COLOR
			l_format_range: EV_CHARACTER_FORMAT_RANGE_INFORMATION
		once
			l_font := base_text_editor.font
			create l_font.make_with_values (l_font.family, {EV_FONT_CONSTANTS}.Weight_bold, l_font.shape, l_font.height)
			create l_character_format.make_with_font (l_font)
			create l_background_color.make_with_8_bit_rgb (255, 255, 0)
			l_character_format.set_background_color (l_background_color)
			create l_format_range.make_with_flags ({EV_CHARACTER_FORMAT_CONSTANTS}.background_color | {EV_CHARACTER_FORMAT_CONSTANTS}.font_weight)
			Result := [l_character_format, l_format_range]
		end

feature {NONE} -- Contract support

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
			-- (export status {NONE})
		do
			Result := True
		end


note
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
