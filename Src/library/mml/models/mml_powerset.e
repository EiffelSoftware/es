indexing
	description: "A set of sets of some basetype G"
	version: "$Id$"
	author: "Bernd Schoeller and Tobias Widmer"
	copyright: "see License.txt"

deferred class
	MML_POWERSET[G]

inherit
	MML_SET[MML_SET[G]]
		redefine
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned
		end

feature -- Basic Operations

	intersected (other: MML_SET [MML_SET [G]]): MML_POWERSET [G] is
			-- The intersection of `current' and `other'.
		deferred
		end

	united (other: MML_SET [MML_SET [G] ]): MML_POWERSET [G] is
			-- The union of `current' and `other'.
		deferred
		end

	subtracted (other: MML_SET [MML_SET [G]]): MML_POWERSET [G] is
			-- The difference of `current' and `other'.
		deferred
		end

	difference (other: MML_SET [MML_SET[G]]): MML_POWERSET [G] is
			-- The symmetric difference of `current' and `other'.
		deferred
		end

	extended (v: MML_SET[G]): MML_POWERSET[G] is
			-- The set `current' extended with `v'.
		deferred
		end

	pruned (v: MML_SET[G]): MML_POWERSET [G] is
			-- The set `current' with `v' removed.
		deferred
		end

feature -- Generalized Operations

	generalized_united : MML_SET[G] is
			-- The generalized union of `current'.
		deferred
		ensure
			-- definition_of_generalized_united : for_all (agent {MML_SET[G]}.for_all (agent Result.is_member (?)))
		end

	generalized_intersected : MML_SET[G] is
			-- The generalized intersection of `current'.
		deferred
		end

feature -- Disjointness

	is_generalized_disjoint : BOOLEAN is
			-- Is `current' disjoint?
		deferred
		ensure
			definition_of_disjoint : Result = generalized_intersected.is_empty
		end

feature -- Partition

	is_generalized_partition (other : MML_SET[G]) : BOOLEAN is
			-- Is `current' a partition of `other'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_partition : Result = (is_generalized_disjoint and equal_value(other,generalized_united))
		end

invariant
	disjointness_implies_empty_intersection : is_generalized_disjoint implies generalized_intersected.is_empty
	disjointness_implies_partition : is_generalized_disjoint implies is_generalized_partition (generalized_united)
	definition_of_generalized_union : generalized_united.is_superset_of (generalized_intersected)
end -- class MML_POWERSET
