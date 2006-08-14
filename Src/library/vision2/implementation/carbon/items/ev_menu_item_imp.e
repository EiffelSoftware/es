indexing
	description: "Eiffel Vision menu item. Carbon implementation."

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
			text,
			accelerators_enabled
		end

	EV_MENU_ITEM_ACTION_SEQUENCES_IMP

	MENUS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

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
			target, h_ret: POINTER
		do
			base_make (an_interface)
			ret := create_new_menu_external (object_id, 0, $ptr) -- We use the unique object_id (-> IDENTIFIED) as menu id
			set_c_object(ptr)

			id := app_implementation.get_id (current)  -- getting an id from the application
			target := get_menu_event_target_external (c_object)
			h_ret := app_implementation.install_event_handler (id, target, {carbonevents_anon_enums}.kEventClassCommand, {carbonevents_anon_enums}.kEventCommandProcess)
		end

	initialize is
			-- Initialize `Current'
		do
			Precursor {EV_ITEM_IMP}
			textable_imp_initialize
		end

feature -- Element change

	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		local
			ptr: POINTER
			ret: INTEGER
			t: STRING
			i: INTEGER
		do
			-- Get rid of the & sign which denotes a shortcut key
			t := a_text.as_string_8
			i := t.substring_index ("&", 1)
			if i /= 0 then
				t := t.substring (1, i - 1) + t.substring (i + 1, t.count)
			end

			ptr := c_object
			ret := set_menu_title_with_cfstring_external (ptr, string_to_cfstring(t))
			text := a_text
		end

	text: STRING_32

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	accelerators_enabled: BOOLEAN is True

	on_activate is
		do
		end

	interface: EV_MENU_ITEM;

indexing
	copyright:	"Copyright (c) 2006, Eiffel.Mac Team"
end -- class EV_MENU_ITEM_IMP

