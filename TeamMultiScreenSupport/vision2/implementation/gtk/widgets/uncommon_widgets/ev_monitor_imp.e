indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MONITOR_IMP

inherit
	EV_MONITOR_I
		redefine
			interface
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create an empty drawing area.
		do
			base_make (an_interface)
		end

	initialize is
			-- not needed for monitor
		do

		end


feature -- access

	get_monitor_position: EV_COORDINATE is
			-- returns the position of the monitor in the screen
		local
			tmp_rect: POINTER
			x,y: INTEGER
		do
			tmp_rect := {EV_GTK_EXTERNALS}.c_gdk_rectangle_struct_allocate
			{EV_GTK_EXTERNALS}.gdk_screen_get_monitor_geometry(default_screen, monitor_number-1, tmp_rect)
			x := {EV_GTK_EXTERNALS}.gdk_rectangle_struct_x(tmp_rect)
			y := {EV_GTK_EXTERNALS}.gdk_rectangle_struct_y(tmp_rect)

			create result.make_with_position (x, y)
		end

feature -- Measurement

	width: INTEGER is
			-- Horizontal size in pixels.
		local
			tmp_rect: POINTER
		do
			tmp_rect := {EV_GTK_EXTERNALS}.c_gdk_rectangle_struct_allocate
			{EV_GTK_EXTERNALS}.gdk_screen_get_monitor_geometry(default_screen, monitor_number-1, tmp_rect)
			result := {EV_GTK_EXTERNALS}.gdk_rectangle_struct_width (tmp_rect)
		end

	height: INTEGER is
			-- Vertical size in pixels.
		local
			tmp_rect: POINTER
		do
			tmp_rect := {EV_GTK_EXTERNALS}.c_gdk_rectangle_struct_allocate
			{EV_GTK_EXTERNALS}.gdk_screen_get_monitor_geometry(default_screen, monitor_number-1, tmp_rect)
			result := {EV_GTK_EXTERNALS}.gdk_rectangle_struct_height (tmp_rect)
		end

feature {NONE} -- Implementation

	default_screen: POINTER is
			-- pointer to the default screen
		do
			result := {EV_GTK_EXTERNALS}.gdk_screen_get_default
		end

	destroy is
			-- not necessary for monitor
		do

		end


	interface: EV_MONITOR;

invariant
	invariant_clause: True -- Your invariant here

end
