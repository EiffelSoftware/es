indexing
	description: "Dynamic Frames"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	FRAME

inherit
	MML_DEFAULT_SET[ANY]
		redefine
			is_disjoint_from,
			is_superset_of,
			is_subset_of,
			is_proper_subset_of,
			is_proper_superset_of,
			is_empty,
			cartesian_product,
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned,
			is_partitioned_by
		end

create
	make_from_element,
	make_empty,
	make_from_array

feature -- Properties

	is_disjoint_from (other: FRAME) : BOOLEAN is
			-- Is `other' disjoint from `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	is_superset_of (other: FRAME) : BOOLEAN is
			-- Is `other' a subset of `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	is_subset_of (other: FRAME) : BOOLEAN is
			-- Is `other' a superset of `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	is_proper_subset_of (other: FRAME) : BOOLEAN is
			-- Is `other' a proper superset of `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	is_proper_superset_of (other: FRAME) : BOOLEAN is
			-- Is `other' a proper subset of `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	is_empty : BOOLEAN is
			-- Is `current' empty?
		do
			do_nothing
			Result := Precursor
		end

feature -- Basic Operations

	cartesian_product (other : FRAME) : MML_SET[MML_PAIR[ANY, ANY]] is
			-- The cartesian product of `other' and `current'.
			-- TypeCheat
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

	intersected (other: FRAME): FRAME is
			-- The intersection of `current' and `other'.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(other)
			create Result.make_from_array (a_set.as_array)
		end

	united (other: FRAME) : FRAME is
			-- The union of `current' and `other'.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(other)
			create Result.make_from_array (a_set.as_array)
		end

	subtracted (other: FRAME): FRAME is
			-- The difference of `current' and `other'.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(other)
			create Result.make_from_array (a_set.as_array)
		end

	difference (other: FRAME): FRAME is
			-- The symmetric difference of `current' and `other'.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(other)
			create Result.make_from_array (a_set.as_array)
		end

	extended (v: ANY): FRAME is
			-- The set `current' extended with `v'.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(v)
			create Result.make_from_array (a_set.as_array)
		end

	pruned (v: ANY): FRAME is
			-- The set `current' with `v' removed.
		local
			a_set: MML_SET[ANY]
		do
			a_set := Precursor {MML_DEFAULT_SET}(v)
			create Result.make_from_array (a_set.as_array)
		end

feature -- Partition

	is_partitioned_by (other : MML_SET[FRAME]) : BOOLEAN is
			-- Is `other' a partition of `current'?
		do
			Result := Precursor {MML_DEFAULT_SET}(other)
		end

end
