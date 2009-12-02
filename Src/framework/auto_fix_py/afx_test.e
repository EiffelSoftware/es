note
	description: "Summary description for {AFX_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST

inherit
    SHARED_AFX_TEST_ID

create
	make

feature -- Initialization

	make (a_test: like test)
			-- initialize a new object
		do
		    test := a_test
		    test_id := global_test_id
		    step_global_test_id
		end

feature -- Status report

	failed: BOOLEAN
			-- did this test fail in last run?
		do
		    Result := test.is_interface_usable and then test.is_outcome_available and then test.failed
		end

	passed: BOOLEAN
			-- did this test succeed in last run?
		do
		    Result := test.is_interface_usable and then test.is_outcome_available and then test.passed
		end

feature -- Access

	test: TEST_I
			-- an Eiffel test

	test_id: INTEGER
			-- a unique id


;note
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
