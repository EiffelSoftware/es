note
	description: "[
		Widget which is a combination of an EV_TREE and an EV_MULTI_COLUMN_LIST.
		Cocoa implementation.
			]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_GRID_IMP

inherit
	EV_GRID_I
		undefine
			propagate_background_color,
			propagate_foreground_color
		redefine
			initialize_grid,
			interface,
			make
		end

	EV_CELL_IMP
		rename
			item as cell_item
		undefine
			drop_actions,
			has_focus,
			set_focus,
			set_pebble,
			set_pebble_function,
			conforming_pick_actions,
			pick_actions,
			pick_ended_actions,
			set_accept_cursor,
			set_deny_cursor,
			enable_capture,
			disable_capture,
			has_capture,
			set_default_colors,
			set_default_key_processing_handler,
			set_pick_and_drop_mode,
			set_drag_and_drop_mode,
			set_target_menu_mode,
			set_configurable_target_menu_mode,
			set_configurable_target_menu_handler,
			tooltip,
			set_tooltip
		redefine
			interface,
			make,
			old_make,
			set_background_color,
			set_foreground_color
		end

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: like interface)
			-- Create grid
		do
			assign_interface (an_interface)
		end

	make
			-- Initialize `Current'
		do
			create focused_selection_color.make_with_rgb (1, 0, 0)
			create non_focused_selection_color.make_with_rgb (0.266667, 0.592157, 0.874510)

			create focused_selection_text_color.make_with_rgb (0, 1, 0)
			create non_focused_selection_text_color.make_with_rgb (1, 1, 1)

			create {EV_FLIPPED_VIEW}cocoa_view.make
			cocoa_view.set_translates_autoresizing_mask_into_constraints_ (False)
			initialize_grid

			set_is_initialized (True)
		end

feature {EV_GRID_LOCKED_I} -- Drawing implementation

	initialize_grid
		local
			l_constraint_utils: NS_LAYOUT_CONSTRAINT_UTILS
			v_imp: EV_VIEWPORT_IMP
		do
			Precursor
			v_imp ?= viewport.implementation
			check v_imp /= Void end
			create l_constraint_utils
			if attached v_imp.clip_view.superview.superview as l_superview then
				-- Set the viewport size to be equal to the static_fixed_viewport size
				if attached {NS_LAYOUT_CONSTRAINT}l_constraint_utils.constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_ (v_imp.clip_view, 7, 0, l_superview, 7, 1.0, 0) as l_constraint then
					l_superview.add_constraint_ (l_constraint)
				end
				if attached {NS_LAYOUT_CONSTRAINT}l_constraint_utils.constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_ (v_imp.clip_view, 8, 0, l_superview, 8, 1.0, 0) as l_constraint then
					l_superview.add_constraint_ (l_constraint)
				end
			end
			if attached {EV_HORIZONTAL_BOX_IMP} item_imp as l_box then
				if attached {EV_VERTICAL_BOX_IMP} l_box.i_th (1).implementation as l_vertical_box then
					-- Fix header height to 17 pixels
					check attached {EV_WIDGET_IMP} l_vertical_box.i_th (1).implementation as l_header then
						l_header.set_fixed_height(17)
					end
				end
			end
			if attached {EV_CELL_IMP} scroll_bar_spacer.implementation as l_cell then
				l_cell.set_fixed_height (15)
			end
		end

feature -- Element change

	set_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'
		do
			Precursor {EV_CELL_IMP} (a_color)
			check attached {EV_FLIPPED_VIEW} attached_view as l_view then
				l_view.set_cocoa_background_color (a_color)
			end
			redraw_client_area
		end

	set_foreground_color (a_color: EV_COLOR)
			-- Assign `a_color' to `foreground_color'
		do
			Precursor {EV_CELL_IMP} (a_color)
			redraw_client_area
		end

feature {EV_GRID_ITEM_I} -- Implementation

	string_size (a_string: READABLE_STRING_GENERAL; a_font: EV_FONT; tuple: TUPLE [INTEGER, INTEGER])
			-- `Result' contains width and height required to
			-- fully display string `s' in font `f'.
			-- This should be used instead of `string_size' from EV_FONT
			-- as we can perform an optimized implementation which does
			-- not include the horizontal overhang or underhang. This can
			-- make quite a difference on certain platforms.
		local
			l_font_imp: detachable EV_FONT_IMP
			l_string: NS_STRING
			l_string_drawing: NS_STRING_DRAWING_CAT
			l_attributes: NS_MUTABLE_DICTIONARY
			l_size: NS_SIZE
		do
			if a_string.is_empty then
				tuple.put_integer (0, 1)
				tuple.put_integer (0, 2)
			else
				l_font_imp ?= a_font.implementation
				check l_font_imp /= void end
				create l_string.make_with_eiffel_string (a_string.as_string_8)
				create l_attributes.make
				l_attributes.set_object__for_key_ (l_font_imp.font, create {NS_STRING}.make_with_eiffel_string ("NSFont"))
				create l_attributes.make
				create l_string_drawing
				l_size := l_string_drawing.size_with_attributes_ (l_string, l_attributes)

				tuple.put_integer (l_size.width.rounded, 1)
				tuple.put_integer (l_size.height.rounded, 2)
			end
		end

	color_from_state (style_type, a_state: INTEGER): EV_COLOR
			-- Return color of either fg or bg representing `a_state'
		local
			a_r, a_g, a_b: INTEGER
		do
				-- Style is cached so it doesn't need to be unreffed.
			create Result
			Result.set_rgb_with_16_bit (a_r, a_g, a_b)
		end

	text_style, base_style, fg_style, bg_style: INTEGER = unique

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_GRID note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'.

end
