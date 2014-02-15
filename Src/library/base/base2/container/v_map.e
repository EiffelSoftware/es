note
	description: "[
		Containers where values are associated with keys. 
		Keys are unique with respect to some equivalence relation.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	model: map

deferred class
	V_MAP [K, V]

inherit
	V_CONTAINER [V]

feature -- Access

	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			closed: closed
			has_key: has_key (k)
		deferred
		ensure
			definition: Result = map [k]
		end

feature -- Search

	has_key (k: K): BOOLEAN
			-- Does `map' contain a key equivalent to `k' according to `key_equivalence'?
		require
			closed: closed
		deferred
		ensure
			definition: Result = map.domain [k]
		end

--	exists_key (pred: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
--			-- Is there a key that satisfies `pred'?
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: map.domain.for_all (agent (k: K; p: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
--				do
--					Result := p.precondition ([k])
--				end (?, pred))
--		local
--			it: V_MAP_ITERATOR [K, V]
--		do
--			from
--				Result := False
--				it := new_cursor
--			until
--				it.after or Result
--			loop
--				Result := pred.item ([it.key])
--				it.forth
--			end
--		ensure
--			definition: Result = map.domain.exists (pred)
--		end

--	for_all_keys (pred: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
--			-- Do all keys satisfy `pred'?
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: map.domain.for_all (agent (k: K; p: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
--				do
--					Result := p.precondition ([k])
--				end (?, pred))
--		do
--			Result := across Current as it all pred.item ([it.key]) end
--		ensure
--			definition: Result = map.domain.for_all (pred)
--		end

feature -- Iteration

	new_cursor: V_MAP_ITERATOR [K, V]
			-- New iterator pointing to a position in the map, from which it can traverse all elements by going `forth'.
		note
			status: impure
			explicit: contracts
		deferred
		end

	at_key (k: K): V_MAP_ITERATOR [K, V]
			-- New iterator pointing to a position with key `k'.
			-- If key does not exist, iterator is off.
		note
			status: impure
			explicit: contracts
		require
			modify_model (["observers"], Current)
		deferred
		ensure
			is_wrapped: is_wrapped
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition_found: has_key (k) implies Result.key_sequence [Result.index] = k
			index_definition_not_found: not has_key (k) implies not Result.key_sequence.domain [Result.index]
		end

--feature -- Output

--	out: STRING
--			-- String representation of the content.
--		local
--			stream: V_STRING_OUTPUT
--		do
--			Result := ""
--			create stream.make_with_separator (Result, "")
--			across
--				Current as it
--			loop
--				stream.output ("(")
--				stream.output (it.key)
--				stream.output (", ")
--				stream.output (it.item)
--				stream.output (")")
--				if not it.is_last then
--					stream.output (" ")
--				end
--			end
--		end

feature -- Specification

	map: MML_MAP [K, V]
			-- Map of keys to values.
		note
			status: ghost
			replaces: bag
		attribute
		end


invariant
	bag_domain_definition: bag.domain ~ map.range
	bag_definition: bag ~ map.to_bag
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
