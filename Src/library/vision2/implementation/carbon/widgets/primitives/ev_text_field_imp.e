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
			set_minimum_width_in_characters
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			visual_widget
		end

	EV_TEXT_FIELD_ACTION_SEQUENCES_IMP
		export
			{EV_INTERMEDIARY_ROUTINES}
				return_actions_internal
		redefine
			create_return_actions
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

feature -- Access

	frozen kTXNSingleLineOnlyMask: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

		"kTXNSingleLineOnlyMask"
	end

	frozen kTXNTextData: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

		"kTXNTextData"
	end

	frozen kTXNStartOffset: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

		"kTXNStartOffset"
	end

	frozen kTXNEndOffset: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

		"kTXNEndOffset"
	end

	frozen kTXNUnicodeTextData: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

		"kTXNUnicodeTextData"
	end

	get_text_length (obj: POINTER):INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

			"[
				{	Handle h;
					TXNGetData ($obj, kTXNStartOffset, kTXNEndOffset, &h);
					int length = GetHandleSize(h);
					return length/2;
				}
			]"
	end

	get_text (obj, buf_ptr: POINTER) is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

			"[
				{	
					char chr;
					Handle h;
					TXNObject t = HITextViewGetTXNObject($obj);
					TXNGetData (t, kTXNStartOffset, kTXNEndOffset, &h);
					int length = GetHandleSize(h);

					//char buffer[length/2];

					char* buffer=$buf_ptr;
					HLock (h);
						char* p = (char *)*h;
						char* q= (char *)*h;
						int i=0;
						for (; q <= (p+length)&& ((char) *q!='\n'); q++)
						{
							buffer[i] = (char) *q;
							i++;
							q++;
						}
					HUnlock (h);
					DisposeHandle (h);
				}
			]"
	end

	text: STRING_32 is
			-- Text displayed in field.
		local
			string_ptr: POINTER
			ret: INTEGER
			c_str: C_STRING

		do

			create c_str.make_empty (get_text_length(entry_widget))
			get_text (c_object, c_str.item)
			io.put_string (c_str.string)
			Result := c_str.string
		end

feature -- Status setting

	set_minimum_width_in_characters (nb: INTEGER) is
			-- Make `nb' characters visible on one line.
		local
			ret : INTEGER
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
		do
			create rect.make_new_unshared
			ret := hiview_get_frame_external (c_object, rect.item)

			create size.make_unshared (rect.size)

			-- maximum_character_width should be implemented
			--size.set_width ((nb + 1) * maximum_character_width)

			size.set_width (100)
			rect.set_size (size.item)
			ret := hiview_set_frame_external (c_object, rect.item)
		end

	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		local
			a_c_str: C_STRING
			ret: INTEGER
		do
			create a_c_str.make (a_text)
			ret := txnset_data_external (entry_widget, kTXNTextData, a_c_str.item, a_text.count, kTXNStartOffset, kTXNEndOffset)
		end

	append_text (txt: STRING_GENERAL) is
			-- Append `txt' to the end of the text.
		local
			a_c_str: C_STRING
			ret: INTEGER
		do
			create a_c_str.make (txt)
			ret := txnset_data_external (entry_widget, kTXNTextData, a_c_str.item, txt.count, kTXNEndOffset, kTXNEndOffset)
		end

	prepend_text (txt: STRING_GENERAL) is
			-- Prepend `txt' to the end of the text.
		local
			a_c_str: C_STRING
			ret: INTEGER
		do
			create a_c_str.make (txt)
			ret := txnset_data_external (entry_widget, kTXNTextData, a_c_str.item, txt.count, kTXNStartOffset, kTXNStartOffset)
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

feature -- Status Report

	caret_position: INTEGER is
			-- Current position of the caret.
		local
			starto, endo: INTEGER
		do
			txnget_selection_external (entry_widget, $starto, $endo)
			Result := starto
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	create_return_actions: EV_NOTIFY_ACTION_SEQUENCE is
		do
			create Result
		end

feature -- Status report

	is_editable: BOOLEAN is
			-- Is the text editable.
		do
		end

	has_selection: BOOLEAN is
			-- Is something selected?
		do
		end

	selection_start: INTEGER is
			-- Index of the first character selected.
		do
		end

	selection_end: INTEGER is
			-- Index of the last character selected.
		do
		end

	clipboard_content: STRING_32 is
			-- `Result' is current clipboard content.
		do
		end

feature -- status settings

	hide_border is
			-- Hide the border of `Current'.
		do
		end

	set_editable (flag: BOOLEAN) is
			-- `flag' true make the component read-write and
			-- `flag' false make the component read-only.
		do
		end

	set_caret_position (pos: INTEGER) is
			-- Set the position of the caret to `pos'.
		do
		end

feature -- Basic operation

	insert_text (txt: STRING_GENERAL) is
			-- Insert `txt' at the current position.
		do
		end

	insert_text_at_position (txt: STRING_GENERAL; a_pos: INTEGER) is
			-- Insert `txt' at the current position at position `a_pos'
		do
		end

	select_region (start_pos, end_pos: INTEGER) is
			-- Select (highlight) the text between
			-- 'start_pos' and 'end_pos'.
		do
		end

	select_from_start_pos (start_pos, end_pos: INTEGER) is
			-- Hack to select region from change actions
		do
		end

	select_region_internal (start_pos, end_pos: INTEGER) is
			-- Select region
		do
		end

	deselect_all is
			-- Unselect the current selection.
		do
		end

	delete_selection is
			-- Delete the current selection.
		do
		end

	cut_selection is
			-- Cut the `selected_region' by erasing it from
			-- the text and putting it in the Clipboard
			-- to paste it later.
			-- If the `selected_region' is empty, it does
			-- nothing.
		do
		end

	copy_selection is
			-- Copy the `selected_region' in the Clipboard
			-- to paste it later.
			-- If the `selected_region' is empty, it does
			-- nothing.
		do
		end

	paste (index: INTEGER) is
			-- Insert the string which is in the
			-- Clipboard at the `index' position in the
			-- text.
			-- If the Clipboard is empty, it does nothing.
		do
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	internal_set_caret_position (pos: INTEGER) is
			-- Set the position of the caret to `pos'.
		do
		end

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

	real_text: STRING_GENERAL

feature {NONE} -- Implementation

	entry_widget: POINTER
		-- A pointer on the text field

	visual_widget: POINTER is
			-- Pointer to the widget shown on screen.
		do
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

