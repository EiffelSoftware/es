note
	description: "New version of an array, for use in verification."
	skip: true

class
	V_ARRAY [G]

create
	make, init

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Create an array of size `n' filled with default values.
		note
			status: creator
		do
		ensure
			count_set: count = n
			all_default: map.is_constant (({G}).default)
		end

	init (s: MML_SEQUENCE [G])
			-- Create an array an initialize it with elements of `s'.
		note
			status: creator
		do
		ensure
			count_set: count = s.count
			elements_set: map = s.to_map
		end

feature -- Access		

	map: MML_MAP [INTEGER, G]
			-- Map from indexes to value.

	count: INTEGER
			-- Number of elements.

	item alias "[]" (i: INTEGER): G assign put
			-- Item at position `i'.
		require
			closed
			valid_index (i)
		do
		ensure
			definition: Result = map [i]
		end

	sequence: MML_SEQUENCE [G]
		require
			closed
		do
		ensure
			defintion: Result.to_map = map
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
			map_effect: map = old map.updated (i, v)
		end

invariant
	non_negative_count: count >= 0
	indexes_in_interval: map.domain ~ create {MML_INTERVAL}.from_range (1, count)

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
