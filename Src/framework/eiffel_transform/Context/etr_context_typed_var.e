note
	description: "Represents an argument or local with a name and a type"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT_TYPED_VAR
create
	make

feature {NONE} -- Creation

	make(a_name: like name; a_res_type: like resolved_type; a_org_type: like original_type)
			-- make with `a_name' and `a_type'
		require
			name_set: a_name /= void
			type_set: a_res_type /= void and a_org_type  /= void
			type_explicit: a_res_type.is_explicit
		do
			name := a_name
			resolved_type := a_res_type
			original_type := a_org_type
		end

feature -- Access
	name: STRING
	resolved_type, original_type: TYPE_A

feature -- Modification

	set_name(a_new_name: like name)
			-- set `name' to `a_new_name'
		require
			non_void: a_new_name /= void
		do
			name := a_new_name
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
