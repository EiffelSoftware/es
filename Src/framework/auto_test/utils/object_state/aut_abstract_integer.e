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
			-- how many elements in the bounds of the abstract integer?
		once
			Result := upper_bound - lower_bound + 1
		end

	random_element: INTEGER
			-- get a random element in the bounds of the abstract integer
		do
			random.forth
			if random.item \\ 4 = 0 then
					-- with a 0.25 probability, choose a random integer from predefined values
				random.forth
				Result := predefined_values_in_bounds.lower + (random.item \\ predefined_values_in_bounds.count)
			else
				random.forth
				Result := lower_bound + (random.item \\ size)
			end
		ensure
			valid_result: Result >= lower_bound and then Result <= upper_bound
		end

feature {NONE} -- Implementation

	predefined_values: ARRAY[INTEGER] is
			-- Array of predefined values (must be sorted)
		once
			Result := <<{INTEGER}.min_value,-100,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10,100,{INTEGER}.max_value>>
		end

	predefined_values_in_bounds: ARRAY[INTEGER] is
			-- Return those predefined_values that are inside the range of the abstract integer
		local
			i: INTEGER
			lower_range_index: INTEGER
			lower_range_index_found: BOOLEAN
			upper_range_index: INTEGER
			upper_range_index_found: BOOLEAN
		once
			from
				i := predefined_values.lower
				lower_range_index_found := False
				upper_range_index_found := False
			until
				i > predefined_values.upper or else (lower_range_index_found and upper_range_index_found)
			loop
				if not lower_range_index_found and then lower_bound <= predefined_values.at (i) then
					lower_range_index := i
					lower_range_index_found := True
				end

				if not upper_range_index_found and then upper_bound >= predefined_values.at (i) then
					upper_range_index := i
					upper_range_index_found := True
				end

				i := i + 1
			end

			Result := predefined_values.subarray (lower_range_index, upper_range_index)
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
