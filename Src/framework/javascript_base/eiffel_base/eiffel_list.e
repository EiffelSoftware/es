note
	description : "JavaScript implementation of EiffelBase class LIST and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: LIST, LINKED_LIST, ARRAYED_LIST"
class
	EIFFEL_LIST [G]

create
	make,
	make_from_array

feature {NONE} -- Initialization

	make
		do
			create inner_array.make
			index := 0
		end

	make_from_array (a_array: attached JS_ARRAY[G])
		do
			inner_array := a_array
			index := 0
		end

feature -- Operations

	after: BOOLEAN
		do
			Result := index >= inner_array.length
		end

	count: INTEGER
		do
			Result := inner_array.length
		end

	extend (a_item: G)
		do
			inner_array.push (a_item)
		end

	first: G
		do
			Result := inner_array[0]
		end

	forth
		do
			index := index + 1
		end

	go_i_th (a_index: INTEGER)
		do
			index := a_index-1
		end

	i_th (a_index: INTEGER): G
		do
			Result := inner_array[a_index-1]
		end

	is_empty: BOOLEAN
		do
			Result := inner_array.length = 0
		end

	item: G
		do
			Result := inner_array[index]
		end

	put_front (a_item: G)
		do
			inner_array.splice1 (0, 0, a_item)
		end

	put_i_th (a_item: G; a_index: INTEGER)
		do
			inner_array.set_item (a_item, a_index-1)
		end

	put_right (a_item: G)
		do
			inner_array.splice1 (index+1, 0, a_item)
		end

	remove
		do
			inner_array.splice0 (index, 1)
		end

	start
		do
			index := 0
		end

	wipe_out
		do
			make
		end

feature {NONE} -- Implementation

	inner_array: attached JS_ARRAY[G]
	index: INTEGER

end
