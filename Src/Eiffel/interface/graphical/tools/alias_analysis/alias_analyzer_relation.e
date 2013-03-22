note
	description: "Relation computed during alias analisys."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_RELATION [G -> HASHABLE]

inherit
	DEBUG_OUTPUT
		redefine
			copy,
			is_equal
		end

create
	make

create {ALIAS_ANALYZER_RELATION}
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty alias relation.
		do
			create table.make (0)
		end

	make (any_aliases: ARRAY [G])
			-- Create an alias relation with special entries `any_aliases' known to be aliased to anything.
		do
			create table.make (any_aliases.count)
			across
				any_aliases as c
			loop
				add_any (c.item)
			end
		end

feature -- Status report

	has_pair (x, y: G): BOOLEAN
			-- Is an alias pair for `x' and `y' present in this relation?
		do
			Result :=
				attached table [x] as t and then (t.is_empty or else t.has (y)) or else
				attached table [y] as t and then t.is_empty
		end

	is_subset (other: like Current): BOOLEAN
			-- Is current object a subset of `other'?
		local
			yy: like table.new_cursor
			xx: like table.item.new_cursor
		do
			Result := across
				table as y
			all
				(y.item.is_empty implies
					(attached other.table [y.key] as z and then z.is_empty)) and then
				(not y.item.is_empty implies
					across y.item as x all other.has_pair (x.item, y.key) end)
			end
			if not Result then
					-- TODO: remove this debug loop.
				from
					yy := table.new_cursor
				until
					yy.after
				loop
					if yy.item.is_empty then
--						if not (attached other.table [yy.key] as z and then z.is_empty) then
--							io.put_string (yy.key.out)
--							io.put_string (".")
--						end
					else
						from
							xx := yy.item.new_cursor
						until
							xx.after
						loop
							if not other.has_pair (xx.item, yy.key) and then has_pair (xx.item, yy.key) /= has_pair (yy.key, xx.item) then
								io.put_string (yy.key.out)
								io.put_string (":")
								io.put_string (xx.item.out)
								io.put_string (".")
							end
							xx.forth
						end
					end
					yy.forth
				end
			end
		end

feature -- Modification

	add_pair (x, y: G)
			-- Add an alias pair for `x' and `y'.
			-- This corresponds to the operation
			--   r' := r ∪ {[x, y], [y, x]}
		local
			t: SEARCH_TABLE [G]
		do
			if x /~ y then
					-- Insert a new association for `x'.
				t := table [x]
				if not attached t then
					create t.make (1)
					table [x] := t
					t.put (y)
				elseif not t.is_empty then
					t.put (y)
					if t.count > maximum_alias_count then
							-- Remove `x' from all the associations.
						remove (x)
							-- `table [x]' is now Void.
							-- Set it to "any item" table.
						t.wipe_out
						table [x] := t
					end
				end
					-- Insert a new association for `y'.
				t := table [y]
				if not attached t then
					create t.make (1)
					table [y] := t
					t.put (x)
				elseif not t.is_empty then
					t.put (x)
					if t.count > maximum_alias_count then
							-- Remove `y' from all the associations.
						remove (y)
							-- `table [y]' is now Void.
							-- Set it to "any item" table.
						t.wipe_out
						table [y] := t
					end
				end
			end
		end

	add_any (x: G)
			-- Add all possible pairs for `x'.
			-- This corresponds to the operation
			--   r' := r ∪ {[x, y], [y, x] | for any y}
		local
			t: SEARCH_TABLE [G]
		do
				-- Insert a new association for `x'.
			t := table [x]
			if not attached t then
				create t.make (0)
				table [x] := t
			else
					-- Remove `x' from all the associations.
				remove (x)
					-- `table [x]' is now Void.
					-- Set it to "any item" table.
				t.wipe_out
				table [x] := t
			end
		end

	add_relation (o: ALIAS_ANALYZER_RELATION [G])
			-- Add all pairs of `o' to the current relation.
			-- This corresponds to the operation
			--   r' := r ∪ o
		local
			other_items: like table.item
		do
			across
				o.table as i
			loop
				other_items := i.item
				if other_items.is_empty then
						-- The item can be aliased to anything.
						-- The next condition is an optimization to avoid removing and re-adding an empty table.
					if not attached table [i.key] as t or else not t.is_empty then
							-- Remove `i.key' from all the associations.
						remove (i.key)
						table [i.key] := other_items
					end
				elseif not attached table [i.key] as t then
						-- There is no association for `i.key' in current relation.
						-- Add a new one.
					table [i.key] := other_items.twin
				elseif not t.is_empty then
						-- There is an association for `i.key' in current relation.
						-- Extend it with new items.
					t.merge (i.item)
					if t.count > maximum_alias_count then
							-- The item can be aliased to anything.
							-- Remove `i.key' from all the associations.
						remove (i.key)
						t.wipe_out
						table [i.key] := t
					end
				end
			end
		end

	remove (x: G)
			-- Remove all pairs with `x'.
			-- This corresponds to the operation
			-- r' := r \- {target}
		do
			if attached table [x] as a then
					-- Remove `x' from all its aliases.
				if not a.is_empty then
					from
						a.start
					until
						a.after
					loop
						if attached table [a.item_for_iteration] as y and then not y.is_empty then
							y.remove (x)
							if y.is_empty then
									-- There are no more aliases for `y'.
									-- Remove the entry of `y' altogether.
								table.remove (a.item_for_iteration)
							end
						end
						a.forth
					end
				end
					-- Remove aliases of `x'.
				table.remove (x)
			end
		end

	remove_pair (x, y: G)
			-- Remove an alias pair for `x' and `y'.
			-- This corresponds to the operation
			--   r' := r - {[x, y], [y, x]}
		do
			if x /~ y then
					-- Remove an association for `x'.
				if attached table [x] as t and then not t.is_empty then
					t.remove (y)
					if t.is_empty then
						table.remove (x)
					end
				end
					-- Remove an association for `y'.
				if attached table [y] as t and then not t.is_empty then
					t.remove (x)
					if t.is_empty then
						table.remove (y)
					end
				end
			end
		end

	mapped (map: FUNCTION [ANY, TUPLE [G], G]): like Current
			-- Replace all items with the application of `map'.
		local
			old_table: like table.item
			new_table: like table.item
		do
			create Result.make_empty
			across
				table as y
			loop
				old_table := y.item
				if old_table.is_empty then
					create new_table.make (0)
				else
					create new_table.make (old_table.count)
					across
						old_table as x
					loop
						new_table.put (map.item ([x.item]))
					end
				end
				Result.table [map.item ([y.key])] := new_table
			end
		end

	wipe_out
			-- Empty the relation.
		do
			table.wipe_out
		end

feature -- Duplication

	copy (other: like Current)
			-- <Precursor>
		local
			other_table_items: like table.item
		do
				-- Duplicate all the elements
				-- except for a special placeholder.
			table := other.table.twin
			create table.make (other.table.count)
			across
				other.table as c
			loop
				other_table_items := c.item
				if not other_table_items.is_empty then
					table [c.key] := other_table_items.twin
				else
					table [c.key] := other_table_items.twin
				end
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := is_subset (other) and then other.is_subset (Current)
		end

feature -- Iteration

	aliases (x: G): ITERABLE [G]
			-- Enumeration of aliases of `x'.
		do
			if attached table [x] as a then
				Result := a
			else
				create {SPECIAL [G]} Result.make_empty (0)
			end
		end

feature -- Output

	debug_output: STRING
			-- <Precursor>
		local
			a: SEARCH_TABLE [G]
			s: STRING
			t: STRING
		do
			create Result.make_empty
				-- First item is not delimited with anything.
			t := ""
			across
				table as i
			loop
					-- Output alias for `i.key' in a format "x: a, b, c".
				Result.append_string (t)
				Result.append_string (i.key.out)
				s := ": "
				a := i.item
				if a.is_empty then
					Result.append_string (s)
					Result.append_string ("any")
				else
					from
						a.start
					until
						a.after
					loop
						Result.append_string (s)
						Result.append_string (a.item_for_iteration.out)
						s := ", "
						a.forth
					end
				end
					-- Set delimiter for next items.
				t := "; "
			end
		end

feature {ALIAS_ANALYZER_RELATION, ALIAS_ANALYZER} -- Storage

	table: HASH_TABLE [SEARCH_TABLE [G], G]
			-- Expressions, containing a specific item, indexed by this item.

	maximum_alias_count: INTEGER = 10
			-- Maximum number of elements that can be aliased to a given one
			-- before considering it to be aliased to anything.

invariant
--	irreflexive: across table as i all not has_pair (i.key, i.key) end
	symmetric:
		across table as i all
			across table as j all
				has_pair (i.key, j.key) = has_pair (j.key, i.key)
			end
		end

note
	copyright: "Copyright (c) 2012-2013, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
