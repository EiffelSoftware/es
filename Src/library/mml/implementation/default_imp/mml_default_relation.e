indexing
	description: "Default implementation of MML_RELATION"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_RELATION[G,H]

inherit
	MML_DEFAULT_SET[MML_PAIR[G,H]]
		redefine
			intersected,
			united,
			subtracted,
			difference,
			extended,
			pruned
		end
	MML_RELATION[G,H]
		undefine
			out
		end

create
	make_empty,
	make_from_element,
	make_from_array

feature -- Status Report

	is_function: BOOLEAN is
			-- The `current' a functional relation ?
		do
			Result := domain.count = count
		end

	is_injective: BOOLEAN is
			-- Is `current' injective ?
		do
			Result := range.count = count
		end

	contains_pair(v1:G; v2:H): BOOLEAN is
			-- Is the pair (`v1',`v2') contained in the relation ?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > count or Result
			loop
				Result := equal_value (a.item(i).first,v1) and equal_value(a.item(i).second,v2)
				i := i + 1
			end
		end

feature -- Basic Operations

	united (other: MML_SET [MML_PAIR [G, H]]): MML_RELATION [G, H] is
			-- The union of `current' and `other'.
		do
			Result := as_relation (Precursor(other))
		end

	intersected (other: MML_SET [MML_PAIR [G, H]]): MML_RELATION [G, H] is
			-- The intersection of `current' and `other'.
		do
			Result := as_relation (Precursor(other))
		end

	subtracted (other: MML_SET [MML_PAIR [G, H]]): MML_RELATION [G, H] is
			-- The difference of `current' and `other'.
		do
			Result := as_relation (Precursor(other))
		end

	difference (other: MML_SET [MML_PAIR [G, H]]): MML_RELATION [G, H] is
			-- The symmetric difference of `current' and `other'.
		do
			Result := as_relation (Precursor(other))
		end

	extended (v: MML_PAIR [G, H]): MML_RELATION [G, H] is
			-- The releation `current' extended with the pair `v'.
		do
			Result := as_relation (Precursor(v))
		end

	extended_by_pair (g:G;h:H): MML_RELATION[G,H] is
			-- The relation `current' extended with the pair `g,h'
		do
			Result := extended (create {MML_DEFAULT_PAIR[G,H]}.make_from(g,h))
		end

	pruned (v: MML_PAIR [G, H]): MML_RELATION [G, H] is
			-- The relation `current' with the pair `v' removed.
		do
			Result := as_relation (Precursor(v))
		end

feature -- Field

	domain: MML_SET [G] is
			-- The domain of `current'.
		local
			new_array: ARRAY [G]
			i,j: INTEGER
		do
			if count = 0 then
				create {MML_DEFAULT_SET[G]}Result.make_empty
			else
				create new_array.make(1,1)
				new_array.put(a.item(1).first,1)
				create {MML_DEFAULT_SET[G]}Result.make_from_array(new_array)
				from
					i := 2
					j := 2
				until
					i > count
				loop
					if not Result.contains (a.item(i).first) then
						new_array.force(a.item(i).first,j)
						j := j + 1
					end
					i := i + 1
				end
			end
		end

	range: MML_SET [H] is
			-- The range of `current'.
		local
			new_array: ARRAY [H]
			i,j: INTEGER
		do
			if count = 0 then
				create {MML_DEFAULT_SET[H]}Result.make_empty
			else
				create new_array.make(1,1)
				new_array.put(a.item(1).second,1)
				create {MML_DEFAULT_SET[H]}Result.make_from_array(new_array)
				from
					i := 2
					j := 2
				until
					i > count
				loop
					if not Result.contains (a.item(i).second) then
						new_array.force(a.item(i).second,j)
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Projections

	image_of (v: G): MML_SET [H] is
			-- The projected range set of `current' through `v'.
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SET[H]}Result.make_empty
			from
				i := 1
			until
				i > count
			loop
				if equal_value(v,a.item (i).first) then
					Result := Result.extended (a.item(i).second)
				end
				i := i + 1
			end
		end

	image (projection: MML_SET [G]): MML_SET [H] is
			-- The projected range set of `current' through `projection'.
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SET[H]}Result.make_empty
			from
				i := 1
			until
				i > count
			loop
				if projection.contains(a.item (i).first) then
					Result := Result.extended (a.item(i).second)
				end
				i := i + 1
			end
		end

	anti_image_of (v: H): MML_SET [G] is
			-- The projected domain set of `current' through `v'.
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SET[G]}Result.make_empty
			from
				i := 1
			until
				i > count
			loop
				if equal_value(v,a.item (i).second) then
					Result := Result.extended (a.item(i).first)
				end
				i := i + 1
			end
		end

	anti_image (projection: MML_SET [H]): MML_SET [G] is
			-- The projected domain set of `current' through `projection'.
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SET[G]}Result.make_empty
			from
				i := 1
			until
				i > count
			loop
				if projection.contains(a.item (i).second) then
					Result := Result.extended (a.item(i).first)
				end
				i := i + 1
			end
		end

	domain_restricted_by (v: G): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if equal_value(a.item(i).first,v) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	domain_restricted (restriction: MML_SET [G]): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if restriction.contains (a.item(i).first) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	range_restricted_by (v: H): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if equal_value(a.item(i).second,v) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	range_restricted (restriction: MML_SET [H]): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if restriction.contains (a.item(i).second) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	domain_anti_restricted_by (v: G): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not equal_value(a.item(i).first,v) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	domain_anti_restricted (restriction: MML_SET [G]): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not restriction.contains (a.item(i).first) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	range_anti_restricted_by (v: H): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not equal_value(a.item(i).second,v) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	range_anti_restricted (restriction: MML_SET [H]): MML_RELATION [G, H] is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		local
			new_array: ARRAY[MML_PAIR[G,H]]
			i,j:INTEGER
		do
			create new_array.make(1,1)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				if not restriction.contains (a.item(i).second) then
					new_array.force(a.item(i),j)
					j := j + 1
				end
				i := i + 1
			end
			if j > 1 then
				create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array(new_array)
			else
				create {MML_DEFAULT_RELATION[G,H]}Result.make_empty
			end
		end

	item (v: G): H is
			-- Lookup the value of `v' in the relation, if it is a function.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				equal_value (a.item(i).first,v)
			loop
				i := i + 1
			end
			Result := a.item(i).second
		end

feature -- Inversion

	inversed: MML_RELATION [H, G] is
			-- The inverse relation of `current'.
		local
			new_array: ARRAY[MML_PAIR[H,G]]
			new_pair: MML_DEFAULT_PAIR[H,G]
			i: INTEGER
		do
			if count = 0 then
				create {MML_DEFAULT_RELATION[H,G]}Result.make_empty
			else
				create new_array.make(1,count)
				from
					i := 1
				until
					i > count
				loop
					create new_pair.make_from (a.item (i).second,a.item (i).first)
					new_array.put (new_pair,i)
					i := i + 1
				end
				create {MML_DEFAULT_RELATION[H,G]}Result.make_from_array (new_array)
			end
		end

end
