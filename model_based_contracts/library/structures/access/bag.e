indexing

	description: "[
		Collections of items, where each item may occur zero
		or more times, and the number of occurrences is meaningful.
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: bag, access;
	access: membership;
	contents: generic;
	model: bag, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class BAG [G] inherit

	COLLECTION [G]
		redefine
			extend,
			prune
		end

feature -- Measurement

	occurrences (v: G): INTEGER is
			-- Number of times `v' appears in structure
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		deferred
		ensure
			non_negative_occurrences: Result >= 0
		-- ensure: model
			definition_reference_comparison: not object_comparison implies Result = bag.occurrences (v)
			definition_object_comparison: object_comparison implies Result = bag.hold_count (agent equal_elements (v, ?))
		end

feature -- Element change

	extend (v: G) is
			-- Add a new occurrence of `v'.
		deferred
		ensure then
			one_more_occurrence: occurrences (v) = old (occurrences (v)) + 1
		-- ensure: model
			bag_effect: bag |=| old bag.extended (v)
		end

feature -- Removal

	prune (v: G) is
			-- Remove one occurrence of `v' if any.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		deferred
		ensure then
		-- ensure then: model -- ToDo: Commented contracts are not true in DYNAMIC_CHAIN
--			bag_effect_reference_comparison: not object_comparison implies bag |=| old bag.pruned (v)
--			bag_effect_object_comparison_has: object_comparison implies (bag.there_exists (agent equal_elements (v, ?)) implies bag |=| old (bag.pruned (bag.item_where (agent equal_elements (v, ?)))))
			bag_effect_object_comparison_not_has: old object_comparison implies (not old bag.there_exists (agent equal_elements (v, ?)) implies bag |=| old bag)
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







end -- class BAG



