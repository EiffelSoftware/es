note
	description: "Eiffel Vision standard dialog. Cocoa implementation."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_STANDARD_DIALOG_IMP

inherit
	EV_STANDARD_DIALOG_I
		redefine
			interface
		end

	EV_STANDARD_DIALOG_ACTION_SEQUENCES_IMP

	EV_ANY_IMP
		redefine
			interface,
			dispose
		end

	EV_NS_WINDOW
		redefine
			make,
			dispose
		end

feature {NONE} -- Implementation

	make
			-- Initialize dialog
		do
			Precursor {EV_NS_WINDOW}
--			cocoa_make
--			cocoa_make (create {NS_RECT}.make_rect (100, 100, 100, 100),
--				{NS_WINDOW}.closable_window_mask | {NS_WINDOW}.miniaturizable_window_mask | {NS_WINDOW}.resizable_window_mask, True)
			make_key_and_order_front_ (Current)
			order_out_ (Current)
			allow_resize
			set_is_initialized (True)
		end

feature -- Status report

	selected_button: detachable IMMUTABLE_STRING_32
			-- Label of the last clicked button.

feature -- Status setting

	show_modal_to_window (a_window: EV_WINDOW)
			-- Show `Current' modal with respect to `a_window'.
		local
			button: INTEGER
		do
			button := app_implementation.run_modal_for_window (Current)

			-- NSOKButton = 1
			if button =  1 then
				selected_button := internal_accept
				ok_actions.call (Void)
			-- NSCancelButton = 0
			elseif button = 0 then
				selected_button := ev_cancel
				cancel_actions.call (Void)
			end
		end

	blocking_window: detachable EV_WINDOW

feature {NONE} -- Implementation

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN)
		do

		end

	minimum_width: INTEGER
		do

		end

	minimum_height: INTEGER
		do

		end

	enable_closeable
			-- Set the window to be closeable by the user
		do
		end

feature -- Dispose

	dispose
		do
			Precursor {EV_ANY_IMP}
			Precursor {EV_NS_WINDOW}
		end

feature {EV_ANY, EV_ANY_I}

	interface: detachable EV_STANDARD_DIALOG note option: stable attribute end;

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end -- class EV_STANDARD_DIALOG_IMP
