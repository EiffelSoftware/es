note
	description: "[Alias Analysis] basic tests."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AAT_BASIC

feature

	a, b, c: detachable STRING_8

	test_simple_assignment
		note
			aliasing: "{AAT_BASIC}.test_simple_assignment.l_a, {AAT_BASIC}.test_simple_assignment.l_b"
		local
			l_a: detachable STRING_8
			l_b: detachable STRING_8
		do
			l_a := "a"
			l_b := l_a
		end

	test_void_assignment
		note
			aliasing: "{AAT_BASIC}.test_void_assignment.l_a, {AAT_BASIC}.test_void_assignment.l_c"
		local
			l_a: detachable STRING_8
			l_b: detachable STRING_8
			l_c: detachable STRING_8
		do
			l_a := "a"
			l_b := l_a
			l_c := l_b
			l_b := Void
		end

	test_void_assignment_2
		note
			aliasing3: "{AAT_BASIC}.a, {AAT_BASIC}.b"
			aliasing: ""
		do
			a := "a"
			b := a
			a := Void
		end

	test_void_assignment_3
		note
			aliasing4: "{AAT_BASIC}.a, {AAT_BASIC}.b, {AAT_BASIC}.c"
			aliasing: "{AAT_BASIC}.a, {AAT_BASIC}.c"
		do
			a := "a"
			b := a
			c := b
			b := Void
		end

--	test_if (a_b: BOOLEAN)
--		note
--			aliasing: "{AAT_BASIC}.test_if.l_a, {AAT_BASIC}.test_if.l_b"
--		local
--			l_a: detachable STRING_8
--			l_b: detachable STRING_8
--		do
--			if a_b then
--				l_a := "a"
--				l_b := l_a
--			else
--				-- nothing
--			end
--		end

--	test_if_2 (a_b: BOOLEAN)
--		note
--			aliasing: "{AAT_BASIC}.test_if_2.l_a, {AAT_BASIC}.test_if_2.l_b"
--		local
--			l_a: detachable STRING_8
--			l_b: detachable STRING_8
--		do
--			if a_b then
--				l_a := "a"
--				l_b := l_a
--			else
--				l_a := Void
--				l_b := Void
--			end
--		end

--	test_if_3 (a_i: INTEGER_32)
--		note
--			aliasing: "[
--					{AAT_BASIC}.test_if_3.l_a: {AAT_BASIC}.test_if_3.l_b
--					{AAT_BASIC}.test_if_3.l_b: {AAT_BASIC}.test_if_3.l_a, {AAT_BASIC}.test_if_3.l_c
--					{AAT_BASIC}.test_if_3.l_c: {AAT_BASIC}.test_if_3.l_b
--				]"
--		local
--			l_a: detachable STRING_8
--			l_b: detachable STRING_8
--			l_c: detachable STRING_8
--		do
--			if a_i = 1 then
--				l_a := "a"
--				l_b := l_a
--			elseif a_i = 2 then
--				l_a := Void
--				l_b := Void
--				l_c := Void
--			else
--				l_b := "b"
--				l_c := l_b
--			end
--		end

	test_void_var
		note
			aliasing: ""
		local
			l_a: detachable STRING_8
			l_b: detachable STRING_8
			l_c: detachable STRING_8
		do
			l_b := l_a
			l_c := l_b
		end

	test_expanded_types
		note
			aliasing: ""
		local
			l_a, l_b: INTEGER_32
		do
			l_a := 1
			l_b := l_a
		end

	test_expanded_types2
		note
			aliasing: "{AAT_BASIC}.test_expanded_types2.l_a.{AATH_EXPANDED}.str2, {AAT_BASIC}.test_expanded_types2.l_b.{AATH_EXPANDED}.str2"
		local
			l_a, l_b: AATH_EXPANDED
		do
			l_a.set_values (Void, "str2", 11, 22)
			l_b := l_a
		end

	test_globals
		note
			aliasing: "{AAT_BASIC}.a, {AAT_BASIC}.b"
		do
			a := "a"
			b := a
		end

	test_function_call
		note
			aliasing: "{AAT_BASIC}.test_function_call.l_a, {AAT_BASIC}.test_function_call.l_b"
		local
			l_a, l_b: STRING_8
		do
			l_a := "a"
			l_b := test_function_call_helper (l_a)
		end

	test_function_call_helper (a_a: STRING_8): STRING_8
		do
			Result := a_a
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
