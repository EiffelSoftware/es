indexing
	description:
		"EiffelVision Tree, Carbon implementation"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	EV_TREE_IMP

inherit
	EV_TREE_I
		redefine
			interface,
			initialize,
			call_pebble_function,
			append
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			initialize,
			call_button_event_actions,
			create_pointer_motion_actions,
			set_to_drag_and_drop,
			able_to_transport,
			ready_for_pnd_menu,
			disable_transport,
			on_mouse_button_event,
			pre_pick_steps,
			post_drop_steps,
			call_pebble_function,
			on_pointer_motion
		end

	EV_ITEM_LIST_IMP [EV_TREE_NODE]
		export
			{EV_TREE_IMP}
				child_array
		redefine
			interface,
			insert_i_th,
			remove_i_th,
			append,
			initialize
		end

	EV_TREE_ACTION_SEQUENCES_IMP

	EV_PND_DEFERRED_ITEM_PARENT

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

	DATA_BROWSER_ITEM_DATA_PROC_PTR_CALLBACK

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create an empty Tree.
		local
			ptr: POINTER
			rect : RECT_STRUCT
			ret: INTEGER
			window: EV_WINDOW_IMP
		do
			base_make (an_interface)

			-- Fix Problems: A DataBrowser Control does not follow the standard hirarchical widgets idea, but is attached directly to the window: UGLY!
			-- This is very buggy currently: Don't try to use it with several windows
			create rect.make_new_unshared
			rect.set_left(20)
			rect.set_right(100)
			rect.set_bottom(40)
			rect.set_top (20)
			app_implementation.windows.start
			window ?= app_implementation.windows.item.implementation -- HACK
			ret := create_data_browser_control_external (window.c_object, rect.item, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserListView, $ptr)
			set_c_object (ptr)

			ret := set_data_browser_has_scroll_bars_external (ptr, 0, 1) -- set a vertical scrollbar only

			if dispatcher = Void then
				create dispatcher.make (current)
			end


			do_ugly_things (ptr, dispatcher.c_dispatcher)
			ret := auto_size_data_browser_list_view_columns_external (ptr)
			--print ("EV_TREE_IMP make called, object: " + ($current).out + "%N")

			-- add a column:
			--add_data_browser_list_view_column ($ptr, column_desc, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserListViewAppendColumn)
			tree_list.extend ([current, c_object])
		end

	do_ugly_things (db_control, c_dispatcher: POINTER) is
			-- move this to the application class or make it somehow unique
		external
			"C inline"
		alias
			"[
				{
				    // Set control non-focusable
				    Boolean frameAndFocus = false;
					SetControlData($db_control, kControlNoPart, kControlDataBrowserIncludesFrameAndFocusTag, sizeof(frameAndFocus), &frameAndFocus);
				
					// Initialize the callbacks
					DataBrowserCallbacks  dbCallbacks;
					dbCallbacks.version = kDataBrowserLatestCallbacks;
					InitDataBrowserCallbacks (&dbCallbacks);
					dbCallbacks.u.v1.itemDataCallback = NewDataBrowserItemDataUPP ( (DataBrowserItemDataProcPtr) $c_dispatcher );
					SetDataBrowserCallbacks ( $db_control, &dbCallbacks );

					// Initialize a single column without name:
					DataBrowserListViewColumnDesc columnDesc;
			
					columnDesc.propertyDesc.propertyID = 1;
					columnDesc.propertyDesc.propertyType = kDataBrowserTextType;

					columnDesc.headerBtnDesc.version = kDataBrowserListViewLatestHeaderDesc;
					columnDesc.headerBtnDesc.minimumWidth = 100;
					columnDesc.headerBtnDesc.maximumWidth = 1000;
					columnDesc.headerBtnDesc.titleOffset = 0;
					columnDesc.headerBtnDesc.titleString = CFSTR("");

					columnDesc.headerBtnDesc.initialOrder = kDataBrowserOrderUndefined;

					columnDesc.headerBtnDesc.btnFontStyle.flags	= kDataBrowserListViewDefaultColumnFlags;
					columnDesc.headerBtnDesc.btnFontStyle.just = teFlushDefault;
					columnDesc.headerBtnDesc.btnContentInfo.contentType = kControlContentTextOnly; //kControlNoContent;
			
					AddDataBrowserListViewColumn( $db_control, &columnDesc, kDataBrowserListViewAppendColumn);
				}
			]"
		end

	dispatcher: DATA_BROWSER_ITEM_DATA_PROC_PTR_DISPATCHER
			-- The dispatcher is on the one side connected to a C function,
			-- that can be given to the C library as a callback target
			-- and on the other hand to an Eiffel object with a feature
			-- `on_callback'. Whenn its C function gets called, the dispatcher
			-- calls `on_callback' in the connected Eiffel object

	on_callback (a_browser: POINTER; a_item: INTEGER; a_property: INTEGER; a_itemdata: POINTER; a_setvalue: INTEGER): INTEGER is
			-- Callback target. This feature gets called
			-- Here the DataBrowser is requesting information about an item
		local
			cfstring: EV_CARBON_CF_STRING
			ret: INTEGER
			a_tree_imp: EV_TREE_IMP
		do
			if a_setvalue = true then
				-- Some information has changed: update data structures
				-- Should not happen, since we don't support e.g. inline editing of the items!
			else
				-- Okay, this is really ugly now: Since there is only one callback function
				--  the current object doesn't have to be the one it should. We have to figure
				--  out for which TREE object we should give out the data by looking at the
				--  DataBrowser pointer, going through the list and comparing with all c_objects.
				from
					tree_list.start
				until
					tree_list.after or else a_browser = tree_list.item.pointer_item (2)
				loop
					print ("tree-item: " + tree_list.item.pointer_item (2) .out + " %N")
					tree_list.forth
				end
				if a_browser = tree_list.item.pointer_item (2) then
					-- We have found the object for a_browser. It is in 'tree_list.item.item (1)'
					a_tree_imp ?= tree_list.item.item (1)
					create cfstring.make_unshared_with_eiffel_string (a_tree_imp.child_array.i_th(a_item).text)
					ret := set_data_browser_item_data_text_external (a_itemdata, cfstring.item)
				end
			end
			print ("on_callback for item: " + a_item.out + "%N")
		end


	call_selection_action_sequences is
			-- Call the appropriate selection action sequences
		do
		end

	initialize is
			-- Connect action sequences to signals.
		do
			Precursor {EV_ITEM_LIST_IMP}
			Precursor {EV_PRIMITIVE_IMP}
			Precursor {EV_TREE_I}
		end

	create_pointer_motion_actions: EV_POINTER_MOTION_ACTION_SEQUENCE is
			-- Create a pointer_motion action sequence.
		do
		end

	call_button_event_actions (
			a_type: INTEGER;
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is

		do

		end

	on_pointer_motion (a_motion_tuple: TUPLE [INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]) is
		do
		end

feature -- Status report

	selected_item: EV_TREE_NODE is
			-- Item which is currently selected
		do
		end

	node_from_tree_path (a_tree_path: POINTER): EV_TREE_NODE_IMP is
			-- Retrieve node from `a_tree_path'
		do

		end

	selected: BOOLEAN is
			-- Is one item selected?
		do

		end

feature -- Implementation

	ensure_item_visible (an_item: EV_TREE_NODE) is

		do

		end

	set_to_drag_and_drop: BOOLEAN is
		do
		end

	able_to_transport (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to transport PND data using `a_button'.
		do

		end

	ready_for_pnd_menu (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to display PND menu using `a_button'
		do

		end

	disable_transport is
		do

		end

	update_pnd_status is
			-- Update PND status of list and its children.
		do
		end

	update_pnd_connection (a_enable: BOOLEAN) is
			-- Update the PND connection status for `Current'.
		do
		end

	on_mouse_button_event (
			a_type: INTEGER
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is
			-- Initialize a pick and drop transport.
		do
		end

	pnd_row_imp: EV_TREE_NODE_IMP
			-- Implementation object of the current row if in PND transport.

	temp_pebble: ANY
			-- Temporary pebble holder used for PND implementation with nodes.

	temp_pebble_function: FUNCTION [ANY, TUPLE [], ANY]
			-- Returns data to be transported by PND mechanism.

	temp_accept_cursor, temp_deny_cursor: EV_CURSOR

	call_pebble_function (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Set `pebble' using `pebble_function' if present.
		do
		end

	pre_pick_steps (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Steps to perform before transport initiated.
		do
		end

	post_drop_steps (a_button: INTEGER)  is
			-- Steps to perform once an attempted drop has happened.
		do
		end

feature {EV_TREE_NODE_IMP}

	row_from_y_coord (a_y: INTEGER): EV_TREE_NODE_IMP is
			-- Returns the row index at relative coordinate `a_y'.
		do
		end

feature {NONE} -- Implementation

	previous_selected_item: EV_TREE_NODE
			-- Item that was selected previously.

	append (s: SEQUENCE [EV_TREE_ITEM]) is
			-- Add 's' to 'Current'
		do
			Precursor (s)
		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			item_imp: EV_TREE_NODE_IMP
			ret: INTEGER
		do
			item_imp ?= v.implementation
			item_imp.set_parent_imp (Current)

			child_array.go_i_th (i)
			child_array.put_left (v)
			print ("INSERT " + i.out + "  " + v.text + "%N")

			item_id := item_id + 1
			ret := add_data_browser_items_external (c_object, 0, 1, $item_id, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemNoProperty);
			-- 3rd argument should be: {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserNoItem
		end

	item_id: POINTER

	remove_i_th (a_position: INTEGER) is
			-- Remove item at `a_position'
		local
--			item_imp: EV_TREE_NODE_IMP
		do
--			item_imp ?= (child_array @ (a_position)).implementation
--			item_imp.set_parent_imp (Void)
--			child_array.go_i_th (a_position)
--			child_array.remove
		end

feature {EV_TREE_NODE_IMP} -- Implementation

	get_text_from_position (a_tree_node_imp: EV_TREE_NODE_IMP): STRING_32 is
			-- Retrieve cell text from `a_tree_node_imp`
		do
		end

	set_text_on_position (a_tree_node_imp: EV_TREE_NODE_IMP; a_text: STRING_GENERAL) is
			-- Set cell text at to `a_text'.
		do
		end

	update_row_pixmap (a_tree_node_imp: EV_TREE_NODE_IMP) is
			-- Set the pixmap for `a_tree_node_imp'.
		do
		end

	set_row_height (value: INTEGER) is
			-- Make `value' the new height of all the rows.
		do
		end

	row_height: INTEGER is
			-- Height of rows in `Current'
		do
		end

feature {NONE} -- Implementation

	pixmaps_size_changed is
			-- Not implemented
		do
		end


	tree_list: LIST [TUPLE] is
			-- A shared list of all trees created
		once
			create {LINKED_LIST [TUPLE]}Result.make
		end


feature {EV_ANY_I} -- Implementation

	interface: EV_TREE;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_TREE_IMP

