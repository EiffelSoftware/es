indexing
	description: "Eiffel Vision scrollbar. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
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
		redefine
			interface,
			set_leap
		end

feature -- Element change

	set_leap (a_leap: INTEGER) is
			-- Set `leap' to `a_leap'.
			-- We redefine it to keep the page size the same as leap.
		do
		ensure then
			range_same: value_range.is_equal (old value_range)
		end

feature {NONE} -- Implementation

	internal_set_upper is
			-- Sets the upper value of the adjustment struct to take 'leap' in to account
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_SCROLL_BAR;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_SCROLL_BAR_IMP

