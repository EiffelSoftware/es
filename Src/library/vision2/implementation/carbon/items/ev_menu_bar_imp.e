indexing
	description: "Eiffel Vision menu bar. GTK+ implementation."

class
	EV_MENU_BAR_IMP

inherit
	EV_MENU_BAR_I
		redefine
			interface
		end

	EV_MENU_ITEM_LIST_IMP
		export
			{EV_WINDOW_IMP}
				list_widget
		redefine
			interface,
			insert_menu_item
		end

	CFSTRING_FUNCTIONS_EXTERNAL
	MENUS_FUNCTIONS_EXTERNAL


create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is False

	make (an_interface: like interface) is
		do
		end

feature {EV_WINDOW_IMP} -- Implementation

	set_parent_window_imp (a_wind: EV_WINDOW_IMP) is
			-- Set `parent_window' to `a_wind'.
		require
			a_wind_not_void: a_wind /= Void
		do
		end

	parent: EV_WINDOW is
			-- Parent window of Current.
		do
		end

	remove_parent_window is
			-- Set `parent_window' to Void.
		do
		end

	parent_imp: EV_WINDOW_IMP

feature {NONE} -- Implementation

	insert_menu_item (an_item_imp: EV_MENU_ITEM_IMP; pos: INTEGER) is
			-- Generic menu item insertion.
		local
			ptr: POINTER
			ret: INTEGER
		do
			ptr := an_item_imp.c_object
			insert_menu_external (ptr, 0)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_MENU_BAR;

indexing
	copyright:	"Copyright (c) 2006, the ETH Eiffel.Mac Team"

end -- class EV_MENU_BAR_IMP

