note
	description: "[Alias Analysis] basic tests."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AAT_BASIC

feature

	a, b: detachable STRING_8

	test1
		note
			aliasing:
				"[
					{AAT_BASIC}.a: {AAT_BASIC}.b
					{AAT_BASIC}.b: {AAT_BASIC}.a
				]"
		do
			a := "a"
			b := a
		end

	test2
		note
			aliasing1: ""
			aliasing2: ""
			aliasing3:
				"[
					{AAT_BASIC}.test2.l_a: {AAT_BASIC}.test2.l_b
					{AAT_BASIC}.test2.l_b: {AAT_BASIC}.test2.l_a
				]"
			aliasing4:
				"[
					{AAT_BASIC}.test2.l_a: {AAT_BASIC}.test2.l_b, {AAT_BASIC}.a
					{AAT_BASIC}.test2.l_b: {AAT_BASIC}.a, {AAT_BASIC}.test2.l_a
					{AAT_BASIC}.a: {AAT_BASIC}.test2.l_b, {AAT_BASIC}.test2.l_a
				]"
			aliasing5: ""
		local
			l_a: STRING_8
			l_b: STRING_8
		do
			l_a := "ab"
			l_b := l_a
			a := l_b

			a := a
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
