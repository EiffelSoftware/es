indexing
	description:
		"Eiffel Vision button. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "press, push, label, pixmap"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_BUTTON_IMP

inherit
	EV_BUTTON_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			initialize,
			make,
			set_foreground_color,
			on_focus_changed,
			needs_event_box,
			event_widget
		end

	EV_PIXMAPABLE_IMP
		redefine
			interface,
			initialize
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			initialize,
			align_text_left,
			align_text_center,
			align_text_right
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			initialize,
			fontable_widget
		end

	EV_BUTTON_ACTION_SEQUENCES_IMP
		export
			{EV_INTERMEDIARY_ROUTINES} select_actions_internal
		redefine
			interface
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			err : INTEGER
			rect : RECT_STRUCT
			struct_ptr : POINTER
			target: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left(20)
			rect.set_right(100)
			rect.set_bottom(40)
			rect.set_top (20)
			err := create_push_button_control_external( null, rect.item, null, $struct_ptr )
			set_c_object ( struct_ptr )
			id:=app_implementation.get_id (current)  --getting an id from the application
			target:=get_control_event_target_external(struct_ptr)
				--	app_implementation.install_event_handler(id,res ,1 ,2)
			app_implementation.install_event_handler (id, target, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventMouseDown)

		end

	initialize is
			-- `Precursor' initialization,
			-- create button box to hold label and pixmap.
		do
			Precursor {EV_PRIMITIVE_IMP}
		end

	fontable_widget: POINTER is
			-- Pointer to the widget that may have fonts set.
		do
		end

	event_widget: POINTER is
			-- Widget that handles the events.
		do
		end

	needs_event_box: BOOLEAN is True
		-- Make sure `Current' is placed within a GtkEventBox.

feature -- Access

	is_default_push_button: BOOLEAN is
			-- Is this button currently a default push button
			-- for a particular container?
		local
			res : INTEGER
		do
			res := get_control_data_boolean( c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlButtonPart, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlPushButtonDefaultTag )
			if res > 0 then
				Result := true
			else
				Result := false
			end
		end

feature -- Status Setting

	align_text_center is
			-- Display `text' centered.
		do		end

	align_text_left is
			-- Display `text' left aligned.
		do		end

	align_text_right is
			-- Display `text' right aligned.
		do		end

	enable_default_push_button is
			-- Set the style of the button corresponding
			-- to the default push button.
		local
			res : INTEGER
		do
			res := set_control_data_boolean( c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlButtonPart, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlPushButtonDefaultTag, true  )
		end


	get_control_data_boolean (incontrol: POINTER; inpart: INTEGER; intagname: INTEGER): INTEGER is
			-- get a boolean value with get_control_data
			-- Resturns >0 if result was true, =0 if false, <0 if an error occured
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
				 	Boolean temp;
				 	Size ActualSize;
					OSErr res = GetControlData( $incontrol, $inpart, $intagname, sizeof(temp), &temp, &ActualSize );
					if ( ActualSize == sizeof(temp) )
						return temp;
					else
						return res;
				}
			]"
		end

		set_control_data_boolean (incontrol: POINTER; inpart: INTEGER; intagname: INTEGER;  value : BOOLEAN): INTEGER is
			-- set a boolean value with set_control_data
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
				 	Boolean temp = $value;
					return SetControlData( $incontrol, $inpart, $intagname, sizeof(temp), &temp );
				}
			]"
		end

	disable_default_push_button is
			-- Remove the style of the button corresponding
			-- to the default push button.
		local
			res : INTEGER
		do
			res := set_control_data_boolean( c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlButtonPart, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlPushButtonDefaultTag, false  )
		end

	enable_can_default is
			-- Allow the style of the button to be the default push button.
		do
			 -- doesn't seem to be necessary in Carbon.
		end

	set_foreground_color (a_color: EV_COLOR) is
		do
		end

feature {NONE} -- implementation

	on_focus_changed (a_has_focus: BOOLEAN) is
			-- Called from focus intermediary agents when focus for `Current' has changed.
			-- if `a_has_focus' then `Current' has just received focus.
		do
		end

feature {EV_ANY_I} -- implementation

	interface: EV_BUTTON
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

invariant
true

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

end -- class EV_BUTTON_IMP
