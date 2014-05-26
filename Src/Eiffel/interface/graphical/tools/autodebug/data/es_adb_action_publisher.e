
class ES_ADB_ACTION_PUBLISHER

feature -- Basic operation

	extend (a_action: ES_ADB_ACTIONS)
			-- Extend current with `a_action'.
		require
			a_action /= Void
		do
			if not compile_start_actions.has (a_action.on_compile_start_agent) then
				compile_start_actions.extend (a_action.on_compile_start_agent)
			end
			if not compile_stop_actions.has (a_action.on_compile_stop_agent) then
				compile_stop_actions.extend (a_action.on_compile_stop_agent)
			end
			if not project_load_actions.has (a_action.on_project_loaded_agent) then
				project_load_actions.extend (a_action.on_project_loaded_agent)
			end
			if not project_unload_actions.has (a_action.on_project_unloaded_agent) then
				project_unload_actions.extend (a_action.on_project_unloaded_agent)
			end
			if not debugging_start_actions.has (a_action.on_debugging_start_agent) then
				debugging_start_actions.extend (a_action.on_debugging_start_agent)
			end
			if not debugging_stop_actions.has (a_action.on_debugging_stop_agent) then
				debugging_stop_actions.extend (a_action.on_debugging_stop_agent)
			end
			if not testing_start_actions.has (a_action.on_testing_start_agent) then
				testing_start_actions.extend (a_action.on_testing_start_agent)
			end
			if not testing_stop_actions.has (a_action.on_testing_stop_agent) then
				testing_stop_actions.extend (a_action.on_testing_stop_agent)
			end
			if not test_case_generated_actions.has (a_action.on_test_case_generated_agent) then
				test_case_generated_actions.extend (a_action.on_test_case_generated_agent)
			end
			if not fixing_start_actions.has (a_action.on_fixing_start_agent) then
				fixing_start_actions.extend (a_action.on_fixing_start_agent)
			end
			if not valid_fix_found_actions.has (a_action.on_valid_fix_found_agent) then
				valid_fix_found_actions.extend (a_action.on_valid_fix_found_agent)
			end
			if not fix_applied_actions.has (a_action.on_fix_applied_agent) then
				fix_applied_actions.extend (a_action.on_fix_applied_agent)
			end
			if not fixing_stop_actions.has (a_action.on_fixing_stop_agent) then
				fixing_stop_actions.extend (a_action.on_fixing_stop_agent)
			end
			if not output_actions.has (a_action.on_output_agent) then
				output_actions.extend (a_action.on_output_agent)
			end
		end

	prune (a_action: ES_ADB_ACTIONS)
			-- Remove `a_action' from current.
		require
			a_action /= Void
		do
			if compile_start_actions.has (a_action.on_compile_start_agent) then
				compile_start_actions.prune_all (a_action.on_compile_start_agent)
			end
			if compile_stop_actions.has (a_action.on_compile_stop_agent) then
				compile_stop_actions.prune_all (a_action.on_compile_stop_agent)
			end
			if project_load_actions.has (a_action.on_project_loaded_agent) then
				project_load_actions.prune_all (a_action.on_project_loaded_agent)
			end
			if project_unload_actions.has (a_action.on_project_unloaded_agent) then
				project_unload_actions.prune_all (a_action.on_project_unloaded_agent)
			end
			if debugging_start_actions.has (a_action.on_debugging_start_agent) then
				debugging_start_actions.prune_all (a_action.on_debugging_start_agent)
			end
			if debugging_stop_actions.has (a_action.on_debugging_stop_agent) then
				debugging_stop_actions.prune_all (a_action.on_debugging_stop_agent)
			end
			if testing_start_actions.has (a_action.on_testing_start_agent) then
				testing_start_actions.prune_all (a_action.on_testing_start_agent)
			end
			if test_case_generated_actions.has (a_action.on_test_case_generated_agent) then
				test_case_generated_actions.prune_all (a_action.on_test_case_generated_agent)
			end
			if testing_stop_actions.has (a_action.on_testing_stop_agent) then
				testing_stop_actions.prune_all (a_action.on_testing_stop_agent)
			end
			if fixing_start_actions.has (a_action.on_fixing_start_agent) then
				fixing_start_actions.prune_all (a_action.on_fixing_start_agent)
			end
			if valid_fix_found_actions.has (a_action.on_valid_fix_found_agent) then
				valid_fix_found_actions.prune_all (a_action.on_valid_fix_found_agent)
			end
			if fix_applied_actions.has (a_action.on_fix_applied_agent) then
				fix_applied_actions.prune_all (a_action.on_fix_applied_agent)
			end
			if fixing_stop_actions.has (a_action.on_fixing_stop_agent) then
				fixing_stop_actions.prune_all (a_action.on_fixing_stop_agent)
			end
			if output_actions.has (a_action.on_output_agent) then
				output_actions.prune_all (a_action.on_output_agent)
			end
		end


feature -- Access

	compile_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when Eiffel compilation starts
		do
			if compile_start_actions_internal = Void then
				create compile_start_actions_internal
			end
			Result := compile_start_actions_internal
		ensure
			result_attached: Result /= Void
		end

	compile_stop_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when Eiffel compilation stops
		do
			if compile_stop_actions_internal = Void then
				create compile_stop_actions_internal
			end
			Result := compile_stop_actions_internal
		ensure
			result_attached: Result /= Void
		end

	project_load_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when project loaded
		do
			if project_load_actions_internal = Void then
				create project_load_actions_internal
			end
			Result := project_load_actions_internal
		ensure
			result_attached: Result /= Void
		end

	project_unload_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when project unloaded
		do
			if project_unload_actions_internal = Void then
				create project_unload_actions_internal
			end
			Result := project_unload_actions_internal
		ensure
			result_attached: Result /= Void
		end

	debugging_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when debugging starts.
		do
			if debugging_start_actions_internal = Void then
				create debugging_start_actions_internal
			end
			Result := debugging_start_actions_internal
		ensure
			Result /= Void
		end

	debugging_stop_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when debugging stops.
		do
			if debugging_stop_actions_internal = Void then
				create debugging_stop_actions_internal
			end
			Result := debugging_stop_actions_internal
		ensure
			Result /= Void
		end

	testing_start_actions: ACTION_SEQUENCE [TUPLE]
		do
			if testing_start_actions_internal = Void then
				create testing_start_actions_internal
			end
			Result := testing_start_actions_internal
		end

	test_case_generated_actions: ACTION_SEQUENCE [TUPLE[ES_ADB_TEST]]
		do
			if test_case_generated_actions_internal = VOid then
				create test_case_generated_actions_internal
			end
			Result := test_case_generated_actions_internal
		end

	testing_stop_actions: ACTION_SEQUENCE [TUPLE]
		do
			if testing_stop_actions_internal = Void then
				create testing_stop_actions_internal
			end
			Result := testing_stop_actions_internal
		end

	fixing_start_actions: ACTION_SEQUENCE [TUPLE[ES_ADB_FAULT]]
		do
			if fixing_start_actions_internal = Void then
				create fixing_start_actions_internal
			end
			Result := fixing_start_actions_internal
		end

	valid_fix_found_actions: ACTION_SEQUENCE [TUPLE[ES_ADB_FIX]]
		do
			if valid_fix_found_actions_internal = Void then
				create valid_fix_found_actions_internal
			end
			Result := valid_fix_found_actions_internal
		end

	fix_applied_actions: ACTION_SEQUENCE [TUPLE[ES_ADB_FIX]]
		do
			if fix_applied_actions_internal = Void then
				create fix_applied_actions_internal
			end
			Result := fix_applied_actions_internal
		end

	fixing_stop_actions: ACTION_SEQUENCE [TUPLE[ES_ADB_FAULT]]
		do
			if fixing_stop_actions_internal = Void then
				create fixing_stop_actions_internal
			end
			Result := fixing_stop_actions_internal
		end

	output_actions: ACTION_SEQUENCE [TUPLE [STRING]]
		do
			if output_actions_internal = Void then
				create output_actions_internal
			end
			Result := output_actions_internal
		end

feature {NONE} -- Implementation

	compile_start_actions_internal: like compile_start_actions
	compile_stop_actions_internal: like compile_stop_actions
	project_load_actions_internal: like project_load_actions
	project_unload_actions_internal: like project_unload_actions
	debugging_start_actions_internal: like debugging_start_actions
	debugging_stop_actions_internal: like debugging_stop_actions
	testing_start_actions_internal: like testing_start_actions
	test_case_generated_actions_internal: like test_case_generated_actions
	testing_stop_actions_internal : like testing_stop_actions
	fixing_start_actions_internal: like fixing_start_actions
	valid_fix_found_actions_internal: like valid_fix_found_actions
	fix_applied_actions_internal: like fix_applied_actions
	fixing_stop_actions_internal: like fixing_stop_actions
	output_actions_internal: like output_actions

invariant
	compile_start_actions /= Void
	compile_stop_actions /= Void
	project_load_actions /= Void
	project_unload_actions /= Void
	debugging_start_actions /= Void
	debugging_stop_actions /= Void
	testing_start_actions /= Void
	test_case_generated_actions /= Void
	testing_stop_actions /= Void
	fixing_start_actions /= VOid
	valid_fix_found_actions /= Void
	fix_applied_actions /= Void
	fixing_stop_actions /= Void
	output_actions /= Void


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
