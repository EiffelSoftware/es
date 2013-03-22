note
	description: "Set of changed values."

class
	ALIAS_ANALYZER_CHANGE_SET [G -> HASHABLE]

inherit
	DEBUG_OUTPUT
		redefine
			copy,
			is_equal
		end

	ITERABLE [G]
		redefine
			copy,
			is_equal
		end

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty alias relation.
		do
			create storage.make (0)
		ensure
			is_empty
		end

feature -- Iteration

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		do
			Result := storage.new_cursor
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Are there no items in the set?
		do
			Result := storage.is_empty
		end

	has (x: G): BOOLEAN
			-- Is element `x' is the current set?
		do
			Result := storage.has (x)
		end

	is_subset (other: like Current): BOOLEAN
			-- Is current object a subset of `other'?
		do
			Result := across Current as c all other.has (c.item) end
		end

feature -- Modification

	put (x: G)
			-- Add an element to the set of changed values.
		do
			storage.put (x)
		end

	merge (other: ALIAS_ANALYZER_CHANGE_SET [G])
			-- Add all elements of `other' to the current set.
		do
			storage.merge (other.storage)
		end

	mapped (map: FUNCTION [ANY, TUPLE [G], G]): like Current
			-- Replace all items with the application of `map'.
		do
			create Result.make_empty
			across
				Current as x
			loop
				Result.put (map.item ([x.item]))
			end
		end

	wipe_out
			-- Empty the set.
		do
			storage.wipe_out
		end

feature -- Duplication

	copy (other: like Current)
			-- <Precursor>
		do
				-- Duplicate all the elements.
			storage := other.storage.twin
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := storage ~ other.storage
		end

feature -- Output

	debug_output: STRING
			-- <Precursor>
		local
			s: STRING
		do
			create Result.make_empty
				-- First item is not delimited with anything.
			s := ""
			across
				Current as c
			loop
				Result.append_string (s)
				Result.append_string (c.item.out)
				s := ", "
			end
		end

feature {ALIAS_ANALYZER_CHANGE_SET} -- Storage

	storage: SEARCH_TABLE [G]
			-- Expressions known to be changed.

invariant

note
	date: "$Date$"
	revision: "$Revision$"
	copyright: "Copyright (c) 2013, Eiffel Software"
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
