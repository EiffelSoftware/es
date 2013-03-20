indexing

	description:
		"Containers whose items are accessible through keys"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: table, access;
	access: key, membership;
	contents: generic;
	model: relation, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class TABLE [G, H] inherit

	BAG [G]
		rename
			put as bag_put
		end

feature -- Access

	item alias "[]", infix "@" (k: H): G assign force is
			-- Entry of key `k'.
		require
			valid_key: valid_key (k)
		deferred
		ensure
		-- ensure: model
			related_to_k: relation.image_of (k).contains (Result) -- ToDo: what about object_comparison for keys?
		end

feature -- Status report

	valid_key (k: H): BOOLEAN is
			-- Is `k' a valid key?
		deferred
		ensure
		-- ensure: model
			definition: Result = relation.domain.contains (k)
		end

feature -- Element change

	put (v: G; k: H) is
			-- Associate value `v' with key `k'.
			-- ToDo: in some classes acts like force and in others put only if not relation.domain.contains (k)
		require
			valid_key: valid_key (k)
		deferred
		end

	force (v: G; k: H) is
			-- Associate value `v' with key `k'.
		require
			valid_key: valid_key (k)
		deferred
		ensure
			inserted: item (k) = v
		-- ensure: model
			relation_effect: relation |=| old relation.domain_anti_restricted_by (k).extended_by_pair (k, v)
		end

feature {NONE} -- Inapplicable

	bag_put (v: G) is
		do
		end

feature -- Model
	relation: MML_RELATION [H, G] is
			-- Matematical relation representing contents of the table
		deferred
		end

invariant
-- invariant: model
	relation_is_function: relation.is_function
	relation_bag_constraint_domain: bag.domain |=| relation.range
	relation_bag_constraint_range: bag.set_for_all (agent (p: MML_PAIR [G, INTEGER]): BOOLEAN do Result := p.second = relation.anti_image_of (p.first).count end)
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

end -- class TABLE



