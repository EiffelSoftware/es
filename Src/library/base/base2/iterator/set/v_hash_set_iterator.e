note
	description: "Iterators over hash sets."
	author: "Nadia Polikarpova"
	model: target, sequence, index_
	manual_inv: true
	false_guards: true

class
	V_HASH_SET_ITERATOR [G -> V_HASHABLE]

inherit
	V_SET_ITERATOR [G]
		redefine
			target
		end

create {V_HASH_SET}
	make

feature {NONE} -- Initialization

	make (s: V_HASH_SET [G]; it: V_LINKED_LIST_ITERATOR [G])
			-- Create an iterator over `s'.
		note
			explicit: contracts
			status: creator
		require
			s_open: s.is_open
			s.inv_only ("set_non_void", "set_not_too_small", "set_not_too_large", "no_precise_duplicates", "bag_domain_definition", "bag_definition")
			it_wrapped: it.is_wrapped
			target_is_bucket: s.lists.has (it.target)
			modify_field ("owner", it)
			modify_field ("observers", s)
			modify (Current)
		do
			target := s
			s.observers := s.observers & Current
			list_iterator := it
			sequence := concat (target.buckets_)
			lemma_content (target.buckets_, target.set, target.bag, sequence)
		ensure
			wrapped: is_wrapped
			target_effect: target = s
			index_effect: index_ = 0
			s_observers_effect: s.observers = old s.observers & Current
		end

feature -- Access

	target: V_HASH_SET [G]
			-- Set to iterate over.

	item: G
			-- Item at current position.
		local
			s: like target.buckets_
		do
			check inv; target.inv end
			check list_iterator.inv_only ("sequence_definition", "subjects_definition") end
			Result := list_iterator.item
			lemma_single_out (target.buckets_, bucket_index)
		end

feature -- Measurement		

	index: INTEGER
			-- Current position.
		do
			check inv; target.inv end
			if after then
				Result := target.count + 1
			elseif not before then
				check list_iterator.inv_only ("subjects_definition") end
				Result := count_sum (1, bucket_index - 1) + list_iterator.index
			end
		end

feature -- Status report

	before: BOOLEAN
			-- Is current position before any position in `target'?
		do
			check inv end
			Result := bucket_index = 0
		end

	after: BOOLEAN
			-- Is current position after any position in `target'?
		do
			check inv; target.inv; list_iterator.inv_only ("sequence_definition") end
			Result := bucket_index > target.capacity
			if target.buckets_.domain [bucket_index] then
				lemma_single_out (target.buckets_, bucket_index)
			end
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			check inv; target.inv end
			check list_iterator.inv_only ("sequence_definition") end
			Result := not off and then (list_iterator.is_first and count_sum (1, bucket_index - 1) = 0)
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			check inv; target.inv end
			check list_iterator.inv_only ("sequence_definition") end
			Result := not off and then (list_iterator.is_last and count_sum (bucket_index + 1, target.capacity) = 0)
			if sequence.domain [index_] then
				lemma_single_out (target.buckets_, bucket_index)
			end
		end

feature -- Cursor movement

	search (v: G)
			-- Move to an element equivalent to `v'.
			-- If `v' does not appear, go after.
			-- (Use object equality.)
		local
			c: V_LINKABLE [G]
		do
			check target.inv_only ("buckets_non_empty", "buckets_lower", "buckets_count", "lists_definition", "buckets_content",
				"owns_definition", "list_observers_same", "set_non_void", "set_not_too_small") end
			check target.lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
			bucket_index := target.index (v)
			c := target.cell_equal (target.buckets [bucket_index], v)
			check target.lists [bucket_index].sequence = target.buckets_ [bucket_index] end
			if c = Void then
				bucket_index := target.capacity + 1
				index_ := concat (target.buckets_).count + 1
			else
				check list_iterator.inv_only ("subjects_definition", "A2") end
				check target.buckets [bucket_index].inv_only ("cells_domain", "owns_definition", "sequence_implementation") end
				list_iterator.switch_target (target.buckets [bucket_index])
				list_iterator.go_to_cell (c)
				check list_iterator.inv_only ("sequence_definition") end
				index_ := concat (target.buckets_.front (bucket_index - 1)).count + list_iterator.index_
				lemma_single_out (target.buckets_, bucket_index)
				v.lemma_transitive (sequence [index_], [target.set_item (v)])
			end
		end

	start
			-- Go to the first position.
		do
			check target.inv_only ("buckets_count", "buckets_content", "owns_definition", "lists_definition", "buckets_lower", "list_observers_same") end
			from
				bucket_index := 1
			invariant
				1 <= bucket_index and bucket_index <= target.lists.count + 1
				across 1 |..| (bucket_index - 1) as j all target.buckets_ [j.item].is_empty end
				modify_field ("bucket_index", Current)
			until
				bucket_index > target.capacity or else not target.buckets [bucket_index].is_empty
			loop
				bucket_index := bucket_index + 1
			variant
				target.lists.count - bucket_index
			end
			if bucket_index <= target.capacity then
				check list_iterator.inv_only ("subjects_definition", "A2", "default_owns") end
				check list_iterator.target.observers = target.lists [bucket_index].observers end
				list_iterator.switch_target (target.buckets [bucket_index])
				list_iterator.start
			end
			index_ := 1
			lemma_empty (target.buckets_.front (bucket_index - 1))
			check list_iterator.inv_only ("sequence_definition") end
		end

	finish
			-- Go to the last position.
		do
			check target.inv_only ("buckets_count", "buckets_content", "owns_definition", "lists_definition", "buckets_lower", "list_observers_same") end
			from
				bucket_index := target.capacity
			invariant
				0 <= bucket_index and bucket_index <= target.lists.count
				across (bucket_index + 1) |..| target.lists.count as j all target.buckets_ [j.item].is_empty end
				modify_field ("bucket_index", Current)
			until
				bucket_index < 1 or else not target.buckets [bucket_index].is_empty
			loop
				bucket_index := bucket_index - 1
			variant
				bucket_index
			end
			if bucket_index >= 1 then
				check list_iterator.inv_only ("subjects_definition", "A2", "default_owns") end
				check list_iterator.target.observers = target.lists [bucket_index].observers end
				list_iterator.switch_target (target.buckets [bucket_index])
				check list_iterator.inv_only ("sequence_definition") end
				list_iterator.finish
				lemma_single_out (target.buckets_, bucket_index)
			end
			index_ := sequence.count
			lemma_empty (target.buckets_.tail (bucket_index + 1))
		end

	forth
			-- Move one position forward.
		note
			explicit: wrapping
		do
			unwrap
			check target.inv; list_iterator.inv_only ("sequence_definition", "subjects_definition", "default_owns") end
			list_iterator.forth
			index_ := index_ + 1
			if list_iterator.after then
				to_next_bucket
			else
				wrap
			end
		end

	back
			-- Go one position backwards.
		note
			explicit: wrapping
		do
			unwrap
			check target.inv; list_iterator.inv_only ("sequence_definition", "subjects_definition", "default_owns") end
			list_iterator.back
			index_ := index_ - 1
			if list_iterator.before then
				to_prev_bucket
			else
				wrap
			end
		end

	go_before
			-- Go before any position of `target'.
		do
			bucket_index := 0
			index_ := 0
		end

	go_after
			-- Go after any position of `target'.
		do
			check target.inv end
			bucket_index := target.capacity + 1
			index_ := sequence.count + 1
		end

feature -- Removal

	remove
			-- Remove element at current position. Move cursor to the next position.
		note
			explicit: wrapping
		do
			unwrap
			check target.inv_only ("buckets_count", "buckets_content") end
			check list_iterator.inv_only ("sequence_definition") end
			lemma_single_out (target.buckets_, bucket_index)

			target.remove_at (Current)

			check target.inv end
			lemma_single_out (target.buckets_, bucket_index)
			check target.buckets_.tail (bucket_index + 1) = (target.buckets_.old_).tail (bucket_index + 1) end
			sequence := sequence.removed_at (index_)
			lemma_content (target.buckets_, target.set, target.bag, sequence)
			check list_iterator.inv_only ("sequence_definition") end

			if list_iterator.after then
				to_next_bucket
			else
				wrap
			end
		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Implementation

	list_iterator: V_LINKED_LIST_ITERATOR [G]
			-- Iterator inside current bucket.

	bucket_index: INTEGER
			-- Index of current bucket.

feature {NONE} -- Implementation

	count_sum (l, u: INTEGER): INTEGER
			-- Total number of elements in buckets `l' to `u'.
		note
			explicit: contracts
		require
			target_closed: target.closed
			in_bounds: 1 <= l and l <= u + 1 and u <= target.buckets_.count
		local
			i: INTEGER
		do
			from
				i := l
				use_definition (concat (target.buckets_.interval (l, l - 1)))
			invariant
				l <= i and i <= u + 1
				Result = concat (target.buckets_.interval (l, i - 1)).count
			until
				i > u
			loop
				check target.inv end
				Result := Result + target.buckets [i].count
				use_definition (concat (target.buckets_.interval (l, i)))
				check target.buckets_.interval (l, i).but_last = target.buckets_.interval (l, i - 1) end
				check target.buckets_.interval (l, i).last = target.buckets_ [i] end
				i := i + 1
			end
		ensure
			definition: Result = concat (target.buckets_.interval (l, u)).count
		end

	to_next_bucket
			-- Move to the start of next bucket is there is one, otherwise go `after'
		note
			explicit: contracts
		require
			open: is_open
			target_closed: target.closed
			list_iterator_wrapped: list_iterator.is_wrapped
			bucket_index_in_range: target.lists.domain [bucket_index]
			list_iterator_after: list_iterator.index_ = target.lists [bucket_index].sequence.count + 1
			almost_holds: inv_without ("list_iterator_not_off", "box_definition")
			modify_field (["bucket_index", "closed", "box"], Current)
			modify (list_iterator)
		do
			check target.inv_only ("buckets_exist", "lists_definition", "owns_definition", "buckets_lower", "buckets_count", "list_observers_same") end
			from
				bucket_index := bucket_index + 1
			invariant
				bucket_index.old_ < bucket_index and bucket_index <= target.buckets.sequence.count + 1
				across (bucket_index.old_ + 1) |..| (bucket_index - 1) as i all target.lists [i.item].sequence.is_empty end
				modify_field ("bucket_index", Current)
			until
				bucket_index > target.capacity or else not target.buckets [bucket_index].is_empty
			loop
				bucket_index := bucket_index + 1
			variant
				target.buckets.sequence.count - bucket_index
			end

			check target.inv_only ("buckets_content") end
			lemma_empty (target.buckets_.interval (bucket_index.old_ + 1, bucket_index - 1))

			if bucket_index <= target.capacity then
				check list_iterator.inv_only ("subjects_definition", "A2", "default_owns") end
				list_iterator.switch_target (target.buckets [bucket_index])
				list_iterator.start

				lemma_single_out (target.buckets_.front (bucket_index - 1), bucket_index.old_)
				check target.buckets_.front (bucket_index - 1).front (bucket_index.old_ - 1) = target.buckets_.front (bucket_index.old_ - 1) end
			else
				lemma_single_out (target.buckets_, bucket_index.old_)
			end
			check list_iterator.inv_only ("sequence_definition") end
			wrap
 		ensure
			wrapped: is_wrapped
		end

	to_prev_bucket
			-- Move to the end of previous bucket is there is one, otherwise go `before'
		note
			explicit: contracts
		require
			open: is_open
			target_closed: target.closed
			list_iterator_wrapped: list_iterator.is_wrapped
			bucket_index_in_range: target.lists.domain [bucket_index]
			list_iterator_before: list_iterator.index_ = 0
			almost_holds: inv_without ("list_iterator_not_off", "box_definition")
			modify_field (["bucket_index", "closed", "box"], Current)
			modify (list_iterator)
		do
			check target.inv_only ("buckets_exist", "lists_definition", "owns_definition", "buckets_lower", "buckets_count", "list_observers_same", "buckets_content") end
			from
				bucket_index := bucket_index - 1
			invariant
				0 <= bucket_index and bucket_index < bucket_index.old_
				across (bucket_index + 1) |..| (bucket_index.old_ - 1) as i all target.lists [i.item].sequence.is_empty end
				modify_field ("bucket_index", Current)
			until
				bucket_index < 1 or else not target.buckets [bucket_index].is_empty
			loop
				bucket_index := bucket_index - 1
			variant
				bucket_index
			end

			check target.inv_only ("buckets_content") end
			lemma_empty (target.buckets_.interval (bucket_index + 1, bucket_index.old_ - 1))

			if bucket_index >= 1 then
				check list_iterator.inv_only ("subjects_definition", "A2", "default_owns") end
				list_iterator.switch_target (target.buckets [bucket_index])
				check list_iterator.inv_only ("sequence_definition") end
				list_iterator.finish
				lemma_single_out (target.buckets_.front (bucket_index.old_ - 1), bucket_index)
				check target.buckets_.front (bucket_index.old_ - 1).front (bucket_index - 1) = target.buckets_.front (bucket_index - 1) end
			end
			wrap
 		ensure
			wrapped: is_wrapped
		end

feature {V_CONTAINER, V_ITERATOR} -- Specification

	concat (seqs: like target.buckets_): MML_SEQUENCE [G]
			-- All sequences in `seqs' concatenated together.
		note
			status: functional, ghost, opaque
		require
			reads ([])
		do
			Result := if seqs.is_empty then {MML_SEQUENCE [G]}.empty_sequence else concat (seqs.but_last) + seqs.last end
		end

	lemma_append (a, b: like target.buckets_)
			-- Lemma: `concat' distributes over append.
		note
			status: lemma
		do
			use_definition (concat (b))
			if b.is_empty then
				check a + b = a end
			else
				check (a + b).but_last = a + b.but_last end
				lemma_append (a, b.but_last)
				use_definition (concat (a + b))
			end
		ensure
			concat (a + b) = concat (a) + concat (b)
		end

	lemma_single_out (seqs: like target.buckets_; i: INTEGER)
			-- Lemma that singles out `seqs [i]' from `concat (seqs)'.
		note
			status: lemma
		require
			i_in_bounds: 1 <= i and i <= seqs.count
		do
			use_definition (concat (seqs.front (i)))
			check seqs.front (i).but_last = seqs.front (i - 1) end
			check seqs = seqs.front (i) + seqs.tail (i + 1) end
			lemma_append (seqs.front (i), seqs.tail (i + 1))
		ensure
			concat (seqs) = concat (seqs.front (i - 1)) + seqs [i] + concat (seqs.tail (i + 1))
		end

	lemma_empty (seqs: like target.buckets_)
			-- Lemma: `concat' of empty sequences is an empty sequence.
		note
			status: lemma
		require
			all_empty: across 1 |..| seqs.count as i all seqs [i.item].is_empty end
		do
			use_definition (concat (seqs))
			if seqs.count > 0 then
				lemma_empty (seqs.but_last)
			end
		ensure
			concat (seqs).is_empty
		end

	lemma_content (bs: like target.buckets_; s: like target.set; b: like target.bag; seq: like sequence)
			-- If `seq' is `concat (bs)', and `s' and `b' are the set and bag of elements in `bs' respectively,
			-- then `s' and `b' are the set and bag of elements in `seq' as well.
		note
			status: lemma
		require
			target /= Void
			valid_seq: seq = concat (bs)
			set_non_void: s.non_void
			set_not_too_small: across 1 |..| bs.count as i all across 1 |..| bs [i.item].count as j all s [(bs [i.item])[j.item]] end end
			set_not_too_large: target.set_not_too_large (s, bs)
			no_precise_duplicates: across 1 |..| bs.count as i all across 1 |..| bs.count as j all
					across 1 |..| bs [i.item].count as k all across 1 |..| bs [j.item].count as l all
							i.item /= j.item or k.item /= l.item implies (bs [i.item])[k.item] /= (bs [j.item])[l.item] end end end end
			bag_domain_definition: b.domain ~ s
			bag_definition: b.is_constant (1)
		do
			use_definition (concat (bs))
			use_definition (target.set_not_too_large (s, bs))
			if not bs.is_empty then
				check across 1 |..| (bs.count - 1) as i all bs [i.item] = bs.but_last [i.item] end end
				use_definition (target.set_not_too_large (s - bs.last.range, bs.but_last))
				lemma_content (bs.but_last, s - bs.last.range, b - bs.last.to_bag, seq.front (seq.count - bs.last.count))
				bs.last.lemma_no_duplicates
			else
				check b.is_empty end
			end
		ensure
			set_constraint: seq.range = s
			bag_constraint: seq.to_bag = b
		end

invariant
	list_iterator_exists: list_iterator /= Void
	bucket_index_in_bounds: 0 <= bucket_index and bucket_index <= target.lists.count + 1
	owns_structure: owns = [ list_iterator ]
	target_is_bucket: target.lists.has (list_iterator.target)
	targets_which_bucket: target.lists.domain [bucket_index] implies list_iterator.target = target.lists [bucket_index]
	list_iterator_not_off: target.lists.domain [bucket_index] implies 1 <= list_iterator.index_ and list_iterator.index_ <= list_iterator.sequence.count
	sequence_implementation: sequence = concat (target.buckets_)
	index_before: bucket_index = 0 implies index_ = 0
	index_after: bucket_index > target.lists.count implies index_ = concat (target.buckets_).count + 1
	index_not_off: target.lists.domain [bucket_index] implies index_ = concat (target.buckets_.front (bucket_index - 1)).count + list_iterator.index_

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
