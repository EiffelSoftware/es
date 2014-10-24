note
	description: "[
		Indexable containers, where elements can be inserted and removed at any position. 
		Indexing starts from 1.
		]"
	author: "Nadia Polikarpova"
	model: sequence
	manual_inv: true
	false_guards: true

deferred class
	V_LIST [G]

inherit
	V_MUTABLE_SEQUENCE [G]
		redefine
			item,
			at,
			is_model_equal
		end

feature -- Access

	item alias "[]" (i: INTEGER): G
			-- Value at index `i'.
		deferred
		ensure then
			definition_sequence: Result = sequence [i]
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		note
			status: dynamic
		do
			check inv_only ("lower_definition") end
			Result := 1
		end

	count: INTEGER
			-- Number of elements.
		note
			status: dynamic
		do
			check inv_only ("count_definition", "bag_definition") end
			Result := count_
		end

feature -- Iteration

	at (i: INTEGER): V_LIST_ITERATOR [G]
			-- New iterator pointing at position `i'.
		note
			status: impure
			explicit: contracts
		deferred
		ensure then
			index_definition_in_bounds: 0 <= i and i <= sequence.count + 1 implies Result.index_ = i
		end

feature -- Extension

	extend_front (v: G)
			-- Insert `v' at the front.
		require
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.prepended (v)
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		require
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old (sequence & v)
		end

	extend_at (v: G; i: INTEGER)
			-- Insert `v' at position `i'.
		require
			valid_index: 1 <= i and i <= sequence.count + 1
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.extended_at (i, v)
		end

	append (input: V_ITERATOR [G])
			-- Append sequence of values produced by `input'.
		note
			status: dynamic
			explicit: wrapping
		require
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
				extend_back (input.item)
				input.forth
			variant
				input.sequence.count - input.index_
			end
		ensure
			sequence_effect: sequence ~ old (sequence + input.sequence.tail (input.index_))
			input_index_effect: input.index_ = input.sequence.count + 1
		end

	prepend (input: V_ITERATOR [G])
			-- Prepend sequence of values produced by `input'.
		require
			not_current: input /= Current
			different_target: input.target /= Current
			input_target_wrapped: input.target.is_wrapped
			not_before: not input.before
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns", "observers"], Current)
			modify_model ("index_", input)
		deferred
		ensure
			sequence_effect: sequence ~ old (input.sequence.tail (input.index_) + sequence)
			input_index_effect: input.index_ = input.sequence.count + 1
			observers_preserved: observers ~ old observers
		end

	insert_at (input: V_ITERATOR [G]; i: INTEGER)
			-- Insert starting at position `i' sequence of values produced by `input'.
		require
			valid_index: 1 <= i and i <= sequence.count + 1
			not_current: input /= Current
			different_target: input.target /= Current
			input_target_wrapped: input.target.is_wrapped
			not_before: not input.before
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns", "observers"], Current)
			modify_model ("index_", input)
		deferred
		ensure
			sequence_effect: sequence ~ old (sequence.front (i - 1) + input.sequence.tail (input.index_) + sequence.tail (i))
			input_index_effect: input.index_ = input.sequence.count + 1
			observers_preserved: observers ~ old observers
		end

feature -- Removal

	remove_front
			-- Remove first element.
		require
			not_empty: not is_empty
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.but_first
		end

	remove_back
			-- Remove last element.
		require
			not_empty: not is_empty
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.but_last
		end

	remove_at (i: INTEGER)
			-- Remove element at position `i'.
		require
			has_index: 1 <= i and i <= sequence.count
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.removed_at (i)
		end

	remove (v: G)
			-- Remove the first occurrence of `v'.
		note
			status: dynamic
			explicit: wrapping
		require
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
			bag_effect: bag ~ old bag.removed (v)
			observers_restored: observers ~ old observers
		end

	remove_all (v: G)
			-- Remove all occurrences of `v'.
		note
			status: dynamic
			explicit: wrapping
		require
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "observers", "owns"], Current)
		local
			i: V_LIST_ITERATOR [G]
			n: INTEGER
			b: like bag
		do
			from
				i := new_cursor
				i.search_forth (v)
			invariant
				is_wrapped and i.is_wrapped
				i.inv_only ("sequence_definition", "index_constraint", "target_bag_constraint")
				1 <= i.index_ and i.index_ <= sequence.count + 1
				not i.off implies i.item = v
				not sequence.front (i.index_ - 1).has (v)
				bag = bag.old_.removed_multiple (v, n)
				bag [v] = bag.old_ [v] - n
				n >= 0
				modify_model (["sequence", "owns"], Current)
				modify_model (["index_", "sequence"], i)
			until
				i.after
			loop
				b := bag
				i.remove
				check i.inv_only ("target_bag_constraint", "sequence_definition") end
				bag.old_.lemma_remove_multiple (v, n)
				i.search_forth (v)
				n := n + 1
			variant
				i.sequence.count - i.index_
			end
			bag.old_.lemma_remove_all (v)
			forget_iterator (i)
		ensure
			bag_effect: bag ~ old bag.removed_all (v)
			observers_restored: observers ~ old observers
		end

	wipe_out
			-- Remove all elements.
		require
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		deferred
		ensure
			sequence_effect: sequence.is_empty
		end

feature {V_LIST, V_LIST_ITERATOR} -- Implementation

	count_: INTEGER
			-- Number of elements.		

feature -- Specification

	is_model_equal (other: like Current): BOOLEAN
			-- Is the abstract state of `Current' equal to that of `other'?
		note
			status: ghost, functional
		do
			Result := sequence ~ other.sequence
		end

invariant
	lower_definition: lower_ = 1
	count_definition: count_ = sequence.count

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
