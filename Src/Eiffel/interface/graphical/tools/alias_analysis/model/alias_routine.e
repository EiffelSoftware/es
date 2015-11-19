class
	ALIAS_ROUTINE

inherit
	ALIAS_VISITABLE
		rename
			variables as locals
		end

create {ALIAS_GRAPH}
	make

feature {NONE}

	make (a_current_object: like current_object; a_routine: like routine; a_locals: like locals)
		require
			a_current_object /= Void
			a_routine /= Void
			a_locals /= Void
		do
			current_object := a_current_object
			routine := a_routine
			locals := a_locals
		ensure
			current_object = a_current_object
			routine = a_routine
			locals = a_locals
		end

feature {ANY}

	current_object: ALIAS_OBJECT

	routine: PROCEDURE_I

feature {ANY}

	out: STRING_8
		do
			Result := current_object.out + "." + routine.feature_name_32
		end

invariant
	routine /= Void
	current_object /= Void

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
