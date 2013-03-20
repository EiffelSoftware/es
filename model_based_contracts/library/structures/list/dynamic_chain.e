indexing

	description:
		"Dynamically modifiable chains"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: dynamic_chain, sequence;
	access: index, cursor, membership;
	contents: generic;
	model: sequence, index, prunable, full, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class DYNAMIC_CHAIN [G] inherit

	CHAIN [G]
		export
			{ANY} remove, prune_all, prune
		undefine
			remove, prune_all, prune
		end

	UNBOUNDED [G]
		undefine
			bag
		end

feature -- Status report

	extendible: BOOLEAN is True
			-- May new items be added? (Answer: yes.)

	prunable: BOOLEAN is
			-- May items be removed? (Answer: yes.)
		do
			Result := True
		end

feature -- Element change

	put_front (v: like item) is
			-- Add `v' at beginning.
			-- Do not move cursor.
		deferred
		ensure
	 		new_count: count = old count + 1
			item_inserted: first = v
		-- ensure: model
			sequence_effect: sequence |=| old sequence.prepended (v)
			index_effect: index = old index + 1 --?
		end

	put_left (v: like item) is
			-- Add `v' to the left of cursor position.
			-- Do not move cursor.
		require
			extendible: extendible
			not_before: not before
		deferred
		ensure
	 		new_count: count = old count + 1
	 		new_index: index = old index + 1
	 	-- ensure
	 		sequence_effect: sequence |=| old (sequence.extended_at (v, index))
	 		index_effect: index = old index + 1
		end

	put_right (v: like item) is
			-- Add `v' to the right of cursor position.
			-- Do not move cursor.
		require
			extendible: extendible
			not_after: not after
		deferred
		ensure
	 		new_count: count = old count + 1
	 		same_index: index = old index
	 	-- ensure
	 		sequence_effect: sequence |=| old (sequence.extended_at (v, index + 1))
		end

	merge_left (other: like Current) is
			-- Merge `other' into current structure before cursor
			-- position. Do not move cursor. Empty `other'.
		require
			extendible: extendible
			not_before: not before
			other_exists: other /= Void
			not_current: other /= Current
		deferred
		ensure
	 		new_count: count = old count + old other.count
	 		new_index: index = old index + old other.count
			other_is_empty: other.is_empty
		--ensure: model
			sequence_effect: sequence |=| old (sequence.interval (1, index - 1).concatenated (other.sequence).concatenated (sequence.interval (index, sequence.count)))
			index_effect: index = old index + old other.sequence.count
			other_sequence_effect: other.sequence.is_empty
		end

	merge_right (other: like Current) is
			-- Merge `other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
		require
			extendible: extendible
			not_after: not after
			other_exists: other /= Void
			not_current: other /= Current
		deferred
		ensure
	 		new_count: count = old count + old other.count
	 		same_index: index = old index
			other_is_empty: other.is_empty
		--ensure: model
			sequence_effect: sequence |=| old (sequence.interval (1, index).concatenated (other.sequence).concatenated (sequence.interval (index + 1, sequence.count)))
			other_sequence_effect: other.sequence.is_empty
		end

feature -- Removal

	prune (v: like item) is
			-- Remove first occurrence of `v', if any,
			-- after cursor position.
			-- If found, move cursor to right neighbor;
			-- if not, make structure `exhausted'.
		do
			search (v)
			if not exhausted then
				remove
			end
		ensure then
		-- ensure then: model
			sequence_effect_reference_comparison_has: not object_comparison implies (old sequence.is_member (v) implies
				sequence |=| old (sequence.pruned_at (sequence.interval (index, sequence.count).index_of_i_th_occurrence_of (v, 1))))
			index_effect_reference_comparison_has: not object_comparison implies (old sequence.is_member (v) implies
				index = old (sequence.interval (index, sequence.count).index_of_i_th_occurrence_of (v, 1)))
			sequence_effect_object_comparison_has: object_comparison implies (old sequence.there_exists (agent equal_elements (v, ?)) implies
				sequence |=| old (sequence.pruned_at (sequence.interval (index, sequence.count).index_of_i_th_that (agent equal_elements (v, ?), 1))))
			index_effect_object_comparison_has: object_comparison implies (old sequence.there_exists (agent equal_elements (v, ?)) implies
				index = old (sequence.interval (index, sequence.count).index_of_i_th_that (agent equal_elements (v, ?), 1)))
		end

	remove_left is
			-- Remove item to the left of cursor position.
			-- Do not move cursor.
		require
			left_exists: index > 1
		deferred
		ensure
	 		new_count: count = old count - 1
	 		new_index: index = old index - 1
	 	-- ensure
	 		sequence_effect: sequence |=| old (sequence.pruned_at (index - 1))
	 		index_effect: index = old index - 1
		end

	remove_right is
			-- Remove item to the right of cursor position.
			-- Do not move cursor.
		require
			right_exists: index < count
		deferred
		ensure
	 		new_count: count = old count - 1
	 		same_index: index = old index
	 	-- ensure
	 		sequence_effect: sequence |=| old (sequence.pruned_at (index + 1))
		end

	prune_all (v: like item) is
			-- Remove all occurrences of `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- Leave structure `exhausted'.
		do
			from
				start
				search (v)
			until
				exhausted
			loop
				remove
				search (v)
			end
		ensure then
			is_exhausted: exhausted
		end

	wipe_out is
			-- Remove all items.
		do
			from
				start
			until
				is_empty
			loop
				remove
			end
		ensure then
		-- ensure then: model
			sequence_effect: sequence.is_empty
			index_effect: index = 0 or index = 1
		end

feature -- Duplication

	duplicate (n: INTEGER): like Current is
			-- Copy of sub-chain beginning at current position
			-- and having min (`n', `from_here') items,
			-- where `from_here' is the number of items
			-- at or to the right of current position.
		local
			pos: CURSOR
			counter: INTEGER
		do
			from
				Result := new_chain
				if object_comparison then
					Result.compare_objects
				end
				pos := cursor
			until
				(counter = n) or else exhausted
			loop
				Result.extend (item)
				forth
				counter := counter + 1
			end
			go_to (pos)
		end

feature {DYNAMIC_CHAIN} -- Implementation

	new_chain: like Current is
			-- A newly created instance of the same type.
			-- This feature may be redefined in descendants so as to
			-- produce an adequately allocated and initialized object.
		deferred
		ensure
			result_exists: Result /= Void
		end

invariant

	extendible: extendible

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







end -- class DYNAMIC_CHAIN



