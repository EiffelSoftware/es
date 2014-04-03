note
	description: "Iterators to read and write from/to a container in linear order."
	author: "Nadia Polikarpova"
	model: target, sequence, index_

deferred class
	V_IO_ITERATOR [G]

inherit
	V_ITERATOR [G]
		redefine
			index_,
			start
		end

	V_OUTPUT_STREAM [G]
		undefine
			is_equal
		end

feature -- Measurement

	index_: INTEGER
			-- Current position.
		note
			status: ghost
			replaces: off_
		attribute
		end

feature -- Replacement

	start
			-- Go to the first position.
		require else
			modify_model ("off_", Current)
		deferred
		end

	put (v: G)
			-- Replace item at current position with `v'.
		require
			not_off: not off
			target_wrapped: target.is_wrapped
			other_observers_open: across target.observers as o all o.item /= Current implies o.item.is_open end
			modify_model (["sequence"], Current)
			modify_model (["bag"], target)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.replaced_at (index_, v)
			target_wrapped: target.is_wrapped
			target_bag_effect: target.bag ~ old ((target.bag / sequence [index_]) & v)
		end

	output (v: G)
			-- Replace item at current position with `v' and go to the next position.
		note
			explicit: wrapping
		require else
			modify_model (["sequence", "index_"], Current)
		do
			check inv_only ("subjects_definition", "subjects_contraint") end
			put (v)
			forth
		ensure then
			sequence_effect: sequence ~ old (sequence.replaced_at (index_, v))
			index_effect: index_ = old index_ + 1
		end

invariant
	off_definition: off_ = not sequence.domain [index_]

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
