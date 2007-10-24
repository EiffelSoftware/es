indexing
	description: "Default implementation of MML_SET, based on ARRAY [G]"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_SET[G]

inherit
	MML_SET[G]
		redefine
			out
		end

create
	make_from_element,
	make_empty,
	make_from_array

feature {NONE} -- Initialization

	make_from_element (other : G) is
			-- Create a new set containing the element `other'.
		do
			create a.make (1, 1)
			a.put (other, 1)
		end

	make_empty is
			-- Create a new empty set.
		do
			a := Void
		end

	make_from_array (an_array: ARRAY[G]) is
			-- Create the set from an array (carefull about aliasing).
		do
			a := an_array
		ensure
			internal_array_set: a = an_array
		end

feature -- Access

	any_item: G is
			-- An arbitrary element of `current'.
		do
			Result := a.item (1)
		end

	item_where (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): G is
			-- An arbitrary element of `current' which satisfies `predicate'?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				(i >= count) or predicate.item([a.item(i)])
			loop
				i := i + 1
			end
			Result := a.item(i)
		end

feature -- Conversion

	identity : MML_RELATION[G, G] is
			-- The identity relation of `current'.
		local
			new_array: ARRAY[MML_PAIR[G,G]]
			i: INTEGER
		do
			if is_empty then
				create {MML_DEFAULT_RELATION[G,G]}Result.make_empty
			else
				create new_array.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					new_array.put(create {MML_DEFAULT_PAIR[G,G]}.make_from (a.item(i),a.item(i)),i)
					i := i + 1
				end
				create {MML_DEFAULT_RELATION[G,G]}Result.make_from_array(new_array)
			end
		end

	lifted : MML_POWERSET[G] is
			-- The set `current' as power set.
		do
			create {MML_DEFAULT_POWERSET[G]}Result.make_from_element (Current)
		end

	randomly_ordered : MML_SEQUENCE[G] is
			-- The set `current' as random sequence.
		do
			create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array (a)
		end

feature -- Comparison

	equals, infix "|=|" (other: MML_ANY): BOOLEAN is
			-- Is `other' mathematically equivalent ?
		local
			as_set: MML_SET[G]
		do
			as_set ?= other
			if as_set = Void or else as_set.count /= count then
				Result := false
			else
				Result := is_superset_of (as_set)
			end
		end

feature -- Status Report

	count : INTEGER is
			-- The cardinality of `current'
		do
			if a = Void then
				Result := 0
			else
				Result := a.count
			end
		end

feature -- Properties

	contains (v: G) : BOOLEAN is
			-- Is `v' a member of `current'?
		do
			find (v)
			Result := was_found
		end

	is_empty : BOOLEAN is
			-- Is `current' empty?
		do
			Result := a = Void
		end

	is_disjoint_from (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' disjoint from `current'?
		do
			Result := not there_exists (agent other.contains (?))
		end

	is_superset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a subset of `current'?
		do
			Result := other.for_all (agent contains(?))
		end

	is_subset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a superset of `current'?
		do
			Result := for_all (agent other.contains(?))
		end

	is_proper_subset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a proper superset of `current'?
		do
			Result := is_subset_of(other) and (other.count > count)
		end

	is_proper_superset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a proper subset of `current'?
		do
			Result := is_superset_of(other) and (other.count < count)
		end

feature -- Basic Operations

	cartesian_product (other : MML_SET[ANY]) : MML_SET[MML_PAIR[G, ANY]] is
			-- The cartesian product of `other' and `current'.
			-- TypeCheat
		do
			check
				not_implemented: false
			end
		end

	intersected (other: MML_SET[G]): MML_SET[G] is
			-- The intersection of `current' and `other'.
		local
			new_array: ARRAY[G]
			i,k: INTEGER
		do
			if count = 0 or other.count = 0 then
				create {MML_DEFAULT_SET[G]}Result.make_empty
			else
				create new_array.make(1,1)
				from
					i := 1
					k := 1
				until
					i > count
				loop
					if other.contains(a.item (i)) then
						new_array.force (a.item(i),k)
						k := k + 1
					end
					i := i + 1
				end
				if k > 1 then
					create {MML_DEFAULT_SET[G]}Result.make_from_array(new_array)
				else
					create {MML_DEFAULT_SET[G]}Result.make_empty
				end
			end
		end

	united (other: MML_SET[G]) : MML_SET[G] is
			-- The union of `current' and `other'.
		local
			new_array: ARRAY [G]
			i: INTEGER
		do
			if other.count = 0 then
				Result := Current
			elseif count = 0 then
				Result := other
			else
				new_array := other.as_array.twin
				create {MML_DEFAULT_SET[G]}Result.make_from_array (new_array)
				from
					i := 1
				until
					i > count
				loop
					if not Result.contains (a.item (i)) then
						new_array.force (a.item(i),new_array.upper+1)
					end
					i := i + 1
				end
			end
		end

	subtracted (other: MML_SET[G]): MML_SET [G] is
			-- The difference of `current' and `other'.
		local
			new_array: ARRAY [G]
			i,j: INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not other.contains (a.item(i)) then
					new_array.force (a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_SET[G]}Result.make_from_array (new_array)
			else
				create {MML_DEFAULT_SET[G]}Result.make_empty
			end
		end

	difference (other: MML_SET[G]): MML_SET [G] is
			-- The symmetric difference of `current' and `other'.
		do
			Result := united(other).subtracted(Current.intersected (other))
		end

	extended (v: G): MML_SET [G] is
			-- The set `current' extended with `v'.
		local
			new_array: ARRAY [G]
		do
			find (v)
			if was_found then
				Result := Current
			else
				create new_array.make (1,count+1)
				if a /= Void then
					new_array.subcopy (a,1,count,1)
				end
				new_array.put (v,count+1)
				create {MML_DEFAULT_SET[G]}Result.make_from_array (new_array)
			end
		end

	pruned (v: G): MML_SET [G] is
			-- The set `current' with `v' removed.
		local
			new_array: ARRAY [G]
		do
			find (v)
			if was_found then
				if count > 1 then
					create new_array.make (1,count-1)
					new_array.subcopy (a,1,count-1,1)
					if last_found_index /= count then
						new_array.put(a.item (count), last_found_index)
					end
				end
				create {MML_DEFAULT_SET[G]}Result.make_from_array (new_array)
			else
				Result := Current
			end
		end

feature -- Quantifiers

	there_exists (predicate: FUNCTION [ANY, TUPLE[G], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the set that satisfies `predicate' ?
		do
			if a = Void then
				Result := false
			else
				Result := a.there_exists (predicate)
			end
		end

	for_all (predicate: FUNCTION [ANY, TUPLE[G], BOOLEAN]): BOOLEAN is
			-- Do all members of the set satisfy `predicate' ?
		do
			if a = Void then
				Result := true
			else
				Result := a.for_all (predicate)
			end
		end

feature -- Partition

	is_partitioned_by (other : MML_SET[MML_SET[G]]) : BOOLEAN is
			-- Is `other' a partition of `current'?
		do
			Result := other.for_all (agent is_superset_of(?))
		end

feature{MML_ANY} -- Direct Access

	as_array: ARRAY [G] is
			-- All elements of the set as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		do
			Result := a
		end

feature{NONE} -- Implementation

	a: ARRAY [G]

	last_found_index: INTEGER

	was_found: BOOLEAN is
			-- Was the last find operation successful?
		do
			Result := (last_found_index >= 1 and last_found_index <= a.count)
		end

	find (needle: G) is
			-- Search for `needle' in a, using equal_value.
			-- Return
		do
			if a /= Void then
				from
					last_found_index := 1
				until
					last_found_index > a.count or equal_value(a.item(last_found_index),needle)
				loop
					last_found_index := last_found_index + 1
				end
			end
		end

feature -- Output

	out: STRING is
			-- String representation of set.
		local
			i: INTEGER
		do
			Result := "{"
			if a /= Void then
				from
					i := 1
				until
					i > count
				loop
					if a.item(i) = Void then
						Result.append ("Void")
					else
						Result.append (a.item(i).out)
					end
					if i < count then
						Result.append (",")
					end
					i := i + 1
				end
			end
			Result.append ("}")
		end

end
