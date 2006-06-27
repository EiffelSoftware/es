indexing
	description: "Margin for use in clickable editor.  Unlike EB_MARGIN this can deal with mouse clicks and breakpoints."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CLICKABLE_MARGIN

inherit
	MARGIN_WIDGET
		redefine
			update_lines,
			draw_line_to_screen,
			text_panel,
			line_numbers_visible,
			user_initialization,
			width,
			text_displayed_type
		end

feature -- Initialization

	user_initialization is
			-- Build margin drawable area
		do
			Precursor {MARGIN_WIDGET}
			margin_area.pointer_button_press_actions.extend (agent on_mouse_button_down)
			hide_breakpoints
		end

feature -- Graphical Interface

	text_panel: EB_CLICKABLE_EDITOR
			-- The text panel/editor to which Current is anchored

feature -- Status Setting

	hide_breakpoints is
			-- Do not show breakpoints even if there are some.
		do
			hidden_breakpoints := True
		end

	show_breakpoints is
			-- Show breakpoints if there are some.
		do
			hidden_breakpoints := False
		end

feature -- Access

	width: INTEGER is
			-- Width in pixels calculated based on which tokens should be displayed
		local
			l_bptok: EDITOR_TOKEN_BREAKPOINT
		do
		    Result := Precursor
			if not hidden_breakpoints then
				create l_bptok.make
				Result := Result + l_bptok.width + separator_width
			end

			smart_text_panel ?= text_panel
			if smart_text_panel /= Void and then folding_points_visible then
				-- folding-points have a pixmap of 8px width
				Result := Result + separator_width + 8 + separator_width
			end
		end

	hidden_breakpoints: BOOLEAN
			-- Are breakpoints hidden? (Default: True)	

feature -- Query

	line_numbers_visible: BOOLEAN is
			-- Are line numbers hidden?
		do
		    Result := Precursor
		end

	folding_points_visible: BOOLEAN is
			-- Are folding_points displayed?
		do
		    Result := (hidden_breakpoints and then text_panel.folding_points_visible)
		end

feature {NONE} -- Implementation

	next_folding_area: EB_FOLDING_AREA
			-- the next area to display

	draw_next_folding_point: BOOLEAN
			-- indicates if the next line to process contains a folding-point

	update_lines (first, last: INTEGER; buffered: BOOLEAN) is
			-- Update the lines from `first' to `last'.  If `buffered' then draw to `buffered_line'
 			-- before drawing to screen, otherwise draw straight to screen.
		local
 			curr_line,
 			y_offset,
 			l_line_height: INTEGER
 			l_text_displayed: like text_displayed_type
 			move_x_lines: INTEGER
		do
			updating_line := True
			l_text_displayed := text_panel.text_displayed
			l_text_displayed.go_i_th (first)
			l_line_height := text_panel.line_height

			-- get the next folding-point line
			if folding_points_visible then
				smart_text_panel ?= text_panel
				if smart_text_panel /= Void and then smart_text_panel.folding_areas /= Void then
				-- we are inside the main code-editor and have to show folding-areas

					-- search for the next folding-area containing 'first'
					next_folding_area := smart_text_panel.folding_areas.first_item_after_line (first)

					if next_folding_area /= Void and then next_folding_area.previous /= Void then
						next_folding_area := next_folding_area.previous
					end

					debug("code-folding:")
						if next_folding_area /= Void then
							io.put_string("first:%T" + first.out + "%Nlast:%T" + last.out + "%N%Tnext fp is on line " + next_folding_area.start_line.out + "%N%N")
						end
					end
				end
			end


			from
 				curr_line := first
 				draw_next_folding_point := false
 				y_offset := margin_viewport.y_offset + ((curr_line - first_line_displayed) * l_line_height)
 			until
 				curr_line > last or else l_text_displayed.after
 				--l_text_displayed.after
 			loop
 				move_x_lines := 1
 				if buffered then
 					-- We do not currently buffer for the margin
				else
					-- did we arrive at the next fp?
					if folding_points_visible then
						if next_folding_area /= Void then -- and then curr_line = next_folding_area.start_line then
							debug ("code-folding:")
								io.putstring("feature on line " + next_folding_area.start_line.out + "has height: " + next_folding_area.height.out + "%N")
							end

							from
							until next_folding_area = Void or else next_folding_area.end_line >= curr_line
							loop next_folding_area := next_folding_area.next
							end

							if next_folding_area /= Void and then (next_folding_area.hidden or (not next_folding_area.hidden and next_folding_area.height > 0)) and then (curr_line >= next_folding_area.start_line and curr_line <= next_folding_area.end_line) then
								draw_next_folding_point := true
							else
								draw_next_folding_point := false
							end

							-- if hidden advance x lines where x = height of folding-area
--							if next_folding_area.hidden and then curr_line = next_folding_area.start_line then
--								move_x_lines := next_folding_area.height
--							end

						end
					end
					draw_line_to_screen (0, y_offset, l_text_displayed.line (curr_line), curr_line)
				end


 				curr_line := curr_line + 1
--				curr_line := curr_line + move_x_lines

				y_offset := y_offset + l_line_height
 				l_text_displayed.forth
 			end
 			updating_line := False
		end

	draw_line_to_screen (x, y: INTEGER; a_line: EIFFEL_EDITOR_LINE; xline: INTEGER) is
			-- Update display by drawing `line' onto the `editor_drawing_area' directly at co-ordinates x,y.
		local
 			curr_token	: EDITOR_TOKEN
 			line_token  : EDITOR_TOKEN_LINE_NUMBER
 			bp_token: EDITOR_TOKEN_BREAKPOINT
 			fp_token: EDITOR_TOKEN_FOLDING_POINT
 			fp_offset: INTEGER
 			spacer_text: STRING
 			max_chars: INTEGER
 		do
 			if text_panel.text_displayed.number_of_lines > 99999 then
	 			max_chars := text_panel.number_of_lines.out.count
 			else
	 			max_chars := default_width
 			end
 			create spacer_text.make_filled ('0', max_chars - xline.out.count)

 				-- Set the correct image for line number
 			line_token ?= a_line.number_token
			if line_token /= Void then
				line_token.set_internal_image (spacer_text + xline.out)
			end

  			from
					-- Display the first applicable token in the margin
				a_line.start
				curr_token := a_line.item
				margin_area.set_background_color (editor_preferences.margin_background_color)
				debug ("editor")
					draw_flash (x, y, width, text_panel.line_height, False)
				end
				margin_area.clear_rectangle (
						x,
						y,
						width,
						text_panel.line_height
					)
 			until
 				a_line.after or else not curr_token.is_margin_token
 			loop
				if curr_token.is_margin_token then
					bp_token ?= curr_token
					if bp_token /= Void and then not hidden_breakpoints then
						bp_token.display (y, margin_area, text_panel)
						fp_offset := bp_token.width
					elseif bp_token /= Void then
						bp_token.hide
					else
						line_token ?= curr_token
						if line_token /= Void and then line_numbers_visible then
							if not hidden_breakpoints then
								line_token.display_with_offset (a_line.breakpoint_token.width, y, margin_area, text_panel)
							else
								line_token.display (y, margin_area, text_panel)
							end
							fp_offset := fp_offset + line_token.width
						elseif line_token /= Void then
							line_token.hide
						end
					end
				end
				a_line.forth
				curr_token := a_line.item
			end

			-- folding-point
			if folding_points_visible and then draw_next_folding_point then
				create fp_token.make_with_folding_area (next_folding_area, xline)
				fp_token.display_with_offset (fp_offset + separator_width, y + ((text_panel.line_height - 8) / 2).ceiling, margin_area, text_panel)
				if xline >= next_folding_area.end_line or next_folding_area.hidden then
					-- advance to the next folding-area
					next_folding_area := next_folding_area.next
					draw_next_folding_point := false
				end

			elseif (fp_token /= Void) then
				fp_token.hide
			end

			margin_area.set_background_color (separator_color)
			margin_area.clear_rectangle (width - separator_width, y, separator_width, editor_preferences.line_height)
			margin_area.set_background_color (editor_preferences.margin_background_color)
		end

feature {NONE} -- Events

	on_mouse_button_down (abs_x_pos, y_pos, button: INTEGER; unused1,unused2,unused3: DOUBLE; a_screen_x, a_screen_y: INTEGER) is
			-- Process single click on mouse buttons.			
		local
			ln: EIFFEL_EDITOR_LINE
			l_number: INTEGER
			bkstn: BREAKABLE_STONE
			x_offset: INTEGER
			ln_token: EDITOR_TOKEN_LINE_NUMBER
			fp_clicked: EB_FOLDING_AREA
			num_lines: INTEGER
		do
			if button = 1 then
				l_number := (y_pos - margin_viewport.y_offset + (first_line_displayed * text_panel.line_height)) // text_panel.line_height

				if l_number <= text_panel.number_of_lines then
					ln ?= text_panel.text_displayed.line (l_number)
					bkstn ?= ln.real_first_token.pebble

					if not hidden_breakpoints then
						x_offset := x_offset + (create {EDITOR_TOKEN_BREAKPOINT}.make).width
					end

					if line_numbers_visible then
						ln_token ?= ln.real_first_token.next
						if ln_token /= Void then
							x_offset := x_offset + ln_token.width
						end
					end

					if abs_x_pos < x_offset then
						-- click onto line-numbers or breakpoints			
						if bkstn /= Void then
							bkstn.toggle_bkpt
						end
					else
						-- click onto folding_area
						smart_text_panel ?= text_panel
						if smart_text_panel /= Void and then smart_text_panel.folding_areas /= Void then
							fp_clicked := smart_text_panel.folding_areas.item_with_line (l_number)
							if fp_clicked /= Void then
								num_lines := fp_clicked.height
								if fp_clicked.hidden then
									fp_clicked.show
									smart_text_panel.text_displayed.show_lines (fp_clicked.start_line)
									sync_folding_areas(fp_clicked, num_lines, true)
								else
									fp_clicked.hide
									smart_text_panel.text_displayed.hide_lines (fp_clicked.start_line + 1, fp_clicked.height)
									sync_folding_areas(fp_clicked, num_lines, false)
								end
							end
						end

					end
					text_panel.on_mouse_button_down (abs_x_pos, y_pos, 1, 0, 0, 0, a_screen_x, a_screen_y)
					current.refresh_now
				end
			elseif button = 3 then
				if not text_panel.text_displayed.is_empty then
					text_panel.on_click_in_text (abs_x_pos - width, y_pos, 3, a_screen_x, a_screen_y)
				end
			end
		end

feature -- Folding

	sync_folding_areas(a_area: like next_folding_area; nb_lines: INTEGER; addition: BOOLEAN) is
			-- syncs all folding areas to proper begin/end values
			-- NOTE: ugly hack... sorry 'bout that
		local
			f_area: like a_area
		do
			from f_area := a_area.next
			until f_area = Void
			loop
				if addition then
					f_area.set_start_line (f_area.start_line + nb_lines)
                  	f_area.set_end_line (f_area.end_line + nb_lines)
				else
					f_area.set_start_line (f_area.start_line - nb_lines)
                  	f_area.set_end_line (f_area.end_line - nb_lines)
				end
				f_area := f_area.next
			end
		end

feature {NONE} -- Implementation
	smart_text_panel: EB_SMART_EDITOR
		-- used for dynamic-binding checking if the current margin is shown inside the main editor

	text_displayed_type: CLICKABLE_TEXT is
			-- Type of `text_panel.text_displayed'.
		do
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_CLICKABLE_MARGIN
