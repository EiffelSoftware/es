indexing
	description: "EiffelVision accelerator. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_ACCELERATOR_IMP

inherit
	EV_ACCELERATOR_I
		export
			{EV_INTERMEDIARY_ROUTINES} actions_internal
		redefine
			interface
		end

	EV_GTK_KEY_CONVERSION

create
	make

feature {NONE} -- Initialization
	
	make (an_interface: like interface) is
			-- Connect interface.
		do
		end

	initialize is
			-- Setup `Current'
		do
		end

feature {EV_TITLED_WINDOW_IMP} -- Implementation

	modifier_mask: INTEGER is
			-- The mask consisting of alt, shift and control keys.
		do
		end		

feature {EV_TITLED_WINDOW_IMP} -- Implementation

	add_accel (a_window_imp: EV_TITLED_WINDOW_IMP) is
			-- Add the current key combination
		require
			a_window_imp_not_void: a_window_imp /= Void
		do
		end

	remove_accel (a_window_imp: EV_TITLED_WINDOW_IMP) is
			-- Remove the current key combination
		require
			a_window_imp_not_void: a_window_imp /= Void
		do
		end

feature -- Access

	key: EV_KEY
			-- Representation of the character that must be entered
			-- by the user. See class EV_KEY_CODE

	shift_required: BOOLEAN
			-- Must the shift key be pressed?

	alt_required: BOOLEAN
			-- Must the alt key be pressed?

	control_required: BOOLEAN
			-- Must the control key be pressed?

feature -- Element change

	set_key (a_key: EV_KEY) is
			-- Set `a_key' as new key that has to be pressed.
		do
		end

	enable_shift_required is
			-- "Shift" must be pressed for the key combination.
		do
		end

	disable_shift_required is
			-- "Shift" is not part of the key combination.
		do
		end

	enable_alt_required is
			-- "Alt" must be pressed for the key combination.
		do
		end

	disable_alt_required is
			-- "Alt" is not part of the key combination.
		do
		end

	enable_control_required is
			-- "Control" must be pressed for the key combination.
		do
		end

	disable_control_required is
			-- "Control" is not part of the key combination.
		do
		end

feature {NONE} -- Implementation

	internal_gdk_key_code: NATURAL_32
		-- Internal gdk key code used to represent key of `Current'

	interface: EV_ACCELERATOR
		-- Interface object of `Current'

feature {NONE} -- Implementation

	destroy is
			-- Free resources of `Current'
		do
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




end -- class EV_ACCELERATOR_IMP

