indexing
	description: "EiffelVision text field. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TEXT_FIELD_IMP

inherit
	EV_TEXT_FIELD_I
		redefine
			interface,
			hide_border
		end

	EV_TEXT_COMPONENT_IMP
		redefine
			interface,
			visual_widget,
			create_change_actions,
			on_key_event,
			set_minimum_width_in_characters,
			dispose
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			visual_widget,
			dispose
		end

	EV_TEXT_FIELD_ACTION_SEQUENCES_IMP
		export
			{EV_INTERMEDIARY_ROUTINES}
				return_actions_internal
		redefine
			create_return_actions
		end
	EV_CARBON_TXN
		undefine
			default_key_processing_blocked,
			initialize
		redefine
			make,
			interface,
			visual_widget,
			dispose,
			hide_border,
			on_key_event
		end
	MACTEXTEDITOR_FUNCTIONS_EXTERNAL
	HIVIEW_FUNCTIONS_EXTERNAL
	CFSTRING_FUNCTIONS_EXTERNAL
	CFBASE_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a carbon entry.
		local
			ret: INTEGER
			struct_ptr: POINTER
			buffer: C_STRING
			point : CGPOINT_STRUCT
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
			a_string: C_STRING
		do
			base_make (an_interface)

			create point.make_new_unshared
			create rect.make_new_unshared
			create size.make_new_unshared

			size.set_height(20)
			size.set_width (100)
			point.set_x (0)
			point.set_y (0)
			rect.set_origin (point.item)
			rect.set_size (size.item)

			ret := hitext_view_create_external (null, 0, kTXNSingleLineOnlyMask, $c_object)
			ret := hiview_set_visible_external (c_object, 1)
			entry_widget := hitext_view_get_txnobject_external (c_object)

			ret := hiview_set_frame_external (c_object, rect.item)
			event_id := app_implementation.get_id (current)  --getting an id from the application
		end

feature -- Status setting
	hide_border is
			do

			end


	set_minimum_width_in_characters (nb: INTEGER) is
			-- Make `nb' characters visible on one line.
		local
			ret : INTEGER
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
		do
			create rect.make_new_unshared
			ret := hiview_get_frame_external (c_object, rect.item)

			create size.make_shared (rect.size)

			-- maximum_character_width should be implemented
			--size.set_width ((nb + 1) * maximum_character_width)

			size.set_width (100)
			rect.set_size (size.item)
			ret := hiview_set_frame_external (c_object, rect.item)
		end


	set_capacity (len: INTEGER) is
			-- Set the maximum number of characters that `Current' can hold to `len'.
		do

		end

	capacity: INTEGER is
			-- Return the maximum number of characters that the
			-- user may enter.
		do
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	create_return_actions: EV_NOTIFY_ACTION_SEQUENCE is
		do
			create Result
		end

feature --dispose
	dispose is
			do
				precursor {EV_CARBON_TXN}
			end



feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	create_change_actions: EV_NOTIFY_ACTION_SEQUENCE is
		do
			create Result
			--real_signal_connect (entry_widget, once "changed", agent  (App_implementation.gtk_marshal).text_component_change_intermediary (c_object), Void)
		end

	stored_text: STRING_32
			-- Value of 'text' prior to a change action, used to compare
			-- between old and new text.

	on_change_actions is
			-- A change action has occurred.
		do
		end

	in_change_action: BOOLEAN
		-- Is `Current' in the process of calling `on_change_actions'

	last_key_backspace: BOOLEAN

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN) is
			-- A key event has occurred
		do
		end

feature {NONE} -- Implementation

	visual_widget: POINTER is
			-- Pointer to the widget shown on screen.
		do
			Result := c_object
		end

feature {EV_TEXT_FIELD_I} -- Implementation

	interface: EV_TEXT_FIELD
			--Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

invariant
	entry_widget_set: entry_widget /= NULL

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




end -- class EV_TEXT_FIELD_IMP

