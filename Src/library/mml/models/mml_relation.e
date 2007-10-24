indexing
	description: "Mathematical objects that relate elements of a domain set to elements of a range set"
	version: "$Id$"
	author: "Bernd Schoeller and Tobias Widmer"
	copyright: "see License.txt"

deferred class
	MML_RELATION[G, H]

inherit
	MML_SET[MML_PAIR[G, H]]
		redefine
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned
		end
	MML_CONVERSION_2[G,H]

feature -- Status Report

	is_function: BOOLEAN is
			-- Is `current' a function ?
		deferred
		end

	is_injective: BOOLEAN is
			-- Is `current' injective ?
		deferred
		end

	contains_pair(v1:G; v2:H): BOOLEAN is
			-- Is the pair (`v1',`v2') contained in the relation ?
		deferred
		ensure
			v1_has_to_be_in_domain: Result implies domain.contains(v1)
			v2_has_to_be_in_range: Result implies range.contains(v2)
		end

feature -- Basic Operations

	united (other: MML_SET[MML_PAIR[G, H]]) : MML_RELATION[G, H] is
			-- The union of `current' and `other'.
		deferred
		end

	intersected (other: MML_SET[MML_PAIR[G, H]]) : MML_RELATION[G, H] is
			-- The intersection of `current' and `other'.
		deferred
		ensure then
			retains_functions: is_function and as_relation(other).is_function implies Result.is_function
			retains_injectivity: is_injective and as_relation(other).is_injective implies Result.is_injective
		end

	subtracted (other: MML_SET [MML_PAIR [G,H]]): MML_RELATION [G,H] is
			-- The difference of `current' and `other'.
		deferred
		ensure then
			retains_functions: is_function and as_relation(other).is_function implies Result.is_function
			retains_injectivity: is_injective and as_relation(other).is_injective implies Result.is_injective
		end

	difference (other: MML_SET [MML_PAIR[G,H]]): MML_RELATION [G,H] is
			-- The symmetric difference of `current' and `other'.
		deferred
		end

	extended (v: MML_PAIR[G,H]): MML_RELATION[G,H] is
			-- The releation `current' extended with the pair `v'.
		deferred
		ensure then
			retains_function: is_function and not domain.contains (v.first) implies Result.is_function
			retains_injectivity: is_injective and not range.contains (v.second) implies Result.is_injective
		end

	extended_by_pair (g:G;h:H): MML_RELATION[G,H] is
			-- The relation `current' extended with the pair `g,h'
		deferred
		end

	pruned (v: MML_PAIR[G,H]): MML_RELATION [G,H] is
			-- The relation `current' with the pair `v' removed.
		deferred
		ensure then
			retains_functions: is_function implies Result.is_function
			retains_injectivity: is_injective implies Result.is_injective
		end

feature -- Field

	domain : MML_SET[G] is
			-- The domain of `current'.
		deferred
		end

	range : MML_SET[H] is
			-- The range of `current'.
		deferred
		end

feature -- Projections

	image_of (v: G) : MML_SET[H] is
			-- The projected range set of `current' through `v'.
		deferred
		ensure then
			image_in_range: range.is_superset_of (Result)
		end

	image (projection : MML_SET[G]) : MML_SET[H] is
			-- The projected range set of `current' through `projection'.
		require
			projection_not_void : projection /= Void
		deferred
		ensure
			image_in_range: range.is_superset_of (Result)
		end

	anti_image_of (v: H) : MML_SET[G] is
			-- The projected domain set of `current' through `v'.
		deferred
		ensure
			anti_image_in_domain: domain.is_superset_of (Result)
		end

	anti_image (projection : MML_SET[H]) : MML_SET[G] is
			-- The projected domain set of `current' through `projection'.
		require
			projection_not_void : projection /= Void
		deferred
		ensure then
			anti_image_in_domain: domain.is_superset_of (Result)
		end

	domain_restricted_by (v: G): MML_RELATION[G,H] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	domain_restricted (restriction: MML_SET[G]): MML_RELATION [G,H] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		require
			restriction_not_void : restriction /= Void
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	range_restricted_by (v: H) : MML_RELATION [G,H] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	range_restricted (restriction : MML_SET[H]) : MML_RELATION [G,H] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		require
			restriction_not_void : restriction /= Void
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	domain_anti_restricted_by (v: G): MML_RELATION [G,H]  is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		deferred
		end

	domain_anti_restricted (restriction : MML_SET[G]) : MML_RELATION [G,H] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		require
			restriction_not_void : restriction /= Void
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	range_anti_restricted_by (v: H) :MML_RELATION [G,H] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	range_anti_restricted (restriction : MML_SET[H]) :MML_RELATION [G,H]  is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		require
			restriction_not_void : restriction /= Void
		deferred
		ensure then
			restriction_is_subset: is_superset_of (Result)
		end

	item (v: G): H is
			-- Lookup the value of `v' in the relation, if it is a function.
		require
			needs_function: is_function
			v_in_domain: domain.contains(v)
		deferred
		ensure
			correct_lookup: contains_pair(v,Result)
		end

feature -- Inversion

	inversed : MML_RELATION[H, G] is
			-- The inverse relation of `current'.
		deferred
		ensure
			definition_of_inversed : equal_value(Result.domain,range) and equal_value(Result.range,domain)
			same_cardinality : Result.count = count
		end

invariant
	definition_of_relation_inversion : equal_value(inversed.inversed,Current)
	relation_injective_and_function: is_injective = inversed.is_function and is_function = inversed.is_injective
	definition_of_domain_range : inversed.domain.equals (range) and inversed.range.equals (domain)
	definition_is_function: is_function implies domain.count = count
	definition_is_injective: is_injective implies range.count = count
end -- class MML_RELATION
