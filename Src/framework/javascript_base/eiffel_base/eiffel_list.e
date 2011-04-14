note
	description : "JavaScript implementation of EiffelBase class LIST and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: LIST, LINKED_LIST, ARRAYED_LIST, TWO_WAY_LIST"
class
	EIFFEL_LIST [G]

inherit
	EIFFEL_SEQUENCE [G]

create
	make,
	make_from_array

feature {NONE} -- Initialization

	make
		do
			create inner_array.make
			inner_index := 0
		end

	make_from_array (a_array: attached JS_ARRAY[G])
		do
			inner_array := a_array
			inner_index := 0
		end

feature -- Operations

	after: BOOLEAN
		do
			Result := inner_index >= inner_array.length
		end

	append (other: attached EIFFEL_SEQUENCE[G])
		do
			from
				other.start
			until
				other.after
			loop
				extend (other.item)
				other.forth
			end
		end

	at alias "@" (a_index: INTEGER): G
		do
			Result := inner_array[a_index-1]
		end

	back
		do
			inner_index := inner_index - 1
		end

	before: BOOLEAN
		do
			Result := inner_index < 0
		end

	count: INTEGER
		do
			Result := inner_array.length
		end

	cursor: attached EIFFEL_LIST_CURSOR
		do
			create Result.make (inner_index)
		end

	do_all (action: attached PROCEDURE [ANY, TUPLE [G]])
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= inner_array.length
			loop
				action.call([inner_array.item (i)])
				i := i + 1
			end
		end

	do_if (action: attached PROCEDURE [ANY, TUPLE [G]]; test: attached FUNCTION [ANY, TUPLE [G], BOOLEAN])
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= inner_array.length
			loop
				if test.item([inner_array.item (i)]) then
					action.call([inner_array.item (i)])
				end
				i := i + 1
			end
		end

	extend (a_item: G)
		do
			inner_array.push (a_item)
		end

	finish
		do
			inner_index := inner_array.length - 1
		end

	first: G
		do
			Result := inner_array[0]
		end

	for_all (test: attached FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
		local
			i: INTEGER
		do
			from
				i := 0
				Result := true
			until
				i >= inner_array.length or Result = false
			loop
				if not test.item([inner_array.item (i)]) then
					Result := false
				end
				i := i + 1
			end
		end

	force (a_item: G)
		do
			inner_array.push (a_item)
		end

	forth
		do
			inner_index := inner_index + 1
		end

	go_i_th (a_index: INTEGER)
		do
			inner_index := a_index-1
		end

	go_to (p: attached EIFFEL_LIST_CURSOR)
		do
			inner_index := p.inner_index
		end

	has (v: G): BOOLEAN
		do
			Result := inner_array.index_of (v) >= 0
		end

	i_th (a_index: INTEGER): G
		do
			Result := inner_array[a_index-1]
		end

	index : INTEGER
		do
			Result := inner_index + 1
		end

	index_of (v: G; i: INTEGER): INTEGER
		do
			Result := inner_array.index_of2 (v, i - 1) + 1
		end

	is_empty: BOOLEAN
		do
			Result := inner_array.length = 0
		end

	item: G
		do
			Result := inner_array[inner_index]
		end

	item_for_iteration: G
		do
			Result := item
		end

	last: G
		do
			Result := inner_array[inner_array.length-1]
		end

	prune (a_item: G)
		local
			p: INTEGER
		do
			p := index_of (a_item, 1)
			if p /= 0 then
				go_i_th(p)
				remove
			end
		end

	put (a_item: G)
		do
			inner_array.set_item (a_item, inner_index)
		end

	put_front (a_item: G)
		do
			inner_array.splice1 (0, 0, a_item)
		end

	put_i_th (a_item: G; a_index: INTEGER)
		do
			inner_array.set_item (a_item, a_index-1)
		end

	put_left (a_item: G)
		do
			inner_array.splice1 (inner_index, 0, a_item)
		end

	put_right (a_item: G)
		do
			inner_array.splice1 (inner_index+1, 0, a_item)
		end

	remove
		do
			inner_array.splice0 (inner_index, 1)
		end

	remove_left
		do
			inner_array.splice0 (inner_index-1, 1)
		end

	remove_right
		do
			inner_array.splice0 (inner_index+1, 1)
		end

	replace (a_item: G)
		do
			inner_array.set_item (a_item, inner_index)
		end

	start
		do
			inner_index := 0
		end

	there_exists (test: attached FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
		local
			i: INTEGER
		do
			from
				i := 0
				Result := false
			until
				i >= inner_array.length or Result = true
			loop
				if test.item([inner_array.item (i)]) then
					Result := true
				end
				i := i + 1
			end
		end

	valid_cursor (p: attached EIFFEL_LIST_CURSOR): BOOLEAN
		do
			Result := p.inner_index >= 0 and p.inner_index < inner_array.length
		end

	wipe_out
		do
			make
		end

feature {NONE} -- Implementation

	inner_array: attached JS_ARRAY[G]
	inner_index: INTEGER

end
