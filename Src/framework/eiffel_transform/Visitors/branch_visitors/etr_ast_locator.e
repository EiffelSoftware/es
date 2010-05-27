note
	description: "Locates a node based on a root and a path expression."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_LOCATOR
inherit
	ETR_BRANCH_VISITOR

feature -- Access

	found: BOOLEAN
			-- Has the node been found?

	found_node: detachable AST_EIFFEL
			-- The node that has been found

feature -- Creation

	find_from_root (a_path: AST_PATH; a_root: AST_EIFFEL)
			-- Starting from `a_root' find a node by following `a_path'
		require
			non_void: a_path /= void and a_root /= void
			path_valid: a_path.is_valid
		do
			found := false
			found_node := void

			path := a_path
			current_position := path.as_array.lower

			if path.as_array.count = 1 then
				found := true
				found_node := a_root
			else
				a_root.process (Current)
			end
		end

feature {NONE} -- Implementation

	process_branch (a_parent: AST_EIFFEL; a_branches:ARRAY[detachable AST_EIFFEL])
			-- <precursor>
		local
			l_next_br_number: INTEGER
		do
			l_next_br_number := next_branch

			if current_position = path.as_array.upper-1 then
				if l_next_br_number <= a_branches.count then
					if attached a_branches[l_next_br_number] as item then
						found_node := item
					else
						found_node := void
					end
					found := true
				end
			elseif current_position < path.as_array.upper then
				current_position := current_position+1
				if attached a_branches[l_next_br_number] as next then
					next.process(Current)
				end
			end
		end

	path: detachable AST_PATH
		-- The location we're looking for

	current_position: INTEGER
		-- current position in `path'

	next_branch: INTEGER
			-- next branch to take
		require
			in_range: current_position<path.as_array.upper
		do
			Result := path.as_array.item (current_position+1)
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
