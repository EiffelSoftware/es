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
			show
		end

	EV_WINDOW_ACTION_SEQUENCES_IMP
		redefine
			interface
		end

	MACWINDOWS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the window.
		do
--			carbon_initialize -- needs to be here since initialize seems to be called twice...(why?)
		end

	initialize is
			-- Create the vertical box `vbox' and horizontal box `hbox'
			-- to put in the window.
			-- The `vbox' will be able to contain the menu bar, the `hbox'
			-- and the status bar.
			-- The `hbox' will contain the child of the window.
		do
			carbon_c_magic
			--create_window
			set_is_initialized (true)
		end

		create_window is
				-- 
			local
				the_window:OPAQUE_WINDOW_PTR_STRUCT
				window_attributes: INTEGER
				rect: RECT_STRUCT
				res: INTEGER
				ptr: POINTER
			do

				--Dimensionen setzten
				create rect.make_new_shared
				rect.set_bottom (200)
				rect.set_left (50)
				rect.set_right (200)
				rect.set_top (50)


				--Attribute: Dazu benötigt ihr die Konstanten. Wie läufts damit Jann?	
--				window_attributes:= ({MACWINDOWS_ANON_ENUMS}.kWindowStandardDocumentAttributes).bit_or({MACWINDOWS_ANON_ENUMS}.kWindowStandardHandlerAttribute).bit_or({MACWINDOWS_ANON_ENUMS}.kWindowInWindowMenuAttribute)
				
				--Window generieren: man achte auf $ptr.
--				res:=create_new_window_external({MACWINDOWS_ANON_ENUMS}.kDocumentWindowClass, window_attributes, rect.item, $ptr)
			--OPAQUE_WINDOW_PTR_STRUCT aus ptr generieren.
				create the_window.make_shared(ptr)

				show_window_external(the_window.item)
			end
	

		carbon_c_magic is
				--
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{	
					WindowRef theWindow;
					WindowAttributes windowAttrs;
					Rect contentRect = {45, 45, 245, 345};
				
					windowAttrs = kWindowStandardDocumentAttributes | kWindowStandardHandlerAttribute;
	
					CreateNewWindow (kDocumentWindowClass, windowAttrs, &contentRect, &theWindow);

					ShowWindow (theWindow);
					BringToFront (theWindow);
				}
			]"
		end

feature  -- Access

	has_focus: BOOLEAN is
			-- Does `Current' have the keyboard focus?
		do
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
		do
			-- Shouldn't this return a BOOLEAN?
		end

	show is
			-- Map the Window to the screen.
		do

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
		do
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
			ret := get_window_bounds_external(c_object, 33, a_rect.item)
			a_rect.set_right(a_rect.left + a_width)
			ret := set_window_bounds_external(c_object, 33, a_rect.item) -- kWindowContentRgn
		end

	set_height (a_height: INTEGER) is
			-- Set the vertical size to `a_height'.
		do
		end

	set_title (new_title: STRING_GENERAL) is
			-- Set `title' to `new_title'.
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{	
					WindowRef aWindow;
					aWindow = GetWindowList();
					SetWindowAlternateTitle(aWindow, "dongdong");
				}
			]"
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
		do
		end

feature {NONE} -- Implementation

	on_widget_mapped is
			-- `Current' has been mapped to the screen.
		do
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

