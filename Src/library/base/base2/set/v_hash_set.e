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
			default_create,
			lock,
			forget_iterator
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty set without a lock.
		note
			status: creator
			explicit: wrapping
		do
			make_empty_buckets (default_capacity)
		ensure then
			set_empty: set.is_empty
			no_lock: lock = Void
			observers_empty: observers.is_empty
		end

feature -- Initialization

	set_lock (l: V_HASH_LOCK [G])
			-- Set `lock' to `l'.
		note
			status: ghost
		require
			no_observers: observers.is_empty
			registered: l.sets [Current]
			not_iterator: not attached {V_ITERATOR [G]} l
		do
			lock := l
			Current.subjects := [lock]
			Current.observers := [lock]
			check lock.inv end
		end

	copy_ (other: V_HASH_SET [G])
			-- Initialize by copying all the items of `other'.
		note
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			same_lock: lock = other.lock
			no_iterators: observers = [lock]
			modify_model (["set", "owns"], Current)
			modify_model ("observers", [Current, other])
		do
			if other /= Current then
				unwrap
				check other.inv end
				make_empty_buckets (other.capacity)
				join (other)
				lemma_same_set (other)
			end
		ensure
			set_effect: set ~ old other.set
			observers_restored: observers ~ old observers
			other_observers_restored: other.observers ~ old other.observers
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
			create Result.make (Current)
			Result.start
		end

	at (v: G): V_HASH_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `after' otherwise.
		note
			status: impure
		do
			create Result.make (Current)
			Result.search (v)
		end

feature -- Extension

	extend (v: G)
			-- Add `v' to the set.
		note
			explicit: wrapping
		do
			check inv_only ("registered"); lock.inv_only ("owns_items") end
			auto_resize (count_ + 1)
			simple_extend (v)
		end

feature -- Removal

	wipe_out
			-- Remove all elements.
		note
			explicit: wrapping
		do
			unwrap
			make_empty_buckets (default_capacity)
		end

feature {NONE} -- Performance parameters

	default_capacity: INTEGER = 16
			-- Default size of `buckets'.		

	target_load_factor: INTEGER = 75
			-- Approximate percentage of elements per bucket that bucket array has after automatic resizing.

	growth_rate: INTEGER = 2
			-- Rate by which bucket array grows and shrinks.			

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
			v_closed: v.closed
			list_items_non_void: list.sequence.non_void
			list_items_closed: across 1 |..| list.sequence.count as i all list.sequence [i.item].closed end
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
				Result = Void or else v.is_equal_ (Result.item)
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

	make_empty_buckets (n: INTEGER)
			-- Create an empty set with `buckets' of size `n'.
		require
			open: is_open
			n_positive: n > 0
			no_iterators: observers <= [lock]
			inv_only ("subjects_definition", "observers_constraint", "registered", "A2")
			modify_field (["buckets", "count_", "set", "lists", "buckets_", "bag", "owns", "closed"], Current)
		local
			i: INTEGER
		do
			create buckets.make (1, n)
			check buckets.inv_only ("owns_definition"); buckets.area.inv_only ("default_owns") end
			from
				i := 1
			invariant
				1 <= i and i <= n + 1
				buckets.is_wrapped
				buckets.sequence.count = n
				across 1 |..| (i - 1) as j all
					buckets.sequence [j.item].is_wrapped and
					buckets.sequence [j.item].is_fresh and
					buckets.sequence [j.item].sequence.is_empty and
					buckets.sequence [j.item].observers.is_empty
				end
				across 1 |..| (i - 1) as k all across 1 |..| (i - 1) as l all
					k.item /= l.item implies buckets.sequence [k.item] /= buckets.sequence [l.item] end end
				modify_model ("sequence", buckets)
			until
				i > n
			loop
				buckets [i] := create {V_LINKED_LIST [G]}
				i := i + 1
			end

			count_ := 0
			create set
			lists := buckets.sequence
			create buckets_.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets.sequence.count)
			create bag
			use_definition (set_not_too_large (set, buckets_))
			wrap
		ensure
			wrapped: is_wrapped
			set_effect: set.is_empty
			capacity_effect: lists.count = n
		end

	remove_at (it: V_HASH_SET_ITERATOR [G])
			-- Remove element to which `it' points.
		require
			wrapped: is_wrapped
			it_open: it.is_open
			valid_target: it.target = Current
			lock_wrapped: lock.is_wrapped
			only_iterator: observers = [lock, it]
			1 <= it.bucket_index and it.bucket_index <= lists.count
			list_iterator_wrapped: it.list_iterator.is_wrapped
			it.inv_only ("target_which_bucket", "list_iterator_not_off")
			modify_model ("set", Current)
			modify_model (["index_", "sequence", "target_index_sequence"], it.list_iterator)
		local
			idx, i: INTEGER
			x: G
		do
			unwrap
			idx := it.bucket_index
			i := it.list_iterator.index_
			check it.list_iterator.inv_only ("subjects_definition", "A2", "sequence_definition") end
			x := it.list_iterator.item
			check x = (buckets_ [idx]) [i] end

			check lists [idx].observers = [it.list_iterator] end
			it.list_iterator.remove

			count_ := count_ - 1
			set := set / x
			buckets_ := buckets_.replaced_at (idx, buckets_ [idx].removed_at (i))
			bag := bag / x
			lemma_set_not_too_large
			wrap
		ensure
			wrapped: is_wrapped
			list_iterator_wrapped: it.list_iterator.is_wrapped
			set_effect: set = old (set / (buckets_ [it.bucket_index]) [it.list_iterator.index_])
			same_index: it.list_iterator.index_ = old it.list_iterator.index_
			same_lists: lists = old lists
			buckets_effect: buckets_ = old (buckets_.replaced_at (it.bucket_index, buckets_ [it.bucket_index].removed_at (it.list_iterator.index_)))
		end

	simple_extend (v: G)
			-- Add `v' to the set without resizing the buckets.
		require
			wrapped: is_wrapped
			v_locked: lock.owns [v]
			lock_wrapped: lock.is_wrapped
			no_iterators: observers = [lock]
			modify_model ("set", Current)
		local
			idx: INTEGER
			list: V_LINKED_LIST [G]
		do
			check inv_only ("registered", "buckets_exist", "owns_definition", "buckets_non_empty", "buckets_count", "lists_definition", "buckets_lower",
				"set_non_void", "set_not_too_small", "lists_definition", "buckets_content") end
			check lock.inv_only ("owns_items", "valid_buckets") end
			idx := index (v)
			list := buckets [idx]
			if cell_equal (list, v) = Void then
				unwrap
				list.extend_back (v)
				buckets_ := buckets_.replaced_at (idx, buckets_ [idx] & v)
				set := set & v
				count_ := count_ + 1
				bag := bag & v
				lemma_set_not_too_large
				wrap
			end
		ensure
			wrapped: is_wrapped
			precise_effect_has: old set_has (v) implies set = old set
			precise_effect_new: not old set_has (v) implies set = old set & v
			capacity_unchanged: lists.count = old lists.count
		end

	auto_resize (new_count: INTEGER)
			-- Resize `buckets' to an optimal size for `new_count'.
		require
			wrapped: is_wrapped
			no_iterators: observers = [lock]
			lock_wrapped: lock.is_wrapped
			modify_model (["set", "owns"], Current)
		do
			check inv end
			if new_count * target_load_factor // 100 > growth_rate * capacity then
				resize (capacity * growth_rate)
			elseif capacity > default_capacity and new_count * target_load_factor // 100 < capacity // growth_rate then
				resize (capacity // growth_rate)
			end
		ensure
			wrapped: is_wrapped
			set_unchanged: set ~ old set
		end

	resize (c: INTEGER)
			-- Resize `buckets' to `c'.
		require
			wrapped: is_wrapped
			c_positive: c > 0
			no_iterators: observers = [lock]
			lock_wrapped: lock.is_wrapped
			modify_model (["set", "owns"], Current)
		local
			i: INTEGER
			b: V_ARRAY [V_LINKED_LIST [G]]
			it: V_LINKED_LIST_ITERATOR [G]
		do
			b := buckets
			check inv_only ("registered", "subjects_definition", "owns_definition", "lists_definition", "buckets_count", "buckets_lower", "buckets_content", "A2") end
			check lock.inv_only ("owns_items", "no_duplicates") end
			unwrap_no_inv
			make_empty_buckets (c)
			use_definition (set_not_too_large (set, buckets_.old_))
			from
				i := 1
			invariant
				is_wrapped
				b.is_wrapped
				across 1 |..| buckets_.old_.count as j all lists.old_ [j.item].is_wrapped end
				1 <= i and i <= buckets_.old_.count + 1
				lists.count = c
				set <= set.old_
				across 1 |..| buckets_.old_.count as k all across 1 |..| buckets_.old_ [k.item].count as l all
					set [(buckets_.old_ [k.item])[l.item]] = (k.item < i) end end
				across set.old_ - set as x all not set_has (x.item) end
				set_not_too_large (set, buckets_.old_)
				modify_model ("set", Current)
				modify_field (["observers", "closed"], lists.old_.range)
			until
				i > b.count
			loop
				from
					it := b [i].new_cursor
				invariant
					is_wrapped
					it.is_wrapped
					1 <= it.index_ and it.index_ <= lists.old_ [i].count + 1
					lists.old_ [i].sequence = buckets_.old_ [i]
					lists.count = c
					across 1 |..| buckets_.old_.count as k all across 1 |..| buckets_.old_ [k.item].count as l all
						set [(buckets_.old_ [k.item])[l.item]] = (k.item < i or (k.item = i and l.item < it.index_)) end end
					set <= set.old_
					across set.old_ - set as x all not set_has (x.item) end
					set_not_too_large (set, buckets_.old_)
					modify_model ("set", Current)
					modify_model ("index_", it)
				until
					it.after
				loop
					check it.inv_only ("sequence_definition") end
					check inv_only ("set_not_too_small", "no_precise_duplicates").old_ end
					lemma_set_one_more_not_too_large (set, buckets_.old_, i, it.index_)
					simple_extend (it.item)
					check no_duplicates (set.old_) end
					it.forth
				variant
					lists.old_ [i].count - it.index_
				end
				i := i + 1
			end
			check inv_only ("set_not_too_large").old_ end
			lemma_same_content (buckets_.old_, set.old_, set)
		ensure
			wrapped: is_wrapped
			capacity_effect: lists.count = c
			set_unchanged: set = old set
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
			-- Is observer `o' the `lock' object? (Update guard)
		note
			status: functional, ghost
		do
			Result := o = lock
		end

	is_lock_ref (new: ANY; o: ANY): BOOLEAN
			-- Is observer `o' the `lock' object? (Update guard)
		note
			status: functional
		do
			Result := o = lock
		end

	is_lock_seq (new: MML_SEQUENCE [ANY]; o: ANY): BOOLEAN
			-- Is observer `o' the `lock' object? (Update guard)
		note
			status: functional, ghost
		do
			Result := o = lock
		end

	set_not_too_large (s: like set; bs: like buckets_): BOOLEAN
			-- Is every element of `s' contained in at least one of `bs'?
		note
			status: functional, ghost, opaque
		require
			reads_field ([])
		do
			Result := across s as x all across 1 |..| bs.count as i some bs [i.item].has (x.item) end end
		end

	forget_iterator (it: V_ITERATOR [G])
			-- Remove `it' from `observers'.
		note
			status: ghost
			explicit: contracts, wrapping
		local
			i, j: INTEGER
		do
			check it.inv_only ("subjects_definition", "A2") end
			check inv_only ("iterators_type", "list_observers_same", "list_observers_count", "owns_definition", "lists_distinct") end
			unwrap_no_inv
			check attached {V_HASH_SET_ITERATOR [G]} it as hsit then
				check hsit.inv_only ("target_is_bucket", "owns_definition") end
				check hsit.list_iterator.inv_only ("subjects_definition", "default_owns", "A2") end
				i := hsit.bucket_index
				hsit.unwrap
				set_observers (observers / hsit)

				if lists.domain [i] then
					lemma_lists_domain (i)
					lists [i].forget_iterator (hsit.list_iterator)
				else
					hsit.list_iterator.unwrap
				end

				from
					j := 1
				invariant
					1 <= j and j <= lists.count + 1
					hsit.list_iterator.is_open
					across 1 |..| lists.count as k all lists [k.item].is_wrapped and then
						lists [k.item].observers = if k.item >= j and k.item /= i
							then lists [k.item].observers.old_
							else lists [k.item].observers.old_ / hsit.list_iterator end end
					lock /= Void implies lock.sets = lock.sets.old_ and lock.observers = lock.observers.old_
					modify_field (["observers", "closed"], lists.range)
				until
					j > lists.count
				loop
					if j /= i then
						lists [j].unwrap
						lists [j].observers := lists [j].observers / hsit.list_iterator
						lists [j].wrap
					end
					j := j + 1
				end
			end
			check inv_without ("iterators_type", "list_observers_same", "list_observers_count", "owns_definition", "lists_distinct").old_ end
			wrap
		end

	lemma_set_not_too_large
			-- `set_not_too_large (set, buckets_)' is a weaker version of `valid_buckets' invariant of the `lock'.
		note
			status: lemma
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		do
			use_definition (set_not_too_large (set, buckets_))
			check lock.inv_only ("valid_buckets") end
		ensure
			set_not_too_large (set, buckets_)
		end

	lemma_set_one_more_not_too_large (s: like set; bs: like buckets_; i, j: INTEGER)
			-- Adding `(bs [i]) [j]' to `s' preserves `set_not_too_large'.
		note
			status: lemma
		require
			set_not_too_large (s, bs)
			i_in_bounds: 1 <= i and i <= bs.count
			j_in_bounds: 1 <= j and j <= bs [i].count
		do
			use_definition (set_not_too_large (s, bs))
			use_definition (set_not_too_large (s & (bs [i]) [j], bs))
		ensure
			set_not_too_large (s & (bs [i]) [j], bs)
		end

	lemma_same_content (bs: like buckets_; s1, s2: like set)
			-- If `s1' and `s2' both have the same elements as `bs', then they are equal.
		note
			status: lemma
		require
			across 1 |..| bs.count as i all across 1 |..| bs [i.item].count as j all s1 [(bs [i.item])[j.item]] end end
			set_not_too_large (s1, bs)
			across 1 |..| bs.count as i all across 1 |..| bs [i.item].count as j all s2 [(bs [i.item])[j.item]] end end
			set_not_too_large (s2, bs)
		do
			use_definition (set_not_too_large (s1, bs))
			use_definition (set_not_too_large (s2, bs))
		ensure
			s1 = s2
		end

	lemma_same_set (other: V_HASH_SET [G])
			-- If `set' if a subset of `other.set' in terms of reference equality,
			-- and the reverse holds in term of object equality,
			-- then it also holds in terms of reference equality.
		note
			status: lemma
		require
			lock_wrapped: lock.is_wrapped
			other_registered: lock.sets [other]
			set <= other.set
			across other.set as y all set_has (y.item) end
		do
			check lock.inv_only ("no_duplicates") end
			check other.no_duplicates (other.set) end
		ensure
			set = other.set
		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Specification

	lists: MML_SEQUENCE [V_LINKED_LIST [G]]
			-- Cache of `buckets.sequence' (required in the invariant of the iterator).
		note
			status: ghost
			guard: is_lock_seq
		attribute
		end

	lemma_lists_domain (i: INTEGER)
			-- `lock' is not in the ownership domain of any of the `lists'.
		note
			status: lemma
		require
			1 <= i and i <= lists.count
			lists [i].closed
		do
			check lists [i].inv_only ("owns_definition") end
			check across 1 |..| lists [i].cells.count as j all lists [i].cells [j.item].inv_only ("default_owns") end end
			check not lists [i].transitive_owns [lock] end
		ensure
			not lists [i].ownership_domain [lock]
		end

invariant
		-- Abstract state:
	buckets_non_empty: not buckets_.is_empty
	set_not_too_small: across 1 |..| buckets_.count as i all
		across 1 |..| buckets_ [i.item].count as j all set [(buckets_ [i.item])[j.item]] end end
	set_not_too_large: set_not_too_large (set, buckets_)
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
	lists_distinct: lists.no_duplicates
	buckets_content: across 1 |..| buckets_.count as i all buckets_ [i.item] = lists [i.item].sequence end
		-- Iterators:
	array_observers: buckets.observers.is_empty
	iterators_type: across observers as o all o /= lock implies attached {V_HASH_SET_ITERATOR [G]} o.item end
	list_observers_same: across 1 |..| lists.count as i all
		across 1 |..| lists.count as j all lists [i.item].observers = lists [j.item].observers end end
	list_observers_count: across 1 |..| lists.count as i all lists [i.item].observers.count <= (observers - subjects).count end

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
