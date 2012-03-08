note
	description: "Eiffel Vision checkable list. Cocoa implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"


class
	EV_CHECKABLE_LIST_IMP

inherit
	EV_CHECKABLE_LIST_I
		rename
			item as list_item
		undefine
			wipe_out,
			selected_items,
			call_pebble_function,
			disable_default_key_processing
		redefine
			interface
		end

	EV_LIST_IMP
		redefine
			make,
			interface,
			initialize,
			table_view__object_value_for_table_column__row_,
			table_view__data_cell_for_table_column__row_,
			table_view__set_object_value__for_table_column__row_
		end

	EV_CHECKABLE_LIST_ACTION_SEQUENCES_IMP

create
	make

feature {NONE} -- Initialization

	make
		do
			add_objc_callback ("did_check_box:", agent did_check_box)
			add_objc_callback ("tableView:dataCellForTableColumn:row:", agent table_view__data_cell_for_table_column__row_)
			add_objc_callback ("tableView:setObjectValue:forTableColumn:row:", agent table_view__set_object_value__for_table_column__row_)
			Precursor {EV_LIST_IMP}
		end

feature -- Initialization

	initialize
			-- Setup `Current'
		do
			Precursor {EV_LIST_IMP}
		end

feature -- Data Source

	table_view__object_value_for_table_column__row_ (a_table_view: NS_TABLE_VIEW; a_table_column: NS_TABLE_COLUMN; a_row: INTEGER_64): detachable NS_OBJECT
		do
			Result := create {NS_NUMBER}.make_with_bool_ (i_th (a_row.as_integer_32 + 1).is_selected)
		end

feature -- Delegate

	table_view__data_cell_for_table_column__row_ (a_table_view: NS_TABLE_VIEW; a_table_column: NS_TABLE_COLUMN; a_row: INTEGER_64): NS_CELL
		local
			l_result: NS_BUTTON_CELL
		do
			create l_result.make
				-- NSSwitchButton = 3
			l_result.set_button_type_ (3)
			l_result.set_title_ (create {NS_STRING}.make_with_eiffel_string (i_th (a_row.as_integer_32 + 1).text))
			l_result.set_target_ (Current)
			l_result.set_action_ (create {OBJC_SELECTOR}.make_with_name ("did_check_box:"))
			Result := l_result
		end

	table_view__set_object_value__for_table_column__row_ (a_table_view: NS_TABLE_VIEW; a_object: NS_OBJECT; a_table_column: NS_TABLE_COLUMN; a_row: INTEGER_64)
		do
			if not i_th (a_row.as_integer_32 + 1).is_selected then
				i_th (a_row.as_integer_32 + 1).enable_select
			else
				i_th (a_row.as_integer_32 + 1).disable_select
			end
		end

feature {NONE} -- Implementation

	did_check_box (a_sender: NS_TABLE_VIEW)
		local
			l_clicked: INTEGER
		do
			l_clicked := a_sender.clicked_row.as_integer_32 + 1
			if not i_th (l_clicked).is_selected then
				check_actions.call ([i_th (l_clicked)])
			else
				uncheck_actions.call ([i_th (l_clicked)])
			end
		end

feature -- Access

	is_item_checked (a_list_item: EV_LIST_ITEM): BOOLEAN
		do
				-- Assume item is checked if and only if the item is selected
			Result := a_list_item.is_selected
		end

feature -- Status setting

	check_item (a_list_item: EV_LIST_ITEM)
		do
			a_list_item.enable_select
			table_view.reload_data
			if check_actions_internal /= Void then
				check_actions_internal.call ([list_item])
			end
		end

	uncheck_item (a_list_item: EV_LIST_ITEM)
			-- Ensure check associated with `list_item' is
			-- checked.
		do
			a_list_item.disable_select
			table_view.reload_data
			if uncheck_actions_internal /= Void then
				uncheck_actions_internal.call ([list_item])
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: EV_CHECKABLE_LIST;

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_CHECKABLE_LIST_IMP

