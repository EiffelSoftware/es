note
	description: "Represents an object local for easy access by EiffelTransform"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_OBJECT_TEST_LOCAL
inherit
	ETR_TYPED_VAR
create
	make_at

feature -- Access
	scope: LIST[AST_PATH]
			-- Scope of this object-test-local

	is_active_at(a_path: AST_PATH): BOOLEAN
			-- is `Current' active at `a_path'
		do
			from
				scope.start
			until
				scope.after or Result
			loop
				if a_path.is_child_of (scope.item) then
					Result := true
				end
				scope.forth
			end
		end

feature {NONE} -- Creation

	make_at(a_name: like name; a_res_type: like resolved_type; a_org_type: like original_type; a_scope: like scope)
			-- create with `a_name', `a_type', `a_scope'
		require
			name_set: a_name /= void
			type_set: a_res_type /= void and a_org_type  /= void
			type_explicit: a_res_type.is_explicit
			scope_set: a_scope /= void
		do
			make(a_name, a_res_type, a_org_type)

			scope := a_scope.twin
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
