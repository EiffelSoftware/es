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
			-- Is `Current' a replace-operation?

	is_insert_before: BOOLEAN
			-- Is `Current' an insert-before-operation?

	is_insert_after: BOOLEAN
			-- Is `Current' an insert-after-operation?

	is_delete: BOOLEAN
			-- Is `Current' a delete-operation?

	is_list_prepend: BOOLEAN
			-- Is `Current' a list-prepend-operation?

	is_list_append: BOOLEAN
			-- Is `Current' a list-append-operation?

	is_list_put_ith: BOOLEAN
			-- Is `Current' a list-put-ith-operation?

	new_transformable: detachable ETR_TRANSFORMABLE
			-- Transformable to insert

	location: AST_PATH
			-- Location this modification will take place

	list_position: INTEGER
			-- Position of insert/deletion if list-operation

	replacement_text: detachable STRING
			-- Replacement text in replacement-operations

feature {COMPARABLE, ARRAY} -- Sorting

	is_less alias "<" (other: like Current): BOOLEAN
			-- Compares the branch_id's of the target_path's only!
		do
			Result := location.branch_id < other.location.branch_id
		end

feature {ETR_MODIFYING_PRINTER} -- Printing

	branch_id: INTEGER
			-- Branch id of the target position (i.e. last part of path)

	set_branch_id(a_branch_id: like branch_id)
			-- set `branch_id' to `a_branch_id'
		do
			branch_id := a_branch_id
		end

feature {NONE} -- Creation

	make_list_put_ith(a_list: like location; a_position: like list_position; a_replacement: like new_transformable)
			-- Replace item at position `a_position' in `a_list' by `a_replacement'
		do
			is_list_put_ith := true
			list_position := a_position

			location := a_list
			new_transformable := a_replacement
		end

	make_list_append(a_list: like location; a_replacement: like new_transformable)
			-- Append `a_replacement' to `a_list'
		do
			is_list_append := true

			location := a_list
			new_transformable := a_replacement
		end

	make_list_prepend(a_list: like location; a_replacement: like new_transformable)
			-- Prepend `a_replacement' to `a_list'
		do
			is_list_prepend := true

			location := a_list
			new_transformable := a_replacement
		end

	make_replace(a_reference: like location; a_replacement: like replacement_text)
			-- Replace `a_reference' by `a_replacement'
		do
			is_replace := true

			location := a_reference
			replacement_text := a_replacement
		end

	make_insert_before(a_reference: like location; a_new_trans: like new_transformable)
			-- Insert `a_new_trans' before `a_reference'
		do
			is_insert_before := true
			branch_id := a_reference.branch_id

			location := a_reference
			new_transformable := a_new_trans
		end

	make_insert_after(a_reference: like location; a_new_trans: like new_transformable)
			-- Insert `a_new_trans' after `a_reference'
		do
			is_insert_after := true
			branch_id := a_reference.branch_id

			location := a_reference
			new_transformable := a_new_trans
		end

	make_delete(a_reference: like location;)
			-- Delete `a_transformable'
		do
			is_delete := true

			location := a_reference
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
