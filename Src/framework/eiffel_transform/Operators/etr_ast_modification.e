note
	description: "Represents a modification in an ast"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_MODIFICATION
create {ETR_BASIC_OPS,ETR_AST_MODIFIER}
	make_replace,
	make_insert_after,
	make_insert_before,
	make_delete

feature -- Access

	is_replace: BOOLEAN
	is_insert_before: BOOLEAN
	is_insert_after: BOOLEAN
	is_delete: BOOLEAN

	new_transformable: detachable ETR_TRANSFORMABLE
	ref_ast: AST_EIFFEL

feature {NONE} -- Creation

	make_replace(a_reference: AST_EIFFEL; a_replacement: ETR_TRANSFORMABLE)
				-- Replace `a_reference' by `a_replacement'
		do
			is_replace := true

			ref_ast := a_reference
			new_transformable := a_replacement
		end

	make_insert_before(a_reference: AST_EIFFEL; a_new_trans: ETR_TRANSFORMABLE)
				-- Insert `a_new_trans' before `a_reference'
		do
			is_insert_before := true

			ref_ast := a_reference
			new_transformable := a_new_trans
		end

	make_insert_after(a_reference: AST_EIFFEL; a_new_trans: ETR_TRANSFORMABLE)
				-- Insert `a_new_trans' after `a_reference'
		do
			is_insert_after := true

			ref_ast := a_reference
			new_transformable := a_new_trans
		end

	make_delete(a_reference: AST_EIFFEL;)
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
