note
	description:
		"EiffelVision application, GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "application"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_APPLICATION_IMP

inherit
	EV_APPLICATION_I
		export
			{EV_ANY_I, EV_INTERMEDIARY_ROUTINES}
				pointer_motion_actions_internal,
				pointer_button_press_actions_internal,
				pointer_double_press_actions_internal,
				pointer_button_release_actions_internal,
				is_destroyed
		undefine
			dispose
		redefine
			call_post_launch_actions, focused_widget, make
		end

	EV_GTK_DEPENDENT_APPLICATION_IMP
		rename
			sleep as nano_sleep
		end

	EV_GTK_EVENT_STRINGS

	RT_DEBUGGER

create
	make

feature {NONE} -- Initialization

	make
			-- Set up the callback marshal and initialize GTK+.
		local
			locale_str: STRING
			l_colormap: POINTER
			l_gdk_screen_get_rgba_colormap_symbol: POINTER
		do
--			if {EV_GTK_DEPENDENT_EXTERNALS}.g_mem_is_system_malloc then
--				{EV_GTK_DEPENDENT_EXTERNALS}.g_mem_set_vtable ({EV_GTK_EXTERNALS}.glib_mem_profiler_table)
--			end

--			put ("localhost:0", "DISPLAY")
				-- This line may be uncommented to allow for display redirection to another machine for debugging purposes

			create character_string_buffer.make (4)



			create locale_str.make_from_c ({GTK}.gtk_set_locale)

			gtk_is_launchable := gtk_init_check

			create stored_display_data
				-- Initialize display retrieval storage for use by motion actions.

				-- Initialize the marshal object.
			create gtk_marshal

			create window_oids.make

			create default_font_name_internal.make_empty

			Precursor

			if gtk_is_launchable then
				initialize_threading
					-- Store the value of the debug mode.
				saved_debug_state := debug_state
				enable_ev_gtk_log (0)
					-- 0 = No messages, 1 = Gtk Log Messages, 2 = Gtk Log Messages with Eiffel exception.
				{GTK}.gdk_set_show_events (False)

				best_available_color_depth := {GTK2}.gdk_visual_get_best_depth.min (24)


					-- Try and set widgets with default rgba colormap if available.
				l_gdk_screen_get_rgba_colormap_symbol := gdk_screen_get_rgba_colormap_symbol
				if l_gdk_screen_get_rgba_colormap_symbol /= default_pointer then
				--	l_colormap := gdk_screen_get_rgba_colormap_call (l_gdk_screen_get_rgba_colormap_symbol, {GTK2}.gdk_screen_get_default)
				end

				if l_colormap = default_pointer then
					l_colormap := {GTK2}.gdk_screen_get_rgb_colormap ({GTK2}.gdk_screen_get_default)
				end
				{GTK}.gtk_widget_set_default_colormap (l_colormap)

				gtk_dependent_initialize

				tooltips := {GTK}.gtk_tooltips_new
				{GOBJECT}.g_object_ref (tooltips)
				{GTK}.gtk_object_sink (tooltips)
				set_tooltip_delay (500)

					-- Uncomment for Gtk 2.x only
--				feature {GTK2}.gdk_window_set_debug_updates (True)

					-- We do not want X Errors to exit the system so we ignore them indefinitely.
				{GTK}.gdk_error_trap_push

				update_screen_meta_data

					-- Initialize default Input Method context for converting keyboard strokes in to Unicode Characters depending on locale keyboard setting.
				default_input_context := {GTK2}.gtk_im_context_simple_new
				gtk_marshal.signal_connect (default_input_context, "commit", agent on_char, im_context_commit_translate_agent, True)
			else
				-- We are unable to launch the gtk toolkit, probably due to a DISPLAY issue.
				print ("EiffelVision application could not launch, check DISPLAY environment variable%N")
				die (0)
			end
		end

	on_char (a_gtk_c_string: EV_GTK_C_STRING)
			-- Update `character_string_buffer' Unicode key string.
		do
			character_string_buffer.wipe_out
			character_string_buffer.append (a_gtk_c_string.string)
			{GTK2}.gtk_im_context_reset (default_input_context)
		end

	update_screen_meta_data
			-- Update the default screen meta data.
		local
			l_rect: POINTER
			l_primary_monitor_number: INTEGER
			l_image: POINTER
			l_supports_composite_symbol: POINTER
		do

				-- Check if an GdkImage using the GDK_IMAGE_SHARED flag (first argument '1') may be created, if so then display is local.
			l_image := {GTK}.gdk_image_new (1, {GTK2}.gdk_screen_get_rgb_visual ({GTK2}.gdk_screen_get_default), 1, 1)
				-- This may fail if the X Server doesn't support the Shared extension, but if this is the case
				-- then the display will be slow anyway so the usage of this function will remain the same.
			is_display_remote := l_image = default_pointer
			if not is_display_remote then
				{GOBJECT}.g_object_unref (l_image)
			end

				-- Check whether display supports transparency
			l_supports_composite_symbol := gdk_display_supports_composite_symbol
			if l_supports_composite_symbol /= default_pointer then
				is_display_alpha_capable := gdk_display_supports_composite_call (l_supports_composite_symbol, {GTK2}.gdk_display_get_default)
			end

			screen_monitor_count := {GTK2}.gdk_screen_get_n_monitors ({GTK2}.gdk_screen_get_default)
			l_rect := reusable_rectangle_struct

			l_primary_monitor_number := {GTK2}.gdk_screen_get_primary_monitor ({GTK2}.gdk_screen_get_default)
			{GTK2}.gdk_screen_get_monitor_geometry ({GTK2}.gdk_screen_get_default, l_primary_monitor_number, l_rect)
			screen_primary_monitor_number := l_primary_monitor_number + 1

			screen_virtual_x := -{GTK}.gdk_rectangle_struct_x (l_rect)
			screen_virtual_y := -{GTK}.gdk_rectangle_struct_y (l_rect)
			screen_width := {GTK}.gdk_rectangle_struct_width (l_rect)
			screen_height := {GTK}.gdk_rectangle_struct_height (l_rect)

			screen_virtual_width := {GTK}.gdk_screen_width
			screen_virtual_height := {GTK}.gdk_screen_height
		end

	gdk_display_supports_composite_symbol: POINTER
			-- Symbol for `gdk_display_supports_composite'
		once
			Result := symbol_from_symbol_name ("gdk_display_supports_composite")
		end

	gdk_display_supports_composite_call (a_function: POINTER; a_display: POINTER): BOOLEAN
		external
			"C inline use <ev_gtk.h>"
		alias
			"return (FUNCTION_CAST(gboolean, (GdkDisplay*)) $a_function)((GdkDisplay*) $a_display);"
		end

	gdk_screen_get_rgba_colormap_symbol: POINTER
			-- Symbol for `gdk_display_supports_composite'
		once
			Result := symbol_from_symbol_name ("gdk_screen_get_rgba_colormap")
		end

	gdk_screen_get_rgba_colormap_call (a_function: POINTER; a_display: POINTER): POINTER
		external
			"C inline use <ev_gtk.h>"
		alias
			"return (FUNCTION_CAST(GdkColormap*, (GdkScreen*)) $a_function)((GdkScreen*) $a_display);"
		end

feature {EV_ANY_I} -- Implementation

	screen_virtual_x: INTEGER
	screen_virtual_y: INTEGER
	screen_virtual_width: INTEGER
	screen_virtual_height: INTEGER
	screen_width: INTEGER
	screen_height: INTEGER
	screen_monitor_count: INTEGER
	screen_primary_monitor_number: INTEGER
		-- Screen meta data.

	best_available_color_depth: INTEGER
		-- Best available color depth of display

	is_display_alpha_capable: BOOLEAN
			-- Is application display capable of displaying transparent windows?

	is_display_remote: BOOLEAN
			-- Is application display remote?
			-- This function is primarily to determine if drawing to the display is optimal.

	set_currently_shown_control (a_control: detachable EV_PICK_AND_DROPABLE)
			-- Set `currently_shown_control' to `a_control'.
		do
			currently_shown_control := a_control
		end

	currently_shown_control: detachable EV_PICK_AND_DROPABLE
		-- Graphical objects that is presently shown
		-- Used for holding a reference do not get garbage collected.

	focused_widget: detachable EV_WIDGET
			-- Widget with keyboard focus
		local
			current_windows: like windows
			current_window: EV_WINDOW
			l_window_imp: detachable EV_WINDOW_IMP
			l_widget_imp: detachable EV_WIDGET_IMP
			l_widget_ptr: POINTER
		do
			current_windows := windows
			from
				current_windows.start
			until
				current_windows.off or Result /= Void
			loop
				current_window := current_windows.item
				if current_window.has_focus then
					if current_window.full then
						l_window_imp ?= current_window.implementation
						check l_window_imp /= Void then end
						l_widget_ptr := {GTK}.gtk_window_struct_focus_widget (l_window_imp.c_object)
						if l_widget_ptr /= {GTK}.null_pointer then
							l_widget_imp ?= eif_object_from_gtk_object (l_widget_ptr)
							if l_widget_imp /= Void then
								Result := l_widget_imp.interface
							end
						end
					else
						Result := current_window
					end
				end
				current_windows.forth
			end
		end

	wait_for_input (msec: INTEGER)
			-- Wait for at most `msec' milliseconds for an event.
		do
			sleep (msec)
		end

	process_underlying_toolkit_event_queue
			-- Process all pending GDK events and then dispatch GTK iteration until no more
			-- events are pending.
		local
			gdk_event: POINTER
			event_widget, l_grab_widget: POINTER
			l_call_event, l_propagate_event, l_event_handled: BOOLEAN
			l_pnd_imp: detachable EV_PICK_AND_DROPABLE_IMP
			l_widget_imp: detachable EV_WIDGET_IMP
			l_top_level_window_imp: detachable EV_WINDOW_IMP
			l_gtk_widget_imp: detachable EV_GTK_WIDGET_IMP
			l_gtk_window_imp: detachable EV_GTK_WINDOW_IMP
			l_gdk_window, l_gtk_widget_ptr: POINTER
			l_motion_tuple: like motion_tuple
			l_app_motion_tuple: like app_motion_tuple
			l_no_more_events: BOOLEAN
			i, l_widget_x, l_widget_y, l_screen_x, l_screen_y, l_button_number: INTEGER
			l_has_grab_widget: BOOLEAN
			l_event_string: detachable STRING
			l_call_theme_events: BOOLEAN
			l_any_event, l_user_event, l_gdk_event_is_sent: BOOLEAN
		do
			from
				l_motion_tuple := motion_tuple
				l_app_motion_tuple := app_motion_tuple
					-- Check if there are any gtk events pending before dispatching them at the end of the loop.
			until
				l_no_more_events or else is_destroyed
			loop
				gdk_event := {GTK}.gdk_event_get
				if gdk_event /= {GTK}.null_pointer then
						-- GDK events are always handled before gtk events.
					event_widget := {GTK}.gtk_get_event_widget (gdk_event)

					l_gdk_event_is_sent := {GTK}.gdk_event_any_struct_send_event (gdk_event) /= 0

						-- event_widget may be null.
					l_any_event := True
					l_call_event := True
					l_propagate_event := False

					l_grab_widget := {GTK}.gtk_grab_get_current
					if l_grab_widget = {GTK}.null_pointer then
						l_has_grab_widget := False
						l_grab_widget := event_widget
					else
						l_has_grab_widget := True
							-- Cancel any invalid event capture.
						if attached pick_and_drop_source as l_pnd_src and then not l_pnd_src.is_displayed then
							l_pnd_src.end_transport (0, 0, 0, 0, 0, 0, 0, 0)
						elseif attached captured_widget as l_captured_widget and then not l_captured_widget.is_displayed then
							l_captured_widget.disable_capture
						end
					end
					inspect
						{GTK}.gdk_event_any_struct_type (gdk_event)
					when GDK_MOTION_NOTIFY then
						debug ("GDK_EVENT")
							print ("GDK_MOTION_NOTIFY%N")
						end
						l_user_event := True
							-- Set up storage to avoid server roundtrips.
						use_stored_display_data := True
						l_widget_x := {GTK}.gdk_event_motion_struct_x (gdk_event).truncated_to_integer
						l_widget_y := {GTK}.gdk_event_motion_struct_y (gdk_event).truncated_to_integer
						l_screen_x := {GTK}.gdk_event_motion_struct_x_root (gdk_event).truncated_to_integer + screen_virtual_x
						l_screen_y := {GTK}.gdk_event_motion_struct_y_root (gdk_event).truncated_to_integer + screen_virtual_y
						stored_display_data.window := {GTK}.gdk_event_motion_struct_window (gdk_event)
						stored_display_data.x := l_screen_x
						stored_display_data.y := l_screen_y
						stored_display_data.mask := {GTK}.gdk_event_motion_struct_state (gdk_event)

						l_call_event := False
						if
							attached captured_widget as l_captured_widget
						then
							l_pnd_imp ?= l_captured_widget.implementation
						elseif
							pick_and_drop_source /= Void
						then
							l_pnd_imp := pick_and_drop_source
						else
							l_pnd_imp ?= gtk_widget_from_gdk_window (stored_display_data.window)
						end

						if l_pnd_imp /= Void and then l_pnd_imp.is_displayed then
							l_top_level_window_imp := l_pnd_imp.top_level_window_imp
							if l_top_level_window_imp /= Void then
								if not l_top_level_window_imp.has_modal_window then
									{GTK}.gtk_main_do_event (gdk_event)
									if pointer_motion_actions_internal /= Void then
										l_widget_imp ?= l_pnd_imp
										if l_widget_imp /= Void then
												l_app_motion_tuple.widget := l_widget_imp.attached_interface
												l_app_motion_tuple.x := l_screen_x
												l_app_motion_tuple.y := l_screen_y
												pointer_motion_actions_internal.call (l_app_motion_tuple)
													-- Remove widget reference so that it gets GC'd
												l_app_motion_tuple.widget := default_window
										end
									end
									if {GTK}.gtk_object_struct_flags (l_pnd_imp.c_object) & {GTK}.GTK_SENSITIVE_ENUM = {GTK}.GTK_SENSITIVE_ENUM then
										if {GTK}.gtk_widget_struct_window (l_pnd_imp.visual_widget) /= {GTK}.gdk_event_motion_struct_window (gdk_event) then
												-- If the event we received is not from the associating widget window then we remap its correct x and y values.
											i := {GTK}.gdk_window_get_origin ({GTK}.gtk_widget_struct_window (l_pnd_imp.visual_widget), $l_widget_x, $l_widget_y)
											l_widget_x := l_screen_x - l_widget_x
											l_widget_y := l_screen_y - l_widget_y
										end
										l_motion_tuple.x := l_widget_x
										l_motion_tuple.y := l_widget_y
										l_motion_tuple.x_tilt := 0.5
										l_motion_tuple.y_tilt := 0.5
										l_motion_tuple.pressure := 0.5
										l_motion_tuple.screen_x := l_screen_x
										l_motion_tuple.screen_y := l_screen_y
										l_pnd_imp.on_pointer_motion (l_motion_tuple)
									end
								end
							else
								{GTK}.gtk_main_do_event (gdk_event)
							end
						else
							{GTK}.gtk_main_do_event (gdk_event)
						end
						l_widget_imp := Void
						l_pnd_imp := Void
							-- Reset display data.
						use_stored_display_data := False

						if {GTK}.gdk_event_motion_struct_is_hint (gdk_event) /= 0 then
								-- We are a motion hint event so we update the display data to retrieve any pending events.
							update_display_data
						end
					when GDK_BUTTON_PRESS, GDK_2BUTTON_PRESS, GDK_3BUTTON_PRESS, GDK_BUTTON_RELEASE then
						debug ("GDK_EVENT")
							print ("GDK_BUTTON_EVENT%N")
						end
						l_user_event := True
						l_call_event := False
						process_button_event (gdk_event)
					when GDK_SCROLL then
						debug ("GDK_EVENT")
							print ("GDK_SCROLL%N")
						end
						if not is_in_transport then
							if attached focused_popup_window as l_focused_popup_window then
								l_focused_popup_window.handle_mouse_button_event (
									{GTK}.gdk_button_press_enum,
									2,
									{GTK}.gdk_event_scroll_struct_x_root (gdk_event).truncated_to_integer + screen_virtual_x,
									{GTK}.gdk_event_scroll_struct_y_root (gdk_event).truncated_to_integer + screen_virtual_y
									)
							end
							l_widget_imp ?= eif_object_from_gtk_object (event_widget)
							if l_widget_imp /= Void then
								if {GTK2}.gdk_event_scroll_struct_scroll_direction (gdk_event) = {GTK2}.gdk_scroll_up_enum then
									l_button_number := 4
								else
									l_button_number := 5
								end
								l_widget_imp.call_button_event_actions ({GTK}.gdk_button_press_enum, 0, 0, l_button_number, 0.5, 0.5, 0.5, 0, 0)
							end
							l_propagate_event := True
						else
							l_call_event := False
						end
						l_user_event := True
					when GDK_PROXIMITY_IN, GDK_PROXIMITY_OUT then
						debug ("GDK_EVENT")
							print ("GDK_PROXIMITY_IN%N")
						end
					when GDK_PROPERTY_NOTIFY then
						debug ("GDK_EVENT")
							print ("GDK_PROPERTY_NOTIFY%N")
						end
					when GDK_EXPOSE then
							-- This is only called on gtk 1.2 as expose compression is
							-- performed in gdk with 2.x and above.
						debug ("GDK_EVENT")
							print ("GDK_EXPOSE%N")
						end
					when GDK_NO_EXPOSE then
						debug ("GDK_EVENT")
							print ("GDK_NO_EXPOSE%N")
						end
					when GDK_FOCUS_CHANGE then
						debug ("GDK_EVENT")
							print ("GDK_FOCUS_CHANGE%N")
						end
						l_top_level_window_imp ?= eif_object_from_gtk_object (event_widget)
						if l_top_level_window_imp /= Void then
							l_call_event := False
							{GTK}.gtk_main_do_event (gdk_event)
							l_top_level_window_imp.on_focus_changed ({GTK}.gdk_event_focus_struct_in (gdk_event).to_boolean)
							l_top_level_window_imp := Void
						end
					when GDK_CONFIGURE then
						debug ("GDK_EVENT")
							print ("GDK_CONFIGURE%N")
						end
						l_gtk_window_imp ?= eif_object_from_gtk_object (event_widget)
						if l_gtk_window_imp /= Void then
							l_call_event := False
								-- Make sure internal gtk structures are updated before firing resize event(s)
							{GTK}.gtk_main_do_event (gdk_event)
							l_gtk_window_imp.on_size_allocate (
								{GTK}.gdk_event_configure_struct_x (gdk_event),
								{GTK}.gdk_event_configure_struct_y (gdk_event),
								{GTK}.gdk_event_configure_struct_width (gdk_event),
								{GTK}.gdk_event_configure_struct_height (gdk_event)
							)
							l_gtk_window_imp := Void
						end
					when GDK_MAP then
						debug ("GDK_EVENT")
							print ("GDK_MAP%N")
						end
						l_call_event := False
						{GTK}.gtk_main_do_event (gdk_event)
						l_widget_imp ?= eif_object_from_gtk_object (event_widget)
						if l_widget_imp /= Void then
							l_widget_imp.on_widget_mapped
						end
						l_widget_imp := Void
					when GDK_UNMAP then
						debug ("GDK_EVENT")
							print ("GDK_UNMAP%N")
						end
						l_call_event := False
						{GTK}.gtk_main_do_event (gdk_event)
						l_gtk_widget_imp ?= eif_object_from_gtk_object (event_widget)
						if l_gtk_widget_imp /= Void then
							if currently_shown_control = l_gtk_widget_imp.interface then
								set_currently_shown_control (Void)
							end
							l_widget_imp ?= l_gtk_widget_imp
							if l_widget_imp /= Void then
								l_widget_imp.on_widget_unmapped
								l_widget_imp := Void
							end
							l_gtk_widget_imp := Void
						end
					when GDK_SELECTION_CLEAR then
						debug ("GDK_EVENT")
							print ("GDK_SELECTION_CLEAR%N")
						end
					when GDK_SELECTION_REQUEST then
						debug ("GDK_EVENT")
							print ("GDK_SELECTION_REQUEST%N")
						end
					when GDK_SELECTION_NOTIFY then
						debug ("GDK_EVENT")
							print ("GDK_SELECTION_NOTIFY%N")
						end
						if attached focused_widget as l_focus_widget then
							l_widget_imp ?= l_focus_widget.implementation
						elseif attached (create {EV_SCREEN}).widget_at_mouse_pointer as l_focus_widget then
							l_widget_imp ?= l_focus_widget.implementation
						end
						if
							attached {EV_TEXT_FIELD_IMP} l_widget_imp as l_text_field_imp
						then
							-- We need to explicitly check for change actions on text fields
							l_call_event := False
							{GTK}.gtk_main_do_event (gdk_event)
							l_text_field_imp.on_change_actions
						end
						l_widget_imp := Void
					when GDK_CLIENT_EVENT then
						debug ("GDK_EVENT")
							print ("GDK_CLIENT_EVENT%N")
						end
					when GDK_VISIBILITY_NOTIFY then
						debug ("GDK_EVENT")
							print ("GDK_VISIBILITY_NOTIFY%N")
						end
					when GDK_WINDOW_STATE then
						debug ("GDK_EVENT")
							print ("GDK_WINDOW_STATE%N")
						end
						l_top_level_window_imp ?= eif_object_from_gtk_object (event_widget)
						if l_top_level_window_imp /= Void then
							l_top_level_window_imp.call_window_state_event (
								{GTK2}.gdk_event_window_state_struct_changed_mask (gdk_event),
								{GTK2}.gdk_event_window_state_struct_new_window_state (gdk_event)
							)
							l_top_level_window_imp := Void
						end
					when GDK_ENTER_NOTIFY, GDK_LEAVE_NOTIFY then
						debug ("GDK_EVENT")
							print ("GDK_ENTER_LEAVE_NOTIFY%N")
						end
						l_gdk_window := {GTK}.gdk_event_any_struct_window (gdk_event)
						l_call_event := False
						if
							l_gdk_window /= {GTK}.null_pointer
							--and then {GTK}.gdk_event_any_struct_send_event (gdk_event) = 0
							and then {GTK}.gdk_event_crossing_struct_mode (gdk_event) = 0
						then
							{GTK}.gdk_window_get_user_data (l_gdk_window, $l_gtk_widget_ptr)

							if l_gtk_widget_ptr /= {GTK}.null_pointer then
								if not is_in_transport then
									l_pnd_imp ?= eif_object_from_gtk_object (l_gtk_widget_ptr)
									if l_pnd_imp /= Void and then l_pnd_imp.c_object = l_gtk_widget_ptr then
											-- We only want the pointer events for the backing widget.
										l_top_level_window_imp := l_pnd_imp.top_level_window_imp
										if l_top_level_window_imp = Void or else not l_top_level_window_imp.has_modal_window then
											l_widget_imp ?= l_pnd_imp
											if l_widget_imp /= Void then
												l_widget_imp.on_pointer_enter_leave ({GTK}.gdk_event_any_struct_type (gdk_event) = GDK_ENTER_NOTIFY)
											end
											l_call_event := True
											l_widget_imp := Void
										end
										l_pnd_imp := Void
										l_gtk_widget_imp := Void
										l_top_level_window_imp := Void
										l_gtk_widget_ptr := {GTK}.null_pointer
									else
											-- This code is needed for standard dialogs where we do not have a handle to all
											-- gtk widgets.
										{GTK}.gtk_main_do_event (gdk_event)
										l_call_event := False
									end
								end
							end
						end
						l_gdk_window := {GTK}.null_pointer
					when GDK_KEY_PRESS, GDK_KEY_RELEASE then
						debug ("GDK_EVENT")
							print ("GDK_KEY_EVENT%N")
						end
						l_user_event := True
						l_propagate_event := True
						if attached focused_popup_window as l_focused_popup_window then
							l_gtk_widget_imp := l_focused_popup_window
								-- Change window of `gdk_event' to be that of focused widget.
							l_gdk_window := {GTK}.gdk_event_any_struct_window (gdk_event)
							{GTK}.set_gdk_event_any_struct_window (gdk_event, {GTK}.gtk_widget_struct_window (l_gtk_widget_imp.c_object))
						else
							if l_has_grab_widget then
								l_gtk_widget_imp ?= eif_object_from_gtk_object (l_grab_widget)
							else
									-- Make sure we only process key events from top level windows.
								l_gtk_window_imp ?= eif_object_from_gtk_object (l_grab_widget)
								l_gtk_widget_imp := l_gtk_window_imp
							end
						end
						if l_gtk_widget_imp /= Void then
							l_gtk_window_imp := l_gtk_widget_imp.top_level_gtk_window_imp
							if l_gtk_window_imp /= Void then
								l_top_level_window_imp ?= l_gtk_window_imp
								if l_top_level_window_imp = Void or else not l_top_level_window_imp.has_modal_window then
									use_stored_display_data_for_keys := True
									stored_display_data.mask := {GTK}.gdk_event_key_struct_state (gdk_event)
									l_call_event := False
									l_gtk_window_imp.process_key_event (gdk_event)
									use_stored_display_data_for_keys := False
								end
								l_gtk_widget_imp := Void
								l_gtk_window_imp := Void
								l_top_level_window_imp := Void
							end
						end
						if l_gdk_window /= {GTK}.null_pointer then
								-- Restore remapped event.
							{GTK}.set_gdk_event_any_struct_window (gdk_event, l_gdk_window)
							l_gdk_window := {GTK}.null_pointer
						end
					when GDK_DELETE then
						debug ("GDK_EVENT")
							print ("GDK_DELETE%N")
						end
						l_user_event := True
						l_call_event := False
						l_gtk_window_imp ?= eif_object_from_gtk_object (event_widget)
						if l_gtk_window_imp /= Void then
							l_gtk_window_imp.call_close_request_actions
							l_gtk_window_imp := Void
						end
					when GDK_DESTROY then
						debug ("GDK_EVENT")
							print ("GDK_DESTROY%N")
						end
					when GDK_DRAG_ENTER then
						debug ("GDK_EVENT")
							print ("GDK_DRAG_ENTER%N")
						end
					when GDK_DRAG_LEAVE then
						debug ("GDK_EVENT")
							print ("GDK_DRAG_LEAVE%N")
						end
					when GDK_DRAG_MOTION then
						debug ("GDK_EVENT")
							print ("GDK_DRAG_MOTION%N")
						end
					when GDK_DRAG_STATUS then
						debug ("GDK_EVENT")
							print ("GDK_DRAG_STATUS%N")
						end
					when GDK_DROP_START then
						debug ("GDK_EVENT")
							print ("GDK_DROP_START")
						end
							-- Some text has been drag dropped on a widget.
						handle_dnd (gdk_event)
					when GDK_DROP_FINISHED then
						debug ("GDK_EVENT")
							print ("GDK_DROP_FINISHED%N")
						end
					when GDK_NOTHING then
						debug ("GDK_NOTHING")
							print ("GDK_NOTHING")
					 	end
					when GDK_SETTING then
						debug ("GDK_SETTING")
							print ("GDK_SETTING")
					 	end
						l_call_event := False
						create l_event_string.make_from_c ({GTK}.gdk_event_setting_struct_name (gdk_event))
						if l_event_string.is_equal (once "gtk-theme-name") then
							-- Theme change
							l_call_theme_events := True
						elseif l_event_string.is_equal (once "gtk-font-name") then
							-- Font change
							l_call_theme_events := True
						end
						l_event_string := Void
						{GTK}.gtk_main_do_event (gdk_event)

						if l_call_theme_events and then theme_changed_actions_internal /= Void then
							theme_changed_actions_internal.call (Void)
						end
						l_call_theme_events := False
					else
						l_call_event := False
					end
					if l_call_event then
						if l_propagate_event then
							{GTK}.gtk_propagate_event (l_grab_widget, gdk_event)
						else
							if event_widget /= {GTK}.null_pointer then
								l_event_handled := {GTK}.gtk_widget_event (event_widget, gdk_event)
							else
								{GTK}.gtk_main_do_event (gdk_event)
							end
						end
					end
					{GTK}.gdk_event_free (gdk_event)
				else
					if {GTK2}.events_pending then
						process_gtk_events
					else
						l_no_more_events := True
					end
				end
			end

				-- Set event status flags.
			events_processed_from_underlying_toolkit := l_any_event
			user_events_processed_from_underlying_toolkit := l_user_event
		end

	process_gtk_events
			-- Process Pending gtk events.
		local
			l_events_processed: BOOLEAN
		do
			if not l_events_processed then
				{GTK2}.dispatch_events
			end
		rescue
				-- Catch any exceptions.
			l_events_processed := True
			retry
		end

feature -- Implementation

	gtk_marshal: EV_GTK_CALLBACK_MARSHAL
		-- Marshal object for all gtk signal emission event handling.

feature {EV_ANY_I} -- Implementation

	symbol_from_symbol_name (a_symbol_name: STRING): POINTER
			-- Return Symbol for symbol name `a_symbol_text'.
		local
			l_module: POINTER
			l_symbol_name: EV_GTK_C_STRING
			l_success: BOOLEAN
			l_result: POINTER
		do
			l_module := main_module
			if l_module /= default_pointer then
				l_symbol_name := a_symbol_name
				l_success := {GTK}.g_module_symbol (l_module, l_symbol_name.item, $l_result)
				if l_success then
					Result := l_result
				end
			end
		end

feature {NONE} -- Implementation

	main_module: POINTER
			-- Module representing `Current' application instance.
		do
			if {GTK}.gtk_min_ver >= 6 and then {GTK}.g_module_supported then
				Result := {GTK}.g_module_open (default_pointer, 0)
			end
		end

feature -- Access

	ctrl_pressed: BOOLEAN
			-- Is ctrl key currently pressed?
		do
			Result := keyboard_modifier_mask & {GTK}.gdk_control_mask_enum = {GTK}.gdk_control_mask_enum
		end

	alt_pressed: BOOLEAN
			-- Is alt key currently pressed?
		do
			Result := keyboard_modifier_mask & {GTK}.gdk_mod1_mask_enum = {GTK}.gdk_mod1_mask_enum
		end

	shift_pressed: BOOLEAN
			-- Is shift key currently pressed?
		do
			Result := keyboard_modifier_mask & {GTK}.gdk_shift_mask_enum = {GTK}.gdk_shift_mask_enum
		end

	caps_lock_on: BOOLEAN
			-- Is the Caps or Shift Lock key currently on?
		do
			Result := keyboard_modifier_mask & {GTK}.gdk_lock_mask_enum = {GTK}.gdk_lock_mask_enum
		end

	window_oids: LINKED_LIST [INTEGER]
			-- Global list of window object ids.

	windows: LINEAR [EV_WINDOW]
			-- Global list of windows.
		local
			cur: CURSOR
			w: detachable EV_WINDOW_IMP
			id: IDENTIFIED
			l: LINKED_LIST [EV_WINDOW]
		do
			create id
			create l.make
			Result := l
			from
				cur := window_oids.cursor
				window_oids.start
			until
				window_oids.after
			loop
				w ?= id.id_object (window_oids.item)
				if w = Void or else w.is_destroyed then
					window_oids.remove
				else
					l.extend (w.attached_interface)
					window_oids.forth
				end
			end
			window_oids.go_to (cur)
		end

	focused_popup_window: detachable EV_POPUP_WINDOW_IMP
		-- Popup Window that is currently focused.

	set_focused_popup_window (a_window: like focused_popup_window)
			-- Set `focused_popup_window' to `a_window'.
		require
			valid:(a_window /= Void and focused_popup_window = Void) or (a_window = Void and focused_popup_window /= Void)
		do
			focused_popup_window := a_window
		end

feature -- Basic operation

	call_post_launch_actions
			-- <Precursor>
		do
			if gtk_is_launchable then
				{GTK2}.gtk_im_context_set_client_window (default_input_context, default_gdk_window)
				{GTK2}.gtk_im_context_focus_in (default_input_context)
			end
			Precursor
		end

	process_graphical_events
			-- Process all pending graphical events and redraws.
		do
			{GTK}.gdk_window_process_all_updates
		end

	motion_tuple: TUPLE [x: INTEGER; y: INTEGER; x_tilt: DOUBLE; y_tilt: DOUBLE; pressure: DOUBLE; screen_x: INTEGER; screen_y: INTEGER]
			-- Tuple optimization
		once
			create Result
		end

	app_motion_tuple: TUPLE [widget: EV_WIDGET; x: INTEGER; y: INTEGER]
			-- Tuple optimization
		once
			Result := [default_widget, 0, 0]
		end

	process_button_event (a_gdk_event: POINTER)
			-- Process button event `a_gdk_event'.
		require
			a_gdkevent_not_null: a_gdk_event /= {GTK}.null_pointer
		local
			l_pnd_item: detachable EV_PICK_AND_DROPABLE_IMP
			l_gdk_window: POINTER
			l_stored_display_data: like stored_display_data
			l_top_level_window_imp: detachable EV_WINDOW_IMP
			l_popup_parent: detachable EV_POPUP_WINDOW_IMP
			l_ignore_event: BOOLEAN
			l_text_component_imp: detachable EV_TEXT_COMPONENT_IMP
			l_screen_x, l_screen_y: INTEGER
		do
				-- Update screen coords from device to logical.
			l_screen_x := {GTK}.gdk_event_button_struct_x_root (a_gdk_event).truncated_to_integer + screen_virtual_x
			l_screen_y := {GTK}.gdk_event_button_struct_y_root (a_gdk_event).truncated_to_integer + screen_virtual_y

			use_stored_display_data := True
			l_stored_display_data := stored_display_data
			l_stored_display_data.window := {GTK}.gdk_event_button_struct_window (a_gdk_event)
			l_stored_display_data.x := l_screen_x
			l_stored_display_data.y := l_screen_y
			l_stored_display_data.mask := {GTK}.gdk_event_button_struct_state (a_gdk_event)

			if attached captured_widget as l_captured_widget then
				l_pnd_item ?= l_captured_widget.implementation
			elseif
				pick_and_drop_source /= Void
			then
				l_pnd_item := pick_and_drop_source
			else
				l_gdk_window := l_stored_display_data.window
				if l_gdk_window /= {GTK}.null_pointer then
					l_pnd_item ?= gtk_widget_from_gdk_window (l_gdk_window)
				end
			end

				-- This is used to prevent context menus in gtk widget such as GtkTextEntry from appearing in EV_POPUP_WINDOWS.
			if l_pnd_item /= Void then
				l_top_level_window_imp ?= l_pnd_item.top_level_window_imp
				l_popup_parent ?= l_top_level_window_imp
				if l_popup_parent /= Void then
					l_text_component_imp ?= l_pnd_item
				end
					-- We do not want to propagate if right clicking in a popup parent (for activation focus handling) unless PND is activated.
					-- or if the widget is insensitive or the top level window has a modal child.
				l_ignore_event :=
					l_popup_parent /= Void and then l_text_component_imp /= Void and then {GTK}.gdk_event_button_struct_button (a_gdk_event) = 3 and then (l_pnd_item.pebble = Void and l_pnd_item.pebble_function = Void) or else
					not {GTK}.gtk_widget_is_sensitive (l_pnd_item.c_object) or else
					l_top_level_window_imp /= Void and then l_top_level_window_imp.has_modal_window and then captured_widget = Void
						-- If a widget has capture then we don't want to ignore the event.
			end

				-- Handle popup window focusing.
			if l_popup_parent = Void then
				l_popup_parent := focused_popup_window
			end
			if l_popup_parent /= Void then
					l_popup_parent.handle_mouse_button_event (
						{GTK}.gdk_event_button_struct_type (a_gdk_event),
						{GTK}.gdk_event_button_struct_button (a_gdk_event),
						l_screen_x,
						l_screen_y
					)
			end

			if not l_ignore_event then
				if pick_and_drop_source = Void then
						-- We don't want signals firing during transport.
					{GTK}.gtk_main_do_event (a_gdk_event)
				end
				if l_pnd_item /= Void then
					l_pnd_item.on_mouse_button_event (
						{GTK}.gdk_event_button_struct_type (a_gdk_event),
						{GTK}.gdk_event_button_struct_x (a_gdk_event).truncated_to_integer,
						{GTK}.gdk_event_button_struct_y (a_gdk_event).truncated_to_integer,
						{GTK}.gdk_event_button_struct_button (a_gdk_event),
						0.5,
						0.5,
						0.5,
						l_screen_x,
						l_screen_y
					)
				end
			end

			use_stored_display_data := False
		end



	handle_dnd (a_event: POINTER)
			-- Handle drag and drop event.
		local
			a_context: POINTER
			a_target_list: POINTER
			a_target: POINTER
			src_window, dest_window, a_selection, gtkwid: POINTER
			a_time: NATURAL_32
			prop_data: POINTER
			prop_type, prop_format, prop_length: INTEGER
			a_string: STRING_32
			l_file_list: detachable LIST [STRING_32]
			l_success: BOOLEAN
			l_widget_imp: detachable EV_WIDGET_IMP
			l_string, l_file: STRING_32
		do
			from
				a_context := {GTK}.gdk_event_dnd_struct_context (a_event)
				src_window := {GTK}.gdk_drag_context_get_source_window (a_context)
				a_selection := {GTK}.gdk_drag_get_selection (a_context)
				a_time := {GTK}.gdk_event_dnd_struct_time (a_event)
				a_target_list := {GTK}.gdk_drag_context_list_targets (a_context)
				l_string := {STRING_32} "STRING"
				l_file := {STRING_32} "file://"
			until
				a_target_list = {GTK}.null_pointer
			loop
				a_target := {GTK}.glist_struct_data (a_target_list)
				if a_target /= {GTK}.null_pointer then
						-- This is a target atom indicating the type of the drop.
					{GTK}.gdk_selection_convert (src_window, a_selection, a_target, a_time)
					prop_length := {GTK}.gdk_selection_property_get (src_window, $prop_data, $prop_type, $prop_format)
					if prop_data /= {GTK}.null_pointer then
						create a_string.make_from_c ({GTK}.gdk_atom_name (a_target))
						debug ("GDK_EVENT")
							print ("%NTarget Type: " + {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (a_string) + " %N" )
						end
						if a_string.is_equal (l_string)  then
							create a_string.make_from_c (prop_data)
							l_file_list := a_string.split ('%N')
							from
								l_file_list.start
							until
								l_file_list.after
							loop
								if l_file_list.item.substring_index (l_file, 1) = 1 then
									l_file_list.replace (l_file_list.item.substring (8, l_file_list.item.count))
									l_success := True
									l_file_list.forth
								else
									l_file_list.remove
								end
							end
						end
					end
				end
				a_target_list := {GTK}.glist_struct_next (a_target_list)
			end
			if l_success and then attached l_file_list then
				dest_window := {GTK}.gdk_drag_context_struct_dest_window (a_context)
				if dest_window /= {GTK}.null_pointer then
					{GTK}.gdk_window_get_user_data (dest_window, $gtkwid)
					if gtkwid /= {GTK}.null_pointer then
						l_widget_imp ?= eif_object_from_gtk_object (gtkwid)
						if
							l_widget_imp /= Void and then
							not l_widget_imp.is_destroyed
						then
							if l_widget_imp.file_drop_actions_internal /= Void then
								l_widget_imp.file_drop_actions.call ([l_file_list])
							end
							if file_drop_actions_internal /= Void then
								file_drop_actions_internal.call ([l_widget_imp.attached_interface, l_file_list])
							end
						end
					end
				end
			end
			{GTK}.gdk_drop_finish (a_context, l_success, a_time)
			{GTK}.gtk_drag_finish (a_context, l_success, False, a_time)
			{GTK}.g_free (prop_data)
			{GTK}.g_free (a_target_list)
		end


	GDK_NOTHING: INTEGER_8 = -1
	GDK_DELETE: INTEGER_8 = 0
	GDK_DESTROY: INTEGER_8 = 1
	GDK_EXPOSE: INTEGER_8 = 2
	GDK_MOTION_NOTIFY: INTEGER_8 = 3
	GDK_BUTTON_PRESS: INTEGER_8 = 4
	GDK_2BUTTON_PRESS : INTEGER_8 = 5
	GDK_3BUTTON_PRESS: INTEGER_8 = 6
	GDK_BUTTON_RELEASE: INTEGER_8 = 7
	GDK_KEY_PRESS: INTEGER_8 = 8
	GDK_KEY_RELEASE: INTEGER_8 = 9
	GDK_ENTER_NOTIFY: INTEGER_8 = 10
	GDK_LEAVE_NOTIFY: INTEGER_8 = 11
	GDK_FOCUS_CHANGE: INTEGER_8 = 12
	GDK_CONFIGURE: INTEGER_8 = 13
	GDK_MAP: INTEGER_8 = 14
	GDK_UNMAP: INTEGER_8 = 15
	GDK_PROPERTY_NOTIFY: INTEGER_8 = 16
	GDK_SELECTION_CLEAR: INTEGER_8 = 17
	GDK_SELECTION_REQUEST: INTEGER_8 = 18
	GDK_SELECTION_NOTIFY: INTEGER_8 = 19
	GDK_PROXIMITY_IN: INTEGER_8 = 20
	GDK_PROXIMITY_OUT: INTEGER_8 = 21
	GDK_DRAG_ENTER: INTEGER_8 = 22
	GDK_DRAG_LEAVE: INTEGER_8 = 23
	GDK_DRAG_MOTION: INTEGER_8 = 24
	GDK_DRAG_STATUS: INTEGER_8 = 25
	GDK_DROP_START: INTEGER_8 = 26
	GDK_DROP_FINISHED: INTEGER_8 = 27
	GDK_CLIENT_EVENT: INTEGER_8 = 28
	GDK_VISIBILITY_NOTIFY: INTEGER_8 = 29
	GDK_NO_EXPOSE: INTEGER_8 = 30
	GDK_SCROLL: INTEGER_8 = 31
	GDK_WINDOW_STATE: INTEGER_8 = 32
	GDK_SETTING: INTEGER_8 = 33
	GDK_OWNER_CHANGE: INTEGER_8 = 34
		-- GDK Event Type Constants

	sleep (msec: INTEGER)
			-- Wait for `msec' milliseconds and return.
		do
			nano_sleep ({INTEGER_64} 1000000 * msec)
		end

	destroy
			-- End the application.
		do
			if not is_destroyed then
				{GOBJECT}.g_object_unref (tooltips)
				set_is_destroyed (True)
					-- This will exit our main loop
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
			if gtk_is_launchable then
				{GTK}.gtk_tooltips_set_delay (tooltips, a_delay)
			end
		end

feature {EV_PICK_AND_DROPABLE_IMP, EV_DOCKABLE_SOURCE_IMP} -- Pick and drop

	set_docking_source (a_source: detachable EV_DOCKABLE_SOURCE_IMP)
			-- Set `docking_source' to `a_source'.
		do
			internal_docking_source := a_source
		end

	on_pick (a_source: EV_PICK_AND_DROPABLE_IMP; a_pebble: ANY)
			-- Called by EV_PICK_AND_DROPABLE_IMP.start_transport
		do
			internal_pick_and_drop_source := a_source
			attached_interface.pick_actions.call ([a_pebble])
		end

	on_drop (a_pebble: detachable ANY)
			-- Called by EV_PICK_AND_DROPABLE_IMP.end_transport
		do
			internal_pick_and_drop_source := Void
		end

feature {EV_ANY_I} -- Implementation

	tooltips: POINTER
			-- Reference to GtkTooltips object.

feature -- Implementation

	is_in_transport: BOOLEAN
			-- Is application currently in transport (either PND or docking)?
		do
			Result := pick_and_drop_source /= Void or else docking_source /= Void
		end

	pick_and_drop_source: detachable EV_PICK_AND_DROPABLE_IMP
			-- Source of pick and drop if any.
		do
			Result := internal_pick_and_drop_source
		end

	docking_source: detachable EV_DOCKABLE_SOURCE_IMP
			-- Source of docking if any.
		assign
			set_docking_source
		do
			Result := internal_docking_source
		end

	internal_pick_and_drop_source: like pick_and_drop_source
	internal_docking_source: like docking_source

	keyboard_modifier_mask: NATURAL_32
			-- Mask representing current keyboard modifiers state.
		local
			l_display_data: like retrieve_display_data
		do
			if use_stored_display_data_for_keys then
					-- If we are inside a key event then we can directly query the key data.
				l_display_data := stored_display_data
			else
				l_display_data := retrieve_display_data
			end
			Result := l_display_data.mask
		end

	retrieve_display_data: TUPLE [window: POINTER; x, y: INTEGER; mask: NATURAL_32]
			-- Retrieve mouse and keyboard data from the display.
		do
			if not use_stored_display_data then
					-- Update values with those from the X Server.
				update_display_data
			end
			Result := stored_display_data
		end

	update_display_data
			-- Update stored values with current values.
		local
			l_window: POINTER
			temp_mask: NATURAL_32
			temp_x, temp_y: INTEGER
			l_screen: POINTER
			l_stored_display_data: like stored_display_data
		do
				-- Update coords for physical to logical.
			l_stored_display_data := stored_display_data

			l_window := {GTK2}.gdk_display_get_window_at_pointer ({GTK2}.gdk_display_get_default, $temp_x, $temp_y)
			{GTK2}.gdk_display_get_pointer ({GTK2}.gdk_display_get_default, $l_screen, $temp_x, $temp_y, $temp_mask)
			l_stored_display_data.window := l_window
			l_stored_display_data.x := temp_x + screen_virtual_x
			l_stored_display_data.y := temp_y + screen_virtual_y
			l_stored_display_data.mask := temp_mask
		end

	im_context_commit_translate_agent: FUNCTION [INTEGER, POINTER, TUPLE]
			-- Translation agent used input method context commits.
		once
			Result :=
			agent (n: INTEGER; p: POINTER): TUPLE
				local
					l_gchar: POINTER
				do
					l_gchar := {GOBJECT}.g_value_pointer (p)
					if l_gchar /= default_pointer then
						reusable_gtk_c_string.share_from_pointer (l_gchar)
					else
						reusable_gtk_c_string.set_with_eiffel_string ("")
					end
					Result := [reusable_gtk_c_string]
				end
		end

	character_string_buffer: STRING_32
		-- Character buffer used for storing converted user keyboard character input.

	use_stored_display_data: BOOLEAN
		-- Should prestored display data values be used when querying for display data.

	use_stored_display_data_for_keys: BOOLEAN
		-- Should prestored display data values be used when querying for key display data.

	stored_display_data: like retrieve_display_data
		-- Store for the previous call to 'retrieve_display_data'
		-- This is needed to avoid unnecessary roundtrips.

	enable_debugger
			-- Enable the Eiffel debugger.
		do
			if debugger_is_disabled then
				debugger_is_disabled := False
				set_debug_state (saved_debug_state)
			end
		end

	disable_debugger
			-- Disable the Eiffel debugger.
		do
			if not debugger_is_disabled then
				debugger_is_disabled := True
				saved_debug_state := debug_state
				disable_debug
			end
		end

	debugger_is_disabled: BOOLEAN
			-- Is the debugger disabled?

feature {EV_ANY_I, EV_FONT_IMP, EV_STOCK_PIXMAPS_IMP, EV_INTERMEDIARY_ROUTINES} -- Implementation

	default_input_context: POINTER
		-- Default input context for application.

	eif_object_from_gtk_object (a_gtk_object: POINTER): detachable EV_ANY_IMP
			-- Return the EV_ANY_IMP object from `a_gtk_object' if any.
		local
			gtkwid, l_null: POINTER
		do
			from
				gtkwid := a_gtk_object
			until
				Result /= Void or else gtkwid = l_null
			loop
				Result := {EV_ANY_IMP}.eif_object_from_c (gtkwid)
				gtkwid := {GTK}.gtk_widget_struct_parent (gtkwid)
			end
			if Result /= Void and then Result.is_destroyed then
				Result := Void
			end
		end

	gtk_widget_imp_at_pointer_position: detachable EV_GTK_WIDGET_IMP
			-- Gtk Widget implementation at current mouse pointer position (if any)
		local
			temp_x, temp_y: INTEGER
			gdkwin, l_null: POINTER
		do
			gdkwin := {GTK2}.gdk_display_get_window_at_pointer ({GTK2}.gdk_display_get_default, $temp_x, $temp_y)
			if gdkwin /= l_null then
				Result := gtk_widget_from_gdk_window (gdkwin)
			end
		end

	gtk_widget_from_gdk_window (a_gdk_window: POINTER): detachable EV_GTK_WIDGET_IMP
			-- Gtk Widget implementation from GdkWindow.
		local
			gtkwid, l_null: POINTER
		do
			{GTK}.gdk_window_get_user_data (a_gdk_window, $gtkwid)
			if gtkwid /= l_null then
				Result ?= eif_object_from_gtk_object (gtkwid)
			end
		end

	gtk_is_launchable: BOOLEAN
		-- Is Gtk launchable?



	default_gtk_window: POINTER
			-- Pointer to a default GtkWindow.
		once
			Result := default_window_imp.c_object
			window_oids.prune_all (Default_window_imp.object_id)
		end

	default_gdk_window: POINTER
			-- Pointer to a default GdkWindow that may be used to
			-- access default visual information (color depth).
		do
			Result := {GTK}.gtk_widget_struct_window (default_gtk_window)
		end

	default_widget: EV_WIDGET
			-- Default widget used for creation of tuples.
		local
			l_widget: detachable EV_WIDGET
		once
			l_widget ?= default_window
			check l_widget /= Void then end
			Result := l_widget
		end

	default_window: EV_WINDOW
			-- Default Window used for creation of agents and holder of clipboard widget.
		once
			create Result
		end

	default_window_imp: EV_WINDOW_IMP
			-- Default window implementation.
		local
			l_result: detachable EV_WINDOW_IMP
		once
			l_result ?= default_window.implementation
			check l_result /= Void then end
			Result := l_result
		end

	default_font_height: INTEGER
			-- Default font height.
		local
			temp_style: POINTER
		do
			temp_style := {GTK}.gtk_widget_struct_style (default_gtk_window)
			Result := {GTK}.gdk_font_struct_ascent ({GTK2}.gtk_style_get_font (temp_style))
		end

	default_font_ascent: INTEGER
			-- Default font ascent.
		local
			temp_style: POINTER
		do
			temp_style := {GTK}.gtk_widget_struct_style (default_gtk_window)
			Result := {GTK}.gdk_font_struct_ascent ({GTK2}.gtk_style_get_font (temp_style))
		end

	default_font_descent: INTEGER
			-- Default font descent.
		local
			temp_style: POINTER
		do
			temp_style := {GTK}.gtk_widget_struct_style (default_gtk_window)
			Result := {GTK}.gdk_font_struct_descent ({GTK2}.gtk_style_get_font (temp_style))
		end

	reusable_rectangle_struct: POINTER
			-- Persistent GdkRectangle struct
		once
			Result := {GTK}.c_gdk_rectangle_struct_allocate
		end

	c_string_from_eiffel_string (a_string: READABLE_STRING_GENERAL): EV_GTK_C_STRING
			-- Return a EV_GTK_C_STRING from`a_string'
			-- `Item' of result must not be freed by gtk.
			-- Result must only be used for temporary setting and should not be persistent.
		require
			a_string_not_void: a_string /= Void
		do
			if a_string.count > default_c_string_size then
					-- Create a new gtk C string to conserve memory.
				Result := a_string
			else
				Result := reusable_gtk_c_string
				Result.set_with_eiffel_string (a_string)
			end
		end

	reusable_gtk_c_string: EV_GTK_C_STRING
			-- Persistent EV_GTK_C_STRING.
		once
			create Result.set_with_eiffel_string ("")
		end

	reusable_color_struct: POINTER
			-- Persistent GdkColorStruct
		once
			Result := {GTK}.c_gdk_color_struct_allocate
		end

feature -- Thread Handling.

	initialize_threading
			-- Initialize thread support.
		do
			if {PLATFORM}.is_thread_capable then
				create idle_action_mutex.make
			end
		end

feature {NONE} -- External implementation

	default_c_string_size: INTEGER = 1000
		-- Default size to set the reusable gtk C string.

	saved_debug_state: like debug_state
		-- Debug mode before debugger was disabled

	enable_ev_gtk_log (a_mode: INTEGER)
			-- Connect GTK+ logging to Eiffel exception handler.
			-- `a_mode' = 0 means no log messages, 1 = messages, 2 = messages with exceptions.
		external
			"C (EIF_INTEGER) | %"ev_c_util.h%""
		end

	gtk_init
		external
			"C [macro <ev_gtk.h>] | %"eif_argv.h%""
		alias
    		"gtk_init (&eif_argc, &eif_argv)"
		end

	gtk_init_check: BOOLEAN
		external
			"C [macro <ev_gtk.h>] | %"eif_argv.h%""
		alias
    		"gtk_init_check (&eif_argc, &eif_argv)"
		end

feature {NONE} -- Externals

	static_mutex: POINTER;
		-- Pointer to the global static mutex

note
	copyright:	"Copyright (c) 1984-2020, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end -- class EV_APPLICATION_IMP





