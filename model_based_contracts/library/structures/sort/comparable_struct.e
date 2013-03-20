indexing

	description: "[
		Data structures whose items may be compared
		according to a total order relation
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: comparable_struct;
	access: min, max;
	contents: generic;
	model: sequence, index, less_equal, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class COMPARABLE_STRUCT [G -> COMPARABLE] inherit

	BILINEAR [G]

feature -- Measurement

	min: like item is
			-- Minimum item
		require
			min_max_available

		do
			from
				start
				Result := item
				forth
			until
				off
			loop
				if item < Result then
					Result := item
				end
				forth
			end
		ensure
		--	smallest: For every item `it' in structure, `Result' <= `it'
		-- ensure: model
			in_sequence: sequence.is_member (Result)
			is_minimal: sequence.for_all (agent less_equal.contains_pair (Result, ?))
		end

	max: like item is
			-- Maximum item
		require
			min_max_available

		do
			from
				start
				Result := item
				forth
			until
				off
			loop
				if item > Result then
					Result := item
				end
				forth
			end
		ensure
		--	largest: For every item `it' in structure, `it' <= `Result'
		-- ensure: model
			in_sequence: sequence.is_member (Result)
			is_minimal: sequence.for_all (agent less_equal.contains_pair (?, Result))
		end

	min_max_available: BOOLEAN is
			-- Can min and max be computed?
		do
			Result := not is_empty
		ensure
			Result implies not is_empty
		-- ensure:
			definition: Result = not sequence.is_empty
		end

feature {NONE} -- Inapplicable

	index: INTEGER is
		do
		end

feature -- Model
	less_equal: MML_RELATION [G, G]
			-- <= relation on elements
		local
			linear1, linear2: LINEAR [G]
		do
			create {MML_DEFAULT_RELATION [G, G]} Result
			linear1 := linear_representation.twin
			linear2 := linear_representation.twin
			from
				linear1.start
			until
				linear1.after
			loop
				from
					linear2.start
				until
					linear2.after
				loop
					if linear1.item <= linear2.item then
						Result := Result.extended_by_pair (linear1.item, linear2.item)
					end
					linear2.forth
				end
				linear1.forth
			end
		end

invariant

	empty_constraint: min_max_available implies not is_empty

-- invariant: model
	total_order: sequence.for_all_pairs (agent (x, y: G): BOOLEAN do Result := less_equal.contains_pair (x, y) or less_equal.contains_pair (y, x) end)

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class COMPARABLE_STRUCT



