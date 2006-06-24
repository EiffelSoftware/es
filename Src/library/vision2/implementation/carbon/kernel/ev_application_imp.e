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

--	EWG_CALLBACK_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL
--		export {NONE} all end

	EVENT_HANDLER_PROC_PTR_CALLBACK



create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Set up the callback marshalL
		do
			id_count:=1
			base_make (an_interface)
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



feature {EV_ANY_IMP} -- Implementation

	install_event_handler(a_id:INTEGER ; a_target:POINTER; a_event_class: INTEGER; a_event_kind:INTEGER) is
			--
		local
			null: POINTER
			ret: INTEGER
			event_target: POINTER
			event_type: EVENT_TYPE_SPEC_STRUCT
			dummy: RECT_STRUCT
		do
			-- this hack with dummy is just a worke around, because i dont know how to get the integer object given a pinter in eiffel
			create dummy.make_new_shared
			dummy.set_top (a_id)

			create dispatcher.make (Current)

			event_target:=a_target

			create event_type.make_new_shared
			event_type.set_eventclass(a_event_class)
			event_type.set_eventkind (a_event_kind)


			ret := install_event_handler_external(event_target, dispatcher.c_dispatcher, 1, event_type.item, dummy.item, null)
			print("event Handler for: " + a_id.out + " installed with kind: "+ a_event_kind.out + " ret: " + ret.out + "%N")
		end


feature -- Access

	id_count: INTEGER  --the next id.

	widget_list: ARRAY[EV_WIDGET_IMP]

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
		end

feature -- Status report

	tooltip_delay: INTEGER
			-- Time in milliseconds before tooltips pop up.

feature -- Status setting

	set_tooltip_delay (a_delay: INTEGER) is
			-- Set `tooltip_delay' to `a_delay'.
		do
		end

		get_id(a_widget: EV_WIDGET_IMP): INTEGER is
		do
			widget_list.force (a_widget,id_count)
			Result:=id_count
			id_count:=id_count+1
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

feature {NONE} -- Carbon callback handling for events

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
			dummy: RECT_STRUCT
			null: POINTER
			event_type: EVENT_TYPE_SPEC_STRUCT
			a_button: EV_BUTTON_IMP
			a_window: EV_WINDOW_IMP
		do

			if a_inuserdata /= null then
				create dummy.make_shared (a_inuserdata) --just a hack, because i dont know how to get to integer from a pointer in eiffel.

				print ("on_callback has been called by id:" + dummy.top.out+"%N")

				--widget_list.item (dummy.top).

			--	create event_type.make_shared (a_inevent)

			--  this part doesent work. Seems that the a_inevent pointer isnt. a pointer to a valid event_type_spec_struct

				--if event_type.eventkind={carbonevents_anon_enums}.kEventMouseDown and event_type.eventclass={carbonevents_anon_enums}.kEventClassControl then

					a_button?=widget_list.item (dummy.top)
					if a_button/=void then
						a_button.select_actions.call (void)
					end
					a_window?=widget_list.item (dummy.top)
					if a_window/=void then
						a_window.close_request_actions.call (void)
					end
				--end
			end

		end




invariant
	window_oids_not_void: is_usable implies window_oids /= void
	tooltips_not_void: tooltips /= default_pointer

indexing
	copyright:	"Copyright (c) 2006, The ETH Eiffel.Mac Team"

end -- class EV_APPLICATION_IMP

