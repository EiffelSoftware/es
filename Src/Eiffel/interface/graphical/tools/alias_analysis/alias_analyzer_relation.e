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

create
	make

feature {NONE} -- Creation

	make
			-- Create an empty alias relation.
		do
			create table.make (0)
		end

feature -- Status report

	has_pair (x, y: G): BOOLEAN
			-- Is an alias pair for `x' and `y' present in this relation?
		do
			Result := attached table [x] as t and then t.has (y)
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
				end
				t.put (y)
					-- Insert a new association for `y'.
				t := table [y]
				if not attached t then
					create t.make (1)
					table [y] := t
				end
				t.put (x)
			end
		end

	add_relation (o: ALIAS_ANALYZER_RELATION [G])
			-- Add all pairs of `o' to the current relation.
			-- This corresponds to the operation
			--   r' := r ∪ o
		local
			t: SEARCH_TABLE [G]
		do
			across
				o.table as i
			loop
				t := table [i.key]
				if attached t then
						-- There is an association for `i.key' in current relation.
						-- Extend it with new items.
					t.merge (i.item)
				else
						-- There is no association for `i.key' in current relation.
						-- Add a new one.
					table [i.key] := i.item.twin
				end
			end
		end

	attach (s, t: G)
			-- Attach source `s' to target `t'.
		do
			if s /~ t then
					-- Remove all occurences of target.
					-- r' := r \- {target}
				remove (t)
					-- Make aliases of `s' to be aliases of `t'.
					-- r' := r' ∪ {target} × r' (source)
				if attached table [s] as a then
						-- Use aliases of `s' as aliases of `t'.
					table [t] := table [s].twin
						-- Alias target `t' with the aliases of `s'.
					from
						a.start
					until
						a.after
					loop
						table [a.item_for_iteration].put (t)
						a.forth
					end
				end
					-- Add one pair for `s' and `t'.
					-- r' := r' ∪ [target, source]
				add_pair (s, t)
			end
		end

	remove (x: G)
			-- Remove all pairs with `x'.
			-- This corresponds to the operation
			-- r' := r \- {target}
		do
			if attached table [x] as a then
					-- Remove `x' from all its aliases.
				from
					a.start
				until
					a.after
				loop
					check attached table [a.item_for_iteration] as y then
						if y.count = 1 then
								-- There is only one element that matches `x'.
							check y.has (x) end
								-- Remove aliases of `y' altogether.
							table.remove (a.item_for_iteration)
						else
								-- There are other aliases except `x'.
								-- Remove just this element.
							y.remove (x)
						end
					end
					a.forth
				end
					-- Remove aliases of `x'.
				table.remove (x)
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
				from
					a := i.item
					a.start
				until
					a.after
				loop
					Result.append_string (s)
					Result.append_string (a.item_for_iteration.out)
					s := ", "
					a.forth
				end
					-- Set delimiter for next items.
				t := "; "
			end
		end

feature {ALIAS_ANALYZER_RELATION} -- Storage

	table: HASH_TABLE [SEARCH_TABLE [G], G]
			-- Expressions, containing a specific item, indexed by this item.

invariant
	irreflexive: across table as i all not has_pair (i.key, i.key) end
	symmetric:
		across table as i all
			across table as j all
				i /~ j implies has_pair (i.key, j.key) = has_pair (j.key, i.key)
			end
		end

note
	copyright: "Copyright (c) 2012, Eiffel Software"
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
