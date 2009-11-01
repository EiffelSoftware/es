note
	description: "Summary description for {EWB_AUTO_FIX_RETRIEVE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTO_FIX_RETRIEVE_STATE

inherit
	SHARED_WORKBENCH

	SHARED_EXEC_ENVIRONMENT
	SHARED_EIFFEL_PROJECT
	PROJECT_CONTEXT
	SYSTEM_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	SHARED_BENCH_NAMES

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config for AutoFix ocmmand line

feature -- Execute

	execute
			-- Execute current command.
		local
			l_bp_manager: AFX_BREAKPOINT_MANAGER
			l_state: AFX_STATE_SKELETON
			l_action: AFX_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION

			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
		do
			create l_bp_manager.make
			create l_state.make_with_basic_argumentless_query (config.state_recipient_class)
			create l_action.make (l_state)

			create l_gen.make
			l_gen.generate (config.state_recipient_class, config.state_recipient)
			io.put_string ("--------------------------------------------%N")
			from
				l_gen.accesses.start
			until
				l_gen.accesses.after
			loop
				io.put_string (l_gen.accesses.item_for_iteration.text + "%N")
				l_gen.accesses.forth
			end
			io.put_string ("--------------------------------------------%N%N")
			l_bp_manager.set_hit_action_with_agent (l_state, agent on_hit, config.state_recipient)
			l_bp_manager.set_breakpoints (l_state, config.state_recipient)
			l_bp_manager.toggle_breakpoints (True)
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
			debugger_manager.observer_provider.application_stopped_actions.extend_kamikaze (agent on_application_stopped)
			start_debugger
			l_bp_manager.toggle_breakpoints (False)
		end

feature{NONE} -- Implementation

	start_debugger
		require
			debugger_manager /= Void
		local
			ctlr: DEBUGGER_CONTROLLER
			wdir: STRING
			param: DEBUGGER_EXECUTION_PARAMETERS
		do
			if wdir = Void or else wdir.is_empty then
				wdir := Eiffel_project.lace.directory_name
						--Execution_environment.current_working_directory
			end
			ctlr := debugger_manager.controller
			create param
			param.set_arguments ("")
			param.set_working_directory (config.working_directory)
			debugger_manager.set_execution_ignoring_breakpoints (False)
			ctlr.debug_application (param, {EXEC_MODES}.run)
		end

	on_hit (a_breakpoint: BREAKPOINT; a_state: AFX_STATE) is
			--
		do
			io.put_string ("===================================================%N")
			io.put_string ("BP_" + a_breakpoint.breakable_line_number.out + "%N")
			from
				a_state.start
			until
				a_state.after
			loop
				io.put_string (a_state.item_for_iteration.expression.name + " = " + a_state.item_for_iteration.value.output_for_debugger + "%N")
				a_state.forth
			end
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		do
			if a_dm.application_is_executing or a_dm.application_is_stopped then
				a_dm.application.kill
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
