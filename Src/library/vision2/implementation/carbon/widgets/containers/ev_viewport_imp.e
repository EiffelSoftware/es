indexing
	description: "Eiffel Vision viewport. Carbon implementation."
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
			on_removed_item
		end

	HIVIEW_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Initialize.
		do
			base_make (an_interface)
		end

feature -- Access

--	minimum_width: INTEGER is
--			-- Minimum width of widget.
--		do
--		end
--
--	minimum_height: INTEGER is
--			-- Minimum_height of widget.
--		do
--		end

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
			internal_set_item_size (a_width, -1)
		end

	set_item_height (a_height: INTEGER) is
			-- Set `a_widget.height' to `a_height'.
		do
			internal_set_item_size (-1, a_height)
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
		local
			item_width, item_height: INTEGER
			w_imp: EV_WIDGET_IMP
			a_rect: CGRECT_STRUCT
			a_size: CGSIZE_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := hiview_get_frame_external ( c_object, a_rect.item )
			create a_size.make_shared ( a_rect.size )


			if a_width > 0 then
				a_size.set_width (a_width)
			end

			if a_height > 0 then
				a_size.set_height (a_height)
			end

			w_imp ?= item.implementation
			w_imp.store_minimum_size

			a_rect.set_size (a_size.item)

			ret := hiview_set_frame_external (w_imp.c_object, a_rect.item)
		end

	on_removed_item (a_widget_imp: EV_WIDGET_IMP) is
			-- Reset minimum size.
		do
		end

	internal_x_offset, internal_y_offset: INTEGER

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

