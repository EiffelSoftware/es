note
	description: "Iterators to read from maps in linear order."
	author: "Nadia Polikarpova"
	model: target, key_sequence, index_
	manual_inv: true
	false_guards: true

deferred class
	V_MAP_ITERATOR [K, V]

inherit
	V_ITERATOR [V]
		rename
			sequence as value_sequence
		redefine
			target
		end

feature -- Access

	key: K
			-- Key at current position.
		require
			closed: closed
			target_closed: target.closed
			not_off: not off
--			reads (Current, subjects.any_item.ownership_domain)
			reads (universe)
		deferred
		ensure
			definition: Result = key_sequence [index_]
		end

	target: V_MAP [K, V]
			-- Map to iterate over.

feature -- Cursor movement

	search_key (k: K)
			-- Move to a position where key is equal to `k'.
			-- If `k' does not appear, go after.
			-- (Use reference equality.)
		require
			modify_model ("index_", Current)
			target.is_wrapped
		deferred
		ensure
			index_effect_found: target.has_key (k) implies key_sequence [index_] = k
			index_effect_not_found: not target.has_key (k) implies index_ = key_sequence.count + 1
		end

feature -- Specification

	key_sequence: MML_SEQUENCE [K]
			-- Sequence of keys.
		note
			status: ghost
			replaces: value_sequence
		attribute
		end

invariant
	keys_in_target: key_sequence.range ~ target.map.domain
	unique_keys: key_sequence.count = target.map.count
	value_sequence_domain_definition: value_sequence.count = key_sequence.count
	value_sequence_definition: across 1 |..| key_sequence.count as i all
			across target.map.domain as k all
				key_sequence [i.item] = k.item implies value_sequence [i.item] = target.map [k.item]
			end
		 end

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
