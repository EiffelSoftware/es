note
	description: "[
		This class tests the alias analysis of overloaded operators (in Eiffel, those routines
		that have the 'alias' keyword: 'overloaded operator' is used to avoid confusions with alias analysis).
		
		Specifically, this class tests the alias analysis of routine 'oper' defined in AAT_OVER_OPER_B class. 
		Operator '&' is overloaded to this routine, thus the alias analysis for "object_b := object_b.oper("")" 
		should yield the same result for the alias analysis of "object_b := object_b & """ (here, 'object_b' is 
		of type AAT_OVER_OPER_B).
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AAT_OVER_OPER_A

feature

	test1
		note
			aliasing: "{AAT_OVER_OPER_A}.test1.l_a, {AAT_OVER_OPER_A}.test1.l_b"
		local
			l_a, l_b: AAT_OVER_OPER_B
		do
			create l_a
			l_b := l_a.oper("")
		end

	test2
		note
			aliasing: "{AAT_OVER_OPER_A}.test2.l_a, {AAT_OVER_OPER_A}.test2.l_b"
		local
			l_a, l_b: AAT_OVER_OPER_B
		do
			create l_a
			l_b := l_a & ""
		end

	test3
		note
			aliasing: "{AAT_OVER_OPER_A}.test3.l_a, {AAT_OVER_OPER_A}.test3.l_b"
		local
			l_a, l_b: AAT_OVER_OPER_B
		do
			l_a := (create {AAT_OVER_OPER_B}) & ""
			l_b := l_a.oper("")
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
