indexing
	description:
		"EiffelVision box. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_BOX_IMP

inherit
	EV_BOX_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		redefine
			interface,
			needs_event_box
		end

feature -- Access

	is_homogeneous: BOOLEAN
			-- Are all children restricted to be the same size?

	border_width: INTEGER
			-- Width of border around container in pixels.

	padding: INTEGER
			-- Space between children in pixels.		

feature {EV_ANY, EV_ANY_I} -- Status report

	is_item_expanded (child: EV_WIDGET): BOOLEAN is
			-- Is `child' expanded to occupy available spare space?
		do
		end

feature {EV_ANY, EV_ANY_I} -- Status settings

	set_homogeneous (flag: BOOLEAN) is
			-- Set whether every child is the same size.
		do
		end

	set_border_width (value: INTEGER) is
			 -- Assign `value' to `border_width'.
		do
		end

	set_padding (value: INTEGER) is
			-- Assign `value' to `padding'.
		do
		end

	set_child_expandable (child: EV_WIDGET; flag: BOOLEAN) is
			-- Set whether `child' expands to fill available spare space.
		do
		end

feature {EV_ANY_I} -- Implementation

	needs_event_box: BOOLEAN is True

feature {EV_ANY_I, EV_ANY} -- Implementation

	interface: EV_BOX;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_BOX_IMP

