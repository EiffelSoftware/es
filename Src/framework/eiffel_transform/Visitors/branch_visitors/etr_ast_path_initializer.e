note
	description: "Iterates over all nodes and creates path-indexes."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_PATH_INITIALIZER
inherit
	ETR_BRANCH_VISITOR
		redefine
			process_binary_as
		end

feature -- Operation

	process_from_root (a_root: AST_EIFFEL)
			-- Process from `a_root'
		require
			root_set: a_root /= void
		do
			a_root.set_path (create {AST_PATH}.make_as_root(a_root))
			a_root.process (Current)
		end

	process_from (a_node: AST_EIFFEL)
			-- Process starting at `a_node'
		require
			node_set: a_node /= void
		do
			a_node.process(Current)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_binary_as (l_as: BINARY_AS)
		do
			-- The operator-name is a shared node, don't modify it
			process_branch(l_as, << l_as.left, void, l_as.right >>)
		end

feature {NONE} -- Implementation

	process_branch (a_parent: AST_EIFFEL; a_branches:ARRAY[detachable AST_EIFFEL])
			-- <precursor>
		local
			i: INTEGER
		do
			from
				i:=1
			until
				i>a_branches.count
			loop
				if attached a_branches[i] as item then
					item.set_path (create {AST_PATH}.make_from_parent (a_parent.path, i))

					item.process (Current)
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
