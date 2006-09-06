indexing
	description:
		" EiffelVision tool-bar radio button. implementation%
		% interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_RADIO_BUTTON_IMP

inherit
	EV_TOOL_BAR_RADIO_BUTTON_I
		redefine
			interface
		end

	EV_TOOL_BAR_BUTTON_IMP
		redefine
			make,
			interface,
			set_item_parent_imp,
			create_select_actions
		end

	EV_RADIO_PEER_IMP
		redefine
			interface,
			widget_object
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Make a radio button with a default of selected.
		do
		end

feature -- Status setting

	enable_select is
			-- Select `Current'.
		do
		end

feature -- Status report

	is_selected: BOOLEAN is
			-- Is `Current' selected.
		do
		end

feature {EV_ANY_I, EV_GTK_CALLBACK_MARSHAL} -- Implementation

	create_select_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Create a select action sequence.
			-- Attach to GTK "clicked" signal.
		do
		end

feature {NONE} -- Implementation

	set_item_parent_imp (a_container_imp: EV_ITEM_LIST_IMP [EV_ITEM]) is
			-- Set `parent_imp' to `a_container_imp'.
		do
		end

feature {EV_ANY_I} -- Implementation

	widget_object (a_list: POINTER): POINTER is
			-- Returns c_object relative to a_list data.
		do
		end

	radio_group: POINTER is
			-- Pointer to the GSList used for holding the radio grouping of `Current'
		do
		end

	interface: EV_TOOL_BAR_RADIO_BUTTON;
			-- Interface of `Current'

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




end -- class EV_TOOL_BAR_RADIO_BUTTON_IMP

