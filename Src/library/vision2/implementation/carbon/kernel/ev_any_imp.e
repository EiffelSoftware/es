indexing
	description:
		"Base class for Carbon implementation (_IMP) classes. %N%
		%Handles interaction between Eiffel objects and Carbon objects %N%
		%See important notes on memory management at end of class"
	legal: "See notice at end of class."
	keywords: "implementation, carbon, any, base"
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_ANY_IMP

inherit
	EV_ANY_I
		export
			{EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES, EV_ANY_IMP}
				is_destroyed
		end

	IDENTIFIED
		undefine
			is_equal,
			copy
		redefine
			dispose
		end

feature {EV_ANY_I} -- Access

	c_object: POINTER
			-- C pointer to corresponding carbon struct

feature {EV_ANY_I} -- Access

	set_c_object (a_c_object: POINTER) is
			-- Assign `a_c_object' to `c_object'.
			-- Set up Eiffel GC / GTK cooperation.
			--| (See note at end of class)
		require
			a_c_object_not_null: a_c_object /= NULL
		do
			c_object := a_c_object
		ensure
			c_object_coupled: eif_object_from_c (c_object) = Current
		end

	frozen eif_object_from_c (a_c_object: POINTER): EV_ANY_IMP is
			-- Retrieve the EV_ANY_IMP stored in `a_c_object'.
		do
		end

	frozen gtk_is_object (a_c_object: POINTER): BOOLEAN is
		do
		end

feature {EV_ANY, EV_ANY_IMP} -- Implementation

	destroy is
			-- Destroy `c_object'.
			-- Render `Current' unusable.
		do

		end

feature {EV_ANY_I, EV_APPLICATION_IMP} -- Event handling

feature {NONE} -- Implementation

	needs_event_box: BOOLEAN is
			-- Does `event_widget' need an event box to receive events?
		do
--			Result := False
		end

	dispose is
			-- Called by the Eiffel GC when `Current' is destroyed.
			-- Destroy `c_object'.
		local
			a_widget: EV_WIDGET_IMP
		do
			io.put_string ("%N GC")
			a_widget ?= current
			if  a_widget /= void then
				a_widget.destroy
			end
		end

	c_object_dispose is
			-- Called when `c_object' is destroyed.
			-- Only called if `Current' is referenced from `c_object'.
			-- Render `Current' unusable.
		do
		ensure
			is_destroyed_set: is_destroyed
			c_object_detached: c_object = NULL
		end

feature {EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Implementation

	process_gdk_event (n_args: INTEGER; args: POINTER) is
			-- Process any incoming gdk event.
		do
			-- Redefined by descendents.
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Access

	visual_widget: POINTER is
			-- Pointer to the widget viewed by user.
		do
		end

feature {EV_INTERMEDIARY_ROUTINES, EV_ANY_I, EV_STOCK_PIXMAPS_IMP} -- Implementation

		App_implementation: EV_APPLICATION_IMP is
			--
		local
			env: EV_ENVIRONMENT
		once
			create env
			Result ?= env.application.implementation
			check
				Result_not_void: Result /= Void
			end
		end

feature -- Measurement

	NULL: POINTER is
		external
			"C [macro <stdio.h>]"
		alias
			"NULL"
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




end -- class EV_ANY_IMP

