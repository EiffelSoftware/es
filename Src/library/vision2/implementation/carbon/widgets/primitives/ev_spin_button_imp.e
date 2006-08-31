indexing
	description: "Eiffel Vision spin button. GTK+ Implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SPIN_BUTTON_IMP

inherit
	EV_SPIN_BUTTON_I
		undefine
			hide_border
		redefine
			interface
		end

	EV_GAUGE_IMP
		undefine
			on_key_event,
			default_key_processing_blocked,
			on_focus_changed
		redefine
			interface,
			initialize,
			make,
			dispose
		end

	EV_TEXT_FIELD_IMP
		rename
			create_change_actions as create_text_change_actions,
			change_actions as text_change_actions,
			change_actions_internal as text_change_actions_internal
		redefine
			make,
			interface,
			initialize,
			set_text,
			dispose
		end

create
	make

feature {NONE} -- Implementation

	make (an_interface: like interface) is
			-- Create the spin button.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
			cfstring: EV_CARBON_CF_STRING
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left(60)
			rect.set_right(150)
			rect.set_bottom(90)
			rect.set_top (60)
			create cfstring.make_unshared_with_eiffel_string ("NOT IMPLEMENTED :D")
			ret := create_static_text_control_external( null, rect.item, cfstring.item, null, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id (current)
		end

	initialize is
		do
			Precursor {EV_TEXT_FIELD_IMP}
			ev_gauge_imp_initialize --| {EV_GAUGE} Precursor
		end

feature {NONE} -- Implementation

	dispose is
			do
				precursor {EV_TEXT_FIELD_IMP}
				precursor {EV_GAUGE_IMP}
			end


	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		do
			--precursor {EV_TEXT_FIELD_IMP} (a_text)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_SPIN_BUTTON;

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




end -- class EV_SPIN_BUTTON_IMP

