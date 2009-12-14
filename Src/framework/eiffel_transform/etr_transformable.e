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
	make_with_path,
	make_with_node

-- todo:
-- helper functions (as_expr etc)

feature -- Access

	scope: AST_PATH
	context: ETR_CONTEXT

	target_node: AST_EIFFEL is
			-- target of scope, computed lazily
		do
			if internal_taget_node=void then
				compute_target_node
			end
			Result := internal_taget_node
		end

feature {NONE} -- Implementation

	internal_taget_node: AST_EIFFEL

	compute_target_node is
			-- compute internal_taget_node
		do
			internal_taget_node := find_node(scope)
		end

feature -- creation

	make_with_node(a_node: like target_node; a_context: like context) is
			-- make with node and context
		require
			non_void: a_node /= void and a_context /= void
			has_path: a_node.path /= void
			valid_path: a_node.path.is_valid
		do
			internal_taget_node := a_node
			context := a_context
			scope := a_node.path
		end

	make_with_path(a_scope: like scope; a_context: like context) is
			-- create with 'a_node' and 'a_context'
		require
			non_void: a_scope /= void and a_context /= void
		do
			scope := a_scope
			context := a_context
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
