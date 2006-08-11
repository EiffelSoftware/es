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

	MENUS_FUNCTIONS_EXTERNAL


feature {EV_MENU_ITEM_IMP} -- implementation

	list_widget: POINTER is
			--
		do
		end

feature {NONE} -- Implementation

	insert_i_th (v: like item; pos: INTEGER) is
			-- Insert the item v in the current menu
		local
			menu_item: EV_MENU_ITEM_IMP
		do
			menu_item ?= v.implementation
			insert_menu_item(menu_item, pos)
		end

	insert_menu_item (an_item_imp: EV_MENU_ITEM_IMP; pos: INTEGER) is
			-- Generic menu item insertion.
		local
			ptr: POINTER
			ret: INTEGER
			parent_item: EV_MENU_ITEM_IMP
			seq_imp: EV_MENU_SEPARATOR_IMP
		do
			ptr := an_item_imp.c_object
			parent_item ?= current

			seq_imp ?= an_item_imp
			if seq_imp /= Void then
				ret := insert_menu_item_text_with_cfstring_external (parent_item.c_object, string_to_cfstring(""), pos + 1, 64, an_item_imp.object_id)
				--    kMenuItemAttrSeparator = (1 << 6)
			else
				ret := insert_menu_item_text_with_cfstring_external (parent_item.c_object, string_to_cfstring(an_item_imp.text), pos + 1, 0, an_item_imp.object_id)
				-- Note: Menu indices start at 1 in Carbon
				ret := set_menu_item_command_id_external (parent_item.c_object, pos + 1, an_item_imp.object_id)
			end
			child_array.go_i_th (pos)
			child_array.put_left (an_item_imp.interface)

			--set_menu_item_hierarchical_menu (parent_item.item, ) ??
		end

	separator_imp_by_index (an_index: INTEGER): EV_MENU_SEPARATOR_IMP is
			-- Separator before item `an_index'.
		require
			an_index_within_bounds:
				an_index > 0 and then an_index <= interface.count
		do
		end

	is_menu_separator_imp (an_item_imp: EV_ITEM_I): BOOLEAN is
		local
			sep_imp: EV_MENU_SEPARATOR_IMP
		do
			sep_imp ?= an_item_imp
			Result := sep_imp /= Void
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

