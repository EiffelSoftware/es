indexing
	description: "Eiffel Vision dialog. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_DIALOG_IMP

inherit
	EV_DIALOG_I
		undefine
			propagate_foreground_color,
			propagate_background_color,
			dialog_key_press_action,
			lock_update,
			unlock_update
		redefine
			interface
		end

	EV_TITLED_WINDOW_IMP
		redefine
			make,
			interface,
			call_close_request_actions,
			initialize,
			client_area
		end

	EV_GTK_DEPENDENT_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create empty dialog box.
		do
			base_make (an_interface)
		end

	initialize is
			-- Initialize 'Current'
		do
		end

feature -- Status Report

	is_closeable: BOOLEAN is
			-- Is the window closeable by the user?
		do
		end

	is_relative: BOOLEAN is
			-- Is `Current' shown relative to another window?
		do
		end

feature -- Status Setting

	enable_closeable is
			-- Set the window to be closeable by the user
		do
		end

	disable_closeable is
			-- Set the window not to be closeable by the user
		do
		end

feature -- Basic operations

	show_modal_to_window (a_window: EV_WINDOW) is
			-- Show `Current' modal with respect to `a_window'.
		do
		end

	show_relative_to_window (a_window: EV_WINDOW) is
			-- Show `Current' with respect to `a_window'.
		do
		end

feature {NONE} -- Implementation

	client_area: POINTER is
			-- Pointer to the widget that is treated as the main holder of the client area within the window.
		do
		end

	dialog_key_press_action (a_key: EV_KEY) is
		do
		end

	set_closeable (new_status: BOOLEAN) is
			-- Set `is_closeable' to `new_status'
		do
		end

	call_close_request_actions is
			-- Call the cancel actions if dialog is closeable.
		do
		end

	interface: EV_DIALOG
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

	is_dialog_closeable: BOOLEAN;
			-- Temporary flag whose only use is to enable functions
			-- `is_closeable', `enable_closeable' and `disable_closeable'
			-- to be executed without raising zillions of assertion violations.
			--| FIXME implement cited function, then remove me.

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




end -- class EV_DIALOG_IMP

