indexing
	description: "Default Implementation of MML_BAG"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_BAG[G]

inherit
	MML_BAG[G]
		redefine
			out
		end
	MML_DEFAULT_RELATION[G,INTEGER]
		rename
			any_item as set_any_item,
			item_where as set_item_where,
			randomly_ordered as set_randomly_ordered,
			difference as set_difference,
			extended as set_extended,
			intersected as set_intersected,
			pruned as set_pruned,
			subtracted as set_subtracted,
			united as set_united,
			is_disjoint_from as set_is_disjoint,
			contains as set_is_member,
			for_all as set_for_all,
			there_exists as set_there_exists,
			count as set_cardinality
		redefine
			set_intersected,
			set_pruned,
			set_subtracted,
			domain_anti_restricted,
			domain_anti_restricted_by,
			domain_restricted_by,
			domain_restricted,
			range_anti_restricted,
			range_anti_restricted_by,
			range_restricted_by,
			range_restricted,
			out
		end

create
	make_empty,
	make_from_array,
	make_from_element

feature -- Access

	any_item: G is
			-- An arbitrary element of the bag `current'.
		do
			Result := a.item(1).first
		end

	item_where (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): G is
			-- Any arbitrary element of the bag `current' that satisfies `predicate'.
		do
			Result := domain.item_where (predicate)
		end

	occurrences (v: G): INTEGER is
			-- The number of times that `v' occures in the bag.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > set_cardinality or equal_value(v,a.item(i).first)
			loop
				i := i + 1
			end
			if i > set_cardinality then
				Result := 0
			else
				Result := a.item(i).second
			end
		end

feature -- Measurement

	count: INTEGER is
			-- The cardinality of `current'
		local
			i: INTEGER
		do
			if is_empty then
				Result := 0
			else
				from
					i := 1
					Result := 0
				until
					i > set_cardinality
				loop
					Result := Result + a.item(i).second
					i := i + 1
				end
			end
		end

feature -- Conversion	

	randomly_ordered: MML_SEQUENCE [G] is
			-- The bag `current' as random sequence.
		local
			i,j,k: INTEGER
			new_array: ARRAY[G]
		do
			if is_empty then
				create {MML_DEFAULT_SEQUENCE[G]}Result.make_empty
			else
				create new_array.make(1,count)
				from
					i := 1
					k := 1
				until
					i > set_cardinality
				loop
					from
						j := 1
					until
						j > a.item(i).second
					loop
						new_array.put (a.item(i).first,k)
						k := k + 1
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Basic Operations

	difference (other: MML_BAG [G]): MML_BAG [G] is
			-- The symmetric difference of the bags `current' and `other'.
		do
			Result := subtracted (other).united (other.subtracted(Current))
		end

	extended (v: G): MML_BAG [G] is
			-- The bag `current' extended with `v'.
		local
			new_array: ARRAY[MML_PAIR[G,INTEGER]]
			i : INTEGER
		do
			if is_empty then
				create new_array.make(1,1)
				new_array.put(create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from(v,1),1)
			else
				new_array := a.twin
				from
					i := new_array.lower
				until
					i > new_array.upper or equal_value(new_array.item(i).first,v)
				loop
					i := i + 1
				end
				if i > new_array.upper then
					new_array.force (create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from(v,1),i)
				else
					new_array.put (create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from (v,1+new_array.item(i).second),i)
				end
			end
			create {MML_DEFAULT_BAG[G]}Result.make_from_array(new_array)
		end

	extended_n (v: G; n:INTEGER): MML_BAG [G] is
			-- The bag `current' extended with `n' occurrences of `v'.
		local
			new_array: ARRAY[MML_PAIR[G,INTEGER]]
			i : INTEGER
		do
			if n = 0 then
				Result := Current
			elseif is_empty then
				create new_array.make(1,1)
				new_array.put(create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from(v,n),1)
				create {MML_DEFAULT_BAG[G]}Result.make_from_array(new_array)
			else
				new_array := a.twin
				from
					i := new_array.lower
				until
					i > new_array.upper or equal_value(new_array.item(i).first,v)
				loop
					i := i + 1
				end
				if i > new_array.upper then
					new_array.force (create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from(v,n),i)
				else
					new_array.put (create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from (v,n+new_array.item(i).second),i)
				end
				create {MML_DEFAULT_BAG[G]}Result.make_from_array(new_array)
			end
		end

	intersected (other: MML_BAG [G]): MML_BAG [G] is
			-- The intersection of the bags `current' and `other'.
		local
			i: INTEGER
		do
			if is_empty then
				Result := Current
			else
				create {MML_DEFAULT_BAG[G]}Result.make_empty
				from
					i := 1
				until
					i > set_cardinality
				loop
					Result := Result.extended_n (a.item (i).first,a.item(i).second.min(other.occurrences(a.item(i).first)))
					i := i + 1
				end
			end
		end

	pruned (v: G): MML_BAG [G] is
			-- The bag `current' with one instance of `v' removed.
		do
			if is_empty then
				Result := Current
			else
				Result := domain_anti_restricted_by (v).extended_n (v, (occurrences (v)-1).max(0))
			end
		end

	set_intersected (other: MML_SET [MML_PAIR [G, INTEGER]]): MML_BAG [G] is
			-- The intersection of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag(Precursor(other))
		end

	set_pruned (v: MML_PAIR [G, INTEGER]): MML_BAG [G] is
			-- The relation `current' with the pair `v' removed.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag(Precursor(v))
		end

	set_subtracted (other: MML_SET [MML_PAIR [G, INTEGER]]): MML_BAG [G] is
			-- The difference of `current' and `other'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(other))
		end

	subtracted (other: MML_BAG [G]): MML_BAG [G] is
			-- The difference of the bags `current' and `other'.
		local
			i: INTEGER
		do
			if is_empty then
				Result := Current
			else
				create {MML_DEFAULT_BAG[G]}Result.make_empty
				from
					i := 1
				until
					i > set_cardinality
				loop
					Result := Result.extended_n (a.item (i).first,(a.item(i).second-other.occurrences(a.item(i).first)).max(0))
					i := i + 1
				end
			end
		end

	united (other: MML_BAG [G]): MML_BAG [G] is
			-- The union of the bags `current' and `other'.
		local
			new_array: ARRAY[MML_PAIR[G,INTEGER]]
			i,j: INTEGER
		do
			if other.is_empty then
				Result := Current
			elseif is_empty then
				Result := other
			else
				new_array := other.as_array.twin
				from
					i := 1
				until
					i > set_cardinality
				loop
					from
						j := new_array.lower
					until
						j > new_array.upper or equal_value(new_array.item(j).first,a.item(i).first)
					loop
						j := j + 1
					end
					if j > new_array.upper then
						new_array.force (a.item(i),j)
					else
						new_array.put (create {MML_DEFAULT_PAIR[G,INTEGER]}.make_from (a.item(i).first,a.item(i).second+new_array.item(j).second),j)
					end
					i := i + 1
				end
				create {MML_DEFAULT_BAG[G]}Result.make_from_array(new_array)
			end
		end

feature -- Projections

	domain_anti_restricted (restriction: MML_SET [G]): MML_BAG [G] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(restriction))
		end

	domain_anti_restricted_by (v: G): MML_BAG [G] is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(v))
		end

	domain_restricted_by (v: G): MML_BAG [G] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(v))
		end

	domain_restricted (restriction: MML_SET [G]): MML_BAG [G] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(restriction))
		end

	range_anti_restricted (restriction: MML_SET [INTEGER]): MML_BAG [G] is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(restriction))
		end

	range_anti_restricted_by (v: INTEGER): MML_BAG [G] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(v))
		end

	range_restricted_by (v: INTEGER): MML_BAG [G] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(v))
		end

	range_restricted (restriction: MML_SET [INTEGER]): MML_BAG [G] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		local
			converter: MML_CONVERSION[G]
		do
			create converter
			Result := converter.as_bag (Precursor(restriction))
		end

feature -- Properties

	is_disjoint_from (other: MML_BAG [G]): BOOLEAN is
			-- Is the current bag disjoint from the bag `other' ?
		do
			Result := domain.is_disjoint_from(other.domain)
		end

	contains (v: G): BOOLEAN is
			-- Is `v' contained at least once in the bag ?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > set_cardinality or Result
			loop
				Result := equal_value(a.item(i).first,v)
				i := i + 1
			end
		end

	is_proper_superbag_of (other: MML_BAG [G]): BOOLEAN is
			-- Is `other' a proper subbag of `current'?
		do
			Result := other.count < count and is_superbag_of(other)
		end

	is_proper_subbag_of (other: MML_BAG [G]): BOOLEAN is
			-- Is `other' a proper superbag of `current'?
		do
			Result := other.count > count and is_subbag_of(other)
		end

	is_superbag_of (other: MML_BAG [G]): BOOLEAN is
			-- Is `other' a subbag of `current'?
		local
			i: INTEGER
		do
			from
				i := 1
				Result := domain.is_superset_of(other.domain)
			until
				i > set_cardinality or not Result
			loop
				Result := (a.item(i).second > other.occurrences (a.item(i).first))
				i := i + 1
			end
		end

	is_subbag_of (other: MML_BAG [G]): BOOLEAN is
			-- Is `other' a superbag of `current'?
		do
			Result := other.is_superbag_of(Current)
		end

feature -- Quantifiers

	for_all (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Do all members of the bag satisfy `predicate' ?
		do
			Result := domain.for_all (predicate)
		end

	there_exists (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the bag that satisfies `predicate' ?
		do
			Result := domain.there_exists (predicate)
		end

feature -- Output

	out: STRING is
			-- String representation of the bag.
		local
			i,j:INTEGER
		do
			Result := "<"
			from
				i := 1
			until
				i > set_cardinality
			loop
				from
					j := 1
				until
					j > a.item (i).second
				loop
					if a.item (i).first /= Void then
						Result.append(a.item (i).first.out)
					else
						Result.append("Void")
					end
					if i < set_cardinality or j < a.item(i).second then
						Result.append(",")
					end
					j := j + 1
				end
				i := i + 1
			end
			Result.append(">")
		end

end
