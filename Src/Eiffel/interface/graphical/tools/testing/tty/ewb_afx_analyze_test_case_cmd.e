note
	description: "Summary description for {EWB_AUTO_FIX_TEST_CASE_ANALYZE_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AFX_ANALYZE_TEST_CASE_CMD

inherit
	SHARED_WORKBENCH

	SHARED_EXEC_ENVIRONMENT
	SHARED_EIFFEL_PROJECT
	PROJECT_CONTEXT
	SYSTEM_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	SHARED_BENCH_NAMES

	AFX_SHARED_CLASS_THEORY

	AUT_SHARED_RANDOM

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		require
			analyze_test_case_set: a_config.should_build_test_cases
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config for AutoFix ocmmand line	

feature -- Basic operations

	execute
			-- Execute.
		do
			debug_project
		end

	debug_project
			-- Debug current project to retrieve system states from test cases.
		local
			l_new_tc_bp_manager: AFX_BREAKPOINT_MANAGER
			l_mark_tc_feat: FEATURE_I
			l_tc_info_skeleton: AFX_STATE_SKELETON
		do
				-- Initialize debugger.
			debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
			debugger_manager.observer_provider.application_stopped_actions.extend_kamikaze (agent on_application_stopped)
			remove_breakpoint (root_class)


				-- Setup breakpoint handling for the routine which indicates
				-- a new test case is to be executed.
			l_mark_tc_feat := root_class.feature_named (mark_test_case_feature_name)
			create l_new_tc_bp_manager.make (root_class, l_mark_tc_feat)
			l_tc_info_skeleton := test_case_info_skeleton (root_class, l_mark_tc_feat)
			l_new_tc_bp_manager.set_hit_action_with_agent (l_tc_info_skeleton, agent on_new_test_case_found, l_mark_tc_feat)
			l_new_tc_bp_manager.set_breakpoint (l_tc_info_skeleton, l_mark_tc_feat, 1)
			l_new_tc_bp_manager.toggle_breakpoints (True)
			debugger_manager.observer_provider.application_stopped_actions.extend (agent on_application_stopped)
			start_debugger
		end

	test_case_info_skeleton (a_class: CLASS_C; a_feature: FEATURE_I): AFX_STATE_SKELETON
			-- State skeleton containing expressions to retrieve test case information from `a_feature'
		local
			l_exprs: LINKED_LIST [STRING]
		do
			create l_exprs.make
			l_exprs.extend ("a_recipient_class")
			l_exprs.extend ("a_recipient")
			l_exprs.extend ("a_exception_code")
			l_exprs.extend ("a_bpslot")
			l_exprs.extend ("a_tag")
			l_exprs.extend ("a_passing")
			l_exprs.extend ("a_test_case_number")
			create Result.make_with_text (a_class, a_feature, l_exprs)
		end

	on_new_test_case_found (a_breakpoint: BREAKPOINT; a_state: AFX_STATE)
			-- Action to be performed when `a_breakpoint' is hit
		local
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_skeleton: AFX_STATE_SKELETON
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
		do
			l_recipient_class := first_class_starts_with_name (a_state.item_with_expression (once "a_recipient_class").value.out)
			l_recipient := l_recipient_class.feature_named (a_state.item_with_expression (once "a_recipient").value.out)

			io.put_string ("-----------------------------------%N")
			io.put_string (a_state.debug_output)
			io.put_string ("%N%N")

				-- Dispose breakpoint manager for the last test case.
			if current_test_case_breakpoint_manager /= Void then
				current_test_case_breakpoint_manager.toggle_breakpoints (False)
				remove_breakpoint (current_test_case_breakpoint_manager.class_)
			end

				-- Setup breakpoint manager for the next test case.
			create l_gen.make
			l_gen.generate (l_recipient_class, l_recipient)
			create l_skeleton.make_with_accesses (l_recipient_class, l_recipient, l_gen.accesses)
			create current_test_case_breakpoint_manager.make (l_recipient_class, l_recipient)

			current_test_case_breakpoint_manager.set_hit_action_with_agent (l_skeleton, agent on_breakpoint_hit_in_test_case, l_recipient)
			current_test_case_breakpoint_manager.set_all_breakpoints_in_feature (l_skeleton, l_recipient)
			current_test_case_breakpoint_manager.toggle_breakpoints (True)
		end

	on_breakpoint_hit_in_test_case (a_breakpoint: BREAKPOINT; a_state: AFX_STATE)
			-- Action to be performed when `a_breakpoint' is hit.
			-- `a_breakpoint' is a break point in a test case.
			-- `a_state' stores the values of all evaluated expressions'.
		do
			io.put_string ("BP_" + a_breakpoint.breakable_line_number.out + "%N")
			io.put_string (a_state.debug_output)
			io.put_string ("%N%N")
		end

	current_test_case_breakpoint_manager: detachable AFX_BREAKPOINT_MANAGER
			-- Breakpoint manager for current test case

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

	mark_test_case_feature_name: STRING = "mark_test_case"
			-- Name of feature to indicate that a new test case is about to run

	remove_breakpoint (a_class: CLASS_C)
			-- Remove user break points in `a_class'.
		do
			debugger_manager.breakpoints_manager.remove_user_breakpoints_in_class (a_class)
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		do
			if a_dm.application_is_executing or a_dm.application_is_stopped then
				if a_dm.application_status.reason_is_catcall or a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					a_dm.controller.resume_workbench_application
				end
			end
		end

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
