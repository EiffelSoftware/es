note
	description: "Eiffel Vision Split Area, Cocoa implementation."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_SPLIT_AREA_IMP

inherit
	EV_VERTICAL_SPLIT_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_SPLIT_AREA_IMP
		redefine
			interface,
			make
		end

create
	make

feature -- Creation

	make
		do
			create split_view.make
			split_view.set_translates_autoresizing_mask_into_constraints_ (False)
			split_view.set_vertical_ (False)
				-- NSSplitViewDividerStylePaneSplitter = 3
			split_view.set_divider_style_ (3)
			cocoa_view := split_view
			Precursor {EV_SPLIT_AREA_IMP}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_VERTICAL_SPLIT_AREA note option: stable attribute end;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

end -- class EV_VERTICAL_SPLIT_AREA_IMP
