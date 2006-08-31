indexing
	description: "Eiffel Vision horizontal scroll bar. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
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
			interface,
			make
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the horizontal scroll bar.
		do
			Precursor {EV_SCROLL_BAR_IMP} (an_interface)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_SCROLL_BAR;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_SCROLL_BAR_IMP

