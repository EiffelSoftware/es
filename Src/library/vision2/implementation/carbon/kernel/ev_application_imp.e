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

	IDENTIFIED
		undefine
			is_equal,
			copy
		end

	EV_APPLICATION_ACTION_SEQUENCES_IMP

	EXECUTION_ENVIRONMENT
		rename
			launch as ee_launch
		end

	PLATFORM

	EXCEPTIONS

	PROCESSES_FUNCTIONS_EXTERNAL

	CARBONEVENTSCORE_FUNCTIONS_EXTERNAL

	CARBONEVENTS_FUNCTIONS_EXTERNAL

	EVENT_HANDLER_PROC_PTR_CALLBACK


create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Set up the callback marshalL
		do
			base_make (an_interface)

			id_count := 1
			create free_ids.make
			create window_oids.make
			create widget_list.make (1, 200)
		end

feature {NONE} -- Event loop

	 launch is
			-- Display the first window, set up the post_launch_actions,
			-- and start the event loop.
		do
			enable_foreground_operation
			run_application_event_loop_external
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
			ret := set_front_process_external(psn.item)
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
		local
			list: LINKED_LIST [EV_WINDOW]
			w: EV_WINDOW_IMP
			id: IDENTIFIED
		do
			create id
			create list.make
			Result := list
			from
				window_oids.start
			until
				window_oids.after
			loop
				w ?= id.id_object (window_oids.item)
				if w = Void or else w.is_destroyed then
					window_oids.prune_all (window_oids.item)
				else
					list.extend (w.interface)
					window_oids.forth
				end
			end
		end


feature -- Basic operation

	process_events_until_stopped is
			-- Process all events until one event is received
			-- by `widget'.
		do
			run_application_event_loop_external

		end

	process_events is
			-- Process all pending events and redraws.
		local
			ret: INTEGER
		do
			--run_application_event_loop_external
			ret := run_current_event_loop_external (100)
		end

	stop_processing is
			-- Exit `process_events_until_stopped'.
		do
			quit_application_event_loop_external
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

	process_carbon_event is
			-- Process all carbon events
		do

		end

	handle_dnd (a_event: POINTER) is
			-- Handle drag and drop event.
		do
		end

	sleep (msec: INTEGER) is
			-- Wait for `msec' milliseconds and return.
		do
		end

	destroy is
			-- End the application.
		do
			quit_application_event_loop_external
			set_is_destroyed (True)
		end

feature -- Status report

	tooltip_delay: INTEGER
			-- Time in milliseconds before tooltips pop up.

feature -- Status setting

	set_tooltip_delay (a_delay: INTEGER) is
			-- Set `tooltip_delay' to `a_delay'.
		do
			tooltip_delay := a_delay
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

feature {NONE} -- callback handling for events

	dispatcher: EVENT_HANDLER_PROC_PTR_DISPATCHER
			-- The dispatcher is on the one side connected to a C function,
			-- that can be given to the C library as a callback target
			-- and on the other hand to an Eiffel object with a feature
			-- `on_callback'. Whenn its C function gets called, the dispatcher
			-- calls `on_callback' in the connected Eiffel object

	on_callback (a_inhandlercallref: POINTER; a_inevent: POINTER; a_inuserdata: POINTER): INTEGER is
			-- Callback target. This feature gets called
			-- anytime somebody calls `trigger_event_external'
		local
			event_class, event_kind, a_id: INTEGER
			a_seq : EV_WIDGET_ACTION_SEQUENCES_IMP
			ret: INTEGER
			command_struct: HICOMMAND_STRUCT
		do
				if a_inuserdata /= default_pointer then
					a_id := pointer_to_int ( a_inuserdata )
					-- print ("on_callback has been called by id:" + a_id.out + "%N")
					Result := widget_list.item ( a_id ).on_event ( a_inhandlercallref, a_inevent, a_inuserdata )
				end
		end

	id_count: INTEGER  -- the next id for an event.

	free_ids: LINKED_LIST[INTEGER]

feature {EV_CARBON_EVENTABLE} -- event handling

	widget_list: ARRAY[EV_CARBON_EVENTABLE]

	get_id (a_widget : EV_CARBON_EVENTABLE) : INTEGER is
			-- Get a unique ID so we can associate a event by it's ID with a control
		do
			if free_ids.is_empty then
				widget_list.force (a_widget, id_count)
				Result := id_count
				id_count := id_count + 1
			else
				widget_list.force (a_widget, free_ids.first)
				Result :=  free_ids.first
				free_ids.remove_left
			end
			--io.put_string ("Get ID: " + Result.out + "%N")
		end

	give_free (a_id: INTEGER) is
				-- Give an id back (it will be recycled)
			do
				widget_list.force (void, a_id)
				free_ids.put_right (a_id)
				--io.put_string ("Freed " + a_id.out + "/n")
			end

feature -- event handling

	install_event_handler (a_id: INTEGER ; a_target: POINTER; a_event_class: INTEGER; a_event_kind: INTEGER): POINTER is
			-- install a carbon event handler
			-- this hack with RECT_STRUCT is just a workearound, because i dont know how to get an Integer  from a pointer in eiffel
		local
			ret: INTEGER
			event_target: POINTER
			event_type: EVENT_TYPE_SPEC_STRUCT
			handler: POINTER
		do
			create dispatcher.make (Current)
			event_target := a_target

			create event_type.make_new_unshared
			event_type.set_eventclass (a_event_class)
			event_type.set_eventkind (a_event_kind)
			ret := install_event_handler_external (event_target, dispatcher.c_dispatcher, 1, event_type.item, int_to_pointer( a_id ), $handler)
			Result := handler
		end

	int_to_pointer ( a_int: INTEGER ) : POINTER is
		external
			"C inline"
		alias
			"[
				{
					return (void*) $a_int;
				}
			]"
		end

	pointer_to_int ( a_pointer: POINTER ) : INTEGER is
		external
			"C inline"
		alias
			"[
				{
					return (EIF_INTEGER_32) $a_pointer;
				}
			]"
		end

invariant
	window_oids_not_void: is_usable implies window_oids /= void

indexing
	copyright:	"Copyright (c) 2006, The ETH Eiffel.Mac Team"
end -- class EV_APPLICATION_IMP

