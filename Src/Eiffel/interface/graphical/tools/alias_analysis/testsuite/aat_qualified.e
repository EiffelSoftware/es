note
	description: "[Alias Analysis] tests with qualified alias relations."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AAT_QUALIFIED

feature

	a: detachable STRING_8 assign set_a

	set_a (a_a: detachable STRING_8)
		do
			a := a_a
		end

	other: detachable AAT_QUALIFIED assign set_other

	set_other (a_other: detachable AAT_QUALIFIED)
		do
			other := a_other
		end

feature

	test_normal
		note
			aliasing: "{AAT_QUALIFIED}.test_normal.l_a.{AAT_QUALIFIED}.a, {AAT_QUALIFIED}.test_normal.l_b.{AAT_QUALIFIED}.a"
		local
			l_a: AAT_QUALIFIED
			l_b: AAT_QUALIFIED
		do
			create l_a
			create l_b
			l_a.set_a ("l_a")
			l_b.set_a (l_a.a)
		end

	test_assigner
		note
			aliasing: "{AAT_QUALIFIED}.test_assigner.l_a.{AAT_QUALIFIED}.a, {AAT_QUALIFIED}.test_assigner.l_b.{AAT_QUALIFIED}.a"
		local
			l_a: AAT_QUALIFIED
			l_b: AAT_QUALIFIED
		do
			create l_a
			create l_b
			l_a.a := "l_a"
			l_b.a := l_a.a
		end

	test_aliased
		note
			aliasing: "[
					{AAT_QUALIFIED}.test_aliased.l_a, {AAT_QUALIFIED}.test_aliased.l_b
					{AAT_QUALIFIED}.test_aliased.l_a.{AAT_QUALIFIED}.a, {AAT_QUALIFIED}.test_aliased.l_b.{AAT_QUALIFIED}.a
				]"
		local
			l_a: AAT_QUALIFIED
			l_b: AAT_QUALIFIED
		do
			create l_a
			l_b := l_a
			l_a.set_a ("l_a")
			l_b.set_a (l_a.a)
		end

	test_cycle
		note
			aliasing: "[
					Current, {AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other, {AAT_QUALIFIED}.test_cycle.l_tmp.{AAT_QUALIFIED}.other
					{AAT_QUALIFIED}.other, {AAT_QUALIFIED}.test_cycle.l_tmp, {AAT_QUALIFIED}.test_cycle.l_tmp.{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other
					
					-- Cycles:
					{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other -> Current
					{AAT_QUALIFIED}.test_cycle.l_tmp.{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other -> {AAT_QUALIFIED}.test_cycle.l_tmp
				]"
		local
			l_tmp: AAT_QUALIFIED
		do
			create l_tmp
			other := l_tmp
			l_tmp.other := Current
		end

	test_cycle_2
		note
			aliasing: "[
					Current, {AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other, {AAT_QUALIFIED}.test_cycle_2.l_tmp.{AAT_QUALIFIED}.other
					{AAT_QUALIFIED}.other, {AAT_QUALIFIED}.test_cycle_2.l_tmp, {AAT_QUALIFIED}.test_cycle_2.l_tmp.{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other
					
					-- Cycles:
					{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other -> Current
					{AAT_QUALIFIED}.test_cycle_2.l_tmp.{AAT_QUALIFIED}.other.{AAT_QUALIFIED}.other -> {AAT_QUALIFIED}.test_cycle_2.l_tmp
				]"
		do
			other := create {AAT_QUALIFIED}
			if attached other as l_tmp then
				l_tmp.other := Current
			end
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
