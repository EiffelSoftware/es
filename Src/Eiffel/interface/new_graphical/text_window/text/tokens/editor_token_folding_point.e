indexing
	description: "items inside the folding-area part of the clickable margin, used for toggling the folding of features"
	author: "bherlig"
	date: "$06/18/2006$"
	revision: "$0.5$"

class
	EDITOR_TOKEN_FOLDING_POINT

inherit
	EDITOR_TOKEN_MARGIN
		undefine
			max_color_id
		redefine
			update_position,
			editor_preferences
		end

	EB_CONSTANTS
		rename
			Pixmaps as Shared_pixmaps
		end

	EB_SHARED_DEBUG_TOOLS

	EB_EDITOR_TOKEN_IDS

create
	make_with_folding_area

feature -- Initialization

	make_with_folding_area (a_area: like folding_area) is
			-- creates a new folding-point token with associated folding-area
		require
			area_exists: folding_area /= Void
		do
			image := ""
			length := 0
			width := 8
			folding_area := a_area
			pixmap.pointer_button_press_actions.extend (agent on_mouse_button_down)
		ensure
			folding_area = a_area
		end


feature -- Access

	folding_area: EB_FOLDING_AREA
		-- associated folding area

feature -- folding

	on_mouse_button_down (abs_x_pos, y_pos, button: INTEGER; unused1,unused2,unused3: DOUBLE; a_screen_x, a_screen_y: INTEGER) is
			-- Process single click on mouse buttons.			
		do
--			if button = 1 then
				if folding_area.hidden then
					folding_area.show
				else
					folding_area.hide
				end

				io.put_string("folding-point on line " + folding_area.start_line.out + " was clicked!%N")
--			end
		end

	on_click is
			-- the fp was clicked
		do
			io.put_string("folding-point on line " + folding_area.start_line.out + " was clicked!%N")
		end



feature -- Width & height

	width: INTEGER
			-- Width in pixel of the entire token.
			-- The width is equal to the pixmap width since this token is not
			-- a real text token.

	get_substring_width (n: INTEGER): INTEGER is
			-- Conpute the width in pixels of the first
			-- `n' characters of the current string.
		do
			Result := 0
		end

	retrieve_position_by_width (a_width: INTEGER): INTEGER is
			-- Return the character situated under the `a_width'-th
			-- pixel.
		do
			Result := 1
		end

feature -- Miscellaneous

	update_position is
			-- Update the value of `position' to its correct value
		do
				-- Update current position
			position := 0

				-- Update position of linked tokens
			if next /= Void then
				next.update_position
			end
		end

	display (d_y: INTEGER; device: EV_DRAWABLE; panel: TEXT_PANEL) is
		do
		end

	display_with_offset (x_offset, d_y: INTEGER; device: EV_DRAWABLE; panel: TEXT_PANEL) is
			-- Display the current token on device context `dc' at the coordinates (`position + x_offset',`d_y')
		do
			update_width
			if panel.text_is_fully_loaded then
				device.draw_pixmap (x_offset, d_y, pixmap)
			end
		end

	hide is
			-- Hide Current
		do
			width := 0
		end

	pixmap: EV_PIXMAP is
			-- Graphical representation of the breakable mark.
			-- 10 different representations whether the breakpoint
			-- is enabled, disabled or not set , whether it has a condition or not,
			-- and whether the application is stopped at this point or not.
		local
			pixmaps: ARRAY [EV_PIXMAP]
			index: INTEGER 	-- index in the pixmap array.
		do
			pixmaps := icons.icon_group_fp

			if folding_area.hidden then
				index := 1
			else
				index := 2
			end

			Result := pixmaps.item (index)
		end


	editor_preferences: EB_EDITOR_DATA is
			--
		once
			Result ?= editor_preferences_cell.item
		end

feature -- Visitor

	process (a_visitor: EIFFEL_TOKEN_VISITOR) is
			-- Visitor
		do
			a_visitor.process_editor_token_folding_point (Current)
		end

feature {MARGIN_WIDGET} -- Implementation

	icons: EB_SHARED_PIXMAPS_8 is
			-- Breakpoint icon resources
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

invariant
--		breakpoint_is_first: previous = Void

end -- class EDITOR_TOKEN_FOLDING_POINT
