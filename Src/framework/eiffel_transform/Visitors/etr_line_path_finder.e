note
	description: "Summary description for {ETR_LINE_PATH_FINDER}."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_LINE_PATH_FINDER
inherit
	ETR_BRANCH_VISITOR
create
	make_with_match_list

feature -- Access

	found: BOOLEAN
			-- Did we find what we we're looking for?

	found_path: AST_PATH
			-- The path we've found

feature -- Operation

	find_path_from_line(an_ast: AST_EIFFEL; a_line: like target_line)
			-- Process `an_ast' and determine the path of `a_line'
		do
			found := false
			found_path := void

			target_line := a_line

			create current_path.make_as_root (an_ast)
			an_ast.process(Current)
		end

feature {NONE} -- Creation

	make_with_match_list(a_match_list: like match_list)
			-- Make with `a_match_list'
		do
			match_list := a_match_list
		end

feature {NONE} -- Implementation

	target_line: INTEGER
			-- The line we're looking for

	match_list: LEAF_AS_LIST
			-- The match-list we're working with

	current_path: AST_PATH
			-- The path we're currently at

	process_n_way_branch(a_parent: AST_EIFFEL; br:TUPLE[AST_EIFFEL])
			-- process an n-way branch with parent `a_parent' and branches `br'
		local
			i: INTEGER
			l_prev_path: AST_PATH
		do
			if a_parent.is_text_available (match_list) and then (a_parent.first_token (match_list).line = target_line or a_parent.last_token (match_list).line = target_line) then
				found := true
				found_path := current_path
			else
				from
					i:=1
				until
					i>br.count
				loop
					if attached {AST_EIFFEL}br.item (i) as item then
						l_prev_path := current_path.twin
						create current_path.make_from_parent (current_path, i)
						item.process (Current)
						current_path := l_prev_path
					end
					i:=i+1
				end
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- process an EIFFEL_LIST
		local
			l_cursor: INTEGER
			i: INTEGER
			l_prev_path: AST_PATH
		do
			if l_as.is_text_available (match_list) and then l_as.first_token (match_list).line = target_line then
				found := true
				found_path := current_path
			else
				from
					l_cursor := l_as.index
					i:=1
					l_as.start
				until
					l_as.after
				loop
					l_prev_path := current_path.twin
					create current_path.make_from_parent (current_path, i)
					l_as.item.process (Current)
					current_path := l_prev_path
					l_as.forth
					i:=i+1
				end
				l_as.go_i_th (l_cursor)
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
