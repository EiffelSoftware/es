indexing
	description:
		"Eiffel Vision colorizable. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "colorizible"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_COLORIZABLE_IMP

inherit

	EV_COLORIZABLE_I
		redefine
			interface,
			set_default_colors
		end

	EV_ANY_IMP
		undefine
			destroy
		redefine
			interface
		end

feature -- Access

	background_color: EV_COLOR is
			-- Color of face.
		do
			create Result
		end

	foreground_color: EV_COLOR is
			-- Color of foreground features like text.
		do
			create Result
		end

feature -- Status setting


	set_background_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `background_color'
		do
		end

	real_set_background_color (a_c_object: POINTER; a_color: EV_COLOR) is
			-- Implementation of `set_background_color'
			-- Used also by classes that inherit EV_WIDGET_IMP but not
			-- EV_WIDGET. (eg EV_PIXMAPABLE_IMP)
			--| Check that the color is not already set.
			--| Copy the existing GtkStyle, modifiy it	
			--| and set it back into the widget.
			--| (See gtk/docs/styles.txt)
		do
		end

	set_foreground_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `foreground_color'
		do
		end

	real_set_foreground_color (a_c_object: POINTER; a_color: EV_COLOR) is
			-- Implementation of `set_foreground_color'
		do
		end

	set_default_colors is
			-- Set foreground and background color to their default values.
		do
		end

feature {NONE} -- Implementation

	background_color_imp: EV_COLOR_IMP
		-- Color used for the background of `Current'

	foreground_color_imp: EV_COLOR_IMP
		-- Color used for the foreground of `Current'

	background_color_pointer: POINTER is
			-- Pointer to bg color for `a_widget'.
		do
		end

	foreground_color_pointer: POINTER is
			-- Pointer to fg color for `a_widget'.
		do
		end

	Prelight_scale: REAL is 1.0909488
		-- Prelight color is this much lighter than `background_color'.

	Highlight_scale: REAL is 0.90912397
		-- Highlight color is this much darker than `background_color'.

feature {EV_ANY_I} -- Implementation

	interface: EV_COLORIZABLE;

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




end -- EV_COLORIZABLE_IMP

