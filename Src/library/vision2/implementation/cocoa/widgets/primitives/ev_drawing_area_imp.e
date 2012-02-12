note
	description: "EiffelVision drawing area. Cocoa implementation."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_DRAWING_AREA_IMP

inherit
	EV_DRAWING_AREA_I
		redefine
			interface
		select
			copy
		end

	EV_DRAWABLE_IMP
		undefine
			old_make,
			is_flipped
		redefine
			interface,
			make,
			prepare_drawing,
			finish_drawing
		end

	EV_PRIMITIVE_IMP
		undefine
			foreground_color_internal,
			background_color_internal,
			set_foreground_color,
			set_background_color
		redefine
			interface,
			make,
			dispose
		end

	EV_DRAWING_AREA_ACTION_SEQUENCES_IMP
		redefine
			interface
		end

	EV_FLIPPED_VIEW
		rename
			copy as copy_cocoa
		undefine
			is_equal
		redefine
			make,
			dispose,
			mouse_down_,
			mouse_up_,
			mouse_moved_,
			accepts_first_responder,
			become_first_responder,
			resign_first_responder,
			draw_rect_
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'
		do
			Precursor {EV_DRAWABLE_IMP}
			add_objc_callback ("mouseDown:", agent mouse_down_)
			add_objc_callback ("mouseUp:", agent mouse_up_)
			add_objc_callback ("mouseMoved:", agent mouse_moved_)
			add_objc_callback ("acceptsFirstResponder", agent accepts_first_responder)
			add_objc_callback ("becomeFirstResponder:", agent become_first_responder)
			add_objc_callback ("resignFirstResponder:", agent resign_first_responder)
			add_objc_callback ("drawRect:", agent draw_rect_)
			Precursor {EV_FLIPPED_VIEW}
			set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := Current
			Precursor {EV_PRIMITIVE_IMP}
			initialize_events
			disable_tabable_from
		end

feature -- Status setting

	redraw
			-- Redraw the entire area.
		do
			set_needs_display_ (True)
		end

	redraw_rectangle (a_x, a_y, a_width, a_height: INTEGER)
			-- Redraw the rectangle area defined by `a_x', `a_y', `a_width', a_height'.
		do
			-- Redraw the whole rectangle until the implementation of EV_GRID_I works properly
			set_needs_display_ (True)
		end

	clear_and_redraw
			-- Clear `Current' and redraw.
		do
			clear
			redraw
		end

	clear_and_redraw_rectangle (a_x, a_y, a_width, a_height: INTEGER)
			-- Clear the rectangle area defined by `a_x', `a_y', `a_width', `a_height' and then redraw it.
		do
			clear_rectangle (a_x, a_y, a_width, a_height)
			redraw_rectangle (a_x, a_y, a_width, a_height)
		end

	flush
			-- Redraw the screen immediately, if change actions have been requested
		do
			if is_displayed then
				refresh_now
			end
		end

	prepare_drawing
		local
			l_color: detachable EV_COLOR_IMP
		do
			if not lock_focus_if_can_draw then
				image.lock_focus
				is_drawing_buffered := True
			else
				is_drawing_buffered := False
			end
			l_color ?= foreground_color.implementation
			check l_color /= void end
			l_color.color.set
		end


	finish_drawing
		do
			if is_drawing_buffered then
				image.unlock_focus
			else
				unlock_focus
			end
		end

feature {NONE} -- Implementation

	mouse_down_ (a_event: NS_EVENT)
		-- Call pointer_button_press_actions or pointer_double_press_actions
		-- depending on the number of clicks of `a_event'. When executing a
		-- double click, pointer_button_press_actions is also executed first.
		-- We assume the behavior of the single click is complementary to the
		-- one of the double click
		local
			pointer_button_action: TUPLE [x: INTEGER; y: INTEGER; button: INTEGER; x_tilt: DOUBLE; y_tilt: DOUBLE; pressure: DOUBLE; screen_x: INTEGER; screen_y: INTEGER]
			point: NS_POINT
			actions: detachable EV_POINTER_BUTTON_ACTION_SEQUENCE
		do
			if a_event.click_count = 1 then
				actions := pointer_button_press_actions_internal
			else -- if click_count >= 2
				actions := pointer_double_press_actions_internal
			end
			if attached actions then
				create pointer_button_action
				point := convert_point__from_view_ (a_event.location_in_window, Void)
				pointer_button_action.x := point.x.rounded
				pointer_button_action.y := point.y.rounded
				point := a_event.window.convert_base_to_screen_ (a_event.location_in_window)
				pointer_button_action.screen_x := point.x.rounded
				pointer_button_action.screen_y := point.y.rounded
				pointer_button_action.button :=	a_event.button_number.to_integer_32 + 1
				actions.call (pointer_button_action)
			end
		end

	mouse_up_ (a_event: NS_EVENT)
		local
			pointer_button_action: TUPLE [x: INTEGER; y: INTEGER; button: INTEGER; x_tilt: DOUBLE; y_tilt: DOUBLE; pressure: DOUBLE; screen_x: INTEGER; screen_y: INTEGER]
			point: NS_POINT
		do
			if attached pointer_button_release_actions_internal as actions then
				create pointer_button_action
				if attached {NS_VIEW} a_event.window.content_view as l_content_view then
					point := l_content_view.convert_point__to_view_ (a_event.location_in_window, cocoa_view)
					pointer_button_action.x := point.x.rounded
					pointer_button_action.y := point.y.rounded
					point := a_event.window.convert_base_to_screen_ (a_event.location_in_window)
					pointer_button_action.screen_x := point.x.rounded
					pointer_button_action.screen_y := point.y.rounded
					pointer_button_action.button :=	a_event.button_number.to_integer_32 + 1
					actions.call (pointer_button_action)
				end
			end
		end

	mouse_moved_ (a_event: NS_EVENT)
			-- Translate a Cocoa mouseMoved NS_EVENT to a pointer_motion_action call
		local
			pointer_motion_action: TUPLE [x: INTEGER; y: INTEGER; x_tilt: DOUBLE; y_tilt: DOUBLE; pressure: DOUBLE; screen_x: INTEGER; screen_y: INTEGER]
			point: NS_POINT
		do
			if attached pointer_motion_actions_internal as actions then
				create pointer_motion_action
				if attached {NS_VIEW} a_event.window.content_view as l_content_view then
					point := l_content_view.convert_point__to_view_ (a_event.location_in_window, cocoa_view)
					pointer_motion_action.x := point.x.rounded
					pointer_motion_action.y := point.y.rounded
					point := a_event.window.convert_base_to_screen_ (a_event.location_in_window)
					pointer_motion_action.screen_x := point.x.rounded
					pointer_motion_action.screen_y := point.y.rounded
					actions.call (pointer_motion_action)
				end
			end
		end

	accepts_first_responder: BOOLEAN
			-- Every (sensitive?) Vision2 widget must be able to accept key events
		do
			Result := is_sensitive
		end

	become_first_responder: BOOLEAN
			-- Call the focus_in actions
		do
			if attached focus_in_actions_internal as actions then
				actions.call ([])
			end
			Result := True -- always accept first responder status
		end

	resign_first_responder: BOOLEAN
			-- Call the focus_out actions
		do
			if attached focus_out_actions_internal as actions then
				actions.call ([])
			end
			Result := True -- always resign first responder status
		end

feature -- Implementation

	is_drawing_buffered: BOOLEAN

	update_if_needed
		do
			set_needs_display_ (True)
		end

	draw_rect_ (a_dirty_rect: NS_RECT)
			-- Draw callback
		do
			if expose_actions_internal /= Void then
				expose_actions_internal.call ([
					a_dirty_rect.origin.x.rounded,
					a_dirty_rect.origin.y.rounded,
					a_dirty_rect.size.width.rounded,
					a_dirty_rect.size.height.rounded
					])
			end
		end

feature {EV_ANY_I} -- Implementation

	dispose
		do
			Precursor {EV_FLIPPED_VIEW}
			Precursor {EV_PRIMITIVE_IMP}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_DRAWING_AREA note option: stable attribute end;

end -- class EV_DRAWING_AREA_IMP
