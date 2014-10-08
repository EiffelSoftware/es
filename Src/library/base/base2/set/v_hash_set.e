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
			buckets := empty_buckets (default_capacity)
			create buckets_.constant ({MML_SEQUENCE [G]}.empty_sequence, default_capacity)
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
			b := buckets_ [index (v)]
			Result := b.domain [index_of (b, v)]
		end

	item (v: G): G
			-- Element of `set' equivalent to `v' according to object equality.
		local
			b: MML_SEQUENCE [G]
			r: G
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
			b := buckets_ [index (v)]
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
			b := buckets_ [idx]
			if not b.domain [index_of (b, v)] then
				buckets_ := buckets_.replaced_at (idx, b & v)
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
			create buckets_.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets_.count)
			create bag
			count_ := 0
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
		note
			status: functional
		require
			buckets_exist: buckets /= Void
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
					Result.sequence [j.item].is_wrapped and then
					Result.sequence [j.item].is_fresh and then
					Result.sequence [j.item].sequence.is_empty
				end
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
			content: across 1 |..| Result.sequence.count as j all
					Result.sequence [j.item].is_wrapped and then
					Result.sequence [j.item].is_fresh and then
					Result.sequence [j.item].sequence.is_empty
				end
		end

feature -- Specification

	buckets_: MML_SEQUENCE [MML_SEQUENCE [G]]
			-- Abstract element storage.
		note
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

invariant
		-- Abstract state:
	buckets_non_empty: not buckets_.is_empty
	set_not_too_small: across 1 |..| buckets_.count as i all
		across 1 |..| buckets_ [i.item].count as j all set [(buckets_ [i.item])[j.item]] end end
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
	all_buckets_exist: buckets.sequence.non_void
	owns_definition: owns = create {MML_SET [ANY]}.singleton (buckets) + buckets.sequence.range
	buckets_count: buckets_.count = buckets.sequence.count
	buckets_content: across 1 |..| buckets_.count as i all buckets_ [i.item] = buckets.sequence [i.item].sequence end

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
