note
	description: "Eiffel Vision viewport. Cocoa implementation."
	author:	"Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VIEWPORT_IMP

inherit
	EV_VIEWPORT_I
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
			replace,
			on_size,
			set_background_color
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create clip_view.make
			clip_view.set_translates_autoresizing_mask_into_constraints_ (False)
			clip_view.set_draws_background_ (False)
			cocoa_view := clip_view

			initialize
			set_is_initialized (True)
		end

feature -- Access

	x_offset: INTEGER
			-- Horizontal position of viewport relative to `item'.

	y_offset: INTEGER
			-- Vertical position of viewport relative to `item'.

feature -- Element change

	replace (v: like item)
			-- Replace `item' with `v'.
		do
			if attached item_imp as l_item_imp then
				l_item_imp.set_parent_imp (Void)
			end
			if attached v and then attached {like item_imp} v.implementation as v_imp then
				v_imp.set_parent_imp (Current)
				clip_view.remove_constraints_ (clip_view.constraints)
				clip_view.set_document_view_ (v_imp.attached_view)

				v_imp.set_parent_imp (Current)
			end
			item := v
		end

	set_x_offset (a_x: INTEGER)
			-- Set `x_offset' to `a_x'.
		local
			l_point: NS_POINT
		do
			create l_point.make
			l_point.set_x (a_x)
			l_point.set_y (y_offset)
--			clip_view.scroll_to_point_ (l_point)
			x_offset := a_x
		end

	set_y_offset (a_y: INTEGER)
			-- Set `y_offset' to `a_y'.
		local
			l_point: NS_POINT
		do
			create l_point.make
			l_point.set_x (x_offset)
			l_point.set_y (a_y)
--			clip_view.scroll_to_point_ (l_point)
			y_offset := a_y
		end

	set_item_size (a_width, a_height: INTEGER)
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		do
			check item /= Void end
			item.set_minimum_size (a_width, a_height)
		end

	set_background_color (a_color: EV_COLOR)
		local
			l_color: NS_COLOR
		do
			Precursor {EV_CELL_IMP} (a_color)
			l_color := color_utils.color_with_calibrated_red__green__blue__alpha_ (a_color.red.to_double, a_color.green.to_double, a_color.blue.to_double, 1.0)
			if attached {NS_CLIP_VIEW} attached_view as l_clip_view then
				l_clip_view.set_background_color_ (l_color)
			elseif attached {NS_SCROLL_VIEW} attached_view as l_scroll_view then
				l_scroll_view.set_background_color_ (l_color)
			end
		end

feature -- Layout

	on_size (a_width, a_height: INTEGER)
		do
			if resize_actions_internal /= Void then
				resize_actions_internal.call ([screen_x, screen_y, a_width, a_height])
			end
		end

feature -- Implementation

	clip_view: NS_CLIP_VIEW;

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_VIEWPORT note option: stable attribute end;

end -- class EV_VIEWPORT_IMP
