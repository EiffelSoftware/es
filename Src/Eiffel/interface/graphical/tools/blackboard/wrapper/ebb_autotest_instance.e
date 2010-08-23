note
	description: "Instance of AutoTest"
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_AUTOTEST_INSTANCE

inherit

	EBB_TOOL_INSTANCE

	SHARED_TEST_SERVICE
		export {NONE} all end

create
	make

feature -- Status report

	is_running: BOOLEAN
			-- <Precursor>
		do
			if attached test_generator then
				Result := test_generator.has_next_step
			end
		end

feature -- Basic operations

	start
			-- <Precursor>
		local
			l_session: SERVICE_CONSUMER [SESSION_MANAGER_S]
		do
			create test_generator.make (test_suite.service, etest_suite)
			test_generator.add_class_name (input.classes.first.name_in_upper)

			create l_session
			l_session.service.retrieve (True).set_value ({TEST_SESSION_CONSTANTS}.types, input.classes.first.name)
			launch_test_generation (test_generator, l_session.service, False)
		end

	cancel
			-- <Precursor>
		do
			test_generator.cancel
		end

feature -- Implementation

	test_generator: TEST_GENERATOR

invariant
note
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
