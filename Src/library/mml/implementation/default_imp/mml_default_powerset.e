indexing
	description: "The default implementation of MML_POWERSET"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_POWERSET[G]

inherit
	MML_POWERSET[G]
		undefine
			out
		redefine
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned
		end
	MML_DEFAULT_SET[MML_SET[G]]
		redefine
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned
		end

create
	make_empty,
	make_from_element,
	make_from_array

feature -- Basic Operations

	intersected (other: MML_SET [MML_SET [G]]): MML_POWERSET [G] is
			-- The intersection of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(other))
		end

	united (other: MML_SET [MML_SET [G] ]): MML_POWERSET [G] is
			-- The union of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(other))
		end

	subtracted (other: MML_SET [MML_SET [G]]): MML_POWERSET [G] is
			-- The difference of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(other))
		end

	difference (other: MML_SET [MML_SET[G]]): MML_POWERSET [G] is
			-- The symmetric difference of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(other))
		end

	extended (v: MML_SET[G]): MML_POWERSET[G] is
			-- The set `current' extended with `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(v))
		end

	pruned (v: MML_SET[G]): MML_POWERSET [G] is
			-- The set `current' with `v' removed.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_powerset(Precursor(v))
		end

feature -- Generalized Operations

	generalized_united: MML_SET [G] is
			-- The generalized union of `current'.
		local
			i: INTEGER
		do
			if a = Void then
				create {MML_DEFAULT_SET[G]}Result.make_empty
			else
				Result := a.item(1)
				from
					i := 2
				until
					i > count
				loop
					Result := Result.united (a.item(i))
				end
			end
		end

	generalized_intersected: MML_SET [G] is
			-- The generalized intersection of `current'.
		local
			i: INTEGER
		do
			if a = Void then
				create {MML_DEFAULT_SET[G]}Result.make_empty
			else
				Result := a.item(1)
				from
					i := 2
				until
					i > count
				loop
					Result := Result.intersected (a.item(i))
				end
			end
		end

feature -- Disjointness

	is_generalized_disjoint: BOOLEAN is
			-- Is `current' disjoint?
		do
			Result := generalized_intersected.is_empty
		end

feature -- Partition

	is_generalized_partition (other: MML_SET [G]): BOOLEAN is
			-- Is `current' a partition of `other'?
		do
			Result := (is_generalized_disjoint and equal_value (other, generalized_united))
		end

end
