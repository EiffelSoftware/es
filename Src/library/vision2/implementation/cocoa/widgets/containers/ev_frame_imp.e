note
	description: "Eiffel Vision frame. Cocoa implementation"
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FRAME_IMP

inherit
	EV_FRAME_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CELL_IMP
		redefine
			interface,
			make,
			insert,
			set_background_color
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			make
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			make,
			set_text
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			a_font: EV_FONT
		do
			create box.make
			create content_view.make
			box.set_translates_autoresizing_mask_into_constraints_ (False)
			box.set_content_view_ (content_view)
			create color_utils
			-- NSNoTitle = 0
			box.set_title_position_ (0)

			cocoa_view := box

			align_text_left
			create a_font.default_create
			a_font.set_height (10)
			set_font (a_font)
			set_is_initialized (True)
			style := {EV_FRAME_CONSTANTS}.Ev_frame_etched_in
			initialize
		end

feature -- Access

	style: INTEGER
			-- Visual appearance. See: EV_FRAME_CONSTANTS.

feature -- Element change

	insert (v: like item)
			-- Assign `v' to `item'.
		require else
			v_not_void: v /= Void
			has_no_item: item = Void
		do
			v.implementation.on_parented
			check attached {EV_WIDGET_IMP} v.implementation as v_imp then
				v_imp.set_parent_imp (Current)
				item := v
				new_item_actions.call ([v])
				content_view.add_subview_ (v_imp.attached_view)
				v_imp.set_padding_constraints (0)
			end
		end

	set_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'
		local
			color: NS_COLOR
		do
			-- Note: works only if box.box_type = NSBoxCustom (4) and box.border_type = NSLineBorder (1)
			Precursor {EV_CELL_IMP} (a_color)
			color := color_utils.color_with_calibrated_red__green__blue__alpha_ (a_color.red.to_double, a_color.green.to_double, a_color.blue.to_double, 1.0)
			box.set_fill_color_ (color)
		end

	set_style (a_style: INTEGER)
			-- Assign `a_style' to `style'.
		do
			if a_style = {EV_FRAME_CONSTANTS}.Ev_frame_lowered or a_style = {EV_FRAME_CONSTANTS}.Ev_frame_etched_in then
				-- NSBezelBorder = 2
				box.set_border_type_ (2)
			else
				-- NSGrooveBorder = 3
				box.set_border_type_ (3)
			end
			style := a_style
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			Precursor {EV_TEXTABLE_IMP} (a_text)
			if a_text /= Void and then not a_text.is_empty then
				-- NSAtTop = 2
				box.set_title_position_ (2)
				box.set_title_ (create {NS_STRING}.make_with_eiffel_string (a_text.as_string_8))
			else
				-- NSNoTitle = 0
				box.set_title_position_ (0)
			end
		end

	set_border_width (value: INTEGER)
			-- Make `value' the new border width of `Current'.
		do
			border_width := value
		end

feature -- Layout

	client_x: INTEGER = 14;

	client_y: INTEGER
		do
			-- NSNoTitle = 0
			if box.title_position = 0 then
				Result := 14
			else
				Result := 18
			end
		end

feature {NONE} -- Implementation

	box: NS_BOX

	content_view: EV_FLIPPED_VIEW

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_FRAME note option: stable attribute end;
			-- Provides a common user interface to possibly platform
			-- dependent functionality implemented by `Current'

end -- class EV_FRAME_IMP
