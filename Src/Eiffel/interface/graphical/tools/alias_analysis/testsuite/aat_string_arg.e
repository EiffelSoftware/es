note
	description: "[Alias Analysis] basic tests."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AAT_STRING_ARG

create
	make

feature -- Initialisation

	make
		do
			create obj.make
			v := ""
		end

feature

	obj : AAT_STRING_ARG
	v : STRING

	set_v(w : STRING)
		do
			v := w
		end

	test1
		note
				aliasing:
					"[
						Void: any
						NonVoid: any
						{AAT_STRING_ARG}.v: {AAT_STRING_ARG}.obj.{AAT_STRING_ARG}.v
						{AAT_STRING_ARG}.obj.{AAT_STRING_ARG}.v: {AAT_STRING_ARG}.v
					]"
		do
			obj.set_v(v)
		end

	test2
		note
				aliasing:
					"[
						Void: any
						NonVoid: any
					]"
		do
			obj.set_v("")
		end

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
