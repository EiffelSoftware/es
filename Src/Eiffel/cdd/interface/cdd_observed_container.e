indexing
	description: "[
			Objects that contain a list of comparable items which each stand
			for a different object of type H. Other objects can be notified
			whenever items are added or removed.
			Note: the implementation relies on that if an item a is less then
			another item b, the corresponding object of a is less then the 
			corresponding object of b.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_OBSERVED_CONTAINER [G, H]

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'
		do
			create items.make
			create items_cursor.make (items)
			create add_item_actions
			create remove_item_actions
			create refresh_actions
		end

feature -- Access

	items: DS_LINKED_LIST [G]
			-- List of items which is beeing observed
			-- Note: only modify list through `add_item' and `remove_item'

	is_refreshing: BOOLEAN
			-- Are we currently refreshing?

feature -- Status setting

	refresh is
			-- Update `items' appropriately and notify observers at the end when `items' has been modified.
		require
			not_refreshing: not is_refreshing
		local
			l_obj_cursor: DS_LINKED_LIST_CURSOR [H]
			l_found: BOOLEAN
		do
			is_modified := False
			is_refreshing := True
			compute_object_list
			create l_obj_cursor.make (last_object_list)
			from
				l_obj_cursor.start
			until
				l_obj_cursor.after
			loop
				from
					items_cursor.start
				until
					items_cursor.after or l_found
				loop
					if corresponds_to_item (items_cursor.item, l_obj_cursor.item) then
						l_found := True
					else
						items_cursor.forth
					end
				end
				if not l_found then
					create_new_item (l_obj_cursor.item)
					add_item (last_created_item)
				end
				l_found := False
				l_obj_cursor.forth
			end

			from
				items_cursor.start
			until
				items_cursor.after
			loop
				from
					l_obj_cursor.start
				until
					l_obj_cursor.after or l_found
				loop
					if corresponds_to_item (items_cursor.item, l_obj_cursor.item) then
						l_found := True
					else
						l_obj_cursor.forth
					end
				end
				if not l_found then
					remove_item
				end
				l_found := False
				items_cursor.forth
			end
			if is_modified then
				refresh_actions.call ([])
			end
			is_refreshing := False
		ensure
			not_refreshing: not is_refreshing
		end

feature -- Event handling

	add_item_actions: ACTION_SEQUENCE [TUPLE [G]]
			-- Agents to be called after some item is added to `items'

	remove_item_actions: ACTION_SEQUENCE [TUPLE [G]]
			-- Agents to be called after some item has been removed from `items'

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents to be called after a refresh and `Current' has been modified

feature {NONE} -- Implementation

	is_modified: BOOLEAN
			-- Has `items' been modified since last call to `refresh'?

	items_cursor: DS_LINKED_LIST_CURSOR [G]
			-- Cursor for traversing `items'

	add_item (an_item: G) is
			-- Add `an_item' to `items' and notify observers.
		require
			refreshing: is_refreshing
			an_item_not_void: an_item /= Void
			not_contained: not items.has (an_item)
		do
			items_cursor.put_left (an_item)
			is_modified := True
			add_item_actions.call ([an_item])
		ensure
			contained: items.has (an_item)
			modified: is_modified
		end

	remove_item is
			-- Remove item at `item_cursor's current position and notify observers.
		require
			refreshing: is_refreshing
			cursor_not_off: not items_cursor.off
		local
			l_item: G
		do
			l_item := items_cursor.item
			items_cursor.remove
			is_modified := True
			remove_item_actions.call ([l_item])
		ensure
			removed: items.count = old items.count - 1
			not_contained: not items.has (old items_cursor.item)
			modified: is_modified
		end

	corresponds_to_item (an_item: G; an_object: H): BOOLEAN
			-- Does `an_item'  stand for `an_object'?
		require
			an_item_not_void: an_item /= Void
			an_object_not_void: an_object /= Void
		deferred
		end

	last_object_list: DS_LINKED_LIST [H]
			-- List of objects last computed by `compute_object_list'

	compute_object_list is
			-- Gather all objects in system to be represented by `items' and store them in `last_object_list'.
			-- Note: `last_object_list' not necessarily has to be sorted, since this will be done by `refresh'
		deferred
		ensure
			last_object_list_not_void: last_object_list /= Void
		end

	last_created_item: G
			-- Item last created by `create_new_item'

	create_new_item (an_obj: H) is
			-- Create a new item for `an_obj' and store it in `last_create_item'.
		require
			an_obj_not_void: an_obj /= Void
		deferred
		ensure
			last_crated_item_not_void: last_created_item /= Void
			valid_item: corresponds_to_item (last_created_item, an_obj)
		end

invariant
	valid_items: items /= Void and then not items.has (Void)
	items_cursor_not_void: items_cursor /= Void

end
