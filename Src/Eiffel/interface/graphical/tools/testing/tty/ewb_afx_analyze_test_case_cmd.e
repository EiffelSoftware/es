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
			create test_case_start_actions
			create test_case_breakpoint_hit_actions
			create application_exited_actions
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config for AutoFix ocmmand line	

	test_case_start_actions: ACTION_SEQUENCE[TUPLE [AFX_TEST_CASE_INFO]]
			-- Actions to be performed when a test case is to be analyzed.
			-- The information about the test case is passed as the argument to the agent.

	test_case_breakpoint_hit_actions: ACTION_SEQUENCE [TUPLE [a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER]]
			-- Actions to be performed when a breakpoint is hit in a test case.
			-- `a_tc' is the test case currently analyzed.
			-- `a_state' is the state evaluated at the breakpoint.
			-- `a_bpslot' is the breakpoint slot number.

	application_exited_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when application exited in debugger

feature -- Basic operations

	execute
			-- Execute.
		local
			l_arff_gen: AFX_ARFF_GENERATOR
		do
			create l_arff_gen.make
			test_case_breakpoint_hit_actions.extend (agent l_arff_gen.on_test_case_breakpoint_hit)
			application_exited_actions.extend (agent l_arff_gen.on_application_exited)
			debug_project
		end

feature{NONE} -- Access

	current_test_case_breakpoint_manager: detachable AFX_BREAKPOINT_MANAGER
			-- Breakpoint manager for current test case

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

	mark_test_case_feature_name: STRING = "mark_test_case"
			-- Name of feature to indicate that a new test case is about to run

	test_case_info_skeleton (a_class: CLASS_C; a_feature: FEATURE_I): AFX_STATE_SKELETON
			-- State skeleton containing expressions to retrieve test case information from `a_feature'
		local
			l_exprs: LINKED_LIST [STRING]
		do
			create l_exprs.make
			l_exprs.extend (expr_a_recipient_class)
			l_exprs.extend (expr_a_recipient)
			l_exprs.extend (expr_a_exception_code)
			l_exprs.extend (expr_a_bpslot)
			l_exprs.extend (expr_a_tag)
			l_exprs.extend (expr_a_passing)
			l_exprs.extend (expr_a_test_case_number)
			create Result.make_with_text (a_class, a_feature, l_exprs)
		end

	current_test_case_info: detachable AFX_TEST_CASE_INFO
			-- Information about currently analyzed test case

feature{NONE} -- Implementation

	debug_project
			-- Debug current project to retrieve system states from test cases.
		local
			l_new_tc_bp_manager: AFX_BREAKPOINT_MANAGER
			l_mark_tc_feat: FEATURE_I
			l_tc_info_skeleton: AFX_STATE_SKELETON
			l_app_stop_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
			l_app_exited_agent: PROCEDURE [ANY, TUPLE [DEBUGGER_MANAGER]]
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
			l_app_stop_agent := agent on_application_stopped
			l_app_exited_agent := agent on_application_exited
			debugger_manager.observer_provider.application_stopped_actions.extend (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.extend (l_app_exited_agent)

				-- Start debugger.
			start_debugger

				-- Clean up debugger.
			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exited_agent)
			remove_breakpoint (root_class)
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

	remove_breakpoint (a_class: CLASS_C)
			-- Remove user break points in `a_class'.
		do
			debugger_manager.breakpoints_manager.remove_user_breakpoints_in_class (a_class)
		end

feature{NONE} -- Constants

	expr_a_recipient_class: STRING is "a_recipient_class"
	expr_a_recipient: STRING is "a_recipient"
	expr_a_exception_code: STRING is "a_exception_code"
	expr_a_bpslot: STRING is "a_bpslot"
	expr_a_tag: STRING is "a_tag"
	expr_a_passing: STRING is "a_passing"
	expr_a_test_case_number: STRING is "a_test_case_number"

feature{NONE} -- Actions

	on_new_test_case_found (a_breakpoint: BREAKPOINT; a_state: AFX_STATE)
			-- Action to be performed when `a_breakpoint' is hit
		local
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_exception_code: INTEGER
			l_bpslot: INTEGER
			l_tag: STRING
			l_passing: BOOLEAN
			l_skeleton: AFX_STATE_SKELETON
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
			l_table: HASH_TABLE [AFX_EXPRESSION_VALUE, STRING]
		do
			l_table := a_state.to_hash_table
			l_recipient_class := first_class_starts_with_name (l_table.item (expr_a_recipient_class).out)
			l_recipient := l_recipient_class.feature_named (l_table.item (expr_a_recipient).out)
			l_exception_code := l_table.item (expr_a_exception_code).out.to_integer
			l_bpslot := l_table.item (expr_a_bpslot).out.to_integer
			l_tag := l_table.item (expr_a_tag).out
			l_passing := l_table.item (expr_a_passing).out.to_boolean

			create current_test_case_info.make (l_recipient_class.name, l_recipient.feature_name, l_recipient_class.name, l_recipient.feature_name, l_exception_code, l_bpslot, l_tag, l_passing)
			test_case_start_actions.call ([current_test_case_info])

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
			test_case_breakpoint_hit_actions.call ([current_test_case_info, a_state, a_breakpoint.breakable_line_number])
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

	on_application_exited (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			application_exited_actions.call (Void)
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
