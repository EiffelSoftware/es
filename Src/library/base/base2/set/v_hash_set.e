note
	description: "[
			Hash sets with hash function provided by HASHABLE and object equality.
			Implementation uses chaining.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	model: set, lock
	manual_inv: true
	false_guards: true

frozen class
	V_HASH_SET [G -> V_HASHABLE]

inherit
	V_SET [G]
		redefine
			lock
--			forget_iterator
		end

create
	make

feature {NONE} -- Initialization

	make (l: V_HASH_LOCK [G])
			-- Create an empty set that will use the lock `l'.
		note
			status: creator
		do
			buckets := empty_buckets (default_capacity)
			lists := buckets.sequence
			create buckets_.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets.sequence.count)
			lock := l
			set_observers ([lock])
		ensure
			set_empty: set.is_empty
			lock_set: lock = l
			observers_set: observers = [lock]
		end

feature -- Measurement

	count: INTEGER
			-- Number of elements.
		note
			status: dynamic
		do
			check inv_only ("count_definition", "bag_domain_definition", "bag_definition") end
			lemma_count (bag)
			Result := count_
		end

feature -- Search

	has (v: G): BOOLEAN
			-- Is `v' contained?
			-- (Uses object equality.)
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets") end
			Result := cell_equal (buckets [index (v)], v) /= Void
		end

	item (v: G): G
			-- Element of `set' equivalent to `v' according to object equality.
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
			Result := cell_equal (buckets [index (v)], v).item
			v.lemma_transitive (Result, [set_item (v)])
		end

feature -- Iteration

	new_cursor: V_HASH_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		note
			status: impure
		do
			Result := fresh_cursor
			Result.start
		end

	at (v: G): V_HASH_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `after' otherwise.
		note
			status: impure
		do
			Result := fresh_cursor
			Result.search (v)
		end

feature -- Extension

	extend (v: G)
			-- Add `v' to the set.
		note
			explicit: wrapping
		local
			idx: INTEGER
			list: V_LINKED_LIST [G]
		do
			check lock.inv_only ("owns_items", "valid_buckets") end
			check inv_only ("buckets_exist", "owns_definition", "buckets_non_empty", "buckets_count", "lists_definition", "buckets_lower",
				"set_non_void", "set_not_too_small", "lists_definition", "buckets_content") end
			idx := index (v)
			list := buckets [idx]
			if cell_equal (list, v) = Void then
				unwrap
				list.extend_back (v)
				buckets_ := buckets_.replaced_at (idx, buckets_ [idx] & v)
				set := set & v
				count_ := count_ + 1
				bag := bag & v
				check set [v] end
				check lock.inv_only ("valid_buckets") end
				wrap
			end
			check set_has (v) end
		end

feature -- Removal

--	remove (v: G)
--			-- Add `v' to the set.
--		note
--			explicit: wrapping
--		local
--			idx: INTEGER
--			list: V_LINKED_LIST [G]
--			c: V_LINKABLE [G]
--			x: G
--		do
--			check lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
--			check inv_only ("buckets_exist", "owns_definition", "buckets_non_empty", "buckets_count", "lists_definition", "buckets_lower",
--				"set_non_void", "set_not_too_small", "lists_definition", "buckets_content") end
--			idx := index (v)
--			list := buckets [idx]
--			c := cell_before_equal (list, v)
--			if c = Void and not list.is_empty then
--				x := list.first
--				check v.is_model_equal (x) end
--				unwrap
--				list.remove_front
--				set := set / x
--				count_ := count_ - 1
--				buckets_ := buckets_.replaced_at (idx, buckets_ [idx].but_first)
--				bag := bag / x
--				x.lemma_transitive (v, set)
--				wrap
--			elseif c /= Void and then c.right /= Void then
--				check assume: false end
--				unwrap
--				list.extend_back (v)
--				buckets_ := buckets_.replaced_at (idx, buckets_ [idx] & v)
--				set := set & v
--				count_ := count_ + 1
--				bag := bag & v
--				check set [v] end
--				wrap
--			end
--			check assume: false end
--		end

	wipe_out
			-- Remove all elements.
		do
			buckets := empty_buckets (default_capacity)
			count_ := 0
			create set
			lists := buckets.sequence
			create buckets_.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets.sequence.count)
			create bag
		end

feature {NONE} -- Performance parameters

	default_capacity: INTEGER = 16
			-- Default size of `buckets'.		

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Implementation

	buckets: V_ARRAY [V_LINKED_LIST [G]]
		-- Element storage.
		note
			guard: is_lock_ref
		attribute
		end

	count_: INTEGER
			-- Number of elements.
		note
			guard: is_lock_int
		attribute
		end

	capacity: INTEGER
			-- Bucket array size.
		require
			buckets_closed: buckets.closed
		do
			Result := buckets.count
		ensure
			definition: Result = buckets.sequence.count
		end

	bucket_index (hc, n: INTEGER): INTEGER
			-- The bucket an item with hash code `hc' belongs,
			-- if there are `n' buckets in total.
		note
			explicit: contracts
		require
			reads ([])
			n_positive: n > 0
			hc_non_negative: 0 <= hc
		do
			Result := hc \\ n + 1
		ensure
			in_bounds: 1 <= Result and Result <= n
		end

	index (v: G): INTEGER
			-- Index of `v' into in a `buckets'.
		require
			v_closed: v.closed
			buckets_closed: buckets.closed
			positive_capacity: buckets.sequence.count > 0
		do
			check v.inv end
			Result := bucket_index (v.hash_code, capacity)
		ensure
			definiton: Result = bucket_index (v.hash_code_, buckets.sequence.count)
		end

	cell_equal (list: V_LINKED_LIST [G]; v: G): V_LINKABLE [G]
			-- Cell of `list' where the item is equal to `v' according to object equality.
			-- Void if the list has no such cell.
		require
			list_closed: list.closed
			list_items_non_void: list.sequence.non_void
			v_non_void: v /= Void
		local
			j: INTEGER
		do
			from
				j := 1
				Result := list.first_cell
			invariant
				list.inv_only ("cells_domain", "cells_exist", "cells_linked", "cells_first", "cells_last", "first_cell_empty", "sequence_implementation")
				1 <= j and j <= list.sequence.count + 1
				Result = if list.sequence.domain [j] then list.cells [j] else ({V_LINKABLE [G]}).default end
				across 1 |..| (j - 1) as k all not v.is_model_equal (list.sequence [k.item]) end
			until
				Result = Void or else v.is_model_equal (Result.item)
			loop
				Result := Result.right
				j := j + 1
			variant
				list.sequence.count - j
			end
		ensure
			definition_not_found: Result = Void implies
				across 1 |..| list.sequence.count as i all not v.is_model_equal (list.sequence [i.item]) end
			definition_found: Result /= Void implies list.cells.has (Result) and list.sequence.has (Result.item) and v.is_model_equal (Result.item)
		end

--	cell_before_equal (list: V_LINKED_LIST [G]; v: G): V_LINKABLE [G]
--		require
--			list_closed: list.closed
--			list_items_non_void: list.sequence.non_void
--			v_non_void: v /= Void
--		local
--			j: INTEGER
--			next: V_LINKABLE [G]
--		do
--			from
--				j := 1
--				next := list.first_cell
--			invariant
--				list.inv_only ("cells_domain", "cells_exist", "cells_linked", "cells_first", "cells_last", "first_cell_empty", "sequence_implementation")
--				1 <= j and j <= list.sequence.count + 1
--				next = if list.sequence.domain [j] then list.cells [j] else ({V_LINKABLE [G]}).default end
--				Result = if list.sequence.domain [j - 1] then list.cells [j - 1] else ({V_LINKABLE [G]}).default end
--				across 1 |..| (j - 1) as k all not v.is_model_equal (list.sequence [k.item]) end
--			until
--				next = Void or else v.is_model_equal (next.item)
--			loop
--				Result := next
--				next := next.right
--				j := j + 1
--			variant
--				list.sequence.count - j
--			end
--		ensure
--			definition_void: Result = Void implies list.sequence.is_empty or else v.is_model_equal (list.sequence.first)
--			definition_not_found: Result /= Void and then Result.right = Void implies
--				across 1 |..| list.sequence.count as i all not v.is_model_equal (list.sequence [i.item]) end
--			definition_found: Result /= Void and then Result.right /= Void implies
--				list.cells.has (Result) and list.cells.has (Result.right) and list.sequence.has (Result.right.item) and v.is_model_equal (Result.right.item)
--		end


	empty_buckets (n: INTEGER): V_ARRAY [V_LINKED_LIST [G]]
			-- Array of `n' empty buckets.
		note
			status: impure
		require
			n_non_negative: n >= 0
			modify ([])
		local
			i: INTEGER
		do
			create Result.make (1, n)
			from
				i := 1
			invariant
				1 <= i and i <= n + 1
				Result.is_wrapped
				Result.sequence.count = n
				across 1 |..| (i - 1) as j all
					Result.sequence [j.item].is_wrapped and
					Result.sequence [j.item].is_fresh and
					Result.sequence [j.item].sequence.is_empty and
					Result.sequence [j.item].observers.is_empty
				end
				across 1 |..| (i - 1) as k all across 1 |..| (i - 1) as l all
					k.item /= l.item implies Result.sequence [k.item] /= Result.sequence [l.item] end end
				modify_model ("sequence", Result)
			until
				i > n
			loop
				Result [i] := create {V_LINKED_LIST [G]}
				i := i + 1
			end
		ensure
			wrapped: Result.is_wrapped
			fresh: Result.is_fresh
			lower: Result.lower_ = 1
			count: Result.sequence.count = n
			no_observers: Result.observers.is_empty
			content: across 1 |..| Result.sequence.count as j all
					Result.sequence [j.item].is_wrapped and
					Result.sequence [j.item].is_fresh and
					Result.sequence [j.item].sequence.is_empty and
					Result.sequence [j.item].observers.is_empty
				end
			lists_distinct: across 1 |..| Result.sequence.count as k all across 1 |..| Result.sequence.count as l all
				k.item /= l.item implies Result.sequence [k.item] /= Result.sequence [l.item] end end
		end

	fresh_cursor: V_HASH_SET_ITERATOR [G]
			-- New iterator over the set (position unspecified).
		note
			status: impure
		require
			wrapped: is_wrapped
			modify_field (["observers", "closed"], Current)
		local
			list_iterator: V_LINKED_LIST_ITERATOR [G]
			i: INTEGER
		do
			unwrap
			list_iterator := buckets [1].new_cursor
			check buckets_ = buckets_.old_ end
			create Result.make (Current, list_iterator)
			from
				i := 2
			invariant
				2 <= i and i <= lists.count + 1
				across 1 |..| lists.count as j all lists [j.item].is_wrapped end
				across 1 |..| (i - 1) as j all lists [j.item].observers = lists [j.item].observers.old_ & list_iterator end
				across i |..| lists.count as j all lists [j.item].observers = lists [j.item].observers.old_ end
				modify_field (["observers", "closed"], lists.range)
			until
				i > lists.count
			loop
				lists [i].add_iterator (list_iterator)
				i := i + 1
			end
			check buckets_ = buckets_.old_ end
			wrap
		ensure
			wrapped: is_wrapped
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
		end

	remove_at (it: V_HASH_SET_ITERATOR [G])
			-- Remove element to which `it' points.
		require
			wrapped: is_wrapped
			it_open: it.is_open
			only_iterator: observers = [lock, it]
			1 <= it.bucket_index and it.bucket_index <= lists.count
			list_iterator_wrapped: it.list_iterator.is_wrapped
			modify_model ("set", Current)
			modify_model (["index_", "sequence", "target_index_sequence"], it.list_iterator)
		local
			x: G
		do
			unwrap
			x := it.list_iterator.item
--			check x = (buckets_ [bi]) [li.index_] end
			it.list_iterator.remove
			count_ := count_ - 1
--			auto_resize
			wrap
		ensure
			wrapped: is_wrapped
		end

feature -- Specification

	buckets_: MML_SEQUENCE [MML_SEQUENCE [G]]
			-- Abstract element storage.
		note
			status: ghost
			guard: inv
		attribute
		end

	lock: V_HASH_LOCK [G]
			-- Helper object for keeping items consistent.
		note
			status: ghost
		attribute
		end

	is_lock_int (new: INTEGER; o: ANY): BOOLEAN
		note
			status: functional
		do
			Result := o = lock
		end

	is_lock_ref (new: ANY; o: ANY): BOOLEAN
		note
			status: functional
		do
			Result := o = lock
		end

	is_lock_seq (new: MML_SEQUENCE [ANY]; o: ANY): BOOLEAN
		note
			status: functional
		do
			Result := o = lock
		end

--	forget_iterator (it: like new_cursor)
--			-- Remove `it' from `observers'.
--		note
--			status: ghost
--			explicit: contracts
--		local
--			i: INTEGER
--		do
--			i := it.bucket_index
--			check it.list_iterator.target = lists [i] end

----			it.unwrap
----			set_observers (observers / it)			
----			check it.iterator.inv_only ("subjects_definition", "A2") end
----			lists [i].forget_iterator (it.list_iterator)
--			check assume: false end
--		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Specification

	lists: MML_SEQUENCE [V_LINKED_LIST [G]]
			-- Cache of `buckets.sequence' (required in the invariant of the iterator).
		note
			status: ghost
			guard: is_lock_seq
		attribute
		end

invariant
		-- Abstract state:
	buckets_non_empty: not buckets_.is_empty
	set_not_too_small: across 1 |..| buckets_.count as i all
		across 1 |..| buckets_ [i.item].count as j all set [(buckets_ [i.item])[j.item]] end end
	set_not_too_large: across set as x all across 1 |..| buckets_.count as i some buckets_ [i.item].has (x.item) end end
	no_precise_duplicates: across 1 |..| buckets_.count as i all
		across 1 |..| buckets_.count as j all
			across 1 |..| buckets_ [i.item].count as k all
				across 1 |..| buckets_ [j.item].count as l all
					i.item /= j.item or k.item /= l.item implies (buckets_ [i.item])[k.item] /= (buckets_ [j.item])[l.item] end end end end
		-- Concrete state:
	count_definition: count_ = set.count
	buckets_exist: buckets /= Void
	buckets_owned: owns [buckets]
	buckets_lower: buckets.lower_ = 1
	lists_definition: lists = buckets.sequence
	all_lists_exist: lists.non_void
	owns_definition: owns = create {MML_SET [ANY]}.singleton (buckets) + lists.range
	buckets_count: buckets_.count = lists.count
--	lists_distinct: across 1 |..| buckets_.count as i all across 1 |..| buckets_.count as j all
--		i.item /= j.item implies lists [i.item] /= lists [j.item] end end
	lists_distinct: lists.no_duplicates
	buckets_content: across 1 |..| buckets_.count as i all buckets_ [i.item] = lists [i.item].sequence end
		-- Iterators:
	array_observers: buckets.observers.is_empty
	list_observers_same: across 1 |..| lists.count as i all
		across 1 |..| lists.count as j all lists [i.item].observers = lists [j.item].observers end end
	list_observers_count: across 1 |..| lists.count as i all lists [i.item].observers.count = observers.count - 1 end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
