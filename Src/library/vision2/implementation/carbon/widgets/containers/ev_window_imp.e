indexing
	description: "Eiffel Vision window. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_WINDOW_IMP

inherit
	EV_WINDOW_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CONTAINER_IMP
		undefine
			replace,
			x_position,
			y_position,
			screen_x,
			screen_y,
			width,
			height,
			is_parentable,
			show
		redefine
			interface,
			initialize,
			make,
			on_key_event,
			on_size_allocate,
			hide,
			internal_set_minimum_size,
			on_widget_mapped,
			destroy,
			has_focus,
			on_focus_changed
		end

	EV_GTK_WINDOW_IMP
		undefine
			initialize,
			destroy,
			parent_imp,
			minimum_width,
			minimum_height
		redefine
			interface,
			on_key_event,
			has_focus,
			show,
			set_size
		end

	EV_WINDOW_ACTION_SEQUENCES_IMP
		redefine
			interface
		end

	QUICKDRAW_FUNCTIONS_EXTERNAL
	MACWINDOWS_FUNCTIONS_EXTERNAL
	PROCESSES_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL
	CONTROLS_FUNCTIONS_EXTERNAL
	CFSTRING_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the window.
			local
					window_attributes: INTEGER
					rect: RECT_STRUCT
					res: INTEGER
					ptr: POINTER
					root_control_ptr : POINTER
					target: POINTER
			do
					base_make (an_interface)
					create rect.make_new_shared

					rect.set_bottom (46)
					rect.set_left (45)
					rect.set_right (46)
					rect.set_top (45)
					window_attributes:= ({MACWINDOWS_ANON_ENUMS}.kwindowstandardfloatingattributes).bit_or({MACWINDOWS_ANON_ENUMS}.kwindowstandardhandlerattribute).bit_or({MACWINDOWS_ANON_ENUMS}.kwindowinwindowmenuattribute)
					res:=create_new_window_external({MACWINDOWS_ANON_ENUMS}.kdocumentwindowclass, window_attributes, rect.item, $ptr)
					res := create_root_control_external( ptr, $root_control_ptr )
					set_c_object (ptr)
					allow_resize
					id:=app_implementation.get_id (current)  --getting an id from the application

			end

	initialize is
			-- Create the vertical box `vbox' and horizontal box `hbox'
			-- to put in the window.
			-- The `vbox' will be able to contain the menu bar, the `hbox'
			-- and the status bar.
			-- The `hbox' will contain the child of the window.
		local

			app_imp: like app_implementation

			l_c_object: POINTER
		do
			set_is_initialized (False)
			l_c_object := c_object
			create upper_bar
			create lower_bar

			maximum_width := interface.maximum_dimension
			maximum_height := interface.maximum_dimension
			app_imp := app_implementation
			--l_gtk_marshal := app_imp.gtk_marshal

			--signal_connect_true (app_imp.delete_event_string, agent (l_gtk_marshal).on_window_close_request (l_c_object))
			initialize_client_area

			default_height := -1
			default_width := -1

			--on_key_event_intermediary_agent := agent (l_gtk_marshal).on_key_event_intermediary (internal_id, ?, ?, ?)
			--signal_connect (l_c_object, app_imp.key_press_event_string, on_key_event_intermediary_agent, key_event_translate_agent, False)
			--signal_connect (l_c_object, app_imp.key_release_event_string, on_key_event_intermediary_agent, key_event_translate_agent, False)

			--signal_connect (l_c_object, app_imp.set_focus_event_string, agent (l_gtk_marshal).on_set_focus_event_intermediary (internal_id, ?), set_focus_event_translate_agent, True)
				-- Used to propagate focus events between internal gtk widgets.

			--signal_connect (l_c_object, app_imp.focus_in_event_string, agent (l_gtk_marshal).window_focus_intermediary (internal_id, True), Void, True)
			--signal_connect (l_c_object, app_imp.focus_out_event_string, agent (l_gtk_marshal).window_focus_intermediary (internal_id, False), Void, True)
				--Used to handle explicit Window focus handling.

			--signal_connect (l_c_object, app_imp.configure_event_string, agent (l_gtk_marshal).on_size_allocate_intermediate (internal_id, ?, ?, ?, ?), configure_translate_agent, False)

			--{EV_GTK_EXTERNALS}.gtk_window_set_default_size (l_c_object, 1, 1)
			Precursor {EV_CONTAINER_IMP}
				-- Need to set decorations after window is realized.
			--{EV_GTK_EXTERNALS}.gdk_window_set_decorations ({EV_GTK_EXTERNALS}.gtk_widget_struct_window (c_object), default_wm_decorations)
			internal_is_border_enabled := True
			user_can_resize := True
			set_is_initialized (True)


		end


		carbon_foreground is
				local
					psn: PROCESS_SERIAL_NUMBER_STRUCT
					ret: INTEGER
				do
					create psn.make_new_unshared
					ret:= get_current_process_external(psn.item)
					ret:=transform_process_type_external(psn.item,1)
					ret:=set_front_process_external(psn.item)
				end

feature  -- Access

	has_focus: BOOLEAN is
			-- Does `Current' have the keyboard focus?
		local
			the_window:OPAQUE_WINDOW_PTR_STRUCT
		do
			create the_window.make_shared(c_object)
			Result := (is_window_active_external (the_window.item)/=0)
		end

	item: EV_WIDGET
			-- Current item.

	width: INTEGER is
			-- Horizontal size measured in pixels.
		do
		end

	height: INTEGER is
			-- Vertical size measured in pixels.
		do
		end

 	maximum_width: INTEGER
			-- Maximum width that application wishes widget
			-- instance to have.

	maximum_height: INTEGER
			-- Maximum height that application wishes widget
			-- instance to have.

	title: STRING_32 is
			-- Application name to be displayed by
			-- the window manager.
		do
		end

	menu_bar: EV_MENU_BAR
			-- Horizontal bar at top of client area that contains menu's.

feature -- Status setting

	internal_disable_border is
			-- Ensure no border is displayed around `Current'.
		do
		end

	internal_enable_border is
			-- Ensure a border is displayed around `Current'.
		do
		end

	frozen gdk_window_get_decorations (a_window: POINTER; a_decorations: TYPED_POINTER [INTEGER]): BOOLEAN is
			-- Retrieve set decorations for `a_window'.
		do
		end

	block is
			-- Wait until window is closed by the user.
		do
		end

	allow_resize is
			-- Allow the resize of the window.
		local
			the_window: OPAQUE_WINDOW_PTR_STRUCT
			res: INTEGER
		do
			create the_window.make_shared(c_object)
			res:=change_window_attributes_external(the_window.item, {MACWINDOWS_ANON_ENUMS}.kwindowresizableattribute, {MACWINDOWS_ANON_ENUMS}.kwindownoattributes)
			internal_enable_border
		end

	show is
			-- Map the Window to the screen.
		do
			if not is_show_requested then
				call_show_actions := True
				--Precursor {EV_GTK_WINDOW_IMP}


				is_positioned := True
			end
			if blocking_window /= Void then
				set_blocking_window (Void)
			end
			show_window_external(c_object)

			carbon_foreground
		end

	is_positioned: BOOLEAN
		-- Has the Window been previously positioned on screen?

	call_show_actions: BOOLEAN
		-- Should the show actions be called?

	hide is
			-- Unmap the Window from the screen.
		do
		end

feature -- Element change


	replace (v: like item) is
			-- Replace `item' with `v'.
		local
			w: EV_WIDGET_IMP
			i: EV_WIDGET
			root_control_ptr : POINTER
			err : INTEGER
			a_fixe: EV_FIXED_IMP
		do
			i := item

			if i /= Void then
				w ?= i.implementation
				on_removed_item (w)
				check
					item_has_implementation: w /= Void
				end
				dispose_control_external(w.c_object )
			end
			if v /= Void then
				w ?= v.implementation
				err := get_root_control_external ( c_object, $root_control_ptr )
				err := embed_control_external ( w.c_object, root_control_ptr )

				on_new_item (w)
				a_fixe?=v.implementation
				if a_fixe/=void then
					a_fixe.embed_all
				end
			end
			item := v
		end

	set_maximum_width (max_width: INTEGER) is
			-- Set `maximum_width' to `max_width'.
		do
		end

	set_maximum_height (max_height: INTEGER) is
			-- Set `maximum_height' to `max_height'.
		do
		end

	set_width (a_width: INTEGER) is
			-- Set the horizontal size to `a_width'.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_shared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)
			a_rect.set_right(a_rect.left + a_width)
			ret := set_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item) -- kWindowContentRgn
		end

	set_height (a_height: INTEGER) is
			-- Set the vertical size to `a_height'.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_shared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)

			a_rect.set_bottom(a_rect.top + a_height)
			ret := set_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item) -- kWindowContentRgn
		end

		set_size (a_width, a_height: INTEGER) is
			-- Set the horizontal size to `a_width'.
			-- Set the vertical size to `a_height'.
		do
			set_width(a_width)
			set_height(a_height)
		end


	set_title (new_title: STRING_GENERAL) is
			-- Set `title' to `new_title'.
			local
			c_str: C_STRING
			ptr: POINTER
			res: INTEGER
		do

			create c_str.make (new_title)
			ptr:=c_string_to_cfstring_ptr(c_str)
			res:=set_window_title_with_cfstring_external (c_object, ptr)
		--	res:=set_control_title_with_cfstring_external (c_object, ptr)


		end

	c_string_to_cfstring_ptr(c_str: C_STRING):POINTER is
			local
				null_ptr:POINTER
			do
				Result:= cfstring_create_with_cstring_external(null_ptr, c_str.item,  kCFStringEncodingASCII)
			end

	frozen kCFStringEncodingASCII: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCFStringEncodingASCII"
	end





	set_menu_bar (a_menu_bar: EV_MENU_BAR) is
			-- Set `menu_bar' to `a_menu_bar'.
		do
		end

	remove_menu_bar is
			-- Set `menu_bar' to `Void'.
		do
		end

feature {EV_ANY_IMP} -- Implementation

	destroy is
			-- Destroy `Current'
			-- 19.6.2006 Ueli
		do
			disable_capture
			hide
			Precursor {EV_CONTAINER_IMP}
		end

feature {NONE} -- Implementation

	on_widget_mapped is
			-- `Current' has been mapped to the screen.
			-- 19.6.06 Ueli
		do
			if show_actions_internal /= Void and call_show_actions then
				show_actions_internal.call (Void)
			end
			call_show_actions := False
		end

	internal_set_minimum_size (a_minimum_width, a_minimum_height: INTEGER) is
			-- Set the minimum horizontal size to `a_minimum_width'.
			-- Set the minimum vertical size to `a_minimum_height'.
		do
		end

	on_size_allocate (a_x, a_y, a_width, a_height: INTEGER) is
			-- Gtk_Widget."size-allocate" happened.
		do
		end

	previously_focused_widget: POINTER
		-- Widget that was previously focused within `Current'.

	set_focused_widget (a_widget: EV_WIDGET_IMP) is
			-- Set currently focused widget to `a_widget'.
		do
		end

	on_focus_changed (a_has_focus: BOOLEAN) is
			-- Called from focus intermediary agents when focus for `Current' has changed.
			-- if `a_has_focus' then `Current' has just received focus.
		do
			if a_has_focus then
				on_set_focus_event (get_user_focus_window_external)
			else
				on_set_focus_event (default_pointer)
			end
			Precursor {EV_CONTAINER_IMP} (a_has_focus)
		end

	previous_x_position, previous_y_position: INTEGER
		-- Positions of previously set x and y coordinates of `Current'.

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN) is
			-- Used for key event actions sequences.
		do
		end

	client_area: POINTER is
			-- Pointer to the widget that is treated as the main holder of the client area within the window.
		do
		end

	initialize_client_area is
			-- Initialize the client area of 'Current'.
		do
		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation

	on_set_focus_event (a_widget_ptr: POINTER) is
			-- The focus of a widget has changed within `Current'.
		do
		end

feature {EV_ACCELERATOR_IMP} -- Implementation

	vbox: POINTER
			-- Vertical_box to have a possibility for a menu on the
			-- top and a status bar at the bottom.

feature {EV_INTERMEDIARY_ROUTINES}

	call_close_request_actions is
			-- Call the close request actions.
		do
		end

feature {EV_CLIPBOARD_IMP} -- Implementation

	hbox: POINTER
			-- Horizontal box for the child.

feature {EV_ANY_I} -- Implementation

	interface: EV_WINDOW;
		-- Interface object of `Current'

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




end -- class EV_WINDOW_IMP

