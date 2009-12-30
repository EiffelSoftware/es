note
	description: "Summary description for {ETR_TRANSFORMABLE}."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORMABLE
inherit
	ETR_SHARED
		export
			{NONE} all
		end
create
	make_from_ast,
	make_invalid,
	make_from_ast_list

feature -- Access

	path: detachable AST_PATH
			-- path of `Current'
		do
			if attached target_node then
				Result := target_node.path
			end
		end

	context: detachable ETR_CONTEXT
	target_node: detachable AST_EIFFEL

	is_valid: BOOLEAN

feature -- creation

	make_from_ast(a_node: like target_node; a_context: like context; duplicate: BOOLEAN)
			-- make with `a_node' and `a_context'
		require
			non_void: a_node /= void and a_context /= void
		do
			if duplicate then
				duplicate_ast (a_node)
				target_node := duplicated_ast
			else
				target_node := a_node
			end

			context := a_context

			-- index it
			index_ast_from_root (target_node)

			is_valid := true
		end

	make_from_ast_list(a_list: LIST[like target_node]; a_context: like context; duplicate: BOOLEAN)
			-- make with `a_list' and `a_context'
		require
			non_void: a_list /= void and a_context /= void
		local
			l_eiffel_list: EIFFEL_LIST[AST_EIFFEL]
		do
			-- duplicate all items
			-- since we're gonna change their paths!
			from
				a_list.start
				create l_eiffel_list.make (a_list.count)
			until
				a_list.after
			loop
				if duplicate then
					duplicate_ast (a_list.item)
					l_eiffel_list.extend (duplicated_ast)
				else
					l_eiffel_list.extend (a_list.item)
				end

				a_list.forth
			end

			-- reindex it
			index_ast_from_root(l_eiffel_list)

			target_node := l_eiffel_list
			context := a_context
			is_valid := true
		end

	make_invalid
			-- make and mark as invalid
		do
			context := void
			target_node := void
			is_valid := false
		end
invariant
	valid_target: is_valid implies (attached target_node and attached context)
note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
