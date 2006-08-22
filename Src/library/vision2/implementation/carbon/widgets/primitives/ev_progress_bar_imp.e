indexing
	description: "Eiffel Vision Progress bar. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_PROGRESS_BAR_IMP

inherit
	EV_PROGRESS_BAR_I
		redefine
			interface
		end

	EV_GAUGE_IMP
		redefine
			interface,
			make
		end

feature {NONE} -- Implementation

	make (an_interface: like interface) is
			-- Create the progress bar.
		local
			rect : RECT_STRUCT
			struct_ptr : POINTER
			err : INTEGER
		do
			Precursor {EV_GAUGE_IMP} (an_interface)
			create rect.make_new_unshared
			rect.set_left(0)
			rect.set_right(100)
			rect.set_bottom(10)
			rect.set_top (0)
			err := create_progress_bar_control_external (default_pointer, rect.item, 0, 0, 100, 0, $struct_ptr)
			set_c_object ( struct_ptr )
		end

feature -- Status report

	is_segmented: BOOLEAN is
			-- Is display segmented?
		do
			Result := false
		end

feature -- Status setting

	enable_segmentation is
			-- Display bar divided into segments.
		do
			-- Not supported on carbon
		end

	disable_segmentation is
			-- Display bar without segments.
		do
			-- Not supported on Carbon
		end

feature {EV_ANY_I} -- Implementation


	interface: EV_PROGRESS_BAR;

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




end -- class EV_PROGRESS_BAR_IMP

