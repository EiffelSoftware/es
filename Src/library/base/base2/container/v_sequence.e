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
--			exists_key as exists_index,
--			for_all_keys as for_all_indexes,
			at_key as at
--		redefine
--			out,
--			key
		end

--inherit {NONE}
--	V_EQUALITY [INTEGER]
--		export {NONE}
--			all
--		undefine
--			out
--		end

--	V_ORDER [INTEGER]
--		export {NONE}
--			all
--		undefine
--			out
--		end

feature -- Access

	first: G
			-- First element.
		require
			closed: closed
			not_empty: not is_empty
		do
			check inv end
			Result := item (lower)
		ensure
			definition: Result = map [lower]
		end

	last: G
			-- Last element.
		require
			closed: closed
			not_empty: not is_empty
		do
			check inv end
			Result := item (upper)
		ensure
			definition: Result = map [upper]
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		deferred
		ensure
			definition_nonempty: not map.is_empty implies Result = map.domain.min
			definition_empty: map.is_empty implies Result = 1
		end

	upper: INTEGER
			-- Upper bound of index interval.
		deferred
		ensure
			definition_nonempty: not map.is_empty implies Result = map.domain.max
			definition_empty: map.is_empty implies Result = 0
		end

	count: INTEGER
			-- Number of elements.
		do
			check inv end
			Result := upper - lower + 1
		ensure then
			definition_sequence: Result = map.domain.count
		end

	has_index (i: INTEGER): BOOLEAN
			-- Is any value associated with `i'?
		do
			check inv end
			Result := lower <= i and i <= upper
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
			modify_model (["closed", "observers"], Current)
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
			constraint: not map.image (create {MML_INTERVAL}.from_range (lower, Result - 1)) [v]
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
			modify_model (["closed", "observers"], Current)
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
 			check across it.target_index_sequence.domain as j all it.sequence [j.item] = map [lower + j.item - 1] end end
			lemma_sequence_map (it.sequence, map, lower, i - lower + 1, it.index - 1, v)
			lemma_sequence_map (it.sequence, map, lower, i - lower + 1, upper - lower + 1, v)

			forget_iterator (it)
		ensure
			definition_not_has: not map.image (create {MML_INTERVAL}.from_range (i, upper)) [v] implies Result = upper + 1
			definition_has: map.image (create {MML_INTERVAL}.from_range (i, upper)) [v] implies
				(map.domain [Result] and Result >= i) and then map [Result] = v
			constraint: not map.image (create {MML_INTERVAL}.from_range (i, Result - 1)) [v]
			observers_restored: observers ~ old observers
			is_wrapped: is_wrapped
		end

--	index_satisfying (pred: PREDICATE [ANY, TUPLE [G]]): INTEGER
--			-- Index of the first value that satisfies `pred';
--			-- out of range, if `pred' is never satisfied.
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: map.range.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--				do
--					Result := p.precondition ([x])
--				end (?, pred))
--		do
--			if not is_empty then
--				Result := index_satisfying_from (pred, lower)
--			end
--		ensure
--			definition_not_has: not map.range.exists (pred) implies not map.domain [Result]
--			definition_has: map.range.exists (pred) implies Result = map.inverse.image (map.range | pred).extremum (agent less_equal)
--		end

--	index_satisfying_from (pred: PREDICATE [ANY, TUPLE [G]]; i: INTEGER): INTEGER
--			-- Index of the first value that satisfies `pred' starting from position `i';
--			-- out of range, if `pred' is never satisfied.
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: map.range.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--				do
--					Result := p.precondition ([x])
--				end (?, pred))
--			has_index: has_index (i)
--		local
--			it: V_ITERATOR [G]
--			j: INTEGER
--		do
--			from
--				it := at (i)
--				j := i
--				Result := upper + 1
--			until
--				it.after or else pred.item ([it.item])
--			loop
--				it.forth
--				j := j + 1
--			end
--			if not it.after then
--				Result := j
--			end
--		ensure
--			definition_not_has: not (map | {MML_INTERVAL} [[i, upper]]).range.exists (pred) implies not map.domain [Result]
--			definition_has: (map | {MML_INTERVAL} [[i, upper]]).range.exists (pred) implies
--				Result = (map | {MML_INTERVAL} [[i, upper]]).inverse.image (map.range | pred).extremum (agent less_equal)
--		end

--	key_equivalence: PREDICATE [ANY, TUPLE [INTEGER, INTEGER]]
--			-- Index equivalence relation: identity.
--		once
--			Result := agent reference_equal
--		end

feature -- Iteration

	new_cursor: like at
			-- New iterator pointing to the first position.
		note
			status: impure
			explicit: contracts
		do
			Result := at (lower)
		end

	at_last: like at
			-- New iterator pointing to the last position.
		note
			status: impure
			explicit: contracts
		require
			modify_model (["closed", "observers"], Current)
		do
			Result := at (upper)
		ensure
			is_wrapped: is_wrapped
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition: Result.index = map.count
		end

	at (i: INTEGER): V_SEQUENCE_ITERATOR [G]
			-- New iterator pointing at position `i'.
			-- If `i' is off scope, iterator is off.
		note
			status: impure
			explicit: contracts
		deferred
		ensure then
			index_definition_before: i < lower implies Result.index = 0
			index_definition_after: i > upper implies Result.index = map.count + 1
		end

--feature -- Output

--	out: STRING
--			-- String representation of the content.
--		local
--			stream: V_STRING_OUTPUT
--		do
--			create Result.make_empty
--			create stream.make (Result)
--			stream.pipe (new_cursor)
--			Result.remove_tail (stream.separator.count)
--		end

feature -- Specification

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

--	key (i: INTEGER): INTEGER
--			-- Identity.
--		note
--			status: specification
--		do
--			Result := i
--		end

---	is_total_order (o: PREDICATE [ANY, TUPLE [G, G]])
			-- Is `o' a total order relation?
---		note
---			status: specification
---		deferred
---		ensure
			--- definition: Result = (
			--- (forall x: G :: o (x, x)) and
			--- (forall x, y, z: G :: o (x, y) and o (y, z) implies o (x, z) and
			--- (forall x, y: G :: o (x, y) or o (y, x)))
---		end		

invariant
	indexes_in_interval: map.domain ~ create {MML_INTERVAL}.from_range (lower, upper)
	--- key_equivalence_definition: key_equivalence |=| agent reference_equal
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
