note
	description: "Iterators over lists."
	author: "Nadia Polikarpova"
	model: target, index

deferred class
	V_LIST_ITERATOR [G]

inherit
	V_MUTABLE_SEQUENCE_ITERATOR [G]
		redefine
			target
		end

feature -- Access

	target: V_LIST [G]
			-- List to iterate over.

feature -- Extension

	extend_left (v: G)
			-- Insert `v' to the left of current position.
			-- Do not move cursor.
		require
			not_off: not off
			modify_model (["index", "sequence"], Current)
			modify_model ("sequence", target)
		deferred
		ensure
			target_sequence_effect: target.sequence ~ old target.sequence.extended_at (index, v)
			index_effect: index = old index + 1
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position.
			-- Do not move cursor.
		require
			not_off: not off
			modify_model (["sequence", "box"], Current)
			modify_model ("sequence", target)
		deferred
		ensure
			target_sequence_effect: target.sequence ~ old target.sequence.extended_at (index + 1, v)
		end

	insert_left (other: V_ITERATOR [G])
			-- Append, to the left of current position, sequence of values produced by `other'.
			-- Do not move cursor.
		require
			not_off: not off
			other_exists: other /= Void
			different_target: target /= other.target
			other_not_before: not other.before
			modify_model (["index", "sequence"], Current)
			modify_model ("index", other)
		deferred
		ensure
			taregt_sequence_effect: target.sequence ~ old (target.sequence.front (index - 1) + other.sequence.tail (other.index) + target.sequence.tail (index))
			index_effect: index = old (index + other.sequence.tail (other.index).count)
			other_index_effect: other.index = other.sequence.count + 1
		end

	insert_right (other: V_ITERATOR [G])
			-- Append, to the right of current position, sequence of values produced by `other'.
			-- Move cursor to the last element of inserted sequence.
		require
			not_off: not off
			other_exists: other /= Void
			different_target: target /= other.target
			other_not_before: not other.before
			modify_model (["index", "sequence"], Current)
			modify_model ("index", other)
		deferred
		ensure
			target_sequence_effect: target.sequence ~ old (target.sequence.front (index) + other.sequence.tail (other.index) + target.sequence.tail (index + 1))
			index_effect: index = old (index + other.sequence.tail (other.index).count)
			other_index_effect: other.index = other.sequence.count + 1
		end

feature -- Removal

	remove
			-- Remove element at current position. Move cursor to the next position.
		note
			modify: sequence
		require
			not_off: not off
			modify_model (["sequence", "box"], Current)
			modify_model ("sequence", target)
		deferred
		ensure
			target_sequence_effect: target.sequence ~ old target.sequence.removed_at (index)
		end

	remove_left
			-- Remove element to the left current position. Do not move cursor.
		require
			not_off: not off
			not_first: not is_first
			modify_model (["sequence", "index"], Current)
			modify_model ("sequence", target)
		deferred
		ensure
			target_sequence_effect: target.sequence ~ old target.sequence.removed_at (index - 1)
			index_effect: index = old index - 1
		end

	remove_right
			-- Remove element to the right current position. Do not move cursor.
		require
			not_off: not off
			not_last: not is_last
			modify_model (["sequence", "index"], Current)
			modify_model ("sequence", target)
		deferred
		ensure
			sequence_effect: sequence ~ old sequence.removed_at (index + 1)
		end


invariant
	sequence_definition: sequence ~ target.sequence
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
