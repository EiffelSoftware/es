note
	description: "Represents a modification in an ast"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_MODIFICATION
inherit
	COMPARABLE
create {ETR_BASIC_OPS,ETR_MODIFYING_PRINTER}
	make_replace,
	make_insert_after,
	make_insert_before,
	make_delete,
	make_list_prepend,
	make_list_append,
	make_list_put_ith

feature -- Access

	is_replace: BOOLEAN
	is_insert_before: BOOLEAN
	is_insert_after: BOOLEAN
	is_delete: BOOLEAN
	is_list_prepend: BOOLEAN
	is_list_append: BOOLEAN
	is_list_put_ith: BOOLEAN

	new_transformable: detachable ETR_TRANSFORMABLE
	ref_ast: AST_PATH

	list_position: INTEGER


feature {COMPARABLE, ARRAY} -- Sorting

	is_less alias "<" (other: like Current): BOOLEAN
			-- Compares the branch_id's of the target_path's only!
		do
			Result := ref_ast.branch_id < other.ref_ast.branch_id
		end

feature {ETR_MODIFYING_PRINTER} -- Printing

	replacement_text: detachable STRING
	branch_id: INTEGER

	set_branch_id(a_branch_id: like branch_id)
			-- set `branch_id' to `a_branch_id'
		do
			branch_id := a_branch_id
		end

	set_replacement_text(a_text: like replacement_text)
			-- set `replacement_text' to `a_text'
		do
			replacement_text := a_text
		end

feature {NONE} -- Creation

	make_list_put_ith(a_list: like ref_ast; a_position: like list_position; a_replacement: like new_transformable)
			-- Replace item at position `a_position' in `a_list' by `a_replacement'
		do
			is_list_put_ith := true
			list_position := a_position

			ref_ast := a_list
			new_transformable := a_replacement
		end

	make_list_append(a_list: like ref_ast; a_replacement: like new_transformable)
			-- Append `a_replacement' to `a_list'
		do
			is_list_append := true

			ref_ast := a_list
			new_transformable := a_replacement
		end

	make_list_prepend(a_list: like ref_ast; a_replacement: like new_transformable)
			-- Prepend `a_replacement' to `a_list'
		do
			is_list_prepend := true

			ref_ast := a_list
			new_transformable := a_replacement
		end

	make_replace(a_reference: like ref_ast; a_replacement: like new_transformable)
			-- Replace `a_reference' by `a_replacement'
		do
			is_replace := true

			ref_ast := a_reference
			new_transformable := a_replacement
		end

	make_insert_before(a_reference: like ref_ast; a_new_trans: like new_transformable)
			-- Insert `a_new_trans' before `a_reference'
		do
			is_insert_before := true
			branch_id := a_reference.branch_id

			ref_ast := a_reference
			new_transformable := a_new_trans
		end

	make_insert_after(a_reference: like ref_ast; a_new_trans: like new_transformable)
			-- Insert `a_new_trans' after `a_reference'
		do
			is_insert_after := true
			branch_id := a_reference.branch_id

			ref_ast := a_reference
			new_transformable := a_new_trans
		end

	make_delete(a_reference: like ref_ast;)
			-- Delete `a_transformable'
		do
			is_delete := true

			ref_ast := a_reference
		end

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
