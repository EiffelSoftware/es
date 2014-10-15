note
	description: "Iterators over sets, allowing efficient search."
	author: "Nadia Polikarpova"
	model: target, sequence, index_
	manual_inv: true
	false_guards: true

deferred class
	V_SET_ITERATOR [G]

inherit
	V_ITERATOR [G]
		redefine
			target
		end

feature -- Access

	target: V_SET [G]
			-- Set to iterate over.

feature -- Cursor movement

	search (v: G)
			-- Move to an element equivalent to `v'.
			-- If `v' does not appear, go after.
			-- (Use object equality.)
		require
			target_wrapped: target.is_wrapped
			lock_wrapped: target.lock.is_wrapped
			target_registered: target.lock.sets [target]
			v_locked: target.lock.owns [v]
			modify_model ("index_", Current)
		deferred
		ensure
			index_effect_found: target.set_has (v) implies v.is_model_equal (sequence [index_])
			index_effect_not_found: not target.set_has (v) implies index_ = sequence.count + 1
		end

feature -- Removal

	remove
			-- Remove element at current position. Move to the next position.
		require
			not_off: not off
			target_wrapped: target.is_wrapped
			lock_wrapped: target.lock.is_wrapped
			target_registered: target.lock.sets [target]
			only_iterator: target.observers = [target.lock, Current]
			modify_model (["sequence"], Current)
			modify_model (["set"], target)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.removed_at (index_)
			target_set_effect: target.set ~ old (target.set / sequence [index_])
			target_wrapped: target.is_wrapped
		end

invariant
	target_set_constraint: target.set = sequence.range

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
