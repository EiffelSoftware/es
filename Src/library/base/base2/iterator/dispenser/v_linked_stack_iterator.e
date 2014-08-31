note
	description: "Iterators over linked stacks."
	author: "Nadia Polikarpova"
	model: target, index_
	manual_inv: true
	false_guards: true

class
	V_LINKED_STACK_ITERATOR [G]

inherit
	V_ITERATOR [G]
		redefine
			target
		end

create {V_CONTAINER}
	make

feature {NONE} -- Initialization

	make (t: V_LINKED_STACK [G]; it: V_LINKED_LIST_ITERATOR [G])
			-- Create a proxy for `it' with target `t'.
		note
			status: creator
			explicit: contracts
		require
			t_open: t.is_open
			it_wrapped: it.is_wrapped
			it_target_owned: t.owns [it.target]
			same_elements: t.bag ~ it.target.bag
			modify_field ("owner", it)
			modify_field ("observers", t)
			modify (Current)
		do
			target := t
			t.set_observers (t.observers & Current)
			iterator := it
			check it.inv end
		ensure
			is_wrapped
			target_effect: target = t
			sequence_effect: sequence ~ it.sequence
			index_effect: index_ = it.index_
			t_observers_effect: t.observers = old t.observers & Current
		end

feature -- Access

	target: V_LINKED_STACK [G]
			-- Stack to iterate over.

	item: G
			-- Item at current position.
		do
			check inv end
			check iterator.inv end
			check iterator.target.transitive_owns <= target.transitive_owns end
			Result := iterator.item
		end

feature -- Measurement		

	index: INTEGER
			-- Current position.
		do
			check inv end
			check iterator.inv end
			check iterator.target.transitive_owns <= target.transitive_owns end
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
			Result := iterator.after
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			check inv end
			check iterator.inv end
			check iterator.target.transitive_owns <= target.transitive_owns end
			Result := iterator.is_first
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			check inv end
			check iterator.inv end
			check iterator.target.transitive_owns <= target.transitive_owns end
			Result := iterator.is_last
		end

feature -- Cursor movement

	start
			-- Go to the first position.
		do
			iterator.start
		end

	finish
			-- Go to the last position.
		do
			iterator.finish
		end

	forth
			-- Move one position forward.
		do
			iterator.forth
		end

	back
			-- Go one position backwards.
		do
			iterator.back
		end

	go_before
			-- Go before any position of `target'.
		do
			iterator.go_before
		end

	go_after
			-- Go after any position of `target'.
		do
			iterator.go_after
		end

feature {V_CONTAINER, V_ITERATOR} -- Implementation

	iterator: V_LINKED_LIST_ITERATOR [G]
			-- Iterator over the storage.

invariant
	sequence_definition: sequence ~ target.sequence
	iterator_exists: iterator /= Void
	owns_structure: owns = [ iterator ]
	targets_connected: target.owns [iterator.target]
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
