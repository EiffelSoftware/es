note
	description: "Eiffel Vision scrollable area. Cocoa implementation."
	author:	"Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SCROLLABLE_AREA_IMP

inherit
	EV_SCROLLABLE_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color,
			set_item_width,
			set_item_height
		redefine
			interface
		end

	EV_VIEWPORT_IMP
		export {NONE}
			clip_view
		redefine
			interface,
			make,
			replace
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create scroll_view.make
			scroll_view.set_translates_autoresizing_mask_into_constraints_ (False)
				-- NSBezelBorder = 2
			scroll_view.set_border_type_ (2)
			scroll_view.set_has_horizontal_scroller_ (True)
			scroll_view.set_has_vertical_scroller_ (True)
			scroll_view.set_draws_background_ (False)
			cocoa_view := scroll_view

			initialize
			set_is_initialized (True)

			set_horizontal_step (10)
			set_vertical_step (10)
		end

feature -- Access

	horizontal_step: INTEGER
		do
			Result := scroll_view.horizontal_line_scroll.truncated_to_integer
		end

	vertical_step: INTEGER
		do
			Result := scroll_view.vertical_line_scroll.truncated_to_integer
		end

	is_horizontal_scroll_bar_visible: BOOLEAN
			-- Should horizontal scroll bar be displayed?
		do
			Result := scroll_view.has_horizontal_scroller
		end

	is_vertical_scroll_bar_visible: BOOLEAN
			-- Should vertical scroll bar be displayed?
		do
			Result := scroll_view.has_vertical_scroller
		end

feature -- Element change

	replace (v: like item)
			-- Replace `item' with `v'.
		do
			if attached item_imp as l_item_imp then
				l_item_imp.set_parent_imp (Void)
			end
			if attached v and then attached {like item_imp} v.implementation as v_imp then
				v_imp.set_parent_imp (Current)
				scroll_view.set_document_view_ (v_imp.attached_view)
				v_imp.set_parent_imp (Current)
			end
			item := v
		end

	set_horizontal_step (a_step: INTEGER)
			-- Set `horizontal_step' to `a_step'.
		do
			scroll_view.set_horizontal_line_scroll_ (a_step)
		end

	set_vertical_step (a_step: INTEGER)
			-- Set `vertical_step' to `a_step'.
		do
			scroll_view.set_vertical_line_scroll_ (a_step)
		end

	show_horizontal_scroll_bar
			-- Display horizontal scroll bar.
		do
			scroll_view.set_has_horizontal_scroller_ (True)
		end

	hide_horizontal_scroll_bar
			-- Do not display horizontal scroll bar.
		do
			scroll_view.set_has_horizontal_scroller_ (False)
		end

	show_vertical_scroll_bar
			-- Display vertical scroll bar.
		do
			scroll_view.set_has_vertical_scroller_ (True)
		end

	hide_vertical_scroll_bar
			-- Do not display vertical scroll bar.
		do
			scroll_view.set_has_vertical_scroller_ (False)
		end

feature -- Implementation

	scroll_view: NS_SCROLL_VIEW;

feature {EV_ANY, EV_ANY_I} -- Implementation		

	interface: detachable EV_SCROLLABLE_AREA note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

end -- class EV_SCROLLABLE_AREA_IMP
