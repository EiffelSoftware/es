indexing
	description: "Default Implementation of MML_ENDORELATION"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_ENDORELATION[G]

inherit
	MML_ENDORELATION[G]
		undefine
			out
		end
	MML_DEFAULT_RELATION[G,G]
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

create
	make_empty,
	make_from_element,
	make_from_array

feature -- Basic Operations

	united (other: MML_SET[MML_PAIR[G, G]]) : MML_ENDORELATION[G] is
			-- The union of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(other))
		end

	intersected (other: MML_SET[MML_PAIR[G, G]]) : MML_ENDORELATION[G] is
			-- The intersection of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(other))
		end

	subtracted (other: MML_SET [MML_PAIR [G,G]]): MML_ENDORELATION [G] is
			-- The difference of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(other))
		end

	difference (other: MML_SET [MML_PAIR[G,G]]): MML_ENDORELATION [G] is
			-- The symmetric difference of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(other))
		end

	extended (v: MML_PAIR[G,G]): MML_ENDORELATION[G] is
			-- The releation `current' extended with the pair `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

	pruned (v: MML_PAIR[G,G]): MML_ENDORELATION [G] is
			-- The relation `current' with the pair `v' removed.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

feature -- Inversion

	inversed: MML_ENDORELATION [G] is
			-- The inverse relation of `current'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor)
		end

feature -- Projections

	domain_anti_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(restriction))
		end

	domain_anti_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

	domain_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

	domain_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(restriction))
		end

	range_anti_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(restriction))
		end

	range_anti_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

	range_restricted_by (v: G): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(v))
		end

	range_restricted (restriction: MML_SET [G]): MML_ENDORELATION [G] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_endorelation(Precursor(restriction))
		end

end
