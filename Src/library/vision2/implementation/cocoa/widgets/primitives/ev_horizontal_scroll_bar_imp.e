note
	description: "Eiffel Vision horizontal scroll bar. Cocoa implementation."
	author:	"Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HORIZONTAL_SCROLL_BAR_IMP

inherit
	EV_HORIZONTAL_SCROLL_BAR_I
		redefine
			interface
		end

	EV_SCROLL_BAR_IMP
		redefine
			make,
			interface
		end

create
	make

feature -- Initialization

	make
		do
			add_objc_callback ("did_change_value:", agent did_change_value)
			make_with_frame_ (create {NS_RECT}.make_with_coordinates (0, 0, 10, 5)) -- This call sets the orientation of the scrollbar
			set_translates_autoresizing_mask_into_constraints_ (False)
				-- NSScrollerStyleLegacy = 0
			set_scroller_style_ (0)
			cocoa_view := Current
			Precursor {EV_SCROLL_BAR_IMP}
			set_target_ (Current)
			set_action_ (create {OBJC_SELECTOR}.make_with_name ("did_change_value:"))
			disable_tabable_from
			disable_tabable_to
			set_enabled_ (True)

			set_is_initialized (True)
			set_fixed_height (15)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_HORIZONTAL_SCROLL_BAR note option: stable attribute end;

end -- class EV_HORIZONTAL_SCROLL_BAR_IMP
