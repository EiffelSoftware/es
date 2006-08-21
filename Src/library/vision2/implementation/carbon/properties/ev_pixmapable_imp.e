indexing
	description:
		"Eiffel Vision pixmapable. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "pixmap, bitmap, icon, graphic, image"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_PIXMAPABLE_IMP

inherit
	EV_PIXMAPABLE_I
		redefine
			interface
		end

	EV_ANY_IMP
		undefine
			destroy
		redefine
			interface
		end

feature -- Initialization

	pixmapable_imp_initialize is
			-- Create a GtkHBox to hold a GtkPixmap.
		do
		end

feature -- Access

	pixmap: EV_PIXMAP is
			-- Pixmap shown in `Current'
		do
		end

feature -- Element change

	set_pixmap (a_pixmap: EV_PIXMAP) is
			-- Assign `a_pixmap' to `pixmap'.
		do
		end

	remove_pixmap is
			-- Assign Void to `pixmap'.
		do
		end

feature {EV_ITEM_PIXMAP_SCALER_I} -- Implementation

	internal_set_pixmap (a_pixmap_imp: EV_PIXMAP_IMP; a_width, a_height: INTEGER) is
			--
		do
		end

	internal_remove_pixmap is
			-- Remove pixmap from Current
		do
		end

	internal_pixmap: EV_PIXMAP_IMP
			-- Internal stored pixmap.		

feature {NONE} -- Implementation

	gtk_pixmap: POINTER is
			-- Pointer to the GtkPixmap widget.
		do
		end

	pixmap_box: POINTER
			-- GtkHBox to hold the GtkPixmap.

feature {EV_ANY_I} -- Implementation

	interface: EV_PIXMAPABLE;

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




end -- EV_PIXMAPABLE_IMP

