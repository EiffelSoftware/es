note
	description: "This class represents online statistical data that are collected during AutoTest sessions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ONLINE_STATISTICS_DATA

inherit
	ANY
		redefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_passing_tc: INTEGER; a_failing_tc: INTEGER; a_invalid_tc: INTEGER; a_object_count: INTEGER; a_restart_count: INTEGER; a_fault_count: INTEGER)
			-- Initialize Current.
		do
			set_passing_test_case_count (a_passing_tc)
			set_failing_test_case_count (a_failing_tc)
			set_invalid_test_case_count (a_invalid_tc)
			set_object_count (a_object_count)
			set_session_restart_count (a_restart_count)
			set_fault_count (a_fault_count)
		end

feature -- Access

	passing_test_case_count: INTEGER
			-- The number of passing test cases seen so far

	failing_test_case_count: INTEGER
			-- The number of failing test cases seen so far

	invalid_test_case_count: INTEGER
			-- The number of invalid test cases seen so far

	valid_test_case_count: INTEGER
			-- The number of valid test cases (passing + failing) seen so far
		do
			Result := passing_test_case_count + failing_test_case_count
		end

	object_count: INTEGER
			-- Number of objects in the object pool

	session_restart_count: INTEGER
			-- Number of session restarts

	fault_count: INTEGER
			-- Number of distinct faults

	out: STRING
			-- String representation of Current
		do
			create Result.make (256)
			Result.append_integer (passing_test_case_count)
			Result.append_character ('%T')

			Result.append_integer (failing_test_case_count)
			Result.append_character ('%T')

			Result.append_integer (invalid_test_case_count)
			Result.append_character ('%T')

			Result.append_integer (object_count)
			Result.append_character ('%T')

			Result.append_integer (fault_count)
			Result.append_character ('%T')

			Result.append_integer (session_restart_count)
		end

feature -- Setting

	set_passing_test_case_count (i: INTEGER)
			-- Set `passing_test_case_count' with `i'.
		do
			passing_test_case_count := i
		ensure
			passing_test_case_count_set: passing_test_case_count = i
		end

	set_failing_test_case_count (i: INTEGER)
			-- Set `failing_test_case_count' with `i'.
		do
			failing_test_case_count := i
		ensure
			failing_test_case_count_set: failing_test_case_count = i
		end

	set_invalid_test_case_count (i: INTEGER)
			-- Set `invalid_test_case_count' with `i'.
		do
			invalid_test_case_count := i
		ensure
			invalid_test_case_count_set: invalid_test_case_count = i
		end

	set_object_count (i: INTEGER)
			-- Set `object_count' with `i'.
		do
			object_count := i
		ensure
			object_count_set: object_count = i
		end

	set_session_restart_count (i: INTEGER)
			-- Set `session_restart_count' with `i'.
		do
			session_restart_count := i
		ensure
			session_restart_count_set: session_restart_count = i
		end

	set_fault_count (i: INTEGER)
			-- Set `fault_count' with `i'.
		do
			fault_count := i
		ensure
			fault_count_set: fault_count = i
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
