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
			replace,
			minimum_width,
			minimum_height
		end

	EV_DOCKABLE_TARGET_IMP
		redefine
			interface
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature -- initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left (20)
			rect.set_right (100)
			rect.set_bottom (40)
			rect.set_top (20)
			ret := create_placard_control_external ( null, rect.item, $ptr )
			set_c_object ( ptr )
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
feature -- Measurement

	minimum_width: INTEGER is
		do
			if item /= void then
				Result := item.minimum_width + 20
			else
				Result := Precursor {EV_CONTAINER_IMP} +20
			end

		end

	minimum_height: INTEGER is
		do
			if item /= void then
				Result := item.minimum_height + 40
			else
				Result := Precursor {EV_CONTAINER_IMP} + 20
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_CELL;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_CELL_IMP

