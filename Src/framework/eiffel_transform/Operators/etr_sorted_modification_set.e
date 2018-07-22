note
	description: "Set of modifications, grouped by parent and insertions sorted by branch id."
	date: "$Date$"
	revision: "$Revision$"
class
	ETR_SORTED_MODIFICATION_SET
create {ETR_AST_STRUCTURE_PRINTER}
	make

feature {NONE} -- Creation

	make
			-- make empty structure
		do
			create par_groups.make
		end

feature {NONE} -- Implementation
	par_groups: LINKED_LIST[TUPLE[AST_PATH,LINKED_LIST[ETR_AST_MODIFICATION]]]
			-- Modifications grouped by their parent-list

feature -- Operations

	item alias "[]" (a_path: AST_PATH): detachable ARRAY[ETR_AST_MODIFICATION]
			-- item by path
		local
			l_par_items: LINKED_LIST[ETR_AST_MODIFICATION]
			l_sorted_array: SORTABLE_ARRAY[ETR_AST_MODIFICATION]
			i: INTEGER
		do
			-- find parent group
			from
				par_groups.start
			until
				par_groups.after or l_par_items /= void
			loop
				if attached {AST_PATH}par_groups.item.item(1) as path and then attached {LINKED_LIST[ETR_AST_MODIFICATION]}par_groups.item.item(2) as list and then path.is_equal(a_path) then
					l_par_items := list
				end
				par_groups.forth
			end

			-- sort
			if attached l_par_items then
				create l_sorted_array.make(1,l_par_items.count)

				from
					l_par_items.start
					i:=1
				until
					l_par_items.after
				loop
					l_sorted_array.force (l_par_items.item, i)
					l_par_items.forth
					i:=i+1
				end

				if not l_par_items.is_empty and then (l_par_items.first.is_insert_after or l_par_items.first.is_insert_before) then
					l_sorted_array.sort
				end

				Result := l_sorted_array
			end
		end

	extend (a_modification: ETR_AST_MODIFICATION)
				-- extend by `a_modification'
		require
			non_void: a_modification /= void
			compat_mod: a_modification.is_insert_after or a_modification.is_insert_before or a_modification.is_list_append or a_modification.is_list_prepend
		local
			l_par_items: LINKED_LIST[ETR_AST_MODIFICATION]
			l_par_group: TUPLE[AST_PATH,LINKED_LIST[ETR_AST_MODIFICATION]]
			l_path_index: AST_PATH
		do
			if a_modification.is_insert_after or a_modification.is_insert_before then
				l_path_index := a_modification.location.parent_path
			else -- append/prepend
				l_path_index := a_modification.location
			end

			-- check if parent group exists
			from
				par_groups.start
			until
				par_groups.after or attached l_par_group
			loop
				if attached {AST_PATH}par_groups.item.item(1) as path and then attached {LINKED_LIST[ETR_AST_MODIFICATION]}par_groups.item.item(2) as list and then path.is_equal(l_path_index) then
					l_par_group := par_groups.item
					list.extend (a_modification)
				end
				par_groups.forth
			end

			-- create it
			if not attached l_par_group then
				create l_par_items.make
				l_par_items.extend (a_modification)
				par_groups.extend ([l_path_index, l_par_items])
			end
		end

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
