note
	description: "Iterators to read from and update tables."
	author: "Nadia Polikarpova"
	model: target, sequence, index_
	manual_inv: true
	false_guards: true

deferred class
	V_TABLE_ITERATOR [K, V]

inherit
	V_ITERATOR [V]
		rename
			sequence as value_sequence
		redefine
			target
		end

--	V_IO_ITERATOR [V]
--		rename
--			sequence as value_sequence
--		redefine
--			target,
--			index_
--		end

feature -- Access

	key: K
			-- Key at current position.
		require
			closed: closed
			target_closed: target.closed
			not_off: not off
		deferred
		ensure
			definition: Result = sequence [index_]
		end

	target: V_TABLE [K, V]
			-- Table to iterate over.

feature -- Cursor movement

	search_key (k: K)
			-- Move to a position where key is equivalent to `k'.
			-- If `k' does not appear, go after.
			-- (Use object equality.)
		require
			target_wrapped: target.is_wrapped
			lock_wrapped: target.lock.is_wrapped
			k_locked: target.lock.owns [k]
			modify_model ("index_", Current)
		deferred
		ensure
			index_effect_found: target.domain_has (k) implies sequence [index_] = target.domain_item (k)
			index_effect_not_found: not target.domain_has (k) implies index_ = sequence.count + 1
		end

feature -- Replacement

	put (v: V)
			-- Replace item at current position with `v'.
		require
			not_off: not off
			target_wrapped: target.is_wrapped
			lock_wrapped: target.lock.is_wrapped
			only_iterator: target.observers = [target.lock, Current]
			modify_model (["value_sequence", "box"], Current)
			modify_model ("map", target)
		deferred
		ensure
			target_map_effect: target.map ~ old target.map.updated (sequence [index_], v)
			target_wrapped: target.is_wrapped
		end

feature -- Removal

	remove
			-- Remove key-value pair at current position. Move to the next position.
		require
			not_off: not off
			target_wrapped: target.is_wrapped
			lock_wrapped: target.lock.is_wrapped
			only_iterator: target.observers = [target.lock, Current]
			modify_model (["sequence", "box"], Current)
			modify_model ("map", target)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.removed_at (index_)
			target_map_effect: target.map ~ old target.map.removed (sequence [index_])
			target_wrapped: target.is_wrapped
			index_ = old index_
		end

feature -- Specification

	sequence: MML_SEQUENCE [K]
			-- Sequence of keys.
		note
			status: ghost
			replaces: value_sequence
		attribute
		end

	value_sequence_from (seq: like sequence; m: like target.map): MML_SEQUENCE [V]
			-- Value sequnce for key sequence `seq' and target map `m'.			
		note
			status: ghost, functional, opaque
		require
			in_domain: seq.range <= m.domain
			reads ([])
		do
			Result := m.sequence_image (seq)
		ensure
			same_count: Result.count = seq.count
		end

	lemma_sequence_no_duplicates
			-- Key sequence has no duplicates.	
		note
			status: lemma
		require
			closed: closed
			target_closed: target.closed
		do
			check inv end
			check target.inv_only ("bag_definition") end
			use_definition (target.bag_from (target.map))
			check value_sequence.count = value_sequence.to_bag.count end
			check sequence.to_bag.domain = sequence.range end
			sequence.to_bag.lemma_domain_count
			sequence.lemma_no_duplicates
		ensure
			sequence.no_duplicates
		end

invariant
	target_domain_constraint: target.map.domain ~ sequence.range
	value_sequence_definition: value_sequence ~ value_sequence_from (sequence, target.map)

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
