indexing
	description: "Eiffel Vision viewport. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VIEWPORT_IMP

inherit
	EV_VIEWPORT_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface,
			set_item_width,
			set_item_height
		end

	EV_CELL_IMP
		redefine
			interface,
			make,
			container_widget,
			visual_widget,
			on_removed_item,
			minimum_width,
			minimum_height,
			needs_event_box
		end

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is False

	make (an_interface: like interface) is
			-- Initialize.
		do
		end

feature -- Access

	minimum_width: INTEGER is
			-- Minimum width of widget.
		do
		end

	minimum_height: INTEGER is
			-- Minimum_height of widget.
		do
		end

	x_offset: INTEGER is
			-- Horizontal position of viewport relative to `item'.
		do
		end

	y_offset: INTEGER is
			-- Vertical position of viewport relative to `item'.
		do
		end

feature -- Element change

	block_resize_actions is
			-- Block any resize actions that may occur.
		do
		end

	unblock_resize_actions is
			-- Unblock all resize actions.
		do
		end

	set_x_offset (a_x: INTEGER) is
			-- Set `x_offset' to `a_x'.
		do
		end

	set_y_offset (a_y: INTEGER) is
			-- Set `y_offset' to `a_y'.
		do
		end

	set_item_size (a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		do
		end

	set_item_width (a_width: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
		do
		end

	set_item_height (a_height: INTEGER) is
			-- Set `a_widget.height' to `a_height'.
		do
		end

feature {NONE} -- Implementation

	container_widget: POINTER
			-- Pointer to the event box

	visual_widget: POINTER is
			--
		do
		end

	internal_set_item_size (a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		do
		end

	on_removed_item (a_widget_imp: EV_WIDGET_IMP) is
			-- Reset minimum size.
		do
		end

	internal_x_offset, internal_y_offset: INTEGER

	horizontal_adjustment: POINTER is
		do
		end

	vertical_adjustment: POINTER is
		do
		end

	internal_set_value_from_adjustment (l_adj: POINTER; a_value: INTEGER) is
			-- Set `value' of adjustment `l_adj' to `a_value'.
		require
			l_adj_not_null: l_adj /= default_pointer
		do
	
  		end

	viewport: POINTER
			-- Pointer to viewport, used for reuse of adjustment functions from descendants.

feature {EV_ANY_I} -- Implementation

	interface: EV_VIEWPORT;

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




end -- class EV_VIEWPORT_IMP

