indexing

	description:
		"Structures whose items are sorted according to a total order relation"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: sorted_struct, comparable_struct;
	access: index, membership, min, max;
	contents: generic;
	model: sequence, index, less_equal, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class SORTED_STRUCT [G -> COMPARABLE] inherit

	COMPARABLE_STRUCT [G]
		undefine
			search, off, sequence, bag
		redefine
			min, max
		end

	INDEXABLE [G]
		rename
			item as i_th,
			put as put_i_th,
			bag_put as putt,
			relation as sequence
		redefine
			sequence,
			putt
		end

	LINEAR [G]
		undefine
			sequence, bag
		end

feature -- Measurement

	min: like item is
			-- Minimum item
		require else
			is_sorted: sorted
		do
			start
			Result := item
		ensure then
		--	smallest:
		--		 For every `i' in `first_position' .. `last_position':
		--				`Result <= i_th (i)';
		--		 `Result' = `i_th' (`first_position')
		-- ensure then: model
			definition: Result = sequence.first
		end

	max: like item is
			-- Maximum item
		require else
			is_sorted: sorted
		do
			finish
			Result := item
		ensure then
		--	largest:
		--		 For every `i' in `first_position' .. `last_position':
		--				`i_th (`i') <= `Result';
		--		 `Result' = `i_th' (`last_position')
		-- ensure then: model
			definition: Result = sequence.last
		end

	median: like item is
			-- Median element
		deferred
		ensure
			median_present: has (Result)
		--	median_definition:
		--		Result = i_th (first_position +
		--			(last_position - first_position) // 2)
		-- ensure: model
			definition: Result = sequence.item ((sequence.count - 1) // 2)
		end

feature -- Status report

	sorted: BOOLEAN is
			-- Is structure sorted?
		local
			m: like item
		do
			if is_empty then
				Result := True
			else
				from
					start
					m := item
					forth
				until
					exhausted or else (item < m)
				loop
					m := item
					forth
				end
				Result := exhausted
			end
		ensure
		-- ensure: model
			definition: Result = sequence.set_for_all_pairs (agent (x, y: MML_PAIR [INTEGER, G]): BOOLEAN do Result := x.first <= y.first implies less_equal.contains_pair (x.second, y.second) end)
		end

feature -- Transformation

	sort is
			-- Sort structure.
		deferred
		ensure
			is_sorted: sorted
		-- ensure: model
			sequence_effect: sequence.set_for_all_pairs (agent (x, y: MML_PAIR [INTEGER, G]): BOOLEAN do Result := x.first <= y.first implies less_equal.contains_pair (x.second, y.second) end)
		end

feature {NONE} -- Inapplicable

	putt (v: like item) is
		do
		end

feature -- Model
	sequence: MML_SEQUENCE [G] is
			-- Mathematical relation, representing content of the container
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SEQUENCE [G]} Result
			from
				i := index_set.lower
			until
				i > index_set.upper
			loop
				Result := Result.extended (i_th (i))
				i := i + 1
			end
		end

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







end -- class SORTED_STRUCT



