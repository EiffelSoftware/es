indexing
	description: "Eiffel Vision menu item list. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_MENU_ITEM_LIST_IMP

inherit
	EV_MENU_ITEM_LIST_I
		redefine
			interface
		end

	EV_ITEM_LIST_IMP [EV_MENU_ITEM]
		redefine
			insert_i_th,
			interface,
			remove_i_th
		end

	EV_ANY_IMP
		undefine
			needs_event_box
		redefine
			interface
		end

	EV_MENU_ITEM_LIST_ACTION_SEQUENCES_IMP

	CFSTRING_FUNCTIONS_EXTERNAL
	MENUS_FUNCTIONS_EXTERNAL


feature {EV_MENU_ITEM_IMP} -- implementation

	list_widget: POINTER is
			--
		do
		end

feature {NONE} -- Implementation

	insert_i_th (v: like item; pos: INTEGER) is
		local
			menu_item: EV_MENU_ITEM_IMP
		do
			-- Insert a menu item here!
			--ret := create_new_menu_external (1234, 0, $ptr)
			menu_item ?= v.implementation
			insert_menu_item(menu_item, pos)
		end

	insert_menu_item (an_item_imp: EV_MENU_ITEM_IMP; pos: INTEGER) is
			-- Generic menu item insertion.
		local
			ptr: POINTER
			ret: INTEGER
		do
			ptr := an_item_imp.c_object
			insert_menu_external (ptr, 0)
		end

	separator_imp_by_index (an_index: INTEGER): EV_MENU_SEPARATOR_IMP is
			-- Separator before item `an_index'.
		require
			an_index_within_bounds:
				an_index > 0 and then an_index <= interface.count
		do
		end

	is_menu_separator_imp (an_item_imp: EV_ITEM_I): BOOLEAN is
		do
		end

	remove_i_th (a_position: INTEGER) is
			-- Remove item at `a_position'
		do
		end

feature -- Access

	radio_group_ref: POINTER_REF is
		do
		end

	set_radio_group (p: POINTER) is
			-- Assign `p' to `radio_group'.
		do
		end

	radio_group: POINTER is
			-- GSList with all radio items of this container.
		do
		end

feature {NONE} -- Implementation

	radio_group_ref_internal: POINTER_REF

feature {EV_ANY_I} -- Implementation

	interface: EV_MENU_ITEM_LIST;

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




end -- class EV_MENU_ITEM_LIST_IMP

