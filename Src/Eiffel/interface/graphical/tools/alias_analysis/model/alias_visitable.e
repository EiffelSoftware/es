deferred class
	ALIAS_VISITABLE

inherit
	ANY
		undefine
			out
		end

feature {ANY}

	variables: HASH_TABLE [ALIAS_OBJECT, STRING_8]

	visited: BOOLEAN assign set_visited

	visiting_data: TWO_WAY_LIST [STRING_8]

feature {ANY}

	set_visited (a_visited: like visited)
		do
			visited := a_visited
		end

	add_visiting_data (a_data: STRING_8)
		do
			if visiting_data = Void then
				create visiting_data.make
			end
			visiting_data.extend (a_data)
		end
	
	clear_visiting_data
		do
			visiting_data := Void
		end

invariant
	variables /= Void

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
