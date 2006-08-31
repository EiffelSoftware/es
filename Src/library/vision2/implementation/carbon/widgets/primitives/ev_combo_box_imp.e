indexing

	description:
		"EiffelVision combo box, gtk implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_COMBO_BOX_IMP

inherit
	EV_COMBO_BOX_I
		undefine
			wipe_out,
			call_pebble_function
		redefine
			interface
		end

	EV_TEXT_FIELD_IMP
		undefine
			create_focus_in_actions,
			create_focus_out_actions,
			pre_pick_steps,
			call_pebble_function,
			enable_transport,
			hide_border
		redefine
			initialize,
			make,
			interface,
			has_focus,
			on_focus_changed,
			dispose
		end

	EV_LIST_ITEM_LIST_IMP
		undefine
			set_default_colors,
			destroy,
			on_key_event,
			default_key_processing_blocked,
			on_focus_changed,
			has_focus,
			set_focus,
			dispose
		redefine
			initialize,
			make,
			interface,
			insert_i_th
		end

	EV_COMBO_BOX_ACTION_SEQUENCES_IMP

	EV_KEY_CONSTANTS

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a combo-box.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			ret := create_popup_button_control_external ( null, rect.item, null, -12345, 0, 0, 0, 0, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id ( current )
		end

feature {NONE} -- Initialization

	call_selection_action_sequences is
			-- Call the appropriate selection action sequences
		do

		end

	previous_selected_item_imp: EV_LIST_ITEM_IMP
		-- Item that was selected previously.

	initialize is
			-- Connect action sequences to signals.
		do

		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		do

		end

feature -- Status report

	has_focus: BOOLEAN is
			-- Does widget have the keyboard focus?
		do

		end

	selected_item: EV_LIST_ITEM is
			-- Item which is currently selected, for a multiple
			-- selection.
		do

		end

	selected_items: ARRAYED_LIST [EV_LIST_ITEM] is
			-- List of all the selected items. Used for list_item.is_selected implementation.
		do

		end

	select_item (an_index: INTEGER) is
			-- Select an item at the one-based `index' of the list.
		do

		end

	deselect_item (an_index: INTEGER) is
			-- Unselect the item at the one-based `index'.
		do

		end

	clear_selection is
			-- Clear the item selection of `Current'.
		do

		end

feature -- Status setting

	set_maximum_text_length (len: INTEGER) is
			-- Set the length of the longest text size in characters that `Current' can display.
		do

		end

feature {NONE} -- Implementation

	on_focus_changed (a_has_focus: BOOLEAN) is
			-- Focus for `Current' has changed'.
		do
		end

	is_list_shown: BOOLEAN
		-- Is combo list current shown?

	retrieve_toggle_button_signal_connection_id: INTEGER
		-- Signal connection id used when finding the toggle button of `Current'.

feature {EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Event handling

	retrieve_toggle_button is
			-- Retrieve the toggle button from the GtkComboBox structure.
		do

		end

	toggle_button_toggled is
			-- The toggle button has been toggled.
		do
		end

feature {NONE} -- Externals

--	frozen return_combo_toggle (a_combo: POINTER; a_toggle_button: TYPED_POINTER [POINTER]) is
--		external
--			"C inline use %"ev_c_util.h%""
--		alias
--			"[
--				{
--				gtk_container_forall (GTK_CONTAINER ($a_combo), (GtkCallback) c_gtk_return_combo_toggle, (GtkWidget**) $a_toggle_button);
--				}
--			]"
--		end

feature {EV_LIST_ITEM_IMP, EV_INTERMEDIARY_ROUTINES} -- Implementation

	container_widget: POINTER
			-- Gtk combo struct

feature {NONE} -- Implementation
	dispose is
			do
				precursor {EV_LIST_ITEM_LIST_IMP}
				precursor {EV_TEXT_FIELD_IMP}
			end

	pixmaps_size_changed is
			-- The size of the displayed pixmaps has just
			-- changed.
		do
			--| FIXME IEK Add pixmap scaling code with gtk+ 2
			--| For now, do nothing.
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_COMBO_BOX;

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




end -- class EV_COMBO_BOX_IMP

