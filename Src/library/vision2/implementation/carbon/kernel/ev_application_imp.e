indexing
	description:
		"EiffelVision application, Carbon implementation."
	legal: "See notice at end of class."

class
	EV_APPLICATION_IMP

inherit
	EV_APPLICATION_I
			export
--				{EV_PICK_AND_DROPABLE_IMP}
--					captured_widget
				{EV_INTERMEDIARY_ROUTINES}
					pointer_motion_actions_internal,
					pointer_button_press_actions_internal,
					pointer_double_press_actions_internal,
					pointer_button_release_actions_internal
			end

	--EV_GTK_DEPENDENT_APPLICATION_IMP

	--EV_GTK_EVENT_STRINGS

--	IDENTIFIED
--		undefine
--			is_equal,
--			copy
--		end
--
	EV_APPLICATION_ACTION_SEQUENCES_IMP
--
--	EXECUTION_ENVIRONMENT
--		rename
--			launch as ee_launch
--		end
--
--	PLATFORM


	EXCEPTIONS

	PROCESSES_FUNCTIONS_EXTERNAL

	CARBONEVENTSCORE_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Set up the callback marshal and initialize GTK+.
		do
		end

feature {NONE} -- Event loop

	 launch is
			-- Display the first window, set up the post_launch_actions,
			-- and start the event loop.
		do
			from
				enable_foreground_operation
			until
				is_destroyed
			loop
				c_event_loop_iteration
			end
		end

	enable_foreground_operation is
			-- Transform the application into a foreground process with manubar and Dock icon
		local
			psn: PROCESS_SERIAL_NUMBER_STRUCT
			ret: INTEGER
		do
			create psn.make_new_shared
			ret := get_current_process_external(psn.item)
			ret := transform_process_type_external(psn.item, 1)
			--ret := set_front_process_external(psn.item)
		end

feature {EV_ANY_IMP} -- Implementation

	carbon_event_pending: BOOLEAN is
		local
			event: OPAQUE_EVENT_REF_STRUCT
			ret: INTEGER
		do
--			create event.make_new_shared
--			ret := receive_next_event_external(0, Void, 1, 1, event)
--			Result := (ret = 0) -- noErr
		end


	c_event_loop_iteration is
			--
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{	
					EventRef theEvent;
					EventTargetRef theTarget;
					
					theTarget = GetEventDispatcherTarget();
					
					if (ReceiveNextEvent(0, NULL, 1, true, &theEvent) == noErr) {
						SendEventToEventTarget(theEvent, theTarget);
						ReleaseEvent(theEvent);
					}
				}
			]"
		end

	event_loop_iteration (a_relinquish_cpu: BOOLEAN) is
		local
			ret: INTEGER
		do
			ret := run_current_event_loop_external (0.01)
		end

feature -- Access

	ctrl_pressed: BOOLEAN is
			-- Is ctrl key currently pressed?
		do
		end

	alt_pressed: BOOLEAN is
			-- Is alt key currently pressed?
		do
		end

	shift_pressed: BOOLEAN is
			-- Is shift key currently pressed?
		do
		end

	window_oids: LINKED_LIST [INTEGER]
			-- Global list of window object ids.

	windows: LINEAR [EV_WINDOW] is
			-- Global list of windows.
		do
		end

feature -- Basic operation

	process_events_until_stopped is
			-- Process all events until one event is received
			-- by `widget'.
		do
		end

	process_events is
			-- Process all pending events and redraws.
		do
		end

	stop_processing is
			-- Exit `process_events_until_stopped'.
		do
		end

	motion_tuple: TUPLE [INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER] is
			-- Tuple optimizations
		once
		end

	process_button_event (a_gdk_event: POINTER) is
			-- Process button event `a_gdk_event'.
		require
			a_gdkevent_not_null: a_gdk_event /= default_pointer
		do
		end

	process_gdk_events is
			-- Process all current GDK events
		do
		end

	handle_dnd (a_event: POINTER) is
			-- Handle drag and drop event.
		do
		end


	GDK_NOTHING: INTEGER is -1
	GDK_DELETE: INTEGER is 0
	GDK_DESTROY: INTEGER is 1
	GDK_EXPOSE: INTEGER is 2
	GDK_MOTION_NOTIFY: INTEGER is 3
	GDK_BUTTON_PRESS: INTEGER is 4
	GDK_2BUTTON_PRESS : INTEGER is 5
	GDK_3BUTTON_PRESS: INTEGER is 6
	GDK_BUTTON_RELEASE: INTEGER is 7
	GDK_KEY_PRESS: INTEGER is 8
	GDK_KEY_RELEASE: INTEGER is 9
	GDK_ENTER_NOTIFY: INTEGER is 10
	GDK_LEAVE_NOTIFY: INTEGER is 11
	GDK_FOCUS_CHANGE: INTEGER is 12
	GDK_CONFIGURE: INTEGER is 13
	GDK_MAP: INTEGER is 14
	GDK_UNMAP: INTEGER is 15
	GDK_PROPERTY_NOTIFY: INTEGER is 16
	GDK_SELECTION_CLEAR: INTEGER is 17
	GDK_SELECTION_REQUEST: INTEGER is 18
	GDK_SELECTION_NOTIFY: INTEGER is 19
	GDK_PROXIMITY_IN: INTEGER is 20
	GDK_PROXIMITY_OUT: INTEGER is 21
	GDK_DRAG_ENTER: INTEGER is 22
	GDK_DRAG_LEAVE: INTEGER is 23
	GDK_DRAG_MOTION: INTEGER is 24
	GDK_DRAG_STATUS: INTEGER is 25
	GDK_DROP_START: INTEGER is 26
	GDK_DROP_FINISHED : INTEGER is 27
	GDK_CLIENT_EVENT: INTEGER is 28
	GDK_VISIBILITY_NOTIFY: INTEGER is 29
	GDK_NO_EXPOSE: INTEGER is 30
	GDK_SCROLL: INTEGER is 31
	GDK_WINDOW_STATE: INTEGER is 32
	GDK_SETTING: INTEGER is 33
	GDK_OWNER_CHANGE: INTEGER is 34
		-- GDK Event Type Constants

	sleep (msec: INTEGER) is
			-- Wait for `msec' milliseconds and return.
		do
		end

	destroy is
			-- End the application.
		do
		end

feature -- Status report

	tooltip_delay: INTEGER
			-- Time in milliseconds before tooltips pop up.

feature -- Status setting

	set_tooltip_delay (a_delay: INTEGER) is
			-- Set `tooltip_delay' to `a_delay'.
		do
		end

feature {EV_PICK_AND_DROPABLE_IMP} -- Pick and drop

	on_pick (a_pebble: ANY) is
			-- Called by EV_PICK_AND_DROPABLE_IMP.start_transport
		do
		end

	on_drop (a_pebble: ANY) is
			-- Called by EV_PICK_AND_DROPABLE_IMP.end_transport
		do
		end

feature {EV_ANY_IMP} -- Implementation

	tooltips: POINTER
			-- Reference to GtkTooltips object.

feature -- Implementation

	is_in_transport: BOOLEAN
		-- Is application currently in transport (either PND or docking)?

	enable_is_in_transport is
			-- Set `is_in_transport' to True.
		require
			not_in_transport: not is_in_transport
		do
		end

	disable_is_in_transport is
			-- Set `is_in_transport' to False.
		require
			in_transport: is_in_transport
		do
		end

	keyboard_modifier_mask: INTEGER is
			-- Mask representing current keyboard modifiers state.
		do
		end

	enable_debugger is
			-- Enable the Eiffel debugger.
		do
		end

	disable_debugger is
			-- Disable the Eiffel debugger.
		do
		end

feature {EV_ANY_I, EV_FONT_IMP, EV_STOCK_PIXMAPS_IMP, EV_INTERMEDIARY_ROUTINES} -- Implementation

	eif_object_from_gtk_object (a_gtk_object: POINTER): EV_ANY_IMP is
			-- Return the EV_ANY_IMP object from `a_gtk_object' if any.
		do
		end

	gtk_widget_imp_at_pointer_position: EV_GTK_WIDGET_IMP is
			-- Gtk Widget implementation at current mouse pointer position (if any)
		do
		end

	gtk_is_launchable: BOOLEAN
		-- Is Gtk launchable?

	default_gtk_window: POINTER is
			-- Pointer to a default GtkWindow.
		once
		end

	gtk_style_has_changed is
			-- The current gtk style has changed.
		do
			-- This is called when the user externally changes the gtk style.
		end

	default_gdk_window: POINTER is
			-- Pointer to a default GdkWindow that may be used to
			-- access default visual information (color depth).
		do
		end

	default_window: EV_WINDOW is
			-- Default Window used for creation of agents and holder of clipboard widget.
		once
		end

	default_window_imp: EV_WINDOW_IMP is
			-- Default window implementation.
		once
		end

	default_font_height: INTEGER is
			-- Default font height.
		do
		end

	default_font_ascent: INTEGER is
			-- Default font ascent.
		do
		end

	default_font_descent: INTEGER is
			-- Default font descent.
		do
		end

	default_translate: FUNCTION [ANY, TUPLE [INTEGER, POINTER], TUPLE] is
			-- Default Gdk event marshaller.
		once
		end

	fg_color: POINTER is
			-- Default allocated background color.
		once
		end

	bg_color: POINTER is
			-- Default allocate foreground color.
		once
		end

	reusable_color_struct: POINTER is
			-- Persistent GdkColorStruct
		once
		end

	reusable_rectangle_struct: POINTER is
			-- Persistent GdkColorStruct
		once
		end

	c_string_from_eiffel_string (a_string: STRING_GENERAL): EV_GTK_C_STRING is
			-- Return a EV_GTK_C_STRING from`a_string'
			-- `Item' of result must not be freed by gtk.
			-- Result must only be used for temporary setting and should not be persistent.
		require
			a_string_not_void: a_string /= Void
		do
		end

	reusable_gtk_c_string: EV_GTK_C_STRING is
			-- Persistent EV_GTK_C_STRING.
		once
		end

feature {EV_PICK_AND_DROPABLE_IMP} -- Pnd Handling

	x_origin, y_origin: INTEGER
		-- Temp coordinate values for origin of Pick and Drop.

	set_x_y_origin (a_x_origin, a_y_origin: INTEGER) is
			-- Set `x_origin' and `y_origin' to `a_x_origin' and `a_y_origin' respectively.
		do
		end

	old_pointer_x,
	old_pointer_y: INTEGER
		-- Position of pointer on previous PND draw.

	set_old_pointer_x_y_origin (a_old_pointer_x, a_old_pointer_y: INTEGER) is
			-- Set PND pointer origins to `a_old_pointer_x' and `a_old_pointer_y'.
		do
		end

feature -- Thread Handling.

	initialize_threading is
			-- Initialize thread support.
		do
		end

	lock is
			-- Lock the Mutex.
		do
		end

	try_lock: BOOLEAN is
			-- Try to see if we can lock, False means no lock could be attained
		do
		end

	unlock is
			-- Unlock the Mutex.
		do
		end

feature {NONE} -- External implementation

	default_c_string_size: INTEGER is 1000
		-- Default size to set the reusable gtk C string.

	internal_set_debug_mode (a_debug_mode: INTEGER) is
			-- Set `debug_mode' to `a_debug_mode'.
		do
		end

	saved_debug_mode: INTEGER
		-- Debug mode before debugger was disabled

	debug_mode: INTEGER is
			-- State of debugger.
		do
		end

	enable_ev_gtk_log (a_mode: INTEGER) is
			-- Connect GTK+ logging to Eiffel exception handler.
			-- `a_mode' = 0 means no log messages, 1 = messages, 2 = messages with exceptions.
		do
		end

	usleep (micro_seconds: INTEGER) is
		do
		end

	gtk_init is
		do
		end

	gtk_init_check: BOOLEAN is
		do
		end

feature {NONE} -- Externals

	static_mutex: POINTER
		-- Pointer to the global static mutex

	new_g_static_rec_mutex: POINTER is
		do
		end

	frozen g_static_rec_mutex_init (a_static_mutex: POINTER) is
		do
		end

	frozen g_static_rec_mutex_lock (a_static_mutex: POINTER) is
		do
		end

	frozen g_static_rec_mutex_trylock (a_static_mutex: POINTER): BOOLEAN is
		do
		end

	frozen g_static_rec_mutex_unlock (a_static_mutex: POINTER) is
		do
		end

	frozen g_thread_supported: BOOLEAN is
		do
		end

	frozen g_thread_init is
		do
		end

invariant
	window_oids_not_void: is_usable implies window_oids /= void
	tooltips_not_void: tooltips /= default_pointer

indexing
	copyright:	"Copyright (c) 2006, The ETH Eiffel.Mac Team"

end -- class EV_APPLICATION_IMP

