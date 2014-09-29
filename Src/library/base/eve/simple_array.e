note
	description: "New version of an array, for use in verification."
	skip: true

frozen class
	SIMPLE_ARRAY [G]

inherit

	ITERABLE [G]

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

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence of values.

feature -- Access

	count: INTEGER
			-- Number of elements.
		require
			reads (Current)
		do
		ensure
			definition: Result = sequence.count
		end

	item alias "[]" (i: INTEGER): G assign put
			-- Item at position `i'.
		require
			in_bounds: 1 <= i and i <= count
			valid_index: valid_index (i)
			reads (Current)			
		do
		ensure
			definition: Result = sequence [i]
		end

	subarray (l, u: INTEGER): SIMPLE_ARRAY [G]
			-- Subarray from `l' to `u' (inclusive).
		note
			status: impure
		require
			l_not_too_small: l >= 1
			u_not_too_large: u <= count
			l_not_too_large: l <= u + 1
		do
		ensure
			result_wrapped: Result.is_wrapped
			result_fresh: Result.is_fresh
			result_sequence_definition: Result.sequence ~ sequence.interval (l, u)
			result_count_definition: Result.count = (u - l + 1)
		end

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		do
		end

feature -- Status report

	has (v: G): BOOLEAN
			-- Does the array contain `v'?
		note
			status: functional
		do
			Result := sequence.has (v)
		end

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
			in_bounds: 1 <= i and i <= count
			valid_index: valid_index (i)
		do
		ensure
			same_count: count = old count
			sequence_effect: sequence = old sequence.replaced_at (i, v)
		end

invariant
	count_definition: count >= 0 and count = sequence.count

end
