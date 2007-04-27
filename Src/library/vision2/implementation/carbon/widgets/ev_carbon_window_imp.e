indexing
	description: "Objects that ..."

deferred class
	EV_CARBON_WINDOW_IMP

inherit
	EV_CARBON_WIDGET_IMP
		undefine
			width,
			height
		redefine
			show
		end

	MACWINDOWS_FUNCTIONS_EXTERNAL

feature {NONE} -- Agent functions.

	key_event_translate_agent: FUNCTION [EV_GTK_CALLBACK_MARSHAL, TUPLE [INTEGER, POINTER], TUPLE] is
			-- Translation agent used for key events
		once
		end

	set_focus_event_translate_agent: FUNCTION [EV_GTK_CALLBACK_MARSHAL, TUPLE [INTEGER, POINTER], TUPLE] is
			-- Translation agent used for set-focus events
		once
		end

feature {NONE} -- Implementation

	parent_imp: EV_CONTAINER_IMP is
			-- Parent of `Current', always Void as windows cannot be parented
		do
		end

	set_blocking_window (a_window: EV_WINDOW) is
			-- Set as transient for `a_window'.
		do

		end

	blocking_window: EV_WINDOW is
			-- Window this dialog is a transient for.
		do
		end

	internal_blocking_window: EV_WINDOW
			-- Window that `Current' is relative to.
			-- Implementation

	set_size (a_width, a_height: INTEGER) is
			-- Set the horizontal size to `a_width'.
			-- Set the vertical size to `a_height'.
		do
			set_width ( a_width )
			set_height ( a_height )
		end

	width: INTEGER is
			-- Horizontal size measured in pixels.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)
			Result := ( a_rect.right - a_rect.left ).abs
		end

	height: INTEGER is
			-- Vertical size measured in pixels.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)
			Result := ( a_rect.bottom - a_rect.top ).abs
		end

	set_width (a_width: INTEGER) is
			-- Set the horizontal size to `a_width'.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
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
			create a_rect.make_new_unshared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)

			a_rect.set_bottom(a_rect.top + a_height)
			ret := set_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item) -- kWindowContentRgn
		end

	default_width, default_height: INTEGER
			-- Default width and height for the window if set, -1 otherwise.
			-- (see. `gtk_window_set_default_size' for more information)

	x_position: INTEGER is
			-- X coordinate of `Current'
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)
			Result := a_rect.left
		end

	y_position: INTEGER is
			-- Y coordinate of `Current'
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := get_window_bounds_external(c_object, {MACWINDOWS_ANON_ENUMS}.kwindowcontentrgn, a_rect.item)
			Result := a_rect.top
		end

	set_x_position (a_x: INTEGER) is
			-- Set horizontal offset to parent to `a_x'.
		local
			a_rect: RECT_STRUCT
			ret: INTEGER
		do
			positioned_by_user := True
			move_window_external(c_object, a_x, x_position, 0)
		end

	set_y_position (a_y: INTEGER) is
			-- Set vertical offset to parent to `a_y'.
		do
			positioned_by_user := True
			move_window_external(c_object, y_position, a_y, 0)
		end

	set_position (a_x, a_y: INTEGER) is
			-- Set horizontal offset to parent to `a_x'.
			-- Set vertical offset to parent to `a_y'.
		do
			positioned_by_user := True
			move_window_external(c_object, a_x, a_y, 0)
		end

	positioned_by_user: BOOLEAN
		-- Has `Current' been positioned by the user?

	screen_x: INTEGER is
			-- Horizontal position of the window on screen,
		do
		end

	screen_y: INTEGER is
			-- Vertical position of the window on screen,
		do
		end

	default_wm_decorations: INTEGER is
			-- Default WM decorations of `Current'.
		do
		end

	show is
			-- Request that `Current' be displayed when its parent is.
		do
		end

feature {EV_ANY_I} -- Implementation

	enable_modal is
			-- Set `is_modal' to `True'.
		do
		end

	disable_modal is
			-- Set `is_modal' to `False'.
		do
		end

	is_modal: BOOLEAN is
			-- Must the window be closed before application continues?
		do
		end

	forbid_resize is
			-- Forbid the resize of the window.
		do
		end

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end
