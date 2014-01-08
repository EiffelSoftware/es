class MML_SET [G]

inherit

	ANY
		redefine
			default_create
		end

	ITERABLE [G]
		redefine
			default_create
		end

create
	default_create,
	make_from_tuple,
	make_from_array

feature {NONE} -- Initialization

	default_create
		do
		end

	make_from_tuple (a_tuple: TUPLE)
		do
		end

	make_from_array (a_array: ARRAY [G])
		do
		end
		
feature -- Access

	any_item: G
			-- Arbitrary element.
		require
			not_empty: not is_empty
		do
		end		

feature -- Status report

	has alias "[]" (x: ANY): BOOLEAN
			-- Is `x' contained?
		do
		end

	is_empty: BOOLEAN
			-- Is the set empty?
		do
		end

feature -- Comparison

	is_subset_of alias "<=" (a_other: MML_SET [ANY]): BOOLEAN
			-- Does `a_other' have all elements of `Current'?
		do
		end

	is_superset_of alias ">=" (a_other: MML_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `a_other'?
		do
		end

	is_disjoint (a_other: MML_SET [G]): BOOLEAN
			-- Do no elements of `a_other' occur in `Current'?
		do
		end

feature -- Basic operations

	extended alias "&" (x: G): MML_SET [G]
			-- Current set extended with `x' if absent.
		do
		end

	removed alias "/" (x: G): MML_SET [G]
			-- Current set with `x' removed if present.
		do
		end

	union alias "+" (a_other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `a_other'.
		do
		end

	intersection alias "*" (a_other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `a_other'.
		do
		end

	difference alias "-" (a_other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `a_other'.
		do
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		do
		end

feature -- Convenience

	empty_set: MML_SET [G]
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
