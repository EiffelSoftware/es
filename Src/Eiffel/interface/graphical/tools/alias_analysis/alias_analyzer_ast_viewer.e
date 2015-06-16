note
	description: "A general purpose AST viewer for inspecting/understanding the AST."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_AST_VIEWER

inherit
	EV_VERTICAL_BOX
	INTERNAL
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make

feature {NONE}

	tree: EV_TREE

	make
		do
			create tree
			tree.drop_actions.extend (agent on_stone_changed)

			default_create
			extend (tree)
		end

	reset
		do
			tree.wipe_out
		end

	on_stone_changed (a_stone: STONE)
		do
			reset
			if
				attached {FEATURE_STONE} a_stone as fs and then
				attached fs.e_feature as f
			then
				handle (tree, f.name_8, f.ast)
			end
		end

	handle (a_tree_parent: EV_TREE_NODE_LIST; a_field_name: STRING_8; a_ast_node: AST_EIFFEL)
		require
			a_tree_parent /= Void
			a_field_name /= Void
			a_ast_node /= Void
		local
			l_tree_node: EV_TREE_ITEM
			l_i, l_count: INTEGER_32
		do
			create l_tree_node.make_with_text (a_field_name + " -> " + a_ast_node.generating_type)
			a_tree_parent.extend (l_tree_node)

			if attached {EIFFEL_LIST [AST_EIFFEL]} a_ast_node as eiffel_list then
				across eiffel_list as c loop
					handle (l_tree_node, c.cursor_index.out, c.item)
				end
			else
				from
					l_i := 1
					l_count := field_count (a_ast_node)
				until
					l_i > l_count
				loop
					if attached {AST_EIFFEL} field (l_i, a_ast_node) as ast_child then
						handle (l_tree_node, field_name (l_i, a_ast_node), ast_child)
					end
					l_i := l_i + 1
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
