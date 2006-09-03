indexing
	description: "Objects that makes Carbon's DataBrowser control easily accessible"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_CARBON_DATABROWSER

inherit
	EV_ANY_IMP

	DATA_BROWSER_ITEM_DATA_PROC_PTR_CALLBACK
		rename
			on_callback as get_set_item_data_callback
		end

	DATA_BROWSER_ITEM_NOTIFICATION_PROC_PTR_CALLBACK
		rename
			on_callback as item_notification_callback
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature -- Creation

		make (an_interface: like interface) is
				--
		local
			ptr: POINTER
			rect: RECT_STRUCT
			ret: INTEGER
		do
			base_make (an_interface)

			create rect.make_new_unshared
			rect.set_right (100)
			rect.set_bottom (100)
			ret := create_data_browser_control_external (null, rect.item, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserListView, $ptr)
			set_c_object (ptr)

			ret := set_data_browser_has_scroll_bars_external (ptr, 0, 1) -- set a vertical scrollbar only

			if get_set_item_data_dispatcher = Void then
				create get_set_item_data_dispatcher.make (current)
			end
			if item_notification_dispatcher = Void then
				create item_notification_dispatcher.make (current)
			end


			do_ugly_things (c_object, get_set_item_data_dispatcher.c_dispatcher, item_notification_dispatcher.c_dispatcher)

			tree_list.extend ([current, c_object])

			id_count := 1
			create free_ids.make
			create item_list.make ( 1, 20 )
		end

	initialize is
			--
		do

		end


	insert_i_th (v: EV_ANY; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			item: like db_item
			ret: INTEGER
			id: INTEGER
		do
			item ?= v.implementation
			--item.set_parent_imp (Current)

			-- carbon specifics:
			item.add_item_and_children_to_parent_tree (Current, Void, i);
			id := item.item_id
			ret := add_data_browser_items_external (c_object, 0, 1, $id, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemNoProperty);
			-- 2nd argument should be: {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserNoItem
		end

--	selected_item: like db_item

feature -- settings

	show_title_row is
			-- Show the row of the titles.
		local
			ret: INTEGER
		do
			ret := set_data_browser_list_view_header_btn_height_external (c_object, 15)
		end

	hide_title_row is
			-- Hide the row of the titles.
		local
			ret: INTEGER
		do
			ret := set_data_browser_list_view_header_btn_height_external (c_object, 0)
		end

	set_disclosure_column is
			--
		local
			ret: INTEGER
		do
			-- Make the column (ID 1) have the disclosure triangles.
			ret := set_data_browser_list_view_disclosure_column_external ( c_object, 1, 0 );
		end


feature -- internals

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
			db: like Current
			node: like db_item
		do
			Result := {CONTROLDEFINITIONS_ANON_ENUMS}.errDataBrowserPropertyNotSupported
			if a_setvalue.to_boolean then
				-- Set Information: Some information has changed: update data structures
				-- Should not happen, since we don't support e.g. inline editing of the items!
			else
				-- Get Information (request from the control)
				if a_property = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemIsContainerProperty then
					db := get_object_from_pointer (a_browser)
					node := db.item_list.item (a_item)
					if node.child_array /= Void and then node.child_array.count /= 0 then
						Result := set_data_browser_item_data_boolean_value_external (a_itemdata, 1)
					else
						Result := set_data_browser_item_data_boolean_value_external (a_itemdata, 0)
					end
				else
					db := get_object_from_pointer (a_browser)
					node := db.item_list.item (a_item)
					create cfstring.make_unshared_with_eiffel_string (node.text)
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
			tree: like current
			node, child_node: like db_item
		do
			if a_message = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserContainerOpened then
				tree := get_object_from_pointer (a_browser)
				node := tree.item_list.item (a_item)
				from
					node.child_array.start
				until
					node.child_array.after
				loop
					child_node ?= node.child_array.item.implementation
					id := child_node.item_id
					ret := add_data_browser_items_external (a_browser, a_item, 1, $id, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemNoProperty);
					node.child_array.forth
				end
				--print ("item_notification: Container-Opened id " + a_item.out + ", " + id.out + "%N")
			elseif a_message = {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserItemSelected then
				tree := get_object_from_pointer (a_browser)
				node := tree.item_list.item (a_item)
				node.select_actions.call ([])
--				selected_item := node.interface
--				selected := true
			end
		end

	get_object_from_pointer (a_pointer: POINTER): EV_CARBON_DATABROWSER is -- Doesn't work with 'like Current' since the instance of the class could be of another type,... callback confusion
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

feature {EV_CARBON_DATABROWSER, EV_CARBON_DATABROWSER_ITEM} -- Implementation

	db_item: EV_CARBON_DATABROWSER_ITEM

	id_count: INTEGER  -- the next id for an event.

	free_ids: LINKED_LIST[INTEGER]

	item_list: ARRAY[like db_item]

	get_id (a_node: like db_item) : INTEGER is
			-- Get a unique ID so we can associate an event by its ID with a control
		do
			if free_ids.is_empty then
				item_list.force (a_node, id_count)
				Result := id_count
				id_count := id_count + 1
			else
				free_ids.start
				item_list.force (a_node, free_ids.item)
				Result :=  free_ids.item
				free_ids.remove
			end
		end

	dispose_id (a_id: INTEGER) is
				-- Give an id back (it will be recycled)
			do
				item_list.force (void, a_id)
				free_ids.put_right (a_id)
			end

	tree_list: LIST [TUPLE] is
			-- A shared list of all trees created
		once
			create {LINKED_LIST [TUPLE]} Result.make
		end

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_CARBON_DATABROWSER
