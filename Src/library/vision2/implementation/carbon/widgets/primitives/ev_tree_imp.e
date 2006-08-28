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
		export
			{NONE} all
		end

	CARBONEVENTS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	DATA_BROWSER_ITEM_DATA_PROC_PTR_CALLBACK
		rename
			on_callback as get_set_item_data_callback
		end

	DATA_BROWSER_ITEM_NOTIFICATION_PROC_PTR_CALLBACK
		rename
			on_callback as item_notification_callback
		end


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

			if get_set_item_data_dispatcher = Void then
				create get_set_item_data_dispatcher.make (current)
			end
			if item_notification_dispatcher = Void then
				create item_notification_dispatcher.make (current)
			end


			do_ugly_things (c_object, get_set_item_data_dispatcher.c_dispatcher, item_notification_dispatcher.c_dispatcher)
			ret := set_data_browser_list_view_header_btn_height_external (c_object, 0) -- Don't show a header

			tree_list.extend ([current, c_object])

			id_count := 1
			create free_ids.make
			create item_list.make ( 1, 20 )
		end

	do_ugly_things (db_control, a_item_data_dispatcher, a_item_notification_dispatcher: POINTER) is
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
					dbCallbacks.u.v1.itemDataCallback = NewDataBrowserItemDataUPP ( (DataBrowserItemDataProcPtr) $a_item_data_dispatcher );
				    dbCallbacks.u.v1.itemNotificationCallback = NewDataBrowserItemNotificationUPP ( $a_item_notification_dispatcher );

					SetDataBrowserCallbacks ( $db_control, &dbCallbacks );

					// Initialize a single column (ID 1) without name:
					DataBrowserListViewColumnDesc columnDesc;
			
					columnDesc.propertyDesc.propertyID = 1;
					columnDesc.propertyDesc.propertyType = kDataBrowserTextType;

					columnDesc.headerBtnDesc.version = kDataBrowserListViewLatestHeaderDesc;
					columnDesc.headerBtnDesc.minimumWidth = 100;
					columnDesc.headerBtnDesc.maximumWidth = 3000;
					columnDesc.headerBtnDesc.titleOffset = 0;
					columnDesc.headerBtnDesc.titleString = CFSTR("");

					columnDesc.headerBtnDesc.initialOrder = kDataBrowserOrderUndefined;

					columnDesc.headerBtnDesc.btnFontStyle.flags	= kDataBrowserListViewDefaultColumnFlags;
					columnDesc.headerBtnDesc.btnFontStyle.just = teFlushDefault;
					columnDesc.headerBtnDesc.btnContentInfo.contentType = kControlContentTextOnly; //kControlNoContent;
			
					AddDataBrowserListViewColumn( $db_control, &columnDesc, kDataBrowserListViewAppendColumn);
					
					// Make the column (ID 1) have the disclosure triangles.
					SetDataBrowserListViewDisclosureColumn ( $db_control, 1, false);
				}
			]"
		end

	get_set_item_data_dispatcher: DATA_BROWSER_ITEM_DATA_PROC_PTR_DISPATCHER
			-- The dispatcher is on the one side connected to a C function,
			-- that can be given to the C library as a callback target
			-- and on the other hand to an Eiffel object with a feature
			-- `on_callback'. Whenn its C function gets called, the dispatcher
			-- calls `on_callback' in the connected Eiffel object (`on callback' ~> `get_set_item_data_callback')

	get_set_item_data_callback (a_browser: POINTER; a_item: INTEGER; a_property: INTEGER; a_itemdata: POINTER; a_setvalue: INTEGER): INTEGER is
			-- Through this callback the DataBrowser is requesting information about an item
		local
			cfstring: EV_CARBON_CF_STRING
--			ret: INTEGER
			tree_imp: EV_TREE_IMP
			node_imp: EV_TREE_NODE_IMP
		do
			Result := {CONTROLDEFINITIONS_ANON_ENUMS}.errDataBrowserPropertyNotSupported
			if a_setvalue = true then
				-- Set Information: Some information has changed: update data structures
				-- Should not happen, since we don't support e.g. inline editing of the items!
			else
				-- Get Information (request from the control)
				if a_property = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemIsContainerProperty then
					tree_imp := get_object_from_pointer (a_browser)
					node_imp := tree_imp.item_list.item (a_item)
					if node_imp.child_array.count = 0 then
						Result := set_data_browser_item_data_boolean_value_external (a_itemdata, 0)
					else
						Result := set_data_browser_item_data_boolean_value_external (a_itemdata, 1)
					end
				else
					tree_imp := get_object_from_pointer (a_browser)
					node_imp := tree_imp.item_list.item (a_item)
					create cfstring.make_unshared_with_eiffel_string (node_imp.text)
					Result := set_data_browser_item_data_text_external (a_itemdata, cfstring.item)
				end
			end
--			print ("on_callback for item: " + a_item.out + "%N")
		end

	item_notification_dispatcher: DATA_BROWSER_ITEM_NOTIFICATION_PROC_PTR_DISPATCHER
			-- The dispatcher is on the one side connected to a C function,
			-- that can be given to the C library as a callback target
			-- and on the other hand to an Eiffel object with a feature
			-- `on_callback'. Whenn its C function gets called, the dispatcher
			-- calls `on_callback' in the connected Eiffel object (`on callback' ~> `item_notification_callback')

	item_notification_callback (a_browser: POINTER; a_item: INTEGER; a_message: INTEGER) is
			-- A item has changed
		local
			id: INTEGER
			ret: INTEGER
			tree_imp: EV_TREE_IMP
			node_imp, child_node: EV_TREE_NODE_IMP
		do
			if a_message = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserContainerOpened then
				tree_imp := get_object_from_pointer (a_browser)
				node_imp := tree_imp.item_list.item (a_item)
				from
					node_imp.child_array.start
				until
					node_imp.child_array.after
				loop
					child_node ?= node_imp.child_array.item.implementation
					id := child_node.item_id
					ret := add_data_browser_items_external (a_browser, a_item, 1, $id, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemNoProperty);
					node_imp.child_array.forth
				end
				--print ("item_notification: Container-Opened id " + a_item.out + ", " + id.out + "%N")
			elseif a_message = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemSelected then
				tree_imp := get_object_from_pointer (a_browser)
				node_imp := tree_imp.item_list.item (a_item)
				node_imp.select_actions.call ([])
				selected_item := node_imp.interface
				selected := true
			end
		end

	get_object_from_pointer (a_pointer: POINTER): EV_TREE_IMP is
			-- Takes a c-pointer to the associated c_object of a object of type EV_TREE_IMP and returns a handle to that.
		do
			-- Okay, this is really ugly now: Since there is only one callback function
			--  the "current" object doesn't have to be the one it should. We have to figure
			--  out for which TREE object we should give out the data by looking at the
			--  DataBrowser pointer, going through the list and comparing with all c_objects.
			from
				tree_list.start
			until
				tree_list.after or else a_pointer = tree_list.item.pointer_item (2)
			loop
				tree_list.forth
			end
			check
				tree_imp_found: a_pointer = tree_list.item.pointer_item (2)
			end
			-- We have found the object for a_browser. It is in 'tree_list.item.item (1)'
			Result ?= tree_list.item.item (1)
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

	selected_item: EV_TREE_NODE
			-- Item which is currently selected

	selected: BOOLEAN
			-- Is one item selected?

feature -- Implementation

	id_count: INTEGER  -- the next id for an event.

	free_ids: LINKED_LIST[INTEGER]

	item_list: ARRAY[EV_TREE_NODE_IMP]

	get_id (a_widget : EV_TREE_NODE_IMP) : INTEGER is
			-- Get a unique ID so we can associate an event by its ID with a control
		do
			if free_ids.is_empty then
				item_list.force (a_widget, id_count)
				Result := id_count
				id_count := id_count + 1
			else
				item_list.force (a_widget, free_ids.first)
				Result :=  free_ids.first
				free_ids.remove_left
			end
		end

	dispose_id (a_id: INTEGER) is
				-- Give an id back (it will be recycled)
			do
				item_list.force (void, a_id)
				free_ids.put_right (a_id)
			end

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
			id: INTEGER
		do
			item_imp ?= v.implementation
			item_imp.set_parent_imp (Current)

			child_array.go_i_th (i)
			child_array.put_left (v)
--			print ("INSERT " + i.out + "  " + v.text + "%N")
			id := get_id (item_imp)
			item_imp.set_item_id (id)

			ret := add_data_browser_items_external (c_object, 0, 1, $id, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemNoProperty);
			-- 3rd argument should be: {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserNoItem
		end

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
			create {LINKED_LIST [TUPLE]} Result.make
		end


feature {EV_ANY_I} -- Implementation

	interface: EV_TREE;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_TREE_IMP

