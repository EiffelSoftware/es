note
	description: "Finite sets."
	author: "Nadia Polikarpova"
	theory: "set.bpl"
	maps_to: "Set"
	type_properties: "Set#ItemsType"

class MML_SET [G]

inherit

	ITERABLE [G]
		redefine
			default_create,
			is_equal
		end

create
	default_create,
	singleton	

feature {NONE} -- Initialization

	default_create
			-- Create an empty set.
		note
			maps_to: "Set#Empty"
		do
		end

	singleton (x: G)
			-- Create a set that contains only `x'.
		do
		end
		
feature -- Properties

	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		note
			maps_to: "[]"
		do
		end

	is_empty: BOOLEAN
			-- Is the set empty?
		do
		end
		

feature -- Elements

	any_item: G
			-- Arbitrary element.
		require
			not_empty: not is_empty
		do
		end		

	min: G
			-- Least element.
		require
			not_empty: not is_empty
		do
		end
		
	max: G
			-- Greatest element.
		require
			not_empty: not is_empty
		do
		end		
				
feature -- Measurement

	count alias "#": INTEGER
			-- Cardinality.
		note
			maps_to: "Set#Card"
		do
		end		

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same set as `Current'?
		note
			maps_to: "Set#Equal"
		do
		end

	is_subset_of alias "<=" (a_other: MML_SET [ANY]): BOOLEAN
			-- Does `a_other' have all elements of `Current'?
		note
			maps_to: "Set#Subset"		
		do
		end

	is_superset_of alias ">=" (a_other: MML_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `a_other'?
		note
			maps_to: "Set#Superset"		
		do
		end

	is_disjoint (a_other: MML_SET [G]): BOOLEAN
			-- Do no elements of `a_other' occur in `Current'?
		note
			maps_to: "Set#Disjoint"		
		do
		end

feature -- Modification

	extended alias "&" (x: G): MML_SET [G]
			-- Current set extended with `x' if absent.
		do
		end

	removed alias "/" (x: G): MML_SET [G]
			-- Current set with `x' removed if present.
		do
		end

	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		do
		ensure
		end

	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		do
		end

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		do
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
		end
		
feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: ""
		do
		end
		
feature -- Convenience

	empty_set: MML_SET [G]
		note
			maps_to: "Set#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

end
