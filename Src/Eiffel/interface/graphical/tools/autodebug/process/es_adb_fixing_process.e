note
	description: "Summary description for {ES_ADB_FIXING_EXECUTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIXING_PROCESS

inherit
	ES_ADB_PROCESS
		redefine
			launch,
			start
		end

create
	make

feature{NONE} -- Initialization

	make (a_fault: ES_ADB_FAULT; a_working_directory: STRING; a_output_buffer: ES_ADB_PROCESS_OUTPUT_BUFFER)
			-- Initialization.
		require
			a_fault /= Void
		local
			l_command_line: STRING
			l_max_length: INTEGER
		do
			fault := a_fault
			l_command_line := command_line_for_fixing (a_fault)
			l_max_length := config.max_session_length_for_fixing + config.Max_session_overhead_length
			set_should_output_be_parsed (True)
			set_should_output_be_logged (True)

			make_process (l_command_line, a_working_directory, l_max_length, a_output_buffer)
			on_start_actions.extend (agent info_center.on_fixing_start (a_fault))
			on_terminate_actions.extend (agent info_center.on_fixing_stop)
		end

feature -- Access

	fault: ES_ADB_FAULT
			-- Fault to fix.

feature -- Operation

	start
			-- <Precursor>
		do
			Precursor
		end

	launch
			-- <Precursor>
		do
			Precursor
			if working_process.launched then
				fault.set_status ({ES_ADB_FAULT}.status_candidate_fix_unavailable)
			end
		end

feature{NONE} -- Implementation

	command_line_for_fixing (a_fault: ES_ADB_FAULT): STRING
			-- Command line string for fixing `a_fault'.
		require
			a_fault /= Void
		local
			l_fix_type_specific: STRING
		do
			create Result.make_empty
			if config.should_fix_implementation and then a_fault.is_exception_type_in_scope_of_implementation_fixing then
				l_fix_type_specific := "--fix-implementation "
			else
				l_fix_type_specific := ""
			end
			if config.should_fix_contracts and then a_fault.is_exception_type_in_scope_of_contract_fixing then
				l_fix_type_specific.append ("--fix-contract ")
				if a_fault.failing_feature_with_context.is_public or else a_fault.failing_feature_with_context.is_creation_feature then
					l_fix_type_specific.append ("--relaxed-test-case-dir " + config.working_directory.relaxed_testing_result_dir.out + " ")
				end
			end

			Result := "%"" + eve_path.out + "%" "
					+ "-project_path %"" + project_path_in_working_directory.out + "%" "
					+ "-config %"" + ecf_path_in_working_directory.out + "%" "
					+ "-target " + target_of_project + " "
					+ "-auto_fix --max-tc-execution-time 40 --max-fixing-target 15 "
					+ "-t " + config.max_session_length_for_fixing.out + " "
					+ "--test-case-dir %"" + config.working_directory.testing_result_dir_for_fault (a_fault).out + "%" "
					+ "--report-file %"" + config.working_directory.fixing_result_dir.extended (a_fault.signature.id + ".afr").out + "%" "
					+ "--max-valid-fix " + config.max_nbr_fix_candidates.out + " "
					+ "--max-passing-tc-number " + config.max_nbr_passing_tests.out + " "
					+ "--max-failing-tc-number " + config.max_nbr_failing_tests.out + " "
					+ "--fault-signature-id " + a_fault.signature.id + " "
					+ l_fix_type_specific
		end

note
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
