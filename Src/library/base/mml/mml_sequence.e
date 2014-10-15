note
	description: "Finite sequence."
	author: "Nadia Polikarpova"
	theory: "sequence.bpl", "map.bpl", "relation.bpl", "bag.bpl", "set.bpl"
	maps_to: "Seq"
	type_properties: "Seq#ItemsType"

class
	MML_SEQUENCE [G]

inherit
	ITERABLE [G]
		redefine
			default_create,
			is_equal
		end

create
	default_create,
	singleton,
	constant

convert
	singleton ({G})

feature {NONE} -- Initialization

	default_create
			-- Create an empty sequence.
		note
			maps_to: "Seq#Empty"
		do
		end

	singleton (x: G)
			-- Create a sequence with one element `x'.
		do
		end

	constant (x: G; n: INTEGER)
			-- Create a sequence with n copies of `x'.
		require
			n_non_negative: n >= 0
		do
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
		end

	is_constant (c: G): BOOLEAN
			-- Are all values equal to `c'?
		do
		end

--	is_sorted: BOOLEAN
--			-- Is the sequence sorted?
--			-- (used for demo)
--		do
--		end

feature -- Elements

	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		require
			in_domain: 1 <= i and i <= count
		do
		end

feature -- Conversion

	domain: MML_SET [INTEGER]
			-- Set of indexes.
		do
		end

	range: MML_SET [G]
			-- Set of values.
		do
		end

	to_map: MML_MAP [INTEGER, G]
			-- Sequence viewed as a map from indexes to value.
		do
		end

	to_bag: MML_BAG [G]
			-- Bag of sequence values.
		do
		end

feature -- Measurement

	count alias "#": INTEGER
			-- Number of elements.
		note
			maps_to: "Seq#Length"
		do
		end

	occurrences (x: G): INTEGER
			-- How many times does `x' occur?
		do
		end

	index_of (x: G): INTEGER
			-- Position of some occurrence of `x'; out of bounds if `x' does not occur.
		do
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same sequence as `Current'?
		note
			maps_to: "Seq#Equal"
		do
		end

	is_less_equal alias "<=" (a_other: MML_SEQUENCE [G]): BOOLEAN
			-- If this sequence shorter than or the same length as `a_other'?
		note
			maps_to: "Seq#LessEqual"
		do
		end

	is_prefix_of (other: MML_SEQUENCE [G]): BOOLEAN
			-- Is this sequence a prefix of `other'?
		note
			maps_to: "Seq#Prefix"
		do
		end

feature -- Decomposition

	first: G
			-- First element.
		require
			non_empty: not is_empty
		do
		end

	last: G
			-- Last element.
		require
			non_empty: not is_empty
		do
		end

	but_first: MML_SEQUENCE [G]
			-- Current sequence without the first element.
		require
			not_empty: not is_empty
		do
		end

	but_last: MML_SEQUENCE [G]
			-- Current sequence without the last element.
		require
			not_empty: not is_empty
		do
		end

	front (upper: INTEGER): MML_SEQUENCE [G]
			-- Prefix up to `upper'.
		do
		end

	tail (lower: INTEGER): MML_SEQUENCE [G]
			-- Suffix from `lower'.
		do
		end

	interval (lower, upper: INTEGER): MML_SEQUENCE [G]
			-- Subsequence from `lower' to `upper'.
		do
		end

	removed_at (i: INTEGER): MML_SEQUENCE [G]
			-- Current sequence with element at position `i' removed.
		require
			in_domain: domain [i]
		do
		end


feature -- Modification

	extended alias "&" (x: G): MML_SEQUENCE [G]
			-- Current sequence extended with `x' at the end.
		do
		end

	extended_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' inserted at position `i'.
		require
			valid_position: 1 <= i and i <= count + 1
		do
		end

	prepended (x: G): MML_SEQUENCE [G]
			-- Current sequence prepended with `x' at the beginning.
		do
		end

	concatenation alias "+" (other: MML_SEQUENCE [G]): MML_SEQUENCE [G]
			-- The concatenation of the current sequence and `other'.
		note
			maps_to: "Seq#Concat"
		do
		end

	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'.
		note
			maps_to: "Seq#Update"
		require
			in_domain: domain [i]
		do
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: "Seq#Range"
		do
		end

feature -- Convenience

	empty_sequence: MML_SEQUENCE [G]
			-- Empty sequence.
			-- Can be used as `{MML_SEQUENCE [G]}.empty_sequence'.
		note
			maps_to: "Seq#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

	non_void: BOOLEAN
			-- Does this sequence contain only non-Void elements?
		note
			maps_to: "Seq#NonNull"
		do
		end

	no_duplicates: BOOLEAN
		do
		end

feature -- Lemmas

	lemma_no_duplicates
			-- In a sequence with no duplicates, each element occurs exactly once.
		note
			status: lemma
		require
			no_duplicates: no_duplicates
		do
			if not is_empty then
				but_last.lemma_no_duplicates
				check Current = but_last & last end
				check but_last.to_bag [last] = 0 end
			end
		ensure
			single_occurrence: across 1 |..| count as i all occurrences (item (i.item)) = 1 end
		end

end

