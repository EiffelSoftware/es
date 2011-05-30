note
	description : "JavaScript implementation of EiffelBase class HASH_TABLE."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: HASH_TABLE"
class
	EIFFEL_HASH_TABLE [G, K -> attached HASHABLE]

create
	make,
	make_from_object

feature -- Initialization

	make (n: INTEGER)
		do
			create inner_array.make_as_obj
			keys_index := 0
			create cached_keys.make
			cached_keys_busted := false
		end

	make_from_object (obj: attached JS_ARRAY[G])
		do
			inner_array := obj
			keys_index := 0
			create cached_keys.make
			cached_keys_busted := true
		end

feature -- Basic Operation

	after: BOOLEAN
		do
			Result := keys_index >= keys.length
		end

	at alias "@" (key: K): G
		do
			Result := inner_array.get_item_by_name (key.out)
			if Result = undefined then
				Result := null
			end
		end

	count: INTEGER
		do
			Result := keys.length
		end

	current_keys: attached ARRAY [attached STRING]
			-- Do note that this returns the keys as strings
		do
			Result := keys.as_eiffel_array
		end

	extend (element: G; key: K)
		do
			inner_array.set_item_by_name (key.out, element)
			cached_keys_busted := true
		end

	force (element: G; key: K)
		do
			inner_array.set_item_by_name (key.out, element)
			cached_keys_busted := true
		end

	forth
		do
			keys_index := keys_index + 1
		end

	go_to (p: attached EIFFEL_HASH_TABLE_CURSOR)
			-- To future implementors of `cursor': create a cursor with index + 1
		do
			keys_index := p.inner_index - 1
		end

	has (key: K): BOOLEAN
		do
			Result := inner_array.has_item_by_name (key.out)
		end

	has_item (v: G): BOOLEAN
		local
			i: INTEGER
		do
			from
				Result := false
				i := 0
			until
				i >= keys.length or Result = true
			loop
				if inner_array.get_item_by_name (keys.item (i)) = v then
					Result := true
				end
				i := i + 1
			end
		end

	has_key (key: K): BOOLEAN
		do
			Result := inner_array.has_item_by_name (key.out)
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	item (key: K): G
		do
			Result := inner_array.get_item_by_name (key.out)
			if Result = undefined then
				Result := null
			end
		end

	item_for_iteration: G
		do
			Result := inner_array.get_item_by_name (keys.item (keys_index))
		end

	key_for_iteration: STRING
		do
			Result := keys.item (keys_index)
		end

	linear_representation: ARRAYED_LIST [G]
		local
			i: INTEGER
		do
			from
				create Result.make (count)
				i := 0
			until
				i >= keys.length
			loop
				Result.extend (inner_array.get_item_by_name (keys.item (i)))
				i := i + 1
			end
		end

	put (element: G; key: K)
		do
			inner_array.set_item_by_name (key.out, element)
			cached_keys_busted := true
		end

	remove (key: K)
		do
			inner_array.remove_item_by_name (key.out)
			cached_keys_busted := true
		end

	replace (element: G; key: K)
		do
			inner_array.set_item_by_name (key.out, element)
			cached_keys_busted := true
		end

	start
		do
			keys_index := 0
		end

	wipe_out
		do
			make (0)
		end

feature {NONE} -- Implementation

	null: G
		external "C" alias "#null" end
	undefined: G
		external "C" alias "#undefined" end

	keys_index: INTEGER

	inner_array: attached JS_ARRAY[G]

feature {NONE} -- Keys access implementation

	get_keys: attached JS_ARRAY[attached STRING]
		external "C" alias "#runtime.getProperties($TARGET.inner_array, true)" end
	cached_keys: attached JS_ARRAY[attached STRING]
	cached_keys_busted: BOOLEAN
	keys: attached JS_ARRAY[attached STRING]
		do
			if cached_keys_busted then
				cached_keys := get_keys
				cached_keys_busted := false
			end
			Result := cached_keys
		end

end
