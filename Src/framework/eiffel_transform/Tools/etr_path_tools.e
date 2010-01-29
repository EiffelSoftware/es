note
	description: "Helper function for path operations"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_PATH_TOOLS
inherit
	ETR_SHARED_PATH_TOOLS

feature {NONE} -- Implementation

	ast_locator: ETR_AST_LOCATOR
			-- shared instance of ETR_AST_LOCATOR
		once
			create Result
		end

feature -- Operations

	path_from_line(a_ast: AST_EIFFEL; a_match_list: LEAF_AS_LIST; a_line: INTEGER): detachable AST_PATH
			-- Gets a path from a line in a match list
		require
			non_void: a_match_list /= void and a_ast /= void
		local
			l_visitor: ETR_LINE_PATH_FINDER
		do
			create l_visitor.make_with_match_list (a_match_list)
			l_visitor.find_path_from_line (a_ast, a_line)

			if l_visitor.found then
				Result := l_visitor.found_path
			end
		end

	find_node(a_path: AST_PATH; a_root: AST_EIFFEL): detachable AST_EIFFEL
			-- finds a node from `a_path' and root `a_root'
		require
			non_void: a_path /= void and a_root /= void
			path_valid: a_path.is_valid
		do
			ast_locator.find_from_root (a_path, a_root)

			if ast_locator.found then
				Result := ast_locator.found_node
			end
		end

	index_ast_from_root(an_ast: AST_EIFFEL)
			-- indexes and ast with root `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from_root(an_ast)
		end

	reindex_ast(an_ast: AST_EIFFEL) is
			-- reindexes `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from(an_ast)
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
