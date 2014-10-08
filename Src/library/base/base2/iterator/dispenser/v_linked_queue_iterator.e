note
	description: "Iterators over linked queues."
	author: "Nadia Polikarpova"
	model: target, index_
	manual_inv: true
	false_guards: true

class
	V_LINKED_QUEUE_ITERATOR [G]

inherit
	V_ITERATOR [G]
		redefine
			target,
			is_equal_
		end

create {V_CONTAINER}
	make

feature {NONE} -- Initialization

	make (t: V_LINKED_QUEUE [G]; it: V_LINKED_LIST_ITERATOR [G])
			-- Create a proxy for `it' with target `t'.
		note
			explicit: contracts
			status: creator
		require
			t_open: t.is_open
			t.inv_only ("bag_definition", "sequence_implementation")
			it_wrapped: it.is_wrapped
			connected: t.list = it.target
			same_elements: t.bag ~ it.target.bag
			modify_field ("owner", it)
			modify_field ("observers", t)
			modify (Current)
		do
			target := t
			t.observers := t.observers & Current
			iterator := it
			check it.inv end
		ensure
			wrapped: is_wrapped
			target_effect: target = t
			index_effect: index_ = it.index_
			t_observers_effect: t.observers = old t.observers & Current
		end

feature -- Access

	target: V_LINKED_QUEUE [G]
			-- Stack to iterate over.

	item: G
			-- Item at current position.
		do
			check inv end
			check iterator.inv end
			check target.inv end
			Result := iterator.item
		end

feature -- Measurement		

	index: INTEGER
			-- Current position.
		do
			check inv end
			check iterator.inv end
			check target.inv end
			Result := iterator.index
		end

feature -- Status report

	before: BOOLEAN
			-- Is current position before any position in `target'?
		do
			check inv end
			check iterator.inv end
			Result := iterator.before
		end

	after: BOOLEAN
			-- Is current position after any position in `target'?
		do
			check inv end
			check iterator.inv end
			check target.inv end
			check iterator.target.ownership_domain <= target.ownership_domain end
			Result := iterator.after
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			check inv end
			check iterator.inv end
			check target.inv end
			Result := iterator.is_first
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			check inv end
			check iterator.inv end
			check target.inv end
			Result := iterator.is_last
		end

feature -- Comparison

	is_equal_ (other: like Current): BOOLEAN
			-- Is iterator traversing the same container and is at the same position at `other'?
		do
			check inv; other.inv; iterator.inv; other.iterator.inv; target.inv; other.target.inv end
			Result := iterator.is_equal_ (other.iterator)
		end

feature -- Cursor movement

	start
			-- Go to the first position.
		do
			check iterator.inv end
			check target.inv_only ("owns_definition") end
			iterator.start
		end

	finish
			-- Go to the last position.
		do
			check iterator.inv end
			check target.inv_only ("owns_definition") end
			iterator.finish
		end

	forth
			-- Move one position forward.
		do
			check iterator.inv end
			check target.inv_only ("owns_definition") end
			iterator.forth
		end

	back
			-- Go one position backwards.
		do
			check iterator.inv end
			check target.inv_only ("owns_definition") end
			iterator.back
		end

	go_before
			-- Go before any position of `target'.
		do
			check iterator.inv end
			iterator.go_before
		end

	go_after
			-- Go after any position of `target'.
		do
			check iterator.inv end
			check target.inv_only ("owns_definition") end
			iterator.go_after
		end

feature {V_CONTAINER, V_ITERATOR} -- Implementation

	iterator: V_LINKED_LIST_ITERATOR [G]
			-- Iterator over the storage.

invariant
	sequence_definition: sequence ~ target.sequence
	iterator_exists: iterator /= Void
	owns_structure: owns = [ iterator ]
	targets_connected: target.list = iterator.target
	same_sequence: sequence ~ iterator.sequence
	same_index: index_ = iterator.index_

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
