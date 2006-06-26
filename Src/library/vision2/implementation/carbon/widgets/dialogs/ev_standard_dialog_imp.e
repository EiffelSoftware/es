indexing
	description: "Eiffel Vision standard dialog. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_STANDARD_DIALOG_IMP

inherit
	EV_STANDARD_DIALOG_I
		redefine
			interface
		end

	EV_CARBON_WINDOW_IMP
		redefine
			interface,
			default_wm_decorations,
			on_key_event,
			initialize
		end

	EV_STANDARD_DIALOG_ACTION_SEQUENCES_IMP

	EV_DIALOG_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	initialize is
			-- Initialize dialog
		do
			Precursor {EV_CARBON_WINDOW_IMP}
		end

feature -- Access

	title: STRING_32 is
			-- Title of dialog shown in title bar.
		do
		end

feature -- Status report

	selected_button: STRING_32
			-- Label of the last clicked button.

feature -- Status setting

	show_modal_to_window (a_window: EV_WINDOW) is
			-- Show `Current' modal with respect to `a_window'.
		do
			show
		end

	set_title (a_title: STRING_GENERAL) is
			-- Set the title of the dialog.
		do
		end

feature {NONE} -- Implementation

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN) is
			-- `a_key' has either been pressed or released
		do
		end

	block is
			-- Wait until window is closed by the user.
		do
		end

	enable_closeable is
			-- Set the window to be closeable by the user
		do
		end

	call_close_request_actions is
			-- Call `on_cancel' if user wants to quit dialog.
		do
			on_cancel
		end

	user_clicked_ok: BOOLEAN
		-- Has the user explicitly cancelled the dialog.

	interface: EV_STANDARD_DIALOG

	default_wm_decorations: INTEGER is
			-- Default Window Manager decorations of `Current'.
		do
		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation

	on_ok is
			-- Close window and call action sequence.
		do
		end

	on_cancel is
			-- Close window and call action sequence.
		do
		end

indexing
	copyright:	"Copyright (c) 2006, The ETH Eiffel.Mac Team"

end -- class EV_STANDARD_DIALOG_IMP

