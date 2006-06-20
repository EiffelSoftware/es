indexing
	description: "Eiffel Vision radio menu item. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$";
	revision: "$Revision$"

class
	EV_RADIO_MENU_ITEM_IMP

inherit
	EV_RADIO_MENU_ITEM_I
		redefine
			interface
		end

	EV_MENU_ITEM_IMP
		redefine
			on_activate,
			interface,
			make
		end

	EV_RADIO_PEER_IMP
		redefine
			interface
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a menu item.
		do
		end

feature -- Status report

	is_selected: BOOLEAN is
			-- Is this menu item checked?
		do
		end

feature -- Status setting

	enable_select is
			-- Select this menu item.
		do
		end

feature {EV_ANY_I} -- Implementation

	disable_select is
			-- Used to deselect is without firing actions.
		do
		end

	ignore_select_actions: BOOLEAN
		-- Should select_actions be called.

	on_activate is
		do
		end

	set_radio_group (a_gslist: POINTER) is
			-- Make current a member of `a_gslist' radio group.
		do
		end

	radio_group: POINTER is
		do
		end

	interface: EV_RADIO_MENU_ITEM;

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




end -- class EV_RADIO_MENU_ITEM_IMP

