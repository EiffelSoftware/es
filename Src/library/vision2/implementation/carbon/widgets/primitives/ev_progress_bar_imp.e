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
		do
			Precursor {EV_GAUGE_IMP} (an_interface)


			enable_segmentation
		end

feature -- Status report

	is_segmented: BOOLEAN is
			-- Is display segmented?
		do

		end

feature -- Status setting

	enable_segmentation is
			-- Display bar divided into segments.
		do

		end

	disable_segmentation is
			-- Display bar without segments.
		do

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

