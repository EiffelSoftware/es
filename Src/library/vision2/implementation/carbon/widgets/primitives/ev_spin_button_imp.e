indexing
	description: "Eiffel Vision spin button. Carbon Implementation."
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
			-- There is no control like this in carbon. It's probably best to take
			-- a text-field and a little-arrow control to do the same
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_right (300)
			rect.set_bottom (30)
			ret := create_little_arrows_control_external ( null, rect.item, 0, 0, 100, 1, $ptr )
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
			precursor {EV_TEXT_FIELD_IMP} (a_text)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_SPIN_BUTTON;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_SPIN_BUTTON_IMP

