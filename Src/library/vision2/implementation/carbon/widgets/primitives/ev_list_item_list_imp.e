indexing
	description: "EiffelVision list item list, gtk implementation"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_LIST_ITEM_LIST_IMP

inherit
	EV_LIST_ITEM_LIST_I
		redefine
			call_pebble_function,
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			call_pebble_function,
			initialize,
			interface,
			pre_pick_steps
		end

	EV_ITEM_LIST_IMP [EV_LIST_ITEM]
		redefine
			interface,
			insert_i_th,
			remove_i_th,
			initialize
		end

	EV_LIST_ITEM_LIST_ACTION_SEQUENCES_IMP

	EV_KEY_CONSTANTS

	EV_PND_DEFERRED_ITEM_PARENT

feature {NONE} -- Initialization

	initialize is
			-- Set up `Current'
		do

		end

	initialize_model is
			-- Create our data model for `Current'
		do

		end

feature -- Access

	selected_items: ARRAYED_LIST [EV_LIST_ITEM] is
			-- `Result is all items currently selected in `Current'.
		deferred
		end

feature -- Status report

	row_from_y_coord (a_y: INTEGER): EV_PND_DEFERRED_ITEM is
			-- Retrieve the Current row from `a_y' coordinate
		do
		end

	update_pnd_status is
			-- Update PND status of list and its children.
		do

		end

	update_pnd_connection (a_enable: BOOLEAN) is
			-- Update the PND connection of `Current' if needed.
		do

		end

	pre_pick_steps (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
				-- Steps to perform before transport initiated.
			do

			end

	row_height: INTEGER is
			-- Default height of rows
		do

		end

	pnd_row_imp: EV_LIST_ITEM_IMP
			-- Implementation object of the current row if in PND transport.

	temp_pebble: ANY

	temp_pebble_function: FUNCTION [ANY, TUPLE [], ANY]
			-- Returns data to be transported by PND mechanism.

	temp_accept_cursor, temp_deny_cursor: EV_CURSOR

	call_pebble_function (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Set `pebble' using `pebble_function' if present.
		do

		end

feature -- Status setting

	select_item (an_index: INTEGER) is
			-- Select item at one based index, `an_index'.
		deferred
		end

	deselect_item (an_index: INTEGER) is
			-- Deselect item at one based index, `an_index'.
		deferred
		end

feature -- Insertion

	set_text_on_position (a_row: INTEGER; a_text: STRING_GENERAL) is
			-- Set cell text at (a_column, a_row) to `a_text'.
		do

		end

	g_value_string_struct: POINTER is
			-- Optimization for GValue struct access
		once

		end

	set_row_pixmap (a_row: INTEGER; a_pixmap: EV_PIXMAP) is
			-- Set row `a_row' pixmap to `a_pixmap'.
		do

		end

	remove_row_pixmap (a_row: INTEGER) is
			-- Set row `a_row' pixmap to `a_pixmap'.
		do

		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		do

		end

feature {EV_LIST_ITEM_LIST_IMP, EV_LIST_ITEM_IMP} -- Implementation

	interface: EV_LIST_ITEM_LIST

	list_store: POINTER
		-- Pointer to the model which holds all of the column data

feature {NONE} -- Implementation

	remove_i_th (an_index: INTEGER) is
		do

		end

--	new_list_store: POINTER is
--			-- New instance of a list store.
--		external
--			"C inline use <gtk/gtk.h>"
--		alias
--			"gtk_list_store_new (2, GDK_TYPE_PIXBUF, G_TYPE_STRING)"
--		end

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




end -- class EV_LIST_ITEM_LIST_IMP

