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
	make_from_node,
	make_invalid

feature -- Access

	path: AST_PATH
	context: ETR_CONTEXT
	target_node: AST_EIFFEL

	is_valid: BOOLEAN

feature -- creation

	make_from_node(a_node: like target_node; a_context: like context) is
			-- make with `a_node' and `a_context'
		require
			non_void: a_node /= void and a_context /= void
			has_path: a_node.path /= void
			valid_path: a_node.path.is_valid
		do
			target_node := a_node
			context := a_context
			path := a_node.path

			is_valid := true
		end

	make_invalid is
			-- make and mark as invalid
		do
			path := void
			context := void
			target_node := void

			is_valid := false
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
