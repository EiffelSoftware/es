note
	description: "Summary description for {AFX_FIX_PROPOSER_CONF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_PROPOSER_CONF

inherit
	AFX_FIX_PROPOSER_CONF_I

	TEST_EXECUTOR_CONF
		rename
		    make as make_executor_conf
		redefine
		    is_interface_usable
		end

	SHARED_AFX_TEST_ID

create
    make

feature -- Creation

	make (a_selected_tests: attached like tests; a_all_tests: attached like tests)
			-- create a new conf
		require
		    a_selected_tests_not_empty: not a_selected_tests.is_empty
		    a_all_tests_not_empty: not a_all_tests.is_empty
		do
			make_executor_conf (False)

			create failing_tests.make(1)
			create regression_tests.make(a_all_tests.count)

			reset_global_test_id
			prepare_failing_tests(a_selected_tests, a_all_tests)
			prepare_regression_tests(a_all_tests)
		end

feature -- Status report

	is_interface_usable: BOOLEAN
			-- <Precursor>
		do
		    Result := failing_tests.count = 1
		ensure then
		    exactly_one_failing_test: failing_tests.count =  1
		end

feature -- Access

	failing_tests: DS_ARRAYED_LIST [AFX_TEST]
			-- <Precursor>

	regression_tests: DS_ARRAYED_LIST [AFX_TEST]
			-- <Precursor>

feature -- Implementation

	prepare_regression_tests(a_tests: attached like tests)
			-- get all the successful tests from `a_tests' and use them as `regression_tests'
		do
			a_tests.do_all (
				agent (a_test: TEST_I)
					do
        		        if a_test.is_interface_usable and then a_test.is_outcome_available and then a_test.passed then
        	                regression_tests.force_last(create {AFX_TEST}.make (a_test))
        		        end
		        	end
			)
		end

	prepare_failing_tests (a_selected_tests: like tests; a_all_tests: like tests)
			-- get the failing tests from `a_selected_tests' and `a_all_tests', and put them into `failing_tests'
			-- NOTE: only one failing test a time, for now
		require
		    failing_tests_empty: failing_tests.is_empty
		do
			a_selected_tests.do_all (
				agent (a_test: attached TEST_I)
					do
        		        if a_test.is_interface_usable and then a_test.is_outcome_available and then a_test.failed then
        	                failing_tests.force_last(create {AFX_TEST}.make (a_test))
        		        end
		        	end
			)

				-- if no failing test specified in the `a_selected_tests', check the `a_all_tests'
		    if failing_tests.is_empty then
    			a_all_tests.do_all (
    				agent (a_test: attached TEST_I)
    					do
            		        if a_test.is_interface_usable and then a_test.is_outcome_available and then a_test.failed then
            	                failing_tests.force_last(create {AFX_TEST}.make (a_test))
            		        end
    		        	end
    			)
		    end
		end

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
