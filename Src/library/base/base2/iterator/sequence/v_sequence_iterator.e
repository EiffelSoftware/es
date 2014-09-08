note
	description: "Itreators to read from sequences."
	author: "Nadia Polikarpova"
	model: target, index_
	manual_inv: true
	false_guards: true

deferred class
	V_SEQUENCE_ITERATOR [G]

inherit
	V_MAP_ITERATOR [INTEGER, G]
		rename
			key as target_index,
			search_key as search_target_index,
			key_sequence as target_index_sequence,
			value_sequence as sequence
		redefine
			target
		end

feature -- Access

	target_index: INTEGER
			-- Target index at current position.
		note
			status: dynamic
		do
			check inv end
			Result := target.lower + index_ - 1
		end

	target: V_SEQUENCE [G]
			-- Sequence to iterate over.

feature -- Cursor movement

	search_target_index (i: INTEGER)
			-- Move to a position where target index is `i'.
			-- If `i' is not a valid index, go after.
			-- (Use reference equlity.)
		note
			status: dynamic
			explicit: wrapping
		do
			check inv end
			if target.has_index (i) then
				go_to (i - target.lower + 1)
			else
				go_after
			end
		end

feature {NONE} -- Specification

	set_target_index_sequence
			-- Set `target_index_sequence' to [1..target.count]
		note
			status: ghost, dynamic
		require
			target_wrapped: target.is_wrapped
			no_observers: observers = []
			modify_field ("target_index_sequence", Current)
		local
			j: INTEGER
		do
			check target.inv end
			from
				create target_index_sequence
				j := 1
			invariant
				1 <= j and j <= target.sequence.count + 1
				target_index_sequence.count = j - 1
				across 1 |..| (j - 1) as i all target_index_sequence [i.item] = i.item + target.lower_ - 1 end
				target_index_sequence.range = create {MML_INTERVAL}.from_range (target.lower_, target.lower_ + j - 2)
			until
				j > target.count
			loop
				check (target_index_sequence & (j + target.lower_ - 1)).range = target_index_sequence.range & (j + target.lower_ - 1) end
				target_index_sequence := target_index_sequence & (j + target.lower_ - 1)
				j := j + 1
			end
		ensure
			domain_set: target_index_sequence.count = target.sequence.count
			values_set: across 1 |..| target.sequence.count as i all target_index_sequence [i.item] = i.item + target.lower_ - 1 end
			range_set: target_index_sequence.range = create {MML_INTERVAL}.from_range (target.lower_, target.upper_)
		end

invariant
	target_index_sequence_definition: across 1 |..| target_index_sequence.count as i all target_index_sequence [i.item] = target.lower_ + i.item - 1 end
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
