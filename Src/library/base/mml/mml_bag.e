note
	description: "Finite bags."
	author: "Nadia Polikarpova"
	theory: "bag.bpl", "set.bpl"
	maps_to: "Bag"
	where: "Bag#IsValid"
	type_properties: "Bag#DomainType"

class
	MML_BAG [G]

inherit
	ITERABLE [G]
		redefine
			default_create,
			is_equal
		end

create
	default_create,
	singleton,
	multiple

feature {NONE} -- Initialization

	default_create
			-- Create an empty bag.
		note
			maps_to: "Bag#Empty"
		do
		end

	singleton (x: G)
			-- Create a bag that contains a single occurrence of `x'.
		do
		end

	multiple (x: G; n: INTEGER)
			-- Create a bag that contains `n' occurrences of `x'.
		require
			n_positive: n >= 0
		do
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
		end

	is_empty: BOOLEAN
			-- Is bag empty?
		do
		end

	is_constant (c: INTEGER): BOOLEAN
			-- Are all values equal to `c'?
		do
		end

	is_valid: BOOLEAN
			-- Id `Current' a valid bag (are all occurrences non-negative)?
		do
		end

feature -- Sets

	domain: MML_SET [G]
			-- Set of values that occur at least once.
		do
		end

feature -- Measurement

	occurrences alias "[]" (x: G): INTEGER
			-- How many times `v' appears.
		note
			maps_to: "[]"
		do
		end

	count alias "#": INTEGER
			-- Total number of elements.
		note
			maps_to: "Bag#Card"
		do
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same bag as `Current'?
		note
			maps_to: "Bag#Equal"
		do
		end

	is_subbag alias "<=" (a_other: MML_BAG [G]): BOOLEAN
			-- Does `other' contain all the elements of `Current'?
		note
			maps_to: "Bag#Subset"
		do
		end

	is_disjoint (a_other: MML_BAG [G]): BOOLEAN
			-- Do `a_other' and `Current' have no elements in common?
		note
			maps_to: "Bag#Disjoint"
		do
		end

feature -- Modification

	extended alias "&" (x: G): MML_BAG [G]
			-- Current bag extended with one occurrence of `x'.
		do
		end

	extended_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag extended with `n' occurrences of `x'.
		require
			n_non_negative: n >= 0
		do
		end

	removed alias "/" (x: G): MML_BAG [G]
			-- Current bag with one occurrence of `x' removed if present.
		do
		end

	removed_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag with at most `n' occurrences of `x' removed if present.
		require
			n_non_negative: n >= 0
		do
		end

	removed_all (x: G): MML_BAG [G]
			-- Current bag with all occurrences of `x' removed.
		do
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_BAG [G]
			-- Bag that consists of all elements of `Current' that are in `subdomain'.
		do
		end

	union alias "+" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains all elements from `other' and `Current'.
		do
		end

	intersection alias "*" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains only elements present in both `other' and `Current'.
		do
		end

	difference alias "-" (other: MML_BAG [G]): MML_BAG[G]
			-- Current bag with all occurrences of values from `other' removed.
		do
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: "Bag#Domain"
		do
		end

feature -- Convenience

	empty_bag: MML_BAG [G]
			-- Empty bag.
			-- Can be used as `{MML_BAG [G]}.empty_bag'.
		note
			maps_to: "Bag#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

feature -- Lemmas

	lemma_remove_multiple (v: G; n: INTEGER)
			-- Removing `n' occurrences of `v' from `Current' and then one,
			-- is the same as removing `n' + 1 occurrences.
		note
			status: lemma
		require
			n >= 0
		do
			check across domain as x all removed_multiple (v, n).removed (v) [x.item] = removed_multiple (v, n + 1) [x.item] end end
		ensure
			removed_multiple (v, n).removed (v) = removed_multiple (v, n + 1)
		end

	lemma_remove_all (v: G)
			-- Removing `Current [v]' occurrences of `v' from `b' is the same as removing all occurrences.
		note
			status: lemma
		do
			check across domain as x all removed_multiple (v, Current [v]) [x.item] = removed_all (v) [x.item] end end
		ensure
			removed_multiple (v, Current [v]) = removed_all (v)
		end

end
