note
	description: "Summary description for {AUT_ABSTRACT_INTEGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ABSTRACT_INTEGER

inherit
	AUT_ABSTRACT_VALUE
	AUT_SHARED_RANDOM

create
	make

feature {NONE} -- Initialization

	make (a_lower_bound, a_upper_bound: INTEGER)
			-- Initialization for `Current'.
		require
			a_lower_bound_smaller_equal_a_upper_bound: a_lower_bound <= a_upper_bound
		do
			lower_bound := a_lower_bound
			upper_bound := a_upper_bound
		end

feature -- Access

	lower_bound: INTEGER
			-- lower bound of the abstract integer

	upper_bound: INTEGER
			-- upper bound of the abstract integer

	size: INTEGER
			-- how many elements in the range of the abstract integer?
		once
			Result := upper_bound - lower_bound + 1
		end

	random_element: INTEGER
			-- get a random element in the range of the abstract integer
		do
			random.forth
			Result := lower_bound + (random.item \\ size)
		ensure
			valid_result: Result >= lower_bound and then Result <= upper_bound
		end

invariant
	lower_bound_smaller_equal_upper_bound: lower_bound <= upper_bound
	size_greater_zero: size > 0

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
