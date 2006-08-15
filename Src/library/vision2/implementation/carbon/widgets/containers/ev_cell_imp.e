indexing
	description:
		"Eiffel Vision cell, Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_CELL_IMP

inherit
	EV_CELL_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CONTAINER_IMP
		redefine
			interface,
			replace
		end

	EV_DOCKABLE_TARGET_IMP
		redefine
			interface
		end

create
	make

feature -- initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		do
			base_make (an_interface)
			set_c_object ($current) -- just to make sure the contract is valid
		end

feature -- Access

	item: EV_WIDGET
			-- Current item.

feature -- Element change

	replace (v: like item) is
			-- Replace `item' with `v'.
		do
			Precursor {EV_CONTAINER_IMP} (v)
			item := v
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_CELL;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_CELL_IMP

