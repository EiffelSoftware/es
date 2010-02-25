note
	description: "Finds stuff in an ast with no path information."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETR_PATH_FINDER
inherit
	ETR_BRANCH_VISITOR

feature -- Access

	found: BOOLEAN
			-- Did we find what we we're looking for?

	found_path: AST_PATH
			-- The path we've found

	found_node: AST_EIFFEL
			-- The node we've found

feature -- Operation

	find_from(a_ast: AST_EIFFEL)
			-- Find from `a_ast'
		do
			found := false
			found_path := void
			found_node := void

			create current_path.make_as_root (a_ast)

			if is_target(a_ast) then
				found := true
				found_path := current_path
				found_node := a_ast
			else
				a_ast.process(Current)
			end
		end

feature {NONE} -- Creation

	make_with_match_list(a_match_list: like match_list)
			-- Make with `a_match_list'
		do
			match_list := a_match_list
		end

feature {NONE} -- Implementation

	match_list: LEAF_AS_LIST
			-- The match-list we're working with

	current_path: AST_PATH
			-- The path we're currently at

	is_target(a_ast: AST_EIFFEL): BOOLEAN
			-- is `a_ast' the target?
		deferred
		end

	process_branch(a_parent: AST_EIFFEL; a_branches:ARRAY[detachable AST_EIFFEL])
			-- process an n-way branch with parent `a_parent' and `a_branches'
		local
			i: INTEGER
			l_prev_path: AST_PATH
		do
			from
				i:=1
			until
				i>a_branches.count or found
			loop
				if attached a_branches[i] as item then
					l_prev_path := current_path.twin
					create current_path.make_from_parent (current_path, i)
					if is_target(item) then
						found := true
						found_path := current_path
						found_node := item
					else
						item.process (Current)
					end

					current_path := l_prev_path
				end
				i:=i+1
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
