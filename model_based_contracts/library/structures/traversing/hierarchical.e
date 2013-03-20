indexing

	description: "[
		Hierarchical structures in which each item has zero or
		one immediate predecessor, and zero or more successors.
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: hierarchical, traversing;
	access: cursor;
	contents: generic;
	model: bag, relation, object_comparison;
	model_links: item;
	date: "$Date$"
	revision: "$Revision$"

deferred class HIERARCHICAL [G] inherit

	TRAVERSABLE [G]

feature -- Access

	successor_count: INTEGER is
			-- Number of successors of current element
		require
			not_off: not off
		deferred
		ensure
		-- ensure: model
			definition: Result = relation.image_of (item).any_item.count
		end

feature -- Cursor movement

	up is
			-- Move to predecessor.
		require
			not_off: not off
		deferred
		ensure
		-- ensure: model
			item_effect: relation.image_of (item).any_item.is_member (old item)
		end

	down (i: INTEGER) is
			-- Move to `i'-th successor.
		require
			not_off: not off
 			argument_within_bounds: i >= 1 and i <= successor_count
		deferred
		ensure
		-- ensure: model
			item_effect: item = relation.image_of (old item).any_item.item (i)
		end

feature -- Model


	relation: MML_RELATION [G, MML_SEQUENCE [G]]
			-- Mathematical representation of hierarchy
			-- ToDo: should be deferred
		do
		end

invariant

	non_negative_successor_count: successor_count >= 0

-- invariant: model
	relation_is_function: relation.is_function
	relation_is_injective: relation.is_injective

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







end -- class HIERARCHICAL



