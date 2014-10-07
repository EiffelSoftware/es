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

class
	V_HASH_SET [G -> V_HASHABLE]

inherit
	V_SET [G]
		redefine
			lock
		end

create
	make

feature {NONE} -- Initialization

	make (l: V_HASH_LOCK [G])
			-- Create an empty set that will use the lock `l'.
		note
			status: creator
		do
			create buckets.constant ({MML_SEQUENCE [G]}.empty_sequence, 10)
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
		local
			b: MML_SEQUENCE [G]
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets") end
			b := buckets [index (v)]
			Result := b.domain [index_of (b, v)]
		end

	item (v: G): G
			-- Element of `set' equivalent to `v' according to object equality.
		local
			b: MML_SEQUENCE [G]
			r: G
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
			b := buckets [index (v)]
			Result := b [index_of (b, v)]
			v.lemma_transitive (Result, [set_item (v)])
		end

feature -- Iteration

	new_cursor: V_HASH_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		note
			status: impure
			explicit: wrapping
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
		local
			idx: INTEGER
			b: MML_SEQUENCE [G]
		do
			check lock.inv_only ("owns_items", "valid_buckets") end
			idx := index (v)
			b := buckets [idx]
			if not b.domain [index_of (b, v)] then
				buckets := buckets.replaced_at (idx, b & v)
				set := set & v
				count_ := count_ + 1
				bag := bag & v
				check set [v] end
			end
			check set_has (v) end
		end

	wipe_out
			-- Remove all elements.
		do
			create set
			create buckets.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets.count)
			create bag
			count_ := 0
		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Implementation

	buckets: MML_SEQUENCE [MML_SEQUENCE [G]]
			-- Element storage.
		note
			guard: inv
		attribute
		end

	count_: INTEGER
			-- Number of elements.
		note
			guard: is_lock
		attribute
		end

	capacity: INTEGER
			-- Bucket array size.
		note
			status: functional
		require
			reads (Current)
		do
			Result := buckets.count
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
		note
			status: functional
		require
			v_closed: v.closed
			positive_capacity: capacity > 0
			reads (v, Current)
		do
			check v.inv end
			Result := bucket_index (v.hash_code_, capacity)
		end

	index_of (b: MML_SEQUENCE [G]; v: G): INTEGER
			-- Index in `b' of an element that is equal to `v'.
		require
			v_closed: v.closed
			items_closed: across 1 |..| b.count as j all b [j.item].closed end
		do
			from
				Result := 1
			invariant
				1 <= Result and Result <= b.count + 1
				across 1 |..| (Result - 1) as j all not v.is_model_equal (b [j.item]) end
			until
				Result > b.count or else v.is_model_equal (b [Result])
			loop
				Result := Result + 1
			variant
				b.count - Result
			end
		ensure
			definition_found: b.domain [Result] implies v.is_model_equal (b [Result])
			definition_not_found: not b.domain [Result] implies across 1 |..| b.count as j all not v.is_model_equal (b [j.item]) end
		end

feature -- Specification

	lock: V_HASH_LOCK [G]
			-- Helper object for keeping items consistent.
		note
			status: ghost
		attribute
		end

	is_lock (new_count: INTEGER; o: ANY): BOOLEAN
		note
			status: functional
		do
			Result := o = lock
		end

invariant
	count_definition: count_ = set.count
	buckets_non_empty: not buckets.is_empty
	set_not_too_small: across 1 |..| buckets.count as i all
		across 1 |..| buckets [i.item].count as j all set [(buckets [i.item])[j.item]] end end
	no_precise_duplicates: across 1 |..| buckets.count as i all
		across 1 |..| buckets.count as j all
			across 1 |..| buckets [i.item].count as k all
				across 1 |..| buckets [j.item].count as l all
					i.item /= j.item or k.item /= l.item implies (buckets [i.item])[k.item] /= (buckets [j.item])[l.item] end end end end

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
