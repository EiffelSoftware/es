indexing
	description: "Default implementation of MML_SEQUENCE using ARRAY"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_SEQUENCE[G]

inherit
	MML_SEQUENCE[G]
		redefine
			out
		end

create
	make_from_array,
	make_from_element,
	make_empty

feature {NONE} -- Constructors

	make_from_array (an_array:ARRAY[G]) is
			-- Create the sequence from a given array.
			-- The values of the array have to be immutable !
		do
			a := an_array
		ensure
			array_set: a = an_array
		end

	make_from_element (other : G) is
			-- Create a new set containing the element `other'.
		do
			create a.make(1,1)
			a.put(other,1)
		end

	make_empty is
			-- Create a new empty set.
		do
			a := Void
		end

feature -- Access

	any_element: G is
			-- An arbitrary element of `current'.
		do
			Result := a.item(1)
		end

	set_any_item: MML_PAIR [INTEGER, G] is
			-- An arbitrary element of `current'.
		do
			create {MML_DEFAULT_PAIR[INTEGER,G]}Result.make_from (1,a.item(1))
		end

	any_item (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): G is
			-- An arbitrary element of `current' which satisfies `predicate'?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				predicate.item([a.item(i)])
			loop
				i := i + 1
			end
			Result := a.item(i)
		end

	set_item_where (predicate: FUNCTION [ANY, TUPLE [MML_PAIR [INTEGER, G]], BOOLEAN]): MML_PAIR [INTEGER, G] is
			-- An arbitrary element of `current' which satisfies `predicate'?
		local
			i: INTEGER
		do
			from
				i := 2
				create {MML_DEFAULT_PAIR[INTEGER,G]}Result.make_from(1,a.item(1))
			until
				predicate.item([Result])
			loop
				i := i + 1
				create {MML_DEFAULT_PAIR[INTEGER,G]}Result.make_from(i,a.item(i))
			end
		end

	identity: MML_RELATION [MML_PAIR[INTEGER,G], MML_PAIR[INTEGER,G]] is
			-- The identity relation of `current'.
		do
			Result := as_default_relation.identity
		end

	lifted: MML_POWERSET [MML_PAIR [INTEGER,G]] is
			-- The set `current' as power set.
		do
			create {MML_DEFAULT_POWERSET[MML_PAIR[INTEGER,G]]}Result.make_from_element (Current)
		end

	randomly_ordered: MML_SEQUENCE [MML_PAIR[INTEGER,G]] is
			-- The set `current' as random sequence.
		do
			Result := as_default_relation.randomly_ordered
		end

feature {MML_COMPARISON} -- Comparison

	equals, infix "|=|" (other: MML_ANY): BOOLEAN is
			-- Is `other' mathematically equivalent ?
		local
			other_sequence: MML_SEQUENCE[G]
			other_set: MML_SET[MML_PAIR[INTEGER,G]]
			other_relation: MML_RELATION[INTEGER,G]
			i: INTEGER
			converter: MML_CONVERSION_2[INTEGER,G]
		do
			create converter
			other_sequence ?= other
			if other_sequence = Void then
				other_set ?= other
				if other_set = Void then
					Result := false
				else
					other_relation := converter.as_relation(other_set)
					if other_relation.count = count then
						from
							i := 1
							Result := true
						until
							i > count or not Result
						loop
							Result := other_relation.contains_pair (i,a.item(i))
							i := i + 1
						end
					else
						Result := false
					end
				end
			else
				Result := equal(a,other_sequence.as_array)
			end
		end

feature -- Basic Operations

	cartesian_product (other: MML_SET [ANY]): MML_SET [MML_PAIR [MML_PAIR [INTEGER, G], ANY]] is
			-- The cartesian product of `other' and `current'.
			-- TypeCheat
		do
			check
				not_implemented: false
			end
		end

	difference (other: MML_SET [MML_PAIR [INTEGER, G]]): MML_RELATION [INTEGER, G] is
			-- The symmetric difference of `current' and `other'.
		do
			Result := as_default_relation.difference (other)
		end

	set_extended (v: MML_PAIR [INTEGER, G]): MML_RELATION [INTEGER, G] is
			-- The releation `current' extended with the pair `v'.
		do
			Result := as_default_relation.extended (v)
		end

	set_extended_by_pair (g:INTEGER;h:G): MML_RELATION [INTEGER, G] is
			-- The releation `current' extended with the pair `g,h'.
		do
			Result := as_default_relation.extended_by_pair(g,h)
		end

	extended_at (other: G; position: INTEGER): MML_SEQUENCE [G] is
			-- The sequence `current' extended with `other' at `position'.
		local
			new_array: ARRAY[G]
			i,j: INTEGER
		do
			create new_array.make(1,count+1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if j = position then
					new_array.put(other,j)
				else
					new_array.put(a.item(i),j)
					i := i + 1
				end
				j := j + 1
			end
			create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array (new_array)
		end

	intersected (other: MML_SET [MML_PAIR [INTEGER, G]]): MML_RELATION [INTEGER, G] is
			-- The intersection of `current' and `other'.
		do
			Result := as_default_relation.intersected(other)
		end

	pruned (v: G): MML_SEQUENCE [G] is
			-- The sequence `current' with all occurrences of `v' removed.
		local
			new_array: ARRAY[G]
			i,j: INTEGER
		do
			create new_array.make(1,count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not equal_value (v,a.item(i)) then
					new_array.put(a.item (i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array.subarray(1,j-1))
			else
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			end
		end

	set_pruned (v: MML_PAIR [INTEGER, G]): MML_RELATION [INTEGER, G] is
			-- The relation `current' with the pair `v' removed.
		do
			Result := as_default_relation.pruned (v)
		end

	pruned_at (position: INTEGER): MML_SEQUENCE [G] is
			-- The sequence `current' with the element at `position' pruned.
		local
			new_array: ARRAY[G]
		do
			if count = 1 then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			else
				create new_array.make(1,count-1)
				if position > 1 then
					new_array.subcopy (a,1,position-1,1)
				end
				if position < count then
					new_array.subcopy (a,position+1,count,position)
				end
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			end
		end

	replaced_at (other: G; position: INTEGER): MML_SEQUENCE [G] is
			-- The sequence `current' with the element at `position' replaced by `other'.
		local
			new_array: ARRAY[G]
		do
			new_array := a.twin
			new_array.put(other,position)
			create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
		end

	subtracted (other: MML_SET [G]): MML_SEQUENCE [G] is
			-- The sequence `current' with all elements of `other' removed.
		local
			new_array: ARRAY[G]
			i,j: INTEGER
		do
			create new_array.make(1,count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not other.contains(a.item(i)) then
					new_array.put(a.item (i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array.subarray(1,j-1))
			else
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			end
		end

	set_subtracted (other: MML_SET [MML_PAIR [INTEGER, G]]): MML_RELATION [INTEGER, G] is
			-- The difference of `current' and `other'.
		do
			Result := as_default_relation.subtracted(other)
		end

	united (other: MML_SET [MML_PAIR [INTEGER, G]]): MML_RELATION [INTEGER, G] is
			-- The union of `current' and `other'.
		do
			Result := as_default_relation.united (other)
		end

feature -- Concatenation

	concatenated (other: MML_SEQUENCE [G]): MML_SEQUENCE [G] is
			-- The concatenation of `current' and `other'.
		local
			new_array: ARRAY[G]
		do
			if is_empty then
				Result := other
			elseif other.is_empty then
				Result := Current
			else
				create new_array.make(1,count+other.count)
				new_array.subcopy(a,1,count,1)
				new_array.subcopy(other.as_array,1,other.count,count+1)
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			end
		end

	extended (other: G): MML_SEQUENCE [G] is
			-- The sequence `current' with `other' appended.
			-- Was declared in MML_SEQUENCE as synonym of `appended'.
		local
			new_array: ARRAY[G]
		do
			if is_empty then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_element (other)
			else
				create new_array.make(1,count+1)
				new_array.subcopy(a,1,count,1)
				new_array.put(other,count+1)
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			end
		end

	prepended (other: G): MML_SEQUENCE [G] is
			-- The sequence `current' prepended with `other'.
		local
			new_array: ARRAY[G]
		do
			if is_empty then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_element (other)
			else
				create new_array.make(1,count+1)
				new_array.put(other,1)
				new_array.subcopy(a,1,count,2)
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			end
		end

feature -- Decomposition

	first: G is
			-- The first element of `current'.
		do
			Result := a.item (1)
		end

	front: MML_SEQUENCE [G] is
			-- The elements of `current' except for the last one.
		local
			new_array: ARRAY[G]
		do
			if count > 1 then
				create new_array.make(1,count-1)
				new_array.subcopy(a,1,count-1,1)
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			end
		end

	interval (start_position: INTEGER; end_position: INTEGER): MML_SEQUENCE [G] is
			-- The subsequence of `current' starting at index `start_position' and ending at index `end_position'.
		local
			new_array: ARRAY[G]
		do
			if end_position < start_position then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			else
				create new_array.make (1,end_position-start_position+1)
				new_array.subcopy (a,start_position,end_position,1)
				create {MML_DEFAULT_SEQUENCE [G]}Result.make_from_array (new_array)
			end
		end

	last: G is
			-- The last element of `current'.
		do
			Result := a.item(count)
		end

	tail: MML_SEQUENCE [G] is
			-- The elements of `current' except for the first one.
		local
			new_array: ARRAY[G]
		do
			if count > 1 then
				create new_array.make(1,count-1)
				new_array.subcopy(a,2,count,1)
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			end
		end

feature {MML_ANY, MML_CONVERSION, MML_CONVERSION_2} -- Direct Access

	as_array: ARRAY [G] is
			-- All elements of the sequence as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		do
			Result := a
		end

	set_as_array: ARRAY [MML_PAIR [INTEGER, G]] is
			-- All elements of the set as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		local
			i: INTEGER
			pair: MML_DEFAULT_PAIR[INTEGER,G]
		do
			if a = Void then
				Result := Void
			else
				create Result.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					create pair.make_from(i,a.item(i))
					Result.put(pair,i)
					i := i + 1
				end
			end
		end

feature -- Field

	domain: MML_SET [INTEGER] is
			-- The domain of `current'.
		do
			create {MML_RANGE_SET}Result.make_from_range(1,count)
		end

	range: MML_SET [G] is
			-- The range of `current'.
		local
			new_array: ARRAY [G]
			i,j: INTEGER
		do
			if is_empty then
				create {MML_DEFAULT_SET[G]}Result.make_empty
			else
				create new_array.make(1,1)
				new_array.put(a.item(1),1)
				create {MML_DEFAULT_SET[G]}Result.make_from_array(new_array)
				from
					i := 2
					j := 2
				until
					i > count
				loop
					if not Result.contains (a.item(i)) then
						new_array.force(a.item(i),j)
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Inversion

	inversed: MML_RELATION [G, INTEGER] is
			-- The inverse relation of `current'.
		do
			Result := as_default_relation.inversed
		end

feature -- Partition

	is_partitioned_by (other: MML_SET [MML_SET [MML_PAIR [INTEGER, G]]]): BOOLEAN is
			-- Is `other' a partition of `current'?
		do
			Result := as_default_relation.is_partitioned_by (other)
		end

feature -- Projections

	anti_image (projection: MML_SET [G]): MML_SET [INTEGER] is
			-- The projected domain set of `current' through `projection'.
		do
			Result := as_default_relation.anti_image (projection)
		end

	anti_image_of (v: G): MML_SET [INTEGER] is
			-- The projected domain set of `current' through `v'.
		do
			Result := as_default_relation.anti_image_of (v)
		end

	domain_anti_restricted (restriction: MML_SET [INTEGER]): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		do
			Result := as_default_relation.domain_anti_restricted (restriction)
		end

	domain_anti_restricted_by (v: INTEGER): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		do
			Result := as_default_relation.domain_anti_restricted_by (v)
		end

	domain_restricted_by (v: INTEGER): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		do
			Result := as_default_relation.domain_restricted_by (v)
		end

	domain_restricted (restriction: MML_SET [INTEGER]): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		do
			Result := as_default_relation.domain_restricted (restriction)
		end

	image (projection: MML_SET [INTEGER]): MML_SET [G] is
			-- The projected range set of `current' through `projection'.
		do
			Result := as_default_relation.image (projection)
		end

	image_of (v: INTEGER): MML_SET [G] is
			-- The projected range set of `current' through `v'.
		do
			if is_defined(v) then
				create {MML_DEFAULT_SET[G]}Result.make_from_element(a.item(v))
			else
				create {MML_DEFAULT_SET[G]}Result.make_empty
			end
		end

	item (v: INTEGER): G is
			-- Lookup the value of `v' in the relation, if it is a function.
		do
			Result := a.item(v)
		end

	occurrences (v: G): INTEGER is
			-- The occurrences of `v' in `current'.
		local
			i: INTEGER
		do
			from
				Result := 0
				i := 1
			until
				i > count
			loop
				if equal_value(v,a.item(i)) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	index_of_i_th_occurrence_of (v: G; i: INTEGER): INTEGER is
			-- Index of the `i'-th occurence of `v'
		local
			to_skip: INTEGER
			j: INTEGER
		do
			from
				to_skip := i-1;
				j := 0;
			until
				to_skip = 0 and equal_value (v,a.item(i))
			loop
				if equal_value (v,a.item(i)) then
					to_skip := to_skip - 1
				end
				j := j + 1
			end
		end

	range_anti_restricted (restriction: MML_SET [G]): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		do
			Result := as_default_relation.range_anti_restricted (restriction)
		end

	range_anti_restricted_by (v: G): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		do
			Result := as_default_relation.range_anti_restricted_by (v)
		end

	range_restricted_by (v: G): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		do
			Result := as_default_relation.range_restricted_by (v)
		end

	range_restricted (restriction: MML_SET [G]): MML_RELATION [INTEGER, G] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		do
			Result := as_default_relation.range_restricted (restriction)
		end

feature -- Properties

	is_defined (index: INTEGER): BOOLEAN is
			-- Is `index' defined in `current'?
		do
			Result := index >= 1 and index <= count
		end

	is_disjoint_from (other: MML_SET [MML_PAIR [INTEGER, G]]): BOOLEAN is
			-- Is `other' disjoint from `current'?
		do
			Result := as_default_relation.is_disjoint_from(other)
		end

	is_empty: BOOLEAN is
			-- Is `current' empty?
		do
			Result := count = 0
		end

	is_member (v: G): BOOLEAN is
			-- Is `other' a member of `current'?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > count or Result
			loop
				Result := equal_value(v,a.item (i))
				i := i + 1
			end
		end

	set_contains (v: MML_PAIR [INTEGER, G]): BOOLEAN is
			-- Is `v' a member of `current'?
		do
			Result := contains_pair(v.first,v.second)
		end

	is_proper_supersequence_of (other: MML_SEQUENCE [G]): BOOLEAN is
			-- Is `other' a proper subsequence of `current'?
		do
			Result := other.count < count and is_supersequence_of (other)
		end

	is_proper_subsequence_at (other: MML_SEQUENCE [G]; position: INTEGER): BOOLEAN is
			-- Is `other' a proper subsequence of `current' at `position' ?
		do
			Result := other.count < count and is_supersequence_of_at (other,position)
		end

	is_proper_superset_of (other: MML_SET [MML_PAIR [INTEGER, G]]): BOOLEAN is
			-- Is `other' a proper subset of `current'?
		do
			Result := other.count < count and is_superset_of (other)
		end

	is_proper_subsequence_of (other: MML_SEQUENCE [G]): BOOLEAN is
			-- Is `other' a proper supersequence of `current'?
		do
			Result := other.is_proper_supersequence_of(Current)
		end

	is_proper_supersequence_at (other: MML_SEQUENCE [G]; position: INTEGER): BOOLEAN is
			-- Is `other' a proper supersequence of `current' at `position' ?
		do
			Result := other.is_proper_subsequence_at(Current,position)
		end

	is_proper_subset_of (other: MML_SET [MML_PAIR [INTEGER, G]]): BOOLEAN is
			-- Is `other' a proper superset of `current'?
		do
			Result := other.is_proper_superset_of(Current)
		end

	is_supersequence_of (other: MML_SEQUENCE [G]): BOOLEAN is
			-- Is `other' a subsequence of `current'?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i+other.count-1 > count or Result
			loop
				Result := is_supersequence_of_at(other,i)
				i := i + 1
			end
		end

	is_supersequence_of_at (other: MML_SEQUENCE [G]; position: INTEGER): BOOLEAN is
			-- Is `other' a subsequence of `current' at `position' ?
		local
			i :INTEGER
		do
			if other.count+position > count+1 then
				Result := false
			else
				from
					i := 1
					Result := true
				until
					i > count or not Result
				loop
					Result := equal_value(other.item(i),a.item(position+i-1))
					i := i + 1
				end
			end
		end

	is_superset_of (other: MML_SET [MML_PAIR [INTEGER, G]]): BOOLEAN is
			-- Is `other' a subset of `current'?
		do
			Result := other.for_all(agent set_contains(?))
		end

	is_subsequence_of (other: MML_SEQUENCE [G]): BOOLEAN is
			-- Is `other' a supersequence of `current'?
		do
			Result := other.is_supersequence_of(Current)
		end

	is_subsequence_of_at (other: MML_SEQUENCE [G]; position: INTEGER): BOOLEAN is
			-- Is `other' a supersequence of `current' at `position' ?
		do
			Result := other.is_supersequence_of_at (Current,position)
		end

	is_subset_of (other: MML_SET [MML_PAIR [INTEGER, G]]): BOOLEAN is
			-- Is `other' a superset of `current'?
		do
			Result := other.is_superset_of(Current)
		end

feature -- Quantifiers

	set_for_all (predicate: FUNCTION [ANY, TUPLE [MML_PAIR [INTEGER, G]], BOOLEAN]): BOOLEAN is
			-- Do all members of the set satisfy `predicate' ?
		local
			pair: MML_DEFAULT_PAIR[INTEGER,G]
			i: INTEGER
		do
			from
				i := 1
				Result := true
			until
				i > count or not Result
			loop
				create pair.make_from(i,a.item (i))
				Result := predicate.item([pair])
				i := i + 1
			end
		end

	set_there_exists (predicate: FUNCTION [ANY, TUPLE [MML_PAIR [INTEGER, G]], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the set that satisfies `predicate' ?
		local
			pair: MML_DEFAULT_PAIR[INTEGER,G]
			i: INTEGER
		do
			from
				i := 1
			until
				i > count or Result
			loop
				create pair.make_from(i,a.item (i))
				Result := predicate.item([pair])
				i := i + 1
			end
		end

	for_all (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Do all members of the sequence satisfy `predicate' ?
		local
			i: INTEGER
		do
			from
				i := 1
				Result := true
			until
				i > count or not Result
			loop
				Result := predicate.item([a.item(i)])
				i := i + 1
			end
		end

	there_exists (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the sequence that satisfies `predicate' ?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > count or Result
			loop
				Result := predicate.item([a.item(i)])
				i := i + 1
			end
		end

feature -- Reversal

	reversed: MML_SEQUENCE [G] is
			-- The sequence with all elements of `current', but in reversed order.
		local
			new_array:ARRAY[G]
			i: INTEGER
		do
			if count <= 1 then
				Result := Current
			else
				create new_array.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					new_array.put(a.item (i),count+1-i)
					i := i +1
				end
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
			end
		end

feature -- Status Report

	count: INTEGER is
			-- The cardinality of `current'
		do
			if a = Void then
				Result := 0
			else
				Result := a.upper
			end
		end

	is_function: BOOLEAN is
			-- Is `current' a function ?
		do
			Result := true
		end

	is_injective: BOOLEAN is
			-- Is `current' injective ?
			-- (from MML_RELATION)
		do
			Result := count = range.count
		end

	contains_pair (v1: INTEGER; v2: G): BOOLEAN is
			-- Is the pair (`v1',`v2') contained in the relation ?
			-- (from MML_RELATION)
		do
			if is_defined(v1) then
				Result := equal_value(v2,a.item(v1))
			else
				Result := false
			end
		end

feature -- Output

	out: STRING is
			-- String representation of the sequence.
		local
			i: INTEGER
		do
			Result := "["
			if a /= Void then
				from
					i := a.lower
				until
					i > a.upper
				loop
					if a.item(i) /= Void then
						Result.append(a.item(i).out)
					else
						Result.append("Void")
					end
					if i < a.upper then
						Result.append(",")
					end
					i := i + 1
				end
			end
			Result.append("]")
		end

feature{NONE} -- Implementation

	a: ARRAY[G]

	as_default_relation: MML_DEFAULT_RELATION[INTEGER,G] is
			-- `current' tranformed into an MML_DEFAULT_RELATION.
		local
			new_array: ARRAY[MML_DEFAULT_PAIR[INTEGER,G]]
			i: INTEGER
		do
			if not is_empty then
				create new_array.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					new_array.put(create {MML_DEFAULT_PAIR[INTEGER,G]}.make_from(i,a.item(i)),i)
					i := i + 1
				end
			end
			create Result.make_from_array (new_array)
		end

end
