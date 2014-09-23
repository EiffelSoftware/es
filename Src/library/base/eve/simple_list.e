note
	description: "List with specifications usable in AutoProof."
	skip: true

class
	SIMPLE_LIST [G]

inherit

	ITERABLE [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create an empty list.
		note
			status: creator
		do
		ensure
			empty: is_empty
		end

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence of list's elements.
		note
			status: ghost
		attribute
		end

feature -- Access

	is_empty: BOOLEAN
			-- Is the list empty?
		require
			closed: closed
		do
		ensure
			definition: Result = sequence.is_empty
		end

	count: INTEGER
			-- Number of elements in the list.
		require
			closed: closed
		do
		ensure
			definition: Result = sequence.count
		end

	item alias "[]" (i: INTEGER): G
			-- Element at index `i'.
		require
			closed: closed
			in_bounds: 1 <= i and i <= count
		do
		ensure
			definition: Result = sequence [i]
		end

	has (x: G) : BOOLEAN
			-- Is `x' an element of the list?
		require
			closed: closed
		do
		ensure
			definition: Result = sequence.has (x)
		end

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		do
		end

feature -- Extension

	extend_back (v: G)
			-- Insert `v' at the back.
		do
		ensure
			sequence_effect: sequence = old (sequence & v)
		end

end
