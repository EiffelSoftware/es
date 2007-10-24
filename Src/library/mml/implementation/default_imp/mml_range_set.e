indexing
	description: "Implemention of a range of number as a set"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_RANGE_SET

inherit
	MML_SET[INTEGER]
		redefine
			out
		end

create
	make_from_range,
	make_from_element,
	make_empty

feature {MML_COMPARISON} -- Comparison

	equals, infix "|=|" (other: MML_ANY): BOOLEAN is
			-- Is `other' mathematically equivalent ?
		local
			other_set: MML_SET[INTEGER]
			i: INTEGER
		do
			other_set ?= other
			if other_set = Void then
				Result := false
			else
				if other_set.count = count then
					from
						i := lower
						Result := true
					until
						i > upper or Result
					loop
						Result := other_set.contains(i)
						i := i + 1
					end
				end
			end
		end

feature{NONE} -- Constructors

	make_from_range (a_lower,a_upper:INTEGER) is
			-- Create the set of numbers between `a_lower' and `a_upper'.
		do
			lower := a_lower
			upper := a_upper.max (a_lower-1)
		ensure
			never_empty: a_upper < a_lower = is_empty
			lower_is_included: not is_empty implies contains(a_lower) and contains(a_upper)
			cardinality_correct: not is_empty implies count = a_upper+1-a_lower
		end

	make_from_element (other : INTEGER) is
			-- Create a new set containing the element `other'.
		do
			lower := other
			upper := other
		end

	make_empty is
			-- Create a new empty set.
		do
			lower := 1
			upper := 0
		end

feature -- Access

	any_item: INTEGER is
			-- An arbitrary element of `current'.
		do
			Result := lower
		end

	item_where (predicate: FUNCTION [ANY, TUPLE [INTEGER], BOOLEAN]): INTEGER is
			-- An arbitrary element of `current' which satisfies `predicate'?
		local
			i: INTEGER
		do
			from
				i := lower
			until
				predicate.item([i])
			loop
				i := i + 1
			end
		end

	identity: MML_RELATION [INTEGER, INTEGER] is
			-- The identity relation of `current'.
		local
			new_array: ARRAY [MML_PAIR [INTEGER, INTEGER]]
			i: INTEGER
		do
			if is_empty then
				create {MML_DEFAULT_RELATION [INTEGER,INTEGER]} Result.make_empty
			else
				create new_array.make (1, count)
				from
					i := 1
				until
					i > count
				loop
					new_array.put (create {MML_DEFAULT_PAIR [INTEGER,INTEGER]}.make_from (i+lower-1, i+lower-1), i)
					i := i + 1
				end
				create {MML_DEFAULT_RELATION [INTEGER,INTEGER]} Result.make_from_array (new_array)
			end
		end

	lifted : MML_POWERSET[INTEGER] is
			-- The set `current' as power set.
		do
			create {MML_DEFAULT_POWERSET[INTEGER]}Result.make_from_element (Current)
		end

	randomly_ordered: MML_SEQUENCE [INTEGER] is
			-- The set `current' as random sequence.
		local
			new_array: ARRAY[INTEGER]
			i : INTEGER
		do
			if is_empty then
				create {MML_DEFAULT_SEQUENCE[INTEGER]}Result.make_empty
			else
				create new_array.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					new_array.put(lower+i-1,i)
					i := i + 1
				end
			end
		end

feature -- Status Report

	count: INTEGER is
			-- The cardinality of `current'
		do
			Result := 1+upper-lower
		end

feature -- Properties

	contains (v: INTEGER): BOOLEAN is
			-- Is `v' a member of `current'?
		do
			Result := v >= lower and v <= upper
		end

	is_empty: BOOLEAN is
			-- Is `current' empty?
		do
			Result := upper < lower
		end

	is_disjoint_from (other: MML_SET [INTEGER]): BOOLEAN is
			-- Is `other' disjoint from `current'?
		local
			i: INTEGER
		do
			from
				i := lower
				Result := true
			until
				i > upper or not Result
			loop
				Result := not other.contains(i)
				i := i + 1
			end
		end

	is_superset_of (other: MML_SET [INTEGER]): BOOLEAN is
			-- Is `other' a subset of `current'?
		local
			i: INTEGER
		do
			from
				i := lower
				Result := true
			until
				i > upper or not Result
			loop
				Result := other.contains(i)
				i := i + 1
			end
		end

	is_subset_of (other: MML_SET [INTEGER]): BOOLEAN is
			-- Is `other' a superset of `current'?
		do
			Result := other.is_superset_of(Current)
		end

	is_proper_subset_of (other: MML_SET [INTEGER]): BOOLEAN is
			-- Is `other' a proper superset of `current'?
		do
			Result := other.count > count and other.is_superset_of(Current)
		end

	is_proper_superset_of (other: MML_SET [INTEGER]): BOOLEAN is
			-- Is `other' a proper subset of `current'?
		do
			Result := other.count < count and is_superset_of(other)
		end

feature -- Basic Operations

	cartesian_product (other: MML_SET [ANY]): MML_SET [MML_PAIR [INTEGER, ANY]] is
			-- The cartesian product of `other' and `current'.
			-- TypeCheat
		do
			check
				not_implemented: false
			end
		end

	intersected (other: MML_SET [INTEGER]): MML_SET [INTEGER] is
			-- The intersection of `current' and `other'.
		local
			default_set: MML_DEFAULT_SET[INTEGER]
		do
			create default_set.make_from_array(as_array)
			Result := default_set.intersected (other)
		end

	united (other: MML_SET [INTEGER]): MML_SET [INTEGER] is
			-- The union of `current' and `other'.
		local
			default_set: MML_DEFAULT_SET[INTEGER]
		do
			create default_set.make_from_array(as_array)
			Result := default_set.united (other)
		end

	subtracted (other: MML_SET [INTEGER]): MML_SET [INTEGER] is
			-- The difference of `current' and `other'.
		local
			default_set: MML_DEFAULT_SET[INTEGER]
		do
			create default_set.make_from_array(as_array)
			Result := default_set.subtracted (other)
		end

	difference (other: MML_SET [INTEGER]): MML_SET [INTEGER] is
			-- The symmetric difference of `current' and `other'.
		local
			default_set: MML_DEFAULT_SET[INTEGER]
		do
			create default_set.make_from_array(as_array)
			Result := default_set.difference (other)
		end

	extended (v: INTEGER): MML_SET [INTEGER] is
			-- The set `current' extended with `v'.
		do
			if v >= lower and v <= upper then
				Result := Current
			elseif v = upper+1 then
				create {MML_RANGE_SET}Result.make_from_range(lower,upper+1)
			elseif v = lower-1 then
				create {MML_RANGE_SET}Result.make_from_range(lower-1,upper)
			else
				create {MML_DEFAULT_SET[INTEGER]}Result.make_from_array(as_array)
				Result := Result.extended(v)
			end
		end

	pruned (v: INTEGER): MML_SET [INTEGER] is
			-- The set `current' with `v' removed.
		do
			if v < lower or v > upper  then
				Result := Current
			elseif v = upper then
				create {MML_RANGE_SET}Result.make_from_range(lower,upper-1)
			elseif v = lower then
				create {MML_RANGE_SET}Result.make_from_range(lower+1,upper)
			else
				create {MML_DEFAULT_SET[INTEGER]}Result.make_from_array(as_array)
				Result := Result.pruned(v)
			end
		end

feature -- Quantifiers

	there_exists (predicate: FUNCTION [ANY, TUPLE [INTEGER], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the set that satisfies `predicate' ?
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper or Result
			loop
				Result := predicate.item([i])
				i := i + 1
			end
		end

	for_all (predicate: FUNCTION [ANY, TUPLE [INTEGER], BOOLEAN]): BOOLEAN is
			-- Do all members of the set satisfy `predicate' ?
		local
			i: INTEGER
		do
			from
				i := lower
				Result := true
			until
				i > upper or not Result
			loop
				Result := predicate.item([i])
				i := i + 1
			end
		end

feature -- Partition

	is_partitioned_by (other: MML_SET [MML_SET [INTEGER]]): BOOLEAN is
			-- Is `other' a partition of `current'?
		do
			Result := other.for_all (agent is_superset_of(?))
		end

feature {MML_ANY, MML_CONVERSION, MML_CONVERSION_2} -- Direct Access

	as_array: ARRAY [INTEGER] is
			-- All elements of the set as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		local
			i: INTEGER
		do
			if is_empty then
				Result := Void
			else
				create Result.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					Result.put(i+lower-1,i)
					i := i + 1
				end
			end
		end

feature -- Output

	out: STRING is
			-- String representation of the MML_RANGE_SET
		local
			i : INTEGER
		do
			if is_empty then
				Result := "{}"
			else
				Result := "{"
				if upper-lower < 4 then
					from
						i := lower
					until
						i > upper
					loop
						Result.append (i.out)
						if i < upper then
							Result.append(",")
						end
						i := i+1
					end
				else
					Result.append(lower.out)
					Result.append(",...,")
					Result.append(upper.out)
				end
				Result.append ("}")
			end
		end

feature {NONE} -- Implementation
	lower: INTEGER
	upper: INTEGER

invariant
	lower_upper_relation: upper >= lower-1
end
