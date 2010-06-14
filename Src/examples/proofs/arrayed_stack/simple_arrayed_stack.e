indexing
	description: "Summary description for {SIMPLE_ARRAYED_STACK}."
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ARRAYED_STACK [G]

create
	make

feature {NONE} -- Initialization

	make (a_capacity: INTEGER)
			-- Create stack with maximum capacity of `a_capacity'.
		require
			capacity_positive: capacity > 0
		do
			capacity := a_capacity
			count := 0
			create container.make (1,capacity)
		ensure
			count_set: count = 0
			capacity_set: capacity = a_capacity
		end

feature -- Access

	capacity: INTEGER
			-- Capacity of the stack.

	count: INTEGER
			-- Number of elements stored on the stack.

	top: G
			-- Top element
		require
			not_empty: count > 0
		do
			Result := container.item (count)
		end

feature -- Element change

	push (a_value: G)
			-- Push `a_value' onto the stack.
		require
			not_full: count < capacity
		do
			count := count + 1
			container.put (a_value,count)
		ensure
			count_increased: count = old count + 1
			value_on_top: top = a_value
		end

	pop
			-- Remove top element.
		require
			not_empty: count > 0
		do
			count := count - 1
		ensure
			count_decreased: count = old count - 1
		end

feature {NONE} -- Implementation

	container: ARRAY[G]
			-- Container to store stack elements

invariant
	container_not_void: container /= Void
	capacity_positive: capacity > 0
	count_not_negative: count >= 0
	not_overfull: count <= capacity

end
