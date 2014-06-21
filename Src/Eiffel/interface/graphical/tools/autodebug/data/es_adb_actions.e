
deferred class ES_ADB_ACTIONS

feature {NONE} -- Actions

	on_project_loaded
			-- Action to be performed when project loaded
		deferred
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		deferred
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		deferred
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		deferred
		end

	on_debugging_start
			-- Action to be performed when debugging starts
		deferred
		end

	on_debugging_stop
			-- Action to be performed when debugging stops
		deferred
		end

	on_testing_start
			-- Action to be performed when testing starts
		deferred
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- Action to be performed when a new test case is generated
		deferred
		end

	on_testing_stop
			-- Action to be performed when testing stops.
		deferred
		end

	on_continuation_debugging_start
			-- Action to be performed when continuation debugging starts
		deferred
		end

	on_continuation_debugging_stop
			-- Action to be performed when continuation debugging stops
		deferred
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- Action to be performed when fixing `a_fault' starts
		deferred
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- Action to be performed when `a_fix' is found.
		require
			a_fix /= Void
		deferred
		end

	on_fixing_stop
			-- Action to be performed when fixing a fault stops
		deferred
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- Action to be performed when `a_fix' is applied.
		require
			a_fix /= Void and then a_fix.has_been_applied
		deferred
		end

	on_output (a_line: STRING)
			-- Action to be performed when `a_line' is output.
		require
			a_line /= Void
		deferred
		end

feature {ES_ADB_ACTION_PUBLISHER} -- Agents

	on_project_loaded_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_project_loaded.
		do
			if on_project_loaded_agent_internal = Void then
				on_project_loaded_agent_internal := agent on_project_loaded
			end
			Result := on_project_loaded_agent_internal
		end

	on_project_unloaded_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_project_unloaded.
		do
			if on_project_unloaded_agent_internal = Void then
				on_project_unloaded_agent_internal := agent on_project_unloaded
			end
			Result := on_project_unloaded_agent_internal
		end

	on_compile_start_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_compile_start
		do
			if on_compile_start_agent_internal = Void then
				on_compile_start_agent_internal := agent on_compile_start
			end
			Result := on_compile_start_agent_internal
		end

	on_compile_stop_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_compile_stop
		do
			if on_compile_stop_agent_internal = Void then
				on_compile_stop_agent_internal := agent on_compile_stop
			end
			Result := on_compile_stop_agent_internal
		end

	on_debugging_start_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_debugging_start
		do
			if on_debugging_start_agent_internal = Void then
				on_debugging_start_agent_internal := agent on_debugging_start
			end
			Result := on_debugging_start_agent_internal
		end

	on_debugging_stop_agent: PROCEDURE [ANY, TUPLE]
			-- Agent of on_debugging_stop
		do
			if on_debugging_stop_agent_internal = Void then
				on_debugging_stop_agent_internal := agent on_debugging_stop
			end
			Result := on_debugging_stop_agent_internal
		end

	on_testing_start_agent: PROCEDURE [ANY, TUPLE]
		do
			if on_testing_start_agent_internal = Void then
				on_testing_start_agent_internal := agent on_testing_start
			end
			Result := on_testing_start_agent_internal
		end

	on_test_case_generated_agent: PROCEDURE [ANY, TUPLE[ES_ADB_TEST]]
		do
			if on_test_case_generated_agent_internal = Void then
				on_test_case_generated_agent_internal := agent on_test_case_generated
			end
			Result := on_test_case_generated_agent_internal
		end

	on_testing_stop_agent: PROCEDURE [ANY, TUPLE]
		do
			if on_testing_stop_agent_internal = Void then
				on_testing_stop_agent_internal := agent on_testing_stop
			end
			Result := on_testing_stop_agent_internal
		end

	on_fixing_start_agent: PROCEDURE [ANY, TUPLE[ES_ADB_FAULT]]
		do
			if on_fixing_start_agent_internal = Void then
				on_fixing_start_agent_internal := agent on_fixing_start
			end
			Result := on_fixing_start_agent_internal
		end

	on_fixing_stop_agent: PROCEDURE [ANY, TUPLE]
		do
			if on_fixing_stop_agent_internal = Void then
				on_fixing_stop_agent_internal := agent on_fixing_stop
			end
			Result := on_fixing_stop_agent_internal
		end

	on_continuation_debugging_start_agent: PROCEDURE [ANY, TUPLE]
		do
			if on_continuation_debugging_start_agent_internal = Void then
				on_continuation_debugging_start_agent_internal := agent on_continuation_debugging_start
			end
			Result := on_continuation_debugging_start_agent_internal
		end

	on_continuation_debugging_stop_agent: PROCEDURE [ANY, TUPLE]
		do
			if on_continuation_debugging_stop_agent_internal = Void then
				on_continuation_debugging_stop_agent_internal := agent on_continuation_debugging_stop
			end
			Result := on_continuation_debugging_stop_agent_internal
		end

	on_valid_fix_found_agent: PROCEDURE [ANY, TUPLE[ES_ADB_FIX]]
		do
			if on_valid_fix_found_agent_internal = Void then
				on_valid_fix_found_agent_internal := agent on_valid_fix_found
			end
			Result := on_valid_fix_found_agent_internal
		end

	on_fix_applied_agent: PROCEDURE [ANY, TUPLE[ES_ADB_FIX]]
		do
			if on_fix_applied_agent_internal = Void then
				on_fix_applied_agent_internal := agent on_fix_applied
			end
			Result := on_fix_applied_agent_internal
		end

	on_output_agent: PROCEDURE [ANY, TUPLE [STRING]]
		do
			if on_output_agent_internal = Void then
				on_output_agent_internal := agent on_output
			end
			Result := on_output_agent_internal
		end

feature {NONE} -- Implementation

	on_project_loaded_agent_internal: like on_project_loaded_agent
	on_project_unloaded_agent_internal: like on_project_unloaded_agent
	on_compile_start_agent_internal: like on_compile_start_agent
	on_compile_stop_agent_internal: like on_compile_stop_agent
	on_debugging_start_agent_internal: like on_debugging_start_agent
	on_debugging_stop_agent_internal: like on_debugging_stop_agent
	on_testing_start_agent_internal: like on_testing_start_agent
	on_test_case_generated_agent_internal: like on_test_case_generated_agent
	on_testing_stop_agent_internal: like on_testing_stop_agent
	on_fixing_start_agent_internal: like on_fixing_start_agent
	on_fixing_stop_agent_internal: like on_fixing_stop_agent
	on_continuation_debugging_start_agent_internal: like on_continuation_debugging_start_agent
	on_continuation_debugging_stop_agent_internal: like on_continuation_debugging_stop_agent
	on_valid_fix_found_agent_internal: like on_valid_fix_found_agent
	on_fix_applied_agent_internal: like on_fix_applied_agent
	on_output_agent_internal: like on_output_agent

;
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
