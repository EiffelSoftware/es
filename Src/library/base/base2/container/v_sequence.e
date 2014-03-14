note
	description: "[
		Containers where values are associated with integer indexes from a continuous interval.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	model: map

deferred class
	V_SEQUENCE [G]

inherit
	V_MAP [INTEGER, G]
		rename
			has_key as has_index,
			at_key as at
		end

feature -- Access

	first: G
			-- First element.
		require
			closed: closed
			not_empty: not is_empty
			reads (ownership_domain)
		do
			check inv end
			Result := item (lower)
		ensure
			definition: Result = map [lower_]
		end

	last: G
			-- Last element.
		require
			closed: closed
			not_empty: not is_empty
			reads (ownership_domain)
		do
			check inv end
			Result := item (upper)
		ensure
			definition: Result = map [upper_]
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		require
			closed: closed
		deferred
		ensure
			definition: Result = lower_
		end

	upper: INTEGER
			-- Upper bound of index interval.
		require
			closed: closed
		do
			check inv end
			Result := lower + count - 1
		ensure
			definition: Result = upper_
		end

	count: INTEGER
			-- Number of elements.
		deferred
		ensure then
			definition_sequence: Result = map.domain.count
		end

	has_index (i: INTEGER): BOOLEAN
			-- Is any value associated with `i'?
		do
			check inv end
			Result := lower <= i and i <= upper
		ensure then
			Result = (lower <= i and i <= upper)
		end

feature -- Search

	index_of (v: G): INTEGER
			-- Index of the first occurrence of `v';
			-- out of range, if `v' does not occur.
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			modify_model (["observers"], Current)
		do
			if not is_empty then
				Result := index_of_from (v, lower)
			else
				Result := upper + 1
			end
			check inv end
		ensure
			definition_not_has: not map.has (v) implies not map.domain [Result]
			definition_has: map.has (v) implies map.domain [Result] and map [Result] = v
			constraint: not map.image (create {MML_INTERVAL}.from_range (lower_, Result - 1)) [v]
			observers_restored: observers ~ old observers
			is_wrapped: is_wrapped
		end

	index_of_from (v: G; i: INTEGER): INTEGER
			-- Index of the first occurrence of `v' starting from position `i';
			-- out of range, if `v' does not occur.
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			has_index: has_index (i)
			modify_model (["observers"], Current)
		local
			it: V_SEQUENCE_ITERATOR [G]
		do
			it := at (i)
			it.search_forth (v)
			if it.off then
				Result := upper + 1
			else
				Result := it.target_index
			end
			check it.inv end
 			check across it.target_index_sequence.domain as j all it.sequence [j.item] = map [lower_ + j.item - 1] end end
			lemma_sequence_map (it.sequence, map, lower_, i - lower_ + 1, it.index_ - 1, v)
			lemma_sequence_map (it.sequence, map, lower_, i - lower_ + 1, upper_ - lower_ + 1, v)

			forget_iterator (it)
		ensure
			definition_not_has: not map.image (create {MML_INTERVAL}.from_range (i, upper_)) [v] implies Result = upper_ + 1
			definition_has: map.image (create {MML_INTERVAL}.from_range (i, upper_)) [v] implies
				(map.domain [Result] and Result >= i) and then map [Result] = v
			constraint: not map.image (create {MML_INTERVAL}.from_range (i, Result - 1)) [v]
			observers_restored: observers ~ old observers
			is_wrapped: is_wrapped
		end

feature -- Iteration

	new_cursor: like at
			-- New iterator pointing to the first position.
		note
			status: impure
			explicit: contracts
		do
			check inv end
			Result := at (lower)
		end

	at_last: like at
			-- New iterator pointing to the last position.
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			modify_model (["observers"], Current)
		do
			check inv end
			Result := at (upper)
		ensure
			is_wrapped: is_wrapped
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition: Result.index_ = map.count
		end

	at (i: INTEGER): V_SEQUENCE_ITERATOR [G]
			-- New iterator pointing at position `i'.
			-- If `i' is off scope, iterator is off.
		note
			status: impure
			explicit: contracts
		deferred
		ensure then
			index_definition_in_bounds: lower_ - 1 <= i and i <= upper_ + 1 implies Result.index = i - lower_ + 1
			index_definition_before: i < lower_ implies Result.index_ = 0
			index_definition_after: i > upper_ implies Result.index_ = map.count + 1
		end

feature -- Specification

	lower_: INTEGER
			-- Lower bound of `map.domain'.
		note
			status: ghost
		attribute
		end

	upper_: INTEGER
			-- Upper bound of `map.domain'.
		note
			status: ghost
		attribute
		end

	lemma_sequence_map (s: MML_SEQUENCE [G]; m: MML_MAP [INTEGER, G]; k, l, u: INTEGER; v: G)
			-- If `m' is a shifted `s', then the range of any interval of `s' is the `m'-image of a corresponsing shifted interval.
		note
			status: lemma
		require
			m.domain = create {MML_INTERVAL}.from_range (k, s.count + k - 1)
			across s.domain as i all s [i.item] = m [i.item + k - 1] end
			1 <= l and l <= u + 1 and u <= s.count
		do
			check across (create {MML_INTERVAL}.from_range (l, u)) as i all s [i.item] = s.interval (l, u) [i.item - l + 1] end end
			check s.interval (l, u).has (v) = across (create {MML_INTERVAL}.from_range (l, u)) as i some s [i.item] = v end end
			check across (create {MML_INTERVAL}.from_range (k + l - 1, k + u - 1)) as i all m [i.item] = s [i.item - k + 1] end end
		ensure
			s.interval (l, u).has (v) = m.image (create {MML_INTERVAL}.from_range (l + k - 1, u + k - 1))[v]
		end

invariant
	indexes_in_interval: map.domain ~ create {MML_INTERVAL}.from_range (lower_, upper_)
	lower_when_empty: map.is_empty implies lower_ = 1
	upper_when_empty: map.is_empty implies upper_ = 0

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
