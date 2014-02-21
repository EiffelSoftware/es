note
	description: "Iterators to read from and update mutable sequences."
	author: "Nadia Polikarpova"
	model: target, sequence, index

deferred class
	V_MUTABLE_SEQUENCE_ITERATOR [G]

inherit
	V_SEQUENCE_ITERATOR [G]
		redefine
			target,
			index
		end

	V_IO_ITERATOR [G]
		redefine
			target,
			index,
			put
		end

feature -- Access

	target: V_MUTABLE_SEQUENCE [G]
			-- Sequence to iterate over.

feature -- Measurement

	index: INTEGER
			-- Current position.

feature -- Replacement

	put (v: G)
			-- Replace item at current position with `v'.
		require else
			modify_model (["map"], target)
		deferred
		ensure then
			target_map_effect: target.map ~ old (target.map.updated (target.lower + index - 1, v))
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
