note
	description: "Summary description for {AUT_NUMBER_OF_VALID_TEST_CASE_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NUMBER_OF_VALID_TEST_CASE_OBSERVER

inherit
	AUT_WITNESS_OBSERVER
		redefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_time_unit: INTEGER) is
			-- Initialize.
		require
			a_time_unit_is_valid: a_time_unit = 1 or a_time_unit = 1000 or a_time_unit = 60 * 1000 or a_time_unit = 60*60*1000
		do
			system := a_system
			time_unit := a_time_unit
			create test_case_count.make (1, 60)
			current_time := 1
		ensure
			system_set: system = a_system
		end

feature -- Access

	number_of_test_cases: ARRAY [INTEGER] is
			--
		local
			i: INTEGER
			l_count: like test_case_count
		do
			create Result.make (1, current_time)
			from
				l_count := test_case_count
				i := 1
			until
				i > current_time
			loop
				Result.put (l_count.item (i), i)
				i := i + 1
			end
		end

	time_unit: INTEGER
			-- Time unit (relative to millisecond)
			-- For example, 1000 means time unit is second, 60,000 means time unit is 1 minute

feature -- Process

	process_witness (a_witness: AUT_ABS_WITNESS) is
			-- Handle `a_witness'.
		local
			l_new_time: INTEGER
			i: INTEGER
		do
			if a_witness.is_pass or a_witness.is_fail or a_witness.is_bad_response then
				l_new_time := a_witness.request.start_time // time_unit + 1
				test_case_count.grow (l_new_time * 2)

				if current_time < l_new_time then
					from
						i := current_time
					until
						i = l_new_time
					loop
						test_case_count.put (nb_test_case, i)
						i := i + 1
					end
				end

				nb_test_case := nb_test_case + 1
				current_time := l_new_time
				test_case_count.put (nb_test_case, current_time)
			end
		end

feature{NONE} -- Implementation

	system: SYSTEM_I
			-- Current system

	current_time: INTEGER
			-- Current time in unit

	nb_test_case: INTEGER;
			-- Number of valid test cases until so far

	test_case_count: ARRAY [INTEGER]
			-- Number of valid test cases until time
			-- Index of this list is the time interval.

;note
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
