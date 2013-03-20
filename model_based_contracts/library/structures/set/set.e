
indexing

	description:
		"Collection, where each element must be unique."
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: set;
	access: membership;
	contents: generic;
	model: set, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class SET [G] inherit

	COLLECTION [G]
		redefine
			changeable_comparison_criterion
		end

feature -- Measurement

	count: INTEGER is
			-- Number of items
		deferred
		ensure
		-- ensure: model
			definition: Result = set.count
		end

feature -- Element change

	extend, put (v: G) is
			-- Ensure that set includes `v'.
		deferred
		ensure then
			in_set_already: old has (v) implies (count = old count)
			added_to_set: not old has (v) implies (count = old count + 1)
		-- ensure then: model
			set_effect_reference_comparison: not object_comparison implies set |=| old set.extended (v)
			set_effect_object_comparison_not_has: object_comparison implies (not set.there_exists (agent equal_elements (v, ?)) implies set |=| old set.extended (v))
			set_effect_object_comparison_has: object_comparison implies (set.there_exists (agent equal_elements (v, ?)) implies set |=| old set)
		end

feature -- Removal

	prune (v: G) is
			-- Remove `v' if present.
		deferred
		ensure then
			removed_count_change: old has (v) implies (count = old count - 1)
			not_removed_no_count_change: not old has (v) implies (count = old count)
			item_deleted: not has (v)
		-- ensure then: model
			set_effect_reference_comparison: not object_comparison implies set |=| old set.pruned (v)
			set_effect_object_comparison_has: object_comparison implies (set.there_exists (agent equal_elements (v, ?)) implies set |=| old (set.pruned (set.item_where (agent equal_elements (v, ?)))))
			set_effect_object_comparison_not_has: object_comparison implies (not set.there_exists (agent equal_elements (v, ?)) implies set |=| old set)
		end

	changeable_comparison_criterion: BOOLEAN is
			-- May `object_comparison' be changed?
			-- (Answer: only if set empty; otherwise insertions might
			-- introduce duplicates, destroying the set property.)
		do
			Result := is_empty
		ensure then
			only_on_empty: Result = is_empty
		-- ensure then: model
			definition: Result = set.is_empty
		end

feature -- Model
	set: MML_SET [G] is
			-- Mathematical set that corresponds to container contents
		local
			linear: LINEAR [G]
		do
			create {MML_DEFAULT_SET [G]} Result
			linear := linear_representation.twin
			from
				linear.start
			until
				linear.off
			loop
				Result := Result.extended (linear.item)
				linear.forth
			end
		end

invariant
-- invariant: model
	set_bag_constraint: bag.domain |=| set
	bag_is_set: bag.range.for_all (agent (i: INTEGER): BOOLEAN do Result := i = 1 end)

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







end -- class SET



