note
	description: "[
		Containers where values are associated with keys. 
		Keys are unique with respect to some equivalence relation.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	model: map
	manual_inv: true
	false_guards: true


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
			reads (ownership_domain)
		deferred
		ensure
			definition: Result = map [k]
		end

feature -- Search

	has_key (k: K): BOOLEAN
			-- Does `map' contain a key equivalent to `k' according to `key_equivalence'?
		require
			closed: closed
			reads (ownership_domain)
		deferred
		ensure
			definition: Result = map.domain [k]
		end

feature -- Iteration

	new_cursor: V_MAP_ITERATOR [K, V]
			-- New iterator pointing to a position in the map, from which it can traverse all elements by going `forth'.
		note
			status: impure
		deferred
		end

	at_key (k: K): V_MAP_ITERATOR [K, V]
			-- New iterator pointing to a position with key `k'.
			-- If key does not exist, iterator is off.
		note
			status: impure
		require
			modify_field (["observers", "closed"], Current)
		deferred
		ensure
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped and Result.inv
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition_found: has_key (k) implies Result.key_sequence [Result.index_] = k
			index_definition_not_found: not has_key (k) implies not Result.key_sequence.domain [Result.index_]
		end

feature -- Specification

	map: MML_MAP [K, V]
			-- Map of keys to values.
		note
			status: ghost
			replaces: bag
		attribute
		end


invariant
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
