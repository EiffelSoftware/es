note
	description: "A general purpose AST viewer for inspecting/understanding the AST."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_AST_VIEWER

inherit
	EV_HORIZONTAL_SPLIT_AREA
	INTERNAL
		undefine
			default_create,
			is_equal,
			copy
		end
	SHARED_SERVER
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make

feature {NONE}

	ast_view: EV_TREE

	code_view: EV_TEXT

	current_class: CLASS_AS

	make
		local
			l_ast_box, l_code_box: EV_VERTICAL_BOX
		do
			create ast_view
			ast_view.drop_actions.extend (agent on_stone_changed)
			ast_view.select_actions.extend (agent on_selection_changed)

			create code_view
			code_view.disable_edit

			create l_ast_box
			l_ast_box.extend (create {EV_LABEL}.make_with_text ("AST:"))
			l_ast_box.disable_item_expand (l_ast_box.last)
			l_ast_box.extend (ast_view)

			create l_code_box
			l_code_box.extend (create {EV_LABEL}.make_with_text ("Source Code:"))
			l_code_box.disable_item_expand (l_code_box.last)
			l_code_box.extend (code_view)

			default_create
			extend (l_ast_box)
			extend (l_code_box)
			set_split_position (400)
		end

	reset
		do
			ast_view.wipe_out
			code_view.set_text ("")
			current_class := Void
		end

	on_stone_changed (a_stone: STONE)
		do
			reset
			if
				attached {FEATURE_STONE} a_stone as fs and then
				attached fs.e_class as c and then
				attached fs.e_feature as f
			then
				current_class := c.ast
				handle (ast_view, f.name_8, f.ast)
			end
		end

	on_selection_changed
		local
			l_code: STRING_32
			l_pretty_printer: PRETTY_PRINTER
		do
			create l_code.make_empty
			if
				attached ast_view.selected_item as tree_node and then
				attached {AST_EIFFEL} tree_node.data as ast_node
			then
				create l_pretty_printer.make (create {PRETTY_PRINTER_OUTPUT_STREAM}.make_string (l_code))
				l_pretty_printer.setup (current_class, Match_list_server.item (current_class.class_id), True, True)
				l_pretty_printer.process_ast_node (ast_node)
				cleanup (l_code)
			end
			code_view.set_text (l_code)
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
			l_tree_node.set_data (a_ast_node)
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

	cleanup (a_code: STRING_32)
		require
			a_code /= Void
		local
			l_min, l_line_min: INTEGER_32
		do
			-- remove leading empty line
			if a_code.starts_with ("%N") then
				a_code.remove_head (1)
			end

			-- unindent
			l_min := {INTEGER_32}.Max_value
			across a_code.split ('%N') as line_curser loop
				l_line_min := 0
				across
					line_curser.item as char_cursor
				until
					char_cursor.item /= '%T'
				loop
					l_line_min := l_line_min + 1
				end
				l_min := l_min.min (l_line_min)
			end
			if l_min > 0 then
				a_code.remove_head (l_min)
				a_code.replace_substring_all ("%N" + create {STRING_32}.make_filled ('%T', l_min), "%N")
			end
		end

invariant
	ast_view /= Void
	code_view /= Void

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
