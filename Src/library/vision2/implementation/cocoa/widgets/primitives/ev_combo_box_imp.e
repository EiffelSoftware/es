note
	description: "EiffelVision combo box, Cocoa implementation."
	author: "Daniel Furrer"
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
		rename
			text_field as combo_box
		undefine
			pre_pick_steps,
			is_height_resizable,
			control_text_did_change_
		redefine
			make,
			interface,
			has_focus,
			dispose,
			combo_box
		end

	EV_LIST_ITEM_LIST_IMP
		undefine
			on_key_event,
			default_key_processing_blocked,
			has_focus,
			set_focus,
			dispose
		redefine
			make,
			interface
		end

	EV_COMBO_BOX_ACTION_SEQUENCES_IMP

	EV_COMBO_BOX_DELEGATE
		rename
			item as delegate_item
		undefine
			copy,
			is_equal
		redefine
			make,
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Create a Cocoa combo-box.
		do
			Precursor {EV_COMBO_BOX_DELEGATE}
			create combo_box.make
			combo_box.set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := combo_box
			Precursor {EV_LIST_ITEM_LIST_IMP}
			Precursor {EV_TEXT_FIELD_IMP}
			combo_box.set_delegate_ (Current)
		end

feature {NONE} -- Initialization

	call_selection_action_sequences
			-- Call the appropriate selection action sequences
		do
			select_actions.call ([])
		end

	insert_item (item_imp: EV_LIST_ITEM_IMP; pos: INTEGER)
			-- Insert `item_imp' at the one-based index `an_index'.
		do
			combo_box.insert_item_with_object_value__at_index_ (create {NS_STRING}.make_with_eiffel_string (item_imp.text.as_string_8), pos - 1)
			-- Select the item if it is the first:
			if combo_box.number_of_items = 1 then
				combo_box.select_item_at_index_ (0)
			end
		end

	remove_item (item_imp: EV_LIST_ITEM_IMP)
			-- Remove `item_imp' from `Current'.
		local
			an_index: INTEGER
		do
			an_index := ev_children.index_of (item_imp, 1)
			combo_box.remove_item_at_index_ (an_index - 1)
		end

feature -- Status report

	has_focus: BOOLEAN
			-- Does widget have the keyboard focus?
		do
			if attached combo_box.window as l_window then
				Result := l_window.first_responder = combo_box
			end
		end

	selected_item: detachable EV_LIST_ITEM
			-- Item which is currently selected
		local
			l_index: INTEGER
		do
			l_index := combo_box.index_of_selected_item.to_integer
			if l_index > 0 then
				Result := i_th (l_index + 1)
			end -- otherwise no item is selected, return void
		end

	selected_items: ARRAYED_LIST [EV_LIST_ITEM]
			-- List of all the selected items. Used for list_item.is_selected implementation.
		local
			l_item: detachable EV_LIST_ITEM
		do
			create Result.make (1)
			l_item := i_th (combo_box.index_of_selected_item.to_integer_32 + 1)
			check l_item /= Void end
			Result.put (l_item)
		end

	select_item (a_index: INTEGER)
			-- Select an item at the one-based `index' of the list.
		do
			combo_box.select_item_at_index_ (a_index - 1)
		end

	deselect_item (a_index: INTEGER)
			-- Unselect the item at the one-based `index'.
		do
			combo_box.deselect_item_at_index_ (a_index - 1)
		end

	clear_selection
			-- Clear the item selection of `Current'.
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i < count
			loop
				combo_box.deselect_item_at_index_ (i)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	combo_box_selection_did_change_ (a_notification: NS_NOTIFICATION)
		do
			call_selection_action_sequences
		end

	is_list_shown: BOOLEAN

	dispose
			do
				Precursor {EV_COMBO_BOX_DELEGATE}
				Precursor {EV_LIST_ITEM_LIST_IMP}
				Precursor {EV_TEXT_FIELD_IMP}
			end

	pixmaps_size_changed
			-- The size of the displayed pixmaps has just
			-- changed.
		do
		end

feature {EV_ANY_I} -- Implementation

	combo_box: NS_COMBO_BOX

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_COMBO_BOX note option: stable attribute end;

end -- class EV_COMBO_BOX_IMP
