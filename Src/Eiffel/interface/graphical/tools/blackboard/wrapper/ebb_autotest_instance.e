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

	AUT_SHARED_ONLINE_STATISTICS

	EBB_SHARED_BLACKBOARD

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
			l_test_suite: TEST_SUITE_S
			l_log_options: HASH_TABLE [BOOLEAN, STRING]
		do
			create test_generator.make (Current, test_suite.service, etest_suite)
			test_generator.add_class_name (input.classes.first.name_in_upper)
			test_generator.set_is_random_testing_enabled (True)
			test_generator.set_is_slicing_enabled (True)

			create l_log_options.make (10)
			l_log_options.put (True, "failing")
			test_generator.set_proxy_log_options (l_log_options)
			test_generator.set_html_statistics (True)

			online_statistics.passing_statistics.wipe_out
			online_statistics.failing_statistics.wipe_out
			online_statistics.faults.wipe_out


			create l_session
			l_session.service.retrieve (True).set_value (input.classes.first.name, {TEST_SESSION_CONSTANTS}.types)
			launch_test_generation (test_generator, l_session.service, False)

			test_generator.set_time_out_in_seconds (configuration.integer_setting ("timeout").as_natural_32)

			test_generator.set_integer_lower_bound (-1_000_000)
			test_generator.set_integer_upper_bound (1_000_000)
--			test_generator.set_enforce_precondition_satisfaction (True)
			test_generator.set_is_precondition_evaluation_enabled (True)
			test_generator.set_is_passing_test_case_serialization_enabled (True)
			test_generator.set_is_failing_test_case_serialization_enabled (True)

--			test_generator.error_handler.set_debug_standard
--			test_generator.error_handler.set_warning_standard
--			test_generator.error_handler.set_error_standard
--			test_generator.error_handler.set_info_standard
--			test_generator.set_is_interpreter_log_enabled (True)
--			test_generator.set_is_console_output_enabled (True)


			if test_suite.is_service_available then
				l_test_suite := test_suite.service
				if l_test_suite.is_interface_usable then
					l_test_suite.launch_session (test_generator)
				end
			end

		end

	cancel
			-- <Precursor>
		do
			test_generator.cancel
		end

feature {NONE} -- Implementation

	test_generator: EBB_TEST_GENERATOR

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
