indexing

	description: "[
		Finite sequences: structures where existing items are arranged
		and accessed sequentially, and new ones can be added at the end.
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: sequence;
	access: cursor, membership;
	contents: generic;
	model: sequence, index, extendible, prunable, full, object_comparison; -- ToDo: isn't extendible = not full?
	date: "$Date$"
	revision: "$Revision$"

deferred class SEQUENCE [G] inherit

	ACTIVE [G]
		redefine
			extend,
			replace,
			remove,
			prune_all
		end

	BILINEAR [G]

	FINITE [G]

feature -- Status report

	readable: BOOLEAN is
			-- Is there a current item that may be read?
		do
			Result := not off
		ensure then
		-- ensure then: model
			definition: Result = sequence.is_defined (index)
		end


	writable: BOOLEAN is
			-- Is there a current item that may be modified?
		do
			Result := not off
		ensure then
		-- ensure then: model
			definition: Result = sequence.is_defined (index)
		end

feature -- Element change

	force (v: like item) is
			-- Add `v' to end.
		require
			extendible: extendible
		do
			extend (v)
		ensure then
	 		new_count: count = old count + 1
			item_inserted: has (v)
		-- ensure: model
			sequence_effect: sequence |=| old sequence.extended (v)
		end

	append (s: SEQUENCE [G]) is
			-- Append a copy of `s'.
		require
			argument_not_void: s /= Void
		local
			l: like s
		do
			l := s
			if s = Current then
				l := twin
			end
			from
				l.start
			until
				l.exhausted
			loop
				extend (l.item)
				l.forth
			end
		ensure
	 		new_count: count >= old count
	 	-- ensure: model
	 		sequence_effect: sequence |=| old sequence.concatenated (s.sequence)
		end

	put (v: like item) is
			-- Add `v' to end.
		do
			extend (v)
		ensure then
	 		new_count: count = old count + 1
		-- ensure then: model
			sequence_effect: sequence |=| old sequence.extended (v)
		end

	extend (v: G) is
			-- Add a new occurrence of `v'.
		deferred
		ensure then
		-- ensure: model
			sequence_effect: sequence |=| old sequence.extended (v)
		end

	replace (v: G) is
			-- Replace current item by `v'.
		deferred
		ensure then
		-- ensure: model
			sequence_effect: sequence |=| old (sequence.replaced_at (v, index))
		end

feature -- Removal

	prune (v: like item) is
			-- Remove the first occurrence of `v' if any.
			-- If no such occurrence go `off'.
		do
			start
			search (v)
			if not exhausted then
				remove
			end
		ensure then
		-- ensure then: model
			sequence_effect_reference_comparison_not_has: not object_comparison implies (not old sequence.is_member (v) implies sequence |=| old sequence)
			index_effect_reference_comparison_not_has: not object_comparison implies (not old sequence.is_member (v) implies not sequence.is_defined (index))
			sequence_effect_object_comparison_not_has: object_comparison implies (not old sequence.there_exists (agent equal_elements (v, ?)) implies sequence |=| old sequence)
			index_effect_object_comparison_not_has: object_comparison implies (not old sequence.there_exists (agent equal_elements (v, ?)) implies not sequence.is_defined (index))
		end

	prune_all (v: like item) is
			-- Remove all occurrences of `v'; go `off'.
		do
			from
				start
			until
				exhausted
			loop
				search (v)
				if not exhausted then
					remove
				end
			end
		ensure then
		-- ensure then: model
			sequence_effect_reference_comparison: not object_comparison implies sequence |=| old sequence.pruned (v)
			sequence_effect_object_comparison: object_comparison implies sequence |=| old (sequence.subtracted (sequence.range.subset_where (agent equal_elements (v, ?))))
			index_effect: not sequence.is_defined (index)
		end

	remove is
			-- Remove current item.
		deferred
		ensure then
		-- ensure then: model
			sequence_effect: sequence |=| old (sequence.pruned_at (index))
		end

invariant
-- invariant: model
	sequnece_bag_constraint: bag |=| sequence.to_bag

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2008, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class SEQUENCE



