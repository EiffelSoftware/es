indexing
	description: "Endorelations are relation with the same source and target type"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_ENDORELATION[G]

inherit
	MML_RELATION[G,G]
		redefine
			united,
			intersected,
			subtracted,
			difference,
			extended,
			pruned,
			inversed,
			domain_restricted,
			domain_restricted_by,
			range_anti_restricted,
			range_anti_restricted_by,
			domain_anti_restricted,
			domain_anti_restricted_by,
			range_restricted,
			range_restricted_by
		end

feature -- Basic Operations

	united (other: MML_SET[MML_PAIR[G, G]]) : MML_ENDORELATION[G] is
			-- The union of `current' and `other'.
		deferred
		end

	intersected (other: MML_SET[MML_PAIR[G, G]]) : MML_ENDORELATION[G] is
			-- The intersection of `current' and `other'.
		deferred
		end

	subtracted (other: MML_SET [MML_PAIR [G,G]]): MML_ENDORELATION [G] is
			-- The difference of `current' and `other'.
		deferred
		end

	difference (other: MML_SET [MML_PAIR[G,G]]): MML_ENDORELATION [G] is
			-- The symmetric difference of `current' and `other'.
		deferred
		end

	extended (v: MML_PAIR[G,G]): MML_ENDORELATION[G] is
			-- The releation `current' extended with the pair `v'.
		deferred
		end

	pruned (v: MML_PAIR[G,G]): MML_ENDORELATION [G] is
			-- The relation `current' with the pair `v' removed.
		deferred
		end

feature -- Inversion

	inversed: MML_ENDORELATION [G] is
			-- The inverse relation of `current'.
		deferred
		end

feature -- Projections

	domain_anti_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		deferred
		end

	domain_anti_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		deferred
		end

	domain_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		deferred
		end

	domain_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		deferred
		end

	range_anti_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		deferred
		end

	range_anti_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		deferred
		end

	range_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		deferred
		end

	range_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		deferred
		end

end
