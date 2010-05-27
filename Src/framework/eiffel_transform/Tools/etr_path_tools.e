note
	description: "Helper function for path operations."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_PATH_TOOLS
inherit
	ETR_SHARED_TOOLS

feature {NONE} -- Implementation

	ast_locator: ETR_AST_LOCATOR
			-- shared instance of ETR_AST_LOCATOR
		once
			create Result
		end

feature -- Access

	found: BOOLEAN
			-- Did the last search find something?

	last_ast: AST_EIFFEL
			-- Ast found by last search

	last_feature_name: STRING
			-- Feature name found by last search

	last_path: AST_PATH
			-- Path found by last search

feature -- Operations

	find_constant_node_from_x_y (a_ast: AST_EIFFEL; a_matchlist: LEAF_AS_LIST; a_x, a_y: INTEGER)
			-- Finds a constant node at position `a_x'/`a_y' in `a_ast' with `a_matchlist'
			-- Results will be available in `last_ast' and `last_feature_name'
		local
			l_pos_finder: ETR_CONSTANT_CURSOR_POS_FINDER
		do
			create l_pos_finder.make_with_match_list (a_matchlist)
			l_pos_finder.init (a_x, a_y)
			l_pos_finder.find_from (a_ast)

			found := l_pos_finder.found
			last_ast := l_pos_finder.found_node
			last_feature_name := l_pos_finder.contained_feature_name
		end

	find_feature_from_line (a_ast: AST_EIFFEL; a_match_list: LEAF_AS_LIST; a_line: INTEGER)
			-- The feature `a_path' is in
			-- Result will be available in `last_feature_name'
		require
			all_set: a_ast/=void and a_match_list /= void
		local
			l_finder: ETR_PATH_FEATURE_FINDER
		do
			last_feature_name := void
			found := false

			create l_finder.make_with_match_list (a_match_list)
			l_finder.init (a_line)
			l_finder.find_from (a_ast)

			if l_finder.found and l_finder.is_feature then
				found := true
				last_feature_name := l_finder.feature_name
			end
		end

	find_path_from_line (a_ast: AST_EIFFEL; a_match_list: LEAF_AS_LIST; a_line: INTEGER)
			-- Gets a path from `a_line' in `a_match_list'
			-- Result will be available in `last_path'
		require
			non_void: a_match_list /= void and a_ast /= void
		local
			l_visitor: ETR_LINE_PATH_FINDER
		do
			found := false
			last_path := void

			create l_visitor.make_with_match_list (a_match_list)
			l_visitor.init (a_line)
			l_visitor.find_from (a_ast)

			if l_visitor.found then
				found := true
				last_path := l_visitor.found_path
			end
		end

	find_node (a_path: AST_PATH; a_root: AST_EIFFEL)
			-- Finds a node from `a_path' and root `a_root'
			-- Result will be available in `last_ast'
		require
			non_void: a_path /= void and a_root /= void
			path_valid: a_path.is_valid
		do
			found := false
			last_ast := void
			ast_locator.find_from_root (a_path, a_root)

			if ast_locator.found then
				found := true
				last_ast := ast_locator.found_node
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
