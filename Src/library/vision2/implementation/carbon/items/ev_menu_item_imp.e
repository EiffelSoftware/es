indexing
	description: "Eiffel Vision menu item. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MENU_ITEM_IMP

inherit
	EV_MENU_ITEM_I
		redefine
			interface
		end

	EV_ITEM_IMP
		redefine
			interface,
			initialize,
			needs_event_box
		end

	EV_SENSITIVE_IMP
		redefine
			interface
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			set_text,
			accelerators_enabled
		end

	EV_MENU_ITEM_ACTION_SEQUENCES_IMP

	MENUS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is False

	is_dockable: BOOLEAN is False

	make (an_interface: like interface) is
			-- Create a menu.
		local
			ptr: POINTER
			ret: INTEGER
		do
			ret := create_new_menu_external (object_id, 0, $ptr) -- We use the unique object_id (-> IDENTIFIED) as menu id
			set_c_object(ptr)
		end

	initialize is
			-- Initialize `Current'
		do
		end

feature -- Element change

	string_to_cfstring (a_string: STRING_GENERAL): POINTER is
			--
		local
			c_str: C_STRING
			null_ptr: POINTER
		do
			create c_str.make (a_string)
			Result:= cfstring_create_with_cstring_external(null_ptr, c_str.item,  kCFStringEncodingASCII2)
		end

	frozen kCFStringEncodingASCII2: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCFStringEncodingASCII"
	end

	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		local
			ptr: POINTER
			ret: INTEGER
		do
			ptr := c_object
			ret := set_menu_title_with_cfstring_external (ptr, string_to_cfstring(a_text))
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	accelerators_enabled: BOOLEAN is True

	on_activate is
		do
		end

	interface: EV_MENU_ITEM;

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




end -- class EV_MENU_ITEM_IMP

