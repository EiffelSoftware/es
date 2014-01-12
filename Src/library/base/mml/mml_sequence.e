note
	description: "Finite sequence."
	author: "Nadia Polikarpova"
	theory: "sequence.bpl"
	maps_to: "Seq"
	equality: "Seq#Equal"	
	rank: "Seq#LessEqual"
	typed_sets: "Seq#Range"		

class
	MML_SEQUENCE [G]

inherit
	ITERABLE [G]
		redefine
			default_create
		end

create
	default_create,
	singleton

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

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
		end

feature -- Elements

	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		require
			in_domain: domain [i]
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
		
feature -- Comparison

	is_prefix_of alias "<=" (other: MML_SEQUENCE [G]): BOOLEAN
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
		note
			maps_to: "Seq#Take"
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

end

