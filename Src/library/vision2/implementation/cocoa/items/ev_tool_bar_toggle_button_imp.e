note
	description: "EiffelVision toggle tool bar, Cocoa implementations."
	copyright:	"Copyright (c) 2009, Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_TOGGLE_BUTTON_IMP

inherit
	EV_TOOL_BAR_TOGGLE_BUTTON_I
		redefine
			interface
		end

	EV_TOOL_BAR_BUTTON_IMP
		redefine
			interface,
			make
		end

create
	make

feature -- Initialization

	make
			-- Create a Cocoa toggle button.
		do
			Precursor {EV_TOOL_BAR_BUTTON_IMP}
			-- NSPushOnPushOffButton = 1
			button.set_button_type_ (1)
			cocoa_view := button
		end

feature -- Status setting

	disable_select
			-- Unselect `Current'.
		do
			if is_selected then
				is_selected := False
				-- NSOffState
				button.set_state_ (0)
				if attached select_actions_internal as l_actions then
					l_actions.call (Void)
				end
			end
		end

	enable_select
			-- Select `Current'.
		do
			if not is_selected then
				is_selected := True
				-- NSOnState
				button.set_state_ (1)
				if attached select_actions_internal as l_actions then
					l_actions.call (Void)
				end
			end
		end

feature -- Status report

	is_selected: BOOLEAN
			-- Is `Current' selected.

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_TOOL_BAR_TOGGLE_BUTTON note option: stable attribute end;

end -- class EV_TOOL_BAR_TOGGLE_BUTTON_IMP
