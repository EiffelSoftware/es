note
	description: "Eiffel Vision scrollbar. Cocoa implementation."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SCROLL_BAR_IMP

inherit
	EV_SCROLL_BAR_I
		redefine
			interface
		end

	EV_GAUGE_IMP
		undefine
			set_value
		redefine
			interface,
			make,
			set_leap,
			set_range,
			dispose
		end

	NS_SCROLLER
		undefine
			copy,
			is_equal
		redefine
			make,
			dispose
		end

feature {NONE} -- Implementation

	make
		do
			Precursor {EV_GAUGE_IMP}
			disable_tabable_from
			disable_tabable_to
		end

feature {EV_ANY_I} -- Setter

	set_value (a_value: INTEGER)
			-- Set `value' to `a_value'.
		do
			Precursor {EV_GAUGE_IMP} (a_value)
			set_double_value_ (proportion)
		end

feature {EV_ANY_I} -- Implementation

	set_leap (a_leap: INTEGER)
			-- <Precursor>
		do
			Precursor {EV_GAUGE_IMP} (a_leap)
			set_knob_proportion_ ((a_leap / value_range.count).truncated_to_real)
		end

	set_range
			-- <Precursor>
		do
			Precursor {EV_GAUGE_IMP}
			set_knob_proportion_ ((leap / value_range.count).truncated_to_real)
		end

feature -- Dispose

	dispose
		do
			Precursor {NS_SCROLLER}
			Precursor {EV_GAUGE_IMP}
		end

feature {NONE} -- Implementation

	did_change_value (sender: NS_SCROLLER)
		do
			set_proportion (double_value.truncated_to_real)
			change_actions.call ([value])
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_SCROLL_BAR note option: stable attribute end

end -- class EV_SCROLL_BAR_IMP
