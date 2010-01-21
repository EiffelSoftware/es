note
	description: "Represents an object local for easy access by EiffelTransform"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_OBJECT_TEST_LOCAL
inherit
	ETR_SHARED
create
	make

feature -- Access

	name: STRING
	type: detachable TYPE_A
	scope: AST_PATH

	is_active_at(a_path: like scope): BOOLEAN
			-- is `Current' active at `a_path'
		do
			Result := a_path.is_child_of(scope)
		end

feature {NONE} -- Creation

	make(a_name: like name; a_type: like type; a_scope: like scope)
			-- create with `a_name', `a_type', `a_scope'
		require
			name_and_scope_set: a_name /= void and a_scope /= void
		do
			name := a_name
			type := a_type
			scope := a_scope
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
