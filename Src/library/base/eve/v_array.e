note
	description: "New version of an array, for use in verification."

class
	V_ARRAY [G]

create
	make, init

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Create an array of size `n' filled with default values.
		note
			status: creator
		require
			n_non_negative: n >= 0
		do
		ensure
			count_set: count = n
			all_default: across sequence.domain as i all sequence [i.item] = ({G}).default end
		end

	init (s: MML_SEQUENCE [G])
			-- Create an array an initialize it with elements of `s'.
		note
			status: creator
		do
		ensure
			count_set: count = s.count
			sequence_set: sequence = s
		end

feature -- Access		

	sequence: MML_SEQUENCE [G]
			-- Sequence of values.			

	count: INTEGER
			-- Number of elements.

	item alias "[]" (i: INTEGER): G assign put
			-- Item at position `i'.
		require
			closed
			valid_index (i)
		do
		ensure
			definition: Result = sequence [i]
		end

feature -- Status report			

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index into the array?
		note
			status: functional
		do
			Result := 1 <= i and i <= count
		end

feature -- Modification		

	put (v: G; i: INTEGER)
			-- Update value at position `i' with `v'.
		require
			valid_index (i)
		do
		ensure
			same_count: count = old count
			sequence_effect: sequence = old sequence.replaced_at (i, v)
		end

invariant
	count_definition: count = sequence.count

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
