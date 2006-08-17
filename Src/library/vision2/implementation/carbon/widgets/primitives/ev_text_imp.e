indexing

	description:
		"EiffelVision text area, gtk implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TEXT_IMP

inherit
	EV_TEXT_I
		redefine
			interface,
			text_length
		end

	EV_TEXT_COMPONENT_IMP
		redefine
			interface,
			insert_text,
			initialize,
			create_change_actions,
			dispose,
			text_length,
			default_key_processing_blocked,
			visual_widget
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			visual_widget,
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a gtk text view.
		do
			base_make (an_interface)

		end

	create_change_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Hook up the change actions for the text widget
		do

		end

	initialize is
			-- Initialize `Current'
		do
			enable_word_wrapping
			set_editable (True)
			set_background_color ((create {EV_STOCK_COLORS}).white)
			initialize_buffer_events
			Precursor {EV_TEXT_COMPONENT_IMP}
		end

	initialize_buffer_events is
			-- Initialize events for `Current'
		do

		end

feature -- Access

	clipboard_content: STRING_32 is
			-- `Result' is current clipboard content.
		do

		end

feature -- Status report

	line_number_from_position (i: INTEGER): INTEGER is
			-- Line containing caret position `i'.
		do

		end

	is_editable: BOOLEAN
			-- Is the text editable by the user?

	has_selection: BOOLEAN is
			-- Does `Current' have a selection?
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

feature -- Status setting

	set_editable (flag: BOOLEAN) is
			-- if `flag' then make the component read-write.
			-- if not `flag' then make the component read-only.
		do

		end

	set_caret_position (pos: INTEGER) is
			-- set current insertion position
		do

		end

feature -- Basic operation

	select_region (start_pos, end_pos: INTEGER) is
			-- Select (hilight) the text between
			-- `start_pos' and `end_pos'. Both `start_pos' and
			-- `end_pos' are selected.
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
			-- Cut `selected_region' by erasing it from
			-- the text and putting it in the Clipboard to paste it later.
			-- If `selectd_region' is empty, it does nothing.
		do

		end

	copy_selection is
			-- Copy `selected_region' into the Clipboard.
			-- If the `selected_region' is empty, it does nothing.
		do

		end

	paste (index: INTEGER) is
			-- Insert the contents of the clipboard
			-- at `index' postion of `text'.
			-- If the Clipboard is empty, it does nothing.

		do

		end

feature -- Access

	text: STRING_32 is

		do

		end

	line (a_line: INTEGER): STRING_32 is
			-- Returns the content of line `a_line'.
		do

		end

	first_position_from_line_number (a_line: INTEGER): INTEGER is
			-- Position of the first character on line `a_line'.
		do

		end

	last_position_from_line_number (a_line: INTEGER): INTEGER is
			-- Position of the last character on line `a_line'.
		do

		end

feature -- Status report

	text_length: INTEGER is
			-- Number of characters in `Current'
		do

		end

	line_count: INTEGER is
			-- Number of display lines present in widget.
		do

		end

	current_line_number: INTEGER is
			-- Returns the number of the display line the cursor currently
			-- is on.
		do

		end

	caret_position: INTEGER is
			-- Current position of the caret.
		do

		end

	has_word_wrapping: BOOLEAN
			-- Does `Current' have word wrapping enabled?

feature -- Status setting

	insert_text (a_text: STRING_GENERAL) is
		do

		end

	set_text (a_text: STRING_GENERAL) is
			-- Set `text' to `a_text'
		do

		end

	append_text (a_text: STRING_GENERAL) is
			-- Append `a_text' to `text'.
		do

		end

	prepend_text (a_text: STRING_GENERAL) is
			-- Prepend 'txt' to `text'.
		do

		end

	delete_text (start, finish: INTEGER) is
			-- Delete the text between `start' and `finish' index
			-- both sides include.
		do

		end

feature -- Basic operation

	scroll_to_line (i: INTEGER) is
			-- Scroll `Current' to line number `i'
		do

		end

	enable_word_wrapping is
			-- Enable word wrapping for `Current'
		do
				has_word_wrapping := true
		end

	disable_word_wrapping is
			-- Disable word wrapping for `Current'
		do

		end

feature {NONE} -- Implementation

	default_key_processing_blocked (a_key: EV_KEY): BOOLEAN is
			--	Does `a_key' require gtk default key processing to be blocked?
		do

		end

	visual_widget: POINTER is
			-- Pointer to the GtkWidget representing `Current'
		do
			Result := text_view
		end

	selection_start_internal: INTEGER is
			-- Index of the first character selected.
		do

		end

	selection_end_internal: INTEGER is
			-- Index of the last character selected.
		do

		end

	dispose is
			-- Clean up `Current'
		do

		end

	on_change_actions is
			-- The text within the widget has changed.
		do

		end

	append_text_internal (a_text_buffer: POINTER; a_text: STRING_GENERAL) is
			-- Append `txt' to `text'.
		do

		end

	internal_set_caret_position (pos: INTEGER) is
			-- set current insertion position
		do

		end

	text_view: POINTER
		-- Pointer to the GtkTextView widget

	scrolled_window: POINTER
		-- Pointer to the GtkScrolledWindow

	text_buffer: POINTER
			-- Pointer to the GtkTextBuffer.

feature {EV_ANY_I} -- Implementation

	interface: EV_TEXT;

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




end -- class EV_TEXT_IMP

