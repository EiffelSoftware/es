indexing
	description:
		"Eiffel Vision widget. Carbon implementation.%N%
		%See ev_widget.e"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_WIDGET_IMP

inherit
	EV_WIDGET_I
		redefine
			interface
		end

	EV_PICK_AND_DROPABLE_IMP
		redefine
			interface,
			initialize,
			call_button_event_actions,
			destroy,
			minimum_width,
			minimum_height,
			on_key_event,
			show
		end

	EV_SENSITIVE_IMP
		redefine
			interface
		end

	EV_COLORIZABLE_IMP
		redefine
			interface
		end

	EV_WIDGET_ACTION_SEQUENCES_IMP
		export
			{EV_INTERMEDIARY_ROUTINES}
				focus_in_actions_internal,
				focus_out_actions_internal,
				pointer_motion_actions_internal,
				pointer_button_release_actions,
				pointer_leave_actions,
				pointer_leave_actions_internal,
				pointer_enter_actions_internal
		redefine
			interface
		end

	EV_DOCKABLE_SOURCE_IMP
		redefine
			interface
		end

	CONTROLS_FUNCTIONS_EXTERNAL

feature {NONE} -- Initialization

	initialize is
			-- Show non window widgets.
			-- Initialize default options, colors and sizes.
		do
			Precursor {EV_PICK_AND_DROPABLE_IMP}
			internal_minimum_width := -1
			internal_minimum_height := -1
			set_is_initialized (True)
		end

	initialize_file_drop (a_widget: POINTER) is
		do
		end

feature {EV_WINDOW_IMP, EV_INTERMEDIARY_ROUTINES, EV_ANY_I} -- Implementation

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN) is
			-- Used for key event actions sequences.
		do
		end

	on_focus_changed (a_has_focus: BOOLEAN) is
			-- Called from focus intermediary agents when focus for `Current' has changed.
			-- if `a_has_focus' then `Current' has just received focus.
		do
		end

	on_pointer_enter_leave (a_pointer_enter: BOOLEAN) is
			-- Called from pointer enter leave intermediary agents when the mouse pointer either enters or leaves `Current'.
		do
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	call_button_event_actions (
			a_type: INTEGER;
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is
			-- Call pointer_button_press_actions or pointer_double_press_actions
			-- depending on event type in first position of `event_data'.
			--| GTK sends both GDK_BUTTON_PRESS and GDK_2BUTTON_PRESS events
			--| when a handler is attached to "button-press-event".
			--| We attach the signal to this switching feature to look at the
			--| event type and pass the event data to the appropriate action
			--| sequence.
		do
		end

feature {EV_APPLICATION_IMP} -- Implementation

	on_pointer_motion (a_motion_tuple: TUPLE [INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]) is
			-- Handle motion event for `Current'.
		do
		end

feature -- Access



	parent: EV_CONTAINER is
			-- Container widget that contains `Current'.
			-- (Void if `Current' is not in a container)
		local
			a_par_imp: EV_CONTAINER_IMP
		do
			a_par_imp := parent_imp
			if a_par_imp /= Void then
				Result := a_par_imp.interface
			end
		end

	pointer_position: EV_COORDINATE is
			-- Position of the screen pointer relative to `Current'.
		do
			create Result.set (1, 1)
		end

feature {EV_ANY_I, EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Position retrieval

	screen_x: INTEGER is
			-- Horizontal position of the client area on screen,
		do
		end

	screen_y: INTEGER is
			-- Vertical position of the client area on screen,
		do
		end

feature -- Status setting

	hide is
			-- Request that `Current' not be displayed even when its parent is.
		do
			hide_control_external(c_object)

		end

	show is
		do
			show_control_external(c_object)
		end


	is_show_requested: BOOLEAN is
			-- Will `Current' be displayed when its parent is?
			-- See also `is_displayed'

		do
			Result := true
		end

feature -- Element change

	set_minimum_width (a_minimum_width: INTEGER) is
			-- Set the minimum horizontal size to `a_minimum_width'.
		do
			internal_set_minimum_size (a_minimum_width, internal_minimum_height)
		end

	set_minimum_height (a_minimum_height: INTEGER) is
			-- Set the minimum vertical size to `a_minimum_height'.
		do
			internal_set_minimum_size (internal_minimum_width, a_minimum_height)
		end

	set_minimum_size (a_minimum_width, a_minimum_height: INTEGER) is
			-- Set the minimum horizontal size to `a_minimum_width'.
			-- Set the minimum vertical size to `a_minimum_height'.
		do
			internal_set_minimum_size (a_minimum_width, a_minimum_height)
		end

feature -- Measurement

	x_position: INTEGER is
			-- Horizontal offset relative to parent `x_position'.
			-- Unit of measurement: screen pixels.
		do
		end

	y_position: INTEGER is
			-- Vertical offset relative to parent `y_position'.
			-- Unit of measurement: screen pixels.
		do
		end

	minimum_width: INTEGER is
			-- Minimum width that the widget may occupy.
	do
		if internal_minimum_width /= -1 then
			Result := internal_minimum_width
		else
			Result := Precursor {EV_PICK_AND_DROPABLE_IMP}
		end
	end

	minimum_height: INTEGER is
			-- Minimum width that the widget may occupy.
	do
		if internal_minimum_height /= -1 then
			Result := internal_minimum_height
		else
			Result := Precursor {EV_PICK_AND_DROPABLE_IMP}
		end
	end

feature {EV_ANY_I} -- Implementation

	reset_minimum_size is
			-- Reset all values to defaults.
			-- Called by EV_FIXED and EV_VIEWPORT implementations.
		do
		end

	refresh_now is
			-- Flush any pending redraws due for `Current'.
		do
		end

feature {EV_FIXED_IMP, EV_VIEWPORT_IMP} -- Implementation

	store_minimum_size is
			-- Called when size is explicitly set, ie: from fixed or viewport
		do
		end

	internal_minimum_width: INTEGER
			-- Minimum width for the widget.

	internal_minimum_height: INTEGER
			-- Minimum height for the widget.

feature {EV_WINDOW_IMP} -- Implementation

	default_key_processing_blocked (a_key: EV_KEY): BOOLEAN is
			-- Used for drawing area to keep focus on all keys.
		do
		end

feature {EV_CONTAINER_IMP} -- Implementation

	set_parent_imp (a_container_imp: EV_CONTAINER_IMP) is
			-- Set `parent_imp' to `a_container_imp'.
		do
			parent_imp := a_container_imp
		end

feature {EV_ANY_IMP, EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Implementation

	destroy is
			do
				app_implementation.dispose_id (id)
			end

	parent_imp: EV_CONTAINER_IMP
			-- Container widget that contains `Current'.
			-- (Void if `Current' is not in a container)

feature {EV_DOCKABLE_SOURCE_I} -- Implementation

	top_level_window_imp: EV_WINDOW_IMP is
			-- Window implementation that `Current' is contained within (if any)
		do
		end

	top_level_window: EV_WINDOW is
			-- Window the current is contained within (if any)
		do
		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation

	on_widget_mapped is
			-- `Current' has been mapped on to the screen.
		do
		end

feature {NONE} -- Implementation

	internal_set_minimum_size (a_minimum_width, a_minimum_height: INTEGER) is
			-- Abstracted implementation for minimum size setting.
		do
			if a_minimum_width /= -1 then
				internal_minimum_width := a_minimum_width
			end
			if a_minimum_height /= -1 then
				internal_minimum_height := a_minimum_height
			end
		end

	propagate_foreground_color_internal (a_color: EV_COLOR; a_c_object: POINTER) is
			-- Propagate `a_color' to the foreground color of `a_c_object's children.
		do
		end

	propagate_background_color_internal (a_color: EV_COLOR; a_c_object: POINTER) is
			-- Propagate `a_color' to the background color of `a_c_object's children.
		do
		end

	last_width, last_height: INTEGER
			-- Dimenions during last "size-allocate".

	in_resize_event: BOOLEAN
			-- Is `interface.resize_actions' being executed?

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	interface: EV_WIDGET;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_WIDGET_IMP

