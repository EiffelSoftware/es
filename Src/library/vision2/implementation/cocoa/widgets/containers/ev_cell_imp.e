note
	description: "Eiffel Vision cell, Cocoa implementation."
	author: "Daniel Furrer"
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

	EV_SINGLE_CHILD_CONTAINER_IMP
		redefine
			interface,
			client_height,
			client_width,
			make
		end

	EV_DOCKABLE_TARGET_IMP
		redefine
			interface
		end

create
	make

feature -- initialization

	make
		do
			create {EV_FLIPPED_VIEW}cocoa_view.make
			cocoa_view.set_translates_autoresizing_mask_into_constraints_ (False)
			create color_utils
			set_expandable (True)
			is_show_requested := True
			initialize
			set_is_initialized (True)
		end

feature -- Access

	has (v: like item): BOOLEAN
			-- Does `Current' include `v'?	
		do
			Result := not is_destroyed and (v /= Void and then item = v)
		end

	count: INTEGER_32
			-- Number of elements in `Current'.	
		do
			if item /= Void then
				Result := 1
			end
		end

feature -- Element change

	top_level_window_imp: detachable EV_WINDOW_IMP
			-- Top level window that contains `Current'.

	set_top_level_window_imp (a_window: detachable EV_WINDOW_IMP)
			-- Make `a_window' the new `top_level_window_imp'
			-- of `Current'.
		do
			top_level_window_imp := a_window
			if attached item_imp as l_item_imp then
				l_item_imp.set_top_level_window_imp (a_window)
			end
		end

feature -- Layout

	client_height: INTEGER
			-- Height of the client area of `Current'
		do

			if attached {NS_BOX} cocoa_view as l_box then
				check attached {NS_VIEW} l_box.content_view as l_content_view then
					Result := l_content_view.frame.size.height.rounded.max (0).min (height)
				end
			else
				Result := height
			end
		end

	client_width: INTEGER
			-- Height of the client area of `Current'.
		do
			if attached {NS_BOX} cocoa_view as l_box then
				check attached {NS_VIEW} l_box.content_view as l_content_view then
					Result := l_content_view.frame.size.width.rounded.max (0).min (width)
				end
			else
				Result := width
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	color_utils: NS_COLOR_UTILS

	interface: detachable EV_CELL note option: stable attribute end;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

end -- class EV_CELL_IMP
