note
	description: "EiffelVision application, Cocoa implementation."
	author: "Daniel Furrer, Emanuele Rudel"
	todo: "[

	]"

class
	EV_APPLICATION_IMP

inherit
	EV_APPLICATION_I
		export
			{EV_PICK_AND_DROPABLE_IMP}
				captured_widget
		redefine
			make,
			dispose
		end

	EV_APPLICATION_ACTION_SEQUENCES_IMP

	EXECUTION_ENVIRONMENT
		rename
			sleep as nano_sleep,
			launch as ee_launch
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EV_APPLICATION_I}
			create windows_imp.make
			create app_delegate.make
			set_is_initialized (True)
			check attached (create {NS_APPLICATION_UTILS}).shared_application as l_application then
				application := l_application
				application.set_delegate_ (app_delegate)
			end
		end

feature -- Access

	ctrl_pressed: BOOLEAN
			-- Is ctrl key currently pressed?
		do
			-- This is low-level, not trivial in Cocoa (see HID manager)
		end

	alt_pressed: BOOLEAN
			-- Is alt key currently pressed?
		do
			-- This is low-level, not trivial in Cocoa (see HID manager)
		end

	shift_pressed: BOOLEAN
			-- Is shift key currently pressed?
		do
			-- This is low-level, not trivial in Cocoa (see HID manager)
		end

	caps_lock_on: BOOLEAN
			-- Is the Caps or Shift Lock key currently on?
		do
			-- This is low-level, not trivial in Cocoa (see HID manager)
		end

	windows_imp: LINKED_LIST [EV_WINDOW_IMP]
			-- Global list of windows.

	windows: LINKED_LIST [EV_WINDOW]
		do
			create Result.make
			from
				windows_imp.start
			until
				windows_imp.after
			loop
				if attached windows_imp.item.interface as window then
					Result.extend (window)
				end
				windows_imp.forth
			end
		end

feature -- Basic operation

	process_underlying_toolkit_event_queue
			-- Process Cocoa events
		do
			application.run
		end

	process_graphical_events
			-- Process all pending graphical events and redraws.
		do
		end

	sleep (msec: INTEGER)
			-- Wait for `msec' milliseconds and return.
		do
			nano_sleep ({INTEGER_64} 1000000 * msec)
		end

	destroy
			-- End the application.
		do
			if not is_destroyed then
				application.terminate_ (application)
				set_is_destroyed (True)
				destroy_actions.call (Void)
			end
		end

feature -- Status report

	tooltip_delay: INTEGER
			-- Time in milliseconds before tooltips pop up.

feature -- Status setting

	set_tooltip_delay (a_delay: INTEGER)
			-- Set `tooltip_delay' to `a_delay'.
		do
			tooltip_delay := a_delay
		end

	set_application_icon_image (a_image: NS_IMAGE)
			-- Set the application's icon to  `a_image'
		do
			application.set_application_icon_image_ (a_image)
		end

	run_modal_for_window (a_window: NS_WINDOW): INTEGER
			-- Start a modal event loop for `a_window'
		do
			Result := application.run_modal_for_window_ (a_window).as_integer_32
			application.end_sheet_ (a_window)
			a_window.order_out_ (Void)
		end

	abort_modal
			-- Abort the event loop started by run_modal_for_window_ or run_modal_session_
		do
--			application.abort_modal
			application.stop_modal
		end

feature {EV_PICK_AND_DROPABLE_IMP} -- Pick and drop

	on_pick (a_pebble: ANY)
			-- Called by EV_PICK_AND_DROPABLE_IMP.start_transport
		do
		end

	on_drop (a_pebble: ANY)
			-- Called by EV_PICK_AND_DROPABLE_IMP.end_transport
		do
		end

feature {EV_ANY} -- Implementation

	is_display_remote: BOOLEAN
			-- Is application display remote?
			-- This function is primarily to determine if drawing to the display is optimal.

feature {NONE} -- Implementation

	wait_for_input (msec: INTEGER)
			-- Wait for at most `msec' milliseconds for an event.
		do
			sleep (msec)
		end

	is_in_transport: BOOLEAN
		-- Is application currently in transport (either PND or docking)?

	pick_and_drop_source: detachable EV_PICK_AND_DROPABLE_IMP
			-- Source of pick and drop if any.
		do
		end

	enable_is_in_transport
			-- Set `is_in_transport' to True.
		require
			not_in_transport: not is_in_transport
		do
		end

	disable_is_in_transport
			-- Set `is_in_transport' to False.
		require
			in_transport: is_in_transport
		do
		end

feature -- Thread Handling.

	lock
			-- Lock the Mutex.
		do
			if attached idle_action_mutex then
				idle_action_mutex.lock
			end
		end

	unlock
			-- Unlock the Mutex.
		do
			if idle_action_mutex /= Void then
				idle_action_mutex.unlock
			end
		end

feature {EV_WINDOW_IMP} -- Menu handling

	set_cocoa_menu (a_menu: NS_MENU)
		require
			menu_not_void: a_menu /= Void
		do
			application.set_main_menu_ (a_menu)
		end

feature {NONE} -- Implementation

	application: NS_APPLICATION

	app_delegate: EV_APPLICATION_DELEGATE

	dispose
		do
			Precursor {EV_APPLICATION_I}
		end

end -- class EV_APPLICATION_IMP
