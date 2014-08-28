note
	description: "[
		Containers where values are associated with integer indexes from a continuous interval.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	model: sequence, lower_
	manual_inv: true
	false_guards: true

deferred class
	V_SEQUENCE [G]

inherit
	V_MAP [INTEGER, G]
		rename
			has_key as has_index,
			at_key as at
		redefine
			item
		end

feature -- Access

	item alias "[]" (i: INTEGER): G
			-- Value at index `i'.
		deferred
		ensure then
			definition_sequence: Result = sequence [i - lower_ + 1]
		end

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
			definition: Result = sequence.first
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
			definition: Result = sequence.last
		end

feature -- Measurement

	lower: INTEGER
			-- Lower bound of index interval.
		require
			closed: closed
			reads (ownership_domain)
		deferred
		ensure
			definition: Result = lower_
		end

	upper: INTEGER
			-- Upper bound of index interval.
		require
			closed: closed
			reads (ownership_domain)
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
			definition_sequence: Result = sequence.count
		end

	has_index (i: INTEGER): BOOLEAN
			-- Is any value associated with `i'?
		do
			check inv end
			Result := lower <= i and i <= upper
		ensure then
			Result = (lower_ <= i and i <= upper_)
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
			check inv end
			if not is_empty then
				Result := index_of_from (v, lower)
			else
				Result := upper + 1
			end
			check inv end
		ensure
			definition_not_has: not sequence.has (v) implies Result = upper_ + 1
			definition_has: sequence.has (v) implies lower_ <= Result and Result <= upper_ and then sequence [idx (Result)] = v
			constraint: not sequence.front (idx (Result - 1)).has (v)
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
			check inv_only ("upper_definition") end
			forget_iterator (it)
		ensure
			definition_not_has: not sequence.tail (idx (i)).has (v) implies Result = upper_ + 1
			definition_has: sequence.tail (idx (i)).has (v) implies i <= Result and Result <= upper_ and then sequence [idx (Result)] = v
			constraint: not sequence.interval (idx (i), idx (Result - 1)).has (v)
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
			Result := at (lower)
			check inv_only ("upper_definition") end
		end

	at_last: like at
			-- New iterator pointing to the last position.
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			modify_field (["observers", "closed"], Current)
		do
			Result := at (upper)
			check inv_only ("upper_definition") end
		ensure
			is_wrapped: is_wrapped
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped and Result.inv
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition: Result.index_ = sequence.count
		end

	at (i: INTEGER): V_SEQUENCE_ITERATOR [G]
			-- New iterator pointing at position `i'.
			-- If `i' is off scope, iterator is off.
		note
			status: impure
			explicit: contracts
		deferred
		ensure then
			index_definition_in_bounds: lower_ - 1 <= i and i <= upper_ + 1 implies Result.index_ = i - lower_ + 1
			index_definition_before: i < lower_ implies Result.index_ = 0
			index_definition_after: i > upper_ implies Result.index_ = map.count + 1
		end

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence of elements.
		note
			status: ghost
			replaces: map
		attribute
		end

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

	idx (i: INTEGER): INTEGER
		note
			status: ghost, functional
		do
			Result := i - lower_ + 1
		end

invariant
	upper_definition: sequence.count = upper_ - lower_ + 1
	map_domain_definition: map.domain ~ create {MML_INTERVAL}.from_range (lower_, upper_)
	map_definition: across 1 |..| sequence.count as i all
			across lower_ |..| upper_ as j all
				j.item = i.item + lower_ - 1 implies map [j.item] = sequence [i.item]
			end end

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
