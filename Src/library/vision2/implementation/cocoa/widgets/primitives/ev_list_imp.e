note
	description: "EiffelVision list, Cocoa implementation"
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LIST_IMP

inherit
	EV_LIST_I
		rename
			item as list_item
		undefine
			wipe_out,
			selected_items,
			call_pebble_function
		redefine
			interface,
			disable_default_key_processing
		end

	EV_LIST_ITEM_LIST_IMP
		rename
			item as list_item
		redefine
			interface,
			make,
			on_mouse_button_event,
			row_height,
			minimum_height,
			minimum_width,
			dispose
		end

	NS_TABLE_VIEW_DATA_SOURCE_PROTOCOL
		undefine
			copy,
			is_equal
		redefine
			number_of_rows_in_table_view_,
			table_view__object_value_for_table_column__row_,
			dispose
		end

	NS_TABLE_VIEW_DELEGATE_PROTOCOL
		undefine
			copy,
			is_equal
		redefine
			table_view_selection_did_change_,
			dispose
		end

	NS_OBJECT
		undefine
			copy,
			is_equal,
			wrapper_objc_class_name
		redefine
			make,
			dispose
		end

create
	make

feature -- Initialize

	make
			-- Initialize the list.
		local
			table_column: NS_TABLE_COLUMN
		do
			add_objc_callback ("numberOfRowsInTableView:", agent number_of_rows_in_table_view_)
			add_objc_callback ("tableView:objectValueForTableColumn:row:", agent table_view__object_value_for_table_column__row_)
			add_objc_callback ("tableViewSelectionDidChange:", agent table_view_selection_did_change_)
			create scroll_view.make_with_frame_ (create {NS_RECT}.make_with_coordinates (0, 0 , 0, 0))
			scroll_view.set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := scroll_view
			create table_view.make_with_frame_ (create {NS_RECT}.make_with_coordinates (0, 0 , minimum_width, minimum_height))
			table_view.set_header_view_ (Void)
			scroll_view.set_border_type_ (2)
			scroll_view.set_document_view_ (table_view)
			scroll_view.set_has_horizontal_scroller_ (True)
			scroll_view.set_has_vertical_scroller_ (True)
			scroll_view.set_autohides_scrollers_ (True)
			create table_column.make
			table_column.set_editable_ (False)
			table_view.add_table_column_ (table_column)
			table_column.set_width_ ({REAL_32}1000.0)
			Precursor {NS_OBJECT}
			Precursor {EV_LIST_ITEM_LIST_IMP}
			table_view.set_data_source_ (Current)
			table_view.set_delegate_ (Current)

			enable_tabable_to
		end

feature -- Delegate

	table_view_selection_did_change_ (a_notification: NS_NOTIFICATION)
			-- The selection of the table view changed
		do
			select_actions.call ([])
			if attached selected_item as l_item then
				l_item.select_actions.call([])
			end
		end

feature -- DataSource

	number_of_rows_in_table_view_ (a_table_view:NS_TABLE_VIEW): INTEGER_64
		do
			Result := count
		end

	table_view__object_value_for_table_column__row_ (a_table_view: detachable NS_TABLE_VIEW; a_table_column: detachable NS_TABLE_COLUMN; a_row: INTEGER_64): detachable NS_OBJECT
		do
			Result := create {NS_STRING}.make_with_eiffel_string (i_th (a_row.as_integer_32 + 1).text)
		end

feature -- Access

	selected_item: detachable EV_LIST_ITEM
			-- Item which is currently selected, for a multiple
			-- selection.
		do
			if table_view.selected_row >= 0 then
				Result := i_th (table_view.selected_row.as_integer_32 + 1)
			end
		end

	selected_items: ARRAYED_LIST [EV_LIST_ITEM]
			-- List of all the selected items. For a single
			-- selection list, it gives a list with only one
			-- element which is `selected_item'. Therefore, one
			-- should use `selected_item' rather than
			-- `selected_items' for a single selection list.
		do
			create Result.make (1)
			if attached selected_item as l_item then
				Result.extend (l_item)
			end
		end

feature -- Status Report

	multiple_selection_enabled: BOOLEAN
			-- True if the user can choose several items
			-- False otherwise.

feature -- Status setting

	ensure_item_visible (an_item: EV_LIST_ITEM)
			-- Ensure item `an_index' is visible in `Current'.
		do
		end

	enable_multiple_selection
			-- Allow the user to do a multiple selection simply
			-- by clicking on several choices.
		do
			multiple_selection_enabled := True
		end

	disable_multiple_selection
			-- Allow the user to do only one selection. It is the
			-- default status of the list.
		do
			multiple_selection_enabled := False
		end

	select_item (an_index: INTEGER)
			-- Select an item at the one-based `index' of the list.
		do
		end

	deselect_item (an_index: INTEGER)
			-- Unselect the item at the one-based `index'.
		do
		end

	clear_selection
			-- Clear the selection of the list.
		do
		end

feature -- PND

	on_mouse_button_event (a_type: INTEGER; a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			-- Initialize a pick and drop transport.
		do
		end

	row_height: INTEGER
			-- Height of rows in `Current'
			-- (export status {NONE})
		do
		end

feature -- Dispose

	dispose
		do
--			table_view.set_data_source_ (Void)
--			table_view.set_delegate_ (Void)
			Precursor {NS_OBJECT}
			Precursor {EV_LIST_ITEM_LIST_IMP}
		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation


	call_selection_action_sequences
			-- Call appropriate selection and deselection action sequences
		do
		end

feature {NONE} -- Implementation

	disable_default_key_processing
			-- Ensure default key processing is not performed.
		do
		end

	pixmaps_size_changed
			-- The size of the displayed pixmaps has just
			-- changed.
		do
		end

	vertical_adjustment_struct: POINTER
			-- Pointer to vertical adjustment struct use in the scrollbar.
		do
		end

	insert_item (item_imp: EV_LIST_ITEM_IMP; an_index: INTEGER)
			-- Insert `item_imp' at `an_index'.
		do
			table_view.reload_data
		end

	remove_item (item_imp: EV_LIST_ITEM_IMP)
			-- Remove `item' from the list
		do
			table_view.reload_data
		end

	minimum_height: INTEGER
			-- Minimum height that the widget may occupy.
		do
			Result := 74 -- Hardcoded
		end

	minimum_width: INTEGER
			-- Minimum width that the widget may occupy.
		do
			Result := 55 -- Hardcoded
		end

feature {EV_ANY_I, EV_TREE_NODE_IMP} -- Implementation

	scroll_view: NS_SCROLL_VIEW

	table_view: NS_TABLE_VIEW;

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_LIST note option: stable attribute end;

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
		do
			Result := "NSOutlineView"
		end

end -- class EV_LIST_IMP
