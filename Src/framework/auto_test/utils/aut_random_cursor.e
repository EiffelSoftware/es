note
	description: "Summary description for {AUT_RANDOM_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RANDOM_CURSOR [G]

create
	make

feature{NONE} -- Initialization

	make (a_storage: like storage; a_random: like random) is
			-- Initialize.
		require
			a_storage_attached: a_storage /= Void
			a_storage_index_valid: a_storage.lower = 1
			a_random_attached: a_random /= Void
		do
			storage := a_storage
			random := a_random
			unvisited_item_count := storage.count
			before := True
		end

feature -- Access

	item: G is
			-- Item at current position
		require
			not off
		do
			Result := item_cache
		end

feature -- Status report

	before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?

	after: BOOLEAN
			-- Is there no valid position to right of cursor?

	off: BOOLEAN is
			-- Is there a valid position under current cursor?
		do
			Result := before or after
		ensure
			good_result: Result = (before or after)
		end

	is_last: BOOLEAN is
			-- Is current position the last position?
		do
			Result := not off and then unvisited_item_count = 1
		end

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		do
			internal_forth
		end

	forth is
			-- Move cursor to next position.
		require
			not_after: not after
		do
			internal_forth
		end


feature{NONE} -- Implementation

	storage: ARRAY [G]
			-- Storage of all items in current cursor

	random: RANDOM
			-- Random number generator

	unvisited_item_count: INTEGER
			-- Number of items in storage that are not visited

	internal_forth is
			-- Forth to the next item.
		local
			l_index: INTEGER
			l_var: G
			l_item: G
			l_storage: like storage
		do
			if unvisited_item_count = 0 then
				after := True
			else
				l_storage := storage
				random.forth
				l_index := (random.item \\ unvisited_item_count) + 1
				l_var := l_storage.item (unvisited_item_count)
				l_item := l_storage.item (l_index)
				l_storage.put (l_item, unvisited_item_count)
				l_storage.put (l_var, l_index)
				unvisited_item_count := unvisited_item_count - 1
				item_cache := l_item
				before := False
			end
		end

	item_cache: like item
			-- Cache for `item'

invariant
	storage_attached: storage /= Void
	storage_index_valid: storage.lower = 1
	random_attached: random /= Void

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
