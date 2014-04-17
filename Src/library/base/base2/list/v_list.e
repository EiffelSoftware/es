note
	description: "[
		Indexable containers, where elements can be inserted and removed at any position. 
		Indexing starts from 1.
		]"
	author: "Nadia Polikarpova"
	model: sequence
	manual_inv: true

deferred class
	V_LIST [G]

inherit
	V_MUTABLE_SEQUENCE [G]
		redefine
			first,
			last,
			item,
			at
		end

feature -- Access

	item alias "[]" (i: INTEGER): G
			-- Value at index `i'.
		deferred
		ensure then
			definition_sequence: Result = sequence [i]
		end

	first: G
			-- First element.
		do
			check inv end
			Result := item (lower)
		ensure then
			definition_sequence: Result = sequence.first
		end

	last: G
			-- Last element.
		do
			check inv end
			Result := item (upper)
		ensure then
			definition_sequence: Result = sequence.last
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		once
			check inv_only ("lower_definition") end
			Result := 1
		end

feature -- Iteration

	at (i: INTEGER): V_LIST_ITERATOR [G]
			-- New iterator pointing at position `i'.
		note
			status: impure
			explicit: contracts
		deferred
		end

feature -- Comparison

	is_equal_ (other: like Current): BOOLEAN
			-- Is list made of the same values in the same order as `other'?
			-- (Use reference comparison.)
		note
			status: impure
		require
			modify_model ("observers", [Current, other])
		local
			i, j: V_LIST_ITERATOR [G]
		do
			check inv and other.inv end
			if other = Current then
				Result := True
			elseif count = other.count then
				from
					Result := True
					i := new_cursor
					j := other.new_cursor
				invariant
					1 <= i.index_ and i.index_ <= sequence.count + 1
					i.index_ = j.index_
					Result implies across create {MML_INTERVAL}.from_range (1, i.index_ - 1) as k all sequence [k.item] = other.sequence [k.item] end
					not Result implies sequence [i.index_ - 1] /= other.sequence [i.index_ - 1]
					i.is_wrapped and j.is_wrapped
					modify_model ("index_", [i, j])
				until
					i.after or not Result
				loop
					check across create {MML_INTERVAL}.from_range (1, i.index_ - 1) as k all sequence [k.item] = other.sequence [k.item] end end
					Result := i.item = j.item
					i.forth
					j.forth
				variant
					sequence.count - i.index_
				end
				check Result implies across create {MML_INTERVAL}.from_range (1, i.index_ - 1) as k all sequence [k.item] = other.sequence [k.item] end end
				forget_iterator (i)
				other.forget_iterator (j)
			end
		ensure
			definition: Result = (sequence ~ other.sequence)
			observers_restored: observers ~ old observers
		end

feature -- Extension

	extend_front (v: G)
			-- Insert `v' at the front.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old sequence.prepended (v)
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old (sequence & v)
		end

	extend_at (v: G; i: INTEGER)
			-- Insert `v' at position `i'.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			valid_index: has_index (i) or i = count + 1
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old sequence.extended_at (i, v)
		end

	append (input: V_ITERATOR [G])
			-- Append sequence of values produced by `input'.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			not_current: input /= Current
			different_target: input.target /= Current
			input_target_wrapped: input.target.is_wrapped
			not_before: not input.before
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
			modify_model ("index_", input)
		do
			from
			invariant
				is_wrapped and input.is_wrapped
				input.inv
				input.index_.old_ <= input.index_
				input.index_ <= input.sequence.count + 1
				sequence ~ sequence.old_ + input.sequence.interval (input.index_.old_, input.index_ - 1)
			until
				input.after
			loop
				lemma_concat_interval (sequence.old_, input.sequence, {MML_SEQUENCE [G]}.empty_sequence, sequence, input.index_.old_, input.index_ - 1)
				extend_back (input.item)
				input.forth
			variant
				input.sequence.count - input.index_
			end
		ensure
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			sequence_effect: sequence ~ old (sequence + input.sequence.tail (input.index_))
			input_index_effect: input.index_ = input.sequence.count + 1
		end

	prepend (input: V_ITERATOR [G])
			-- Prepend sequence of values produced by `input'.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			not_current: input /= Current
			different_target: input.target /= Current
			input_target_wrapped: input.target.is_wrapped
			not_before: not input.before
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns", "observers"], Current)
			modify_model ("index_", input)
		deferred
		ensure
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			sequence_effect: sequence ~ old (input.sequence.tail (input.index_) + sequence)
			input_index_effect: input.index_ = input.sequence.count + 1
			observers_preserved: observers ~ old observers
		end

	insert_at (input: V_ITERATOR [G]; i: INTEGER)
			-- Insert starting at position `i' sequence of values produced by `input'.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			valid_index: has_index (i) or i = count + 1
			not_current: input /= Current
			different_target: input.target /= Current
			input_target_wrapped: input.target.is_wrapped
			not_before: not input.before
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns", "observers"], Current)
			modify_model ("index_", input)
		deferred
		ensure
			is_wrapped: is_wrapped
			input_wrapped: input.is_wrapped
			sequence_effect: sequence ~ old (sequence.front (i - 1) + input.sequence.tail (input.index_) + sequence.tail (i))
			input_index_effect: input.index_ = input.sequence.count + 1
			observers_preserved: observers ~ old observers
		end

feature -- Removal

	remove_front
			-- Remove first element.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			not_empty: not is_empty
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old sequence.but_first
		end

	remove_back
			-- Remove last element.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			not_empty: not is_empty
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old sequence.but_last
		end

	remove_at (i: INTEGER)
			-- Remove element at position `i'.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			has_index: has_index (i)
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence ~ old sequence.removed_at (i)
		end

	remove (v: G)
			-- Remove the first occurrence of `v'.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			has: sequence.has (v)
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "observers", "owns"], Current)
		local
			i: V_LIST_ITERATOR [G]
		do
			i := new_cursor
			i.search_forth (v)
			i.remove
			check i.inv_only ("target_bag_constraint", "sequence_definition") end
			forget_iterator (i)
		ensure
			is_wrapped: is_wrapped
			bag_effect: bag ~ old bag.removed (v)
			observers_restored: observers ~ old observers
		end

	remove_all (v: G)
			-- Remove all occurrences of `v'.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "observers", "owns"], Current)
		local
			i: V_LIST_ITERATOR [G]
			n: INTEGER
		do
			from
				i := new_cursor
				i.search_forth (v)
			invariant
				is_wrapped and i.is_wrapped
				1 <= i.index_ and i.index_ <= sequence.count + 1
				not i.off implies i.item = v
				not sequence.front (i.index_ - 1).has (v)
				bag = bag.old_.removed_multiple (v, n)
				bag [v] = bag.old_ [v] - n
				n >= 0
				inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty")
				i.inv_only ("sequence_definition", "index_constraint", "target_bag_constraint")
				modify_model (["sequence", "owns"], Current)
				modify_model (["index_", "sequence", "target_index_sequence"], i)
			until
				i.after
			loop
				i.remove
				check i.inv_only ("target_bag_constraint", "sequence_definition") end
				lemma_remove_multiple (bag.old_, v, n)
				i.search_forth (v)
				check i.inv_only ("sequence_definition", "index_constraint") end
				n := n + 1
			variant
				i.sequence.count - i.index_
			end
			lemma_remove_all (bag.old_, v)
			forget_iterator (i)
			check bag = bag.old_.removed_all (v) end
		ensure
			is_wrapped: is_wrapped
			bag_effect: bag ~ old bag.removed_all (v)
			observers_restored: observers ~ old observers
		end

	wipe_out
			-- Remove all elements.
		note
			explicit: contracts
		require
			is_wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			sequence_effect: sequence.is_empty
		end

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence of list's elements.
		note
			status: ghost
			replaces: map
		attribute
		end

feature {V_CONTAINER, V_ITERATOR} -- Specification

	lemma_concat_interval (s1, s2, s3, s: MML_SEQUENCE [G]; i, j: INTEGER)
			-- If `s' is made up of three parts, the middle of which is an interval of `s2',
			-- it will still be made of three parts after extending after the second part with the next element of `s2'.
		note
			status: lemma
		require
			i_j_in_bounds: 1 <= i and i <= j + 1 and j < s2.count
			s_concat: s = s1 + s2.interval (i, j) + s3
		do
		ensure
			s.extended_at (s1.count + j - i + 2, s2 [j + 1]) = s1 + s2.interval (i, j + 1) + s3
		end

	lemma_remove_multiple (b: MML_BAG [G]; v: G; n: INTEGER)
			-- Removing `n' occurrences of `v' from `b' and then one,
			-- is the same as removing `n' + 1 occurrences.
		note
			status: lemma
		require
			n >= 0
		do
			check across b as x all b.removed_multiple (v, n).removed (v) [x.item] = b.removed_multiple (v, n + 1) [x.item] end end
		ensure
			b.removed_multiple (v, n).removed (v) = b.removed_multiple (v, n + 1)
		end

	lemma_remove_all (b: MML_BAG [G]; v: G)
			-- Removing `b [v]' occurrences of `v' from `b' is the same as removing all occurrences.
		note
			status: lemma
		do
			check across b as x all b.removed_multiple (v, b [v]) [x.item] = b.removed_all (v) [x.item] end end
		ensure
			b.removed_multiple (v, b [v]) = b.removed_all (v)
		end

invariant
	map_definition: map ~ sequence.to_map
	lower_definition: lower_ = 1
	upper_definition: upper_ = sequence.count

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
