note
	description: "Linked implementation of queues."
	author: "Nadia Polikarpova"
	model: sequence
	manual_inv: true
	false_guards: true

class
	V_LINKED_QUEUE [G]

inherit
	V_QUEUE [G]
		redefine
			default_create,
			is_equal,
			forget_iterator
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty queue.
		note
			status: creator
		do
			create list
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initialization

	copy_ (other: like Current)
			-- Initialize by copying all the items of `other'.
		require
			no_observers: observers.is_empty
			modify_model ("sequence", Current)
			modify_model ("closed", other)
		do
			if other /= Current then
				other.unwrap
				list.copy_ (other.list)
				other.wrap
			end
		ensure then
			sequence_effect: sequence ~ other.sequence
		end

feature -- Access

	item: G
			-- The top element.
		do
			check inv end
			check list.transitive_owns <= transitive_owns end
			Result := list.first
		end

feature -- Measurement

	count: INTEGER
			-- Number of elements.
		do
			check inv end
			check list.transitive_owns <= transitive_owns end
			Result := list.count
		end

feature -- Iteration

	new_cursor: V_LINKED_QUEUE_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'.
		note
			status: impure
		local
			list_cursor: V_LINKED_LIST_ITERATOR [G]
		do
			unwrap
			list_cursor := list.new_cursor
			create Result.make (Current, list_cursor)
			wrap
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is queue made of the same values in the same order as `other'?
			-- (Use reference comparison.)
		do
			check inv; other.inv; list.inv; other.list.inv end
			Result := list.is_equal (other.list)
		end

feature -- Extension

	extend (v: G)
			-- Push `v' on the stack.
		do
			list.extend_back (v)
		end

feature -- Removal

	remove
			-- Pop the top element.
		do
			list.remove_front
		end

	wipe_out
			-- Pop all elements.
		do
			list.wipe_out
		end

feature {V_CONTAINER, V_ITERATOR} -- Implementation

	list: V_LINKED_LIST [G]
			-- Underlying list.
			-- Should not be reassigned after creation.

feature -- Specification

	forget_iterator (it: like new_cursor)
			-- Remove `it' from `observers'.
		note
			status: ghost
			explicit: contracts
		do
			it.unwrap
			set_observers (observers / it)
			check it.iterator.inv_only ("subjects_definition", "A2") end
			list.forget_iterator (it.iterator)
		end

invariant
	list_exists: list /= Void
	owns_definition: owns = [list]
	sequence_implementation: sequence ~ list.sequence
	observers_correspond: list.observers.count <= observers.count

note
	explicit: observers
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
