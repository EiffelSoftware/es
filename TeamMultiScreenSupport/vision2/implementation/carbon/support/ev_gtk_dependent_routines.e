indexing
	description: "Gtk version dependent routines"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_GTK_DEPENDENT_ROUTINES

feature -- Implementation

	frozen add_g_type_string (an_array: POINTER; a_pos: INTEGER) is
			-- Add G_TYPE_STRING constant in `an_array' at `a_pos' bytes from beginning
			-- of `an_array'.
		require
			an_array_not_null: an_array /= default_pointer
			a_pos_nonnegative: a_pos >= 0
		do
		end

	frozen add_gdk_type_pixbuf (an_array: POINTER; a_pos: INTEGER) is
			-- Add GDK_TYPE_PIXBUF constant in `an_array' at `a_pos' bytes from beginning
			-- of `an_array'.
		require
			an_array_not_null: an_array /= default_pointer
			a_pos_nonnegative: a_pos >= 0
		do
		end

	frozen sizeof_gtype: INTEGER is
			-- Size of the `GType' C type
		do
		end

	create_gtk_dialog: POINTER is
			-- Create and initialize a gtk dialog
		do
		end

	client_area_from_c_object (a_c_object: POINTER): POINTER is
			--
		do
		end

	horizontal_resolution_internal: INTEGER is
			-- Number of pixels per inch along horizontal axis
		once
		end

	vertical_resolution_internal: INTEGER is
			-- Number of pixels per inch along vertical axis
		once
		end

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




end -- class EV_GTK_DEPENDENT_ROUTINES

