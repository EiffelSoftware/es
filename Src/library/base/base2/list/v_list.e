note
	description: "[
		Indexable containers, where elements can be inserted and removed at any position. 
		Indexing starts from 1.
		]"
	author: "Nadia Polikarpova"
	model: sequence

deferred class
	V_LIST [G]

inherit
	V_MUTABLE_SEQUENCE [G]
		redefine
			at,
			index_of_from
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		once
			check inv_only ("lower_defintion") end
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
		ensure then
			definition: Result = (sequence ~ other.sequence)
			observers_restored: observers ~ old observers
		end

feature -- Search

	index_of_from (v: G; i: INTEGER): INTEGER
			-- Index of the first occurrence of `v' starting from position `i';
			-- out of range, if `v' does not occur.
		note
			status: impure
			explicit: contracts
		local
			it: V_LIST_ITERATOR [G]
		do
			it := at (i)
			it.search_forth (v)
			if it.off then
				Result := upper + 1
			else
				Result := it.target_index
			end
			check across (create {MML_INTERVAL}.from_range (i, Result - 1)) as j all sequence[j.item] = sequence.interval (i, Result - 1)[j.item - i + 1]  end end
			forget_iterator (it)
		end

feature -- Extension

	extend_front (v: G)
			-- Insert `v' at the front.
		require
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.prepended (v)
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		require
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old (sequence & v)
		end

	extend_at (v: G; i: INTEGER)
			-- Insert `v' at position `i'.
		require
			valid_index: has_index (i) or i = count + 1
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.extended_at (i, v)
		end

	append (input: V_ITERATOR [G])
			-- Append sequence of values produced by `input'.
		note
			explicit: wrapping
		require
			not_current: input /= Current
			different_target: input.target /= Current
			not_before: not input.before
			modify_model ("sequence", Current)
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
				check input.sequence.interval (input.index_.old_, input.index_) =
					input.sequence.interval (input.index_.old_, input.index_ - 1) & input.item end
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
			not_before: not input.before
			modify_model ("sequence", Current)
			modify_model ("index_", input)
		deferred
		ensure
			sequence_effect: sequence ~ old (input.sequence.tail (input.index_) + sequence)
			input_index_effect: input.index_ = input.sequence.count + 1
		end

	insert_at (input: V_ITERATOR [G]; i: INTEGER)
			-- Insert starting at position `i' sequence of values produced by `input'.
		note
			modify: sequence, input__index
		require
			valid_index: has_index (i) or i = count + 1
			not_current: input /= Current
			different_target: input.target /= Current
			not_before: not input.before
			modify_model ("sequence", Current)
			modify_model ("index_", input)
		deferred
		ensure
			sequence_effect: sequence ~ old (sequence.front (i - 1) + input.sequence.tail (input.index_) + sequence.tail (i))
			input_index_effect: input.index_ = input.sequence.count + 1
		end

feature -- Removal

	remove_front
			-- Remove first element.
		require
			not_empty: not is_empty
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.but_first
		end

	remove_back
			-- Remove last element.
		require
			not_empty: not is_empty
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.but_last
		end

	remove_at (i: INTEGER)
			-- Remove element at position `i'.
		require
			has_index: has_index (i)
			modify_model ("sequence", Current)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.removed_at (i)
		end

	remove (v: G)
			-- Remove the first occurrence of `v'.
		note
			explicit: wrapping
		require
			has: sequence.has (v)
			modify_model (["sequence", "observers"], Current)
		local
			i: V_LIST_ITERATOR [G]
		do
			i := new_cursor
			i.search_forth (v)
			i.remove
			forget_iterator (i)
		ensure
--			sequence_effect: sequence |=| old (sequence.removed_at (sequence.inverse.image_of (v).extremum (agent less_equal)))
			observers_restored: observers ~ old observers
		end

	remove_all (v: G)
			-- Remove all occurrences of `v'.
		note
			explicit: wrapping
		require
			modify_model (["sequence", "observers"], Current)
		local
			i: V_LIST_ITERATOR [G]
		do
			from
				i := new_cursor
				i.search_forth (v)
			invariant
				1 <= i.index_ and i.index_ <= sequence.count + 1
				not i.off implies i.item = v
				is_wrapped and i.is_wrapped
				i.inv
				modify_model ("sequence", Current)
				modify_model (["index_", "sequence"], i)
			until
				i.after
			loop
				i.remove
				i.search_forth (v)
			end
			forget_iterator (i)
		ensure
--			sequence_effect: sequence |=| old (sequence.removed (sequence.inverse.image_of (v)))
			observers_restored: observers ~ old observers
		end

	wipe_out
			-- Remove all elements.
		require
			modify_model ("sequence", Current)
		deferred
		ensure then
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

invariant
	map_domain_definition: map.domain ~ sequence.domain
	map_definition: across map.domain as i all map [i.item] = sequence [i.item] end
	lower_defintion: lower_ = 1
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
