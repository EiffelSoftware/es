indexing
	description: "Eiffel Vision scrollable area. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SCROLLABLE_AREA_IMP

inherit
	EV_SCROLLABLE_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color,
			set_item_width,
			set_item_height
		redefine
			interface
		end

	EV_VIEWPORT_IMP
		redefine
			horizontal_adjustment,
			vertical_adjustment,
			interface,
			make,
			on_size_allocate,
			x_offset,
			y_offset,
			set_x_offset,
			set_y_offset,
			child_has_resized
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create scrollable area.
		do
			base_make (an_interface)
		end

feature -- Access

	horizontal_step: INTEGER is
			-- Number of pixels scrolled up or down when user clicks
			-- an arrow on the horizontal scrollbar.
		do
		end

	vertical_step: INTEGER is
			-- Number of pixels scrolled left or right when user clicks
			-- an arrow on the vertical scrollbar.
		do
		end

	is_horizontal_scroll_bar_visible: BOOLEAN is
			-- Should horizontal scroll bar be displayed?
		do
		end

	is_vertical_scroll_bar_visible: BOOLEAN is
			-- Should vertical scroll bar be displayed?
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

	set_x_offset (a_x: INTEGER) is
			-- Set `x_offset' to `a_x'.
		do
		end

	set_y_offset (a_y: INTEGER) is
			-- Set `y_offset' to `a_y'.
		do
		end

	set_horizontal_step (a_step: INTEGER) is
			-- Set `horizontal_step' to `a_step'.
		do
		end

	set_vertical_step (a_step: INTEGER) is
			-- Set `vertical_step' to `a_step'.
		do
		end

	show_horizontal_scroll_bar is
			-- Display horizontal scroll bar.
		do
		end

	hide_horizontal_scroll_bar is
			-- Do not display horizontal scroll bar.
		do
		end

	show_vertical_scroll_bar is
			-- Display vertical scroll bar.
		do
		end

	hide_vertical_scroll_bar is
			-- Do not display vertical scroll bar.
		do
		end

feature {NONE} -- Implementation

	fixed_widget: POINTER
		-- Pointer to the fixed widget used for central positioning when `item' cannot be scrolled.

	fixed_width: INTEGER is
			-- Fixed Horizontal size measured in pixels.
		do
		end

	fixed_height: INTEGER is
			-- Fixed Vertical size measured in pixels.
		do
		end

	scrolled_window: POINTER

	on_size_allocate (a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- Set item in center of `Current' if smaller.
		do
		end

	child_has_resized (item_imp: EV_WIDGET_IMP) is
			-- If child has resized and smaller than parent then set position in center of `Current'.
		do
		end

	horizontal_adjustment: POINTER is
			-- Pointer to the adjustment struct of the hscrollbar
		do
		end

	vertical_adjustment: POINTER is
			-- Pointer to the adjustment struct of the vscrollbar
		do
		end

	horizontal_policy: INTEGER
		-- Policy type used for the horizontal scrollbar (ALWAYS, AUTOMATIC or NEVER)

	vertical_policy: INTEGER
		-- Policy type used for the vertical scrollbar (ALWAYS, AUTOMATIC or NEVER)

	set_scrolling_policy (hscrollpol, vscrollpol: INTEGER) is
			-- Set the policy for both scrollbars.
		do
		end

feature {EV_ANY_I} -- Implementation		

	interface: EV_SCROLLABLE_AREA;
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




end -- class EV_SCROLLABLE_AREA_IMP

