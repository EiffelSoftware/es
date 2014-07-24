note
	description: "Summary description for {ES_ADB_INFO_CENTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_INFO_CENTER

inherit
	ES_ADB_ACTIONS

	ES_ADB_ACTION_PUBLISHER

	ES_ADB_SHARED_CONFIG

	ES_ADB_FAULT_REPOSITORY
		rename reset as reset_fault_repository end

	ES_ADB_TEST_CASE_REPOSITORY
		rename reset as reset_test_case_repository end

	EPA_UTILITY

	SHARED_PLATFORM_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			create progress_logger
			extend (progress_logger)
			create output_logger
			extend (output_logger)
		end

feature -- Operation

	reset_internal_state
			-- Reset the information center.
		do
			reset_test_case_repository
			reset_fault_repository
		end

	reset_external_state
			-- Reset the working directory.
		do
			config.working_directory.clear
		end

feature -- Access: logging

	progress_logger: ES_ADB_PROGRESS_LOGGER
			-- Logger to log the debugging progress.

	output_logger: ES_ADB_OUTPUT_LOGGER
			-- Logger to log the output of debugging.

feature -- ADB Actions

	on_project_loaded
			-- <Precursor>
		do
			reset_internal_state

			project_load_actions.call (Void)

			progress_logger.load_log
		end

	on_project_unloaded
			-- <Precursor>
		do
			project_unload_actions.call (Void)

			reset_internal_state
		end

	on_compile_start
			-- <Precursor>
		do
			compile_start_actions.call (Void)
		end

	on_compile_stop
			-- <Precursor>
		do
			compile_stop_actions.call (Void)
		end

	on_debugging_start
			-- <Precursor>
		do
			reset_internal_state

			debugging_start_actions.call (Void)
		end

	on_debugging_stop
			-- <Precursor>
		do
			debugging_stop_actions.call (Void)
		end

	on_testing_start
			-- <Precursor>
		do
			testing_start_actions.call (Void)
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		do
			register_test_case (a_test)

			test_case_generated_actions.call (a_test)
		end

	on_testing_stop
			-- <Precursor>
		do
			testing_stop_actions.call (Void)
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
			a_fault.discard_all_fixes
			a_fault.set_status (a_fault.status_candidate_fix_unavailable)
			fixing_start_actions.call (a_fault)
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
		do
			valid_fix_found_actions.call (a_fix)
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
			fix_applied_actions.call (a_fix)
		end

	on_fixing_stop
			-- <Precursor>
		do
			fixing_stop_actions.call (Void)
		end

	on_continuation_debugging_start
			-- <Precursor>
		do
			continuation_debugging_start_actions.call (Void)
		end

	on_continuation_debugging_stop
			-- <Precursor>
		do
			continuation_debugging_stop_actions.call (Void)
		end

	on_output (a_line: STRING)
			-- <Precursor>

		do
			output_actions.call (a_line)
		end

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
