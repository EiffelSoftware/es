note
	description: "Summary description for {EWB_AUTO_FIX_TEST_CASE_ANALYZE_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_APP_ANALYZER

inherit
	SHARED_WORKBENCH

	SHARED_DEBUGGER_MANAGER

	AFX_SHARED_CLASS_THEORY

	AFX_DEBUGGER_HELPER

	AFX_SHARED_STATE_SERVER

	SHARED_EIFFEL_PARSER

	AFX_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		local
			l: AFX_INTERPRETER
		do
			config := a_config
			create test_case_start_actions
			create test_case_breakpoint_hit_actions
			create application_exited_actions
			create exception_spots.make (5)
			exception_spots.compare_objects

			create test_case_execution_status.make (config)
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
		do
			is_mocking := config.is_mocking_mode_enabled

				-- Setup test case execution status collector.
			test_case_start_actions.extend (agent test_case_execution_status.on_test_case_start (?, is_mocking))
			if not is_mocking then
				test_case_breakpoint_hit_actions.extend (agent test_case_execution_status.on_break_point_hit)
				application_exited_actions.extend (agent test_case_execution_status.on_application_exited)
			end

				-- Setup ARFF file generation.
			if config.is_arff_generation_enabled then
				create arff_generator.make (config)
				test_case_breakpoint_hit_actions.extend (agent arff_generator.on_test_case_breakpoint_hit)
				application_exited_actions.extend (agent arff_generator.on_application_exited)
			end

				-- Setup Daikon.
			if config.is_daikon_enabled then
				if is_mocking then
					create {AFX_DAIKON_FACILITY_MOCK} daikon_facility.make (config)
				else
					create daikon_facility.make (config)
				end
				test_case_start_actions.extend (agent daikon_facility.on_new_test_case_found)
				test_case_breakpoint_hit_actions.extend (agent daikon_facility.on_test_case_breakpoint_hit)
				application_exited_actions.extend (agent daikon_facility.on_application_exited)
			end

--			debug ("autofix")
--				 -- Output retrieved state.
--				test_case_breakpoint_hit_actions.extend (agent on_test_case_breakpoint_hit_print_state)
--			end

				-- Start test case analysis
			analyze_test_cases

				-- Generate fixes.
			generate_fixes
--			create fixes.make

				-- Validate generated fixes.
			validate_fixes

		end

feature{NONE} -- Access

	is_mocking: BOOLEAN
			-- Is Current run a mock run?
			-- A mock run will stopping target application execution at the first failing test case,
			-- and load the prestored state invariants.
			-- Note: This is to save debugging time. To be removed in final code.

	arff_generator: detachable AFX_ARFF_GENERATOR
			-- Generator for ARFF file,
			-- ARFF file is used for Weka tool

	daikon_facility: detachable AFX_DAIKON_FACILITY
			-- Daikon Facility

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
			l_exprs.extend (expr_a_dry_run)
			l_exprs.extend (expr_a_uuid)
			l_exprs.extend (expr_a_trace)
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
			remove_breakpoint (debugger_manager, root_class)

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
			start_debugger (debugger_manager, "--analyze-tc " + config.interpreter_log_path + " false", config.working_directory)

				-- Clean up debugger.
			debugger_manager.observer_provider.application_stopped_actions.prune_all (l_app_stop_agent)
			debugger_manager.observer_provider.application_exited_actions.prune_all (l_app_exited_agent)
			remove_breakpoint (debugger_manager, root_class)
		end

	analyze_test_cases
			-- Analyze test cases.
		do
			debug_project
		end

feature{NONE} -- Constants

	expr_a_recipient_class: STRING = "a_recipient_class"
	expr_a_recipient: STRING = "a_recipient"
	expr_a_exception_code: STRING = "a_exception_code"
	expr_a_bpslot: STRING = "a_bpslot"
	expr_a_tag: STRING = "a_tag"
	expr_a_passing: STRING = "a_passing"
	expr_a_test_case_number: STRING = "a_test_case_number"
	expr_a_dry_run: STRING = "a_dry_run"
	expr_a_uuid: STRING = "a_uuid"
	expr_a_trace: STRING = "a_trace"

feature{NONE} -- Actions

	recipient_from_trace (a_origin_recipient: STRING; a_written_class: STRING; a_trace: STRING): TUPLE [recipient_class: STRING; recipient: STRING]
			-- Recipient feature along with its associated class from exception trace `a_trace'
		local
			l_lines: LIST [STRING]
			l_line: STRING
			i: INTEGER
			l_trace_lines: STRING
			l_done: BOOLEAN
			l_analyzer: AFX_EXCEPTION_TRACE_ANALYSER
			l_frames: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			l_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I
			l_ori_class: STRING
			l_ori_feature: STRING
			l_context_class: STRING
			l_context_feature: STRING
		do
			l_lines := a_trace.split ('%N')
			from
				i := 1
				l_lines.start
			until
				i > 7
			loop
				l_lines.remove
				i := i + 1
			end

			create l_trace_lines.make (a_trace.count)
			from
				l_lines.start
			until
				l_lines.after or l_done
			loop
				l_line := l_lines.item_for_iteration
				l_line.keep_tail (l_line.count - 2)
				l_line.left_adjust
				if l_line.is_empty then
					l_done := True
				else
					l_trace_lines.append (l_line)
					l_trace_lines.append_character ('%N')
					l_lines.forth
				end
			end

			create l_analyzer
			l_analyzer.analyse (l_trace_lines)
			l_frames := l_analyzer.last_relevant_exception_frames

			from
				l_done := False
				l_frames.start
			until
				l_frames.after or else l_done
			loop
				l_frame := l_frames.item_for_iteration
				if attached {STRING} l_frame.context_class_name as l_cclass then
					l_context_class := l_cclass
				else
					check should_not_happen: False end
				end

				if attached {STRING} l_frame.feature_name as l_feat_name then
					l_context_feature := l_feat_name
				else
					check should_not_happen: False end
				end

				if attached {STRING} l_frame.origin_class_name as l_oclass then
					l_ori_class := l_oclass
				else
					l_ori_class := l_context_class
				end
				l_ori_feature := l_context_feature

				if l_ori_class ~ a_written_class and then l_ori_feature ~ a_origin_recipient then
					l_done := True
					Result := [l_context_class, l_context_feature]
				end
				l_frames.forth
			end
		ensure
			result_attached: Result /= Void
		end

	on_new_test_case_found (a_breakpoint: BREAKPOINT; a_test_case_info: AFX_STATE)
			-- Action to be performed when `a_breakpoint' is hit
		local
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_exception_code: INTEGER
			l_bpslot: INTEGER
			l_tag: STRING
			l_passing: BOOLEAN
			l_table: HASH_TABLE [AFX_EXPRESSION_VALUE, STRING]
			l_spot: AFX_EXCEPTION_SPOT
			l_uuid: STRING
			l_trace: STRING
			l_data: like recipient_from_trace
		do
			l_table := a_test_case_info.to_hash_table
			l_recipient_class := first_class_starts_with_name (l_table.item (expr_a_recipient_class).out)
			l_recipient := l_recipient_class.feature_named (l_table.item (expr_a_recipient).out)
			l_exception_code := l_table.item (expr_a_exception_code).out.to_integer
			l_bpslot := l_table.item (expr_a_bpslot).out.to_integer
			l_tag := l_table.item (expr_a_tag).out
			l_passing := l_table.item (expr_a_passing).out.to_boolean
			l_uuid := l_table.item (expr_a_uuid).out
			l_trace := l_table.item (expr_a_trace).out
			set_is_current_test_case_dry_run (l_table.item (expr_a_dry_run).out.to_boolean)

			if l_passing then
				check not exception_spots.is_empty end
				exception_spots.start
				current_test_case_info := exception_spots.item_for_iteration.test_case_info.deep_twin
				current_test_case_info.set_is_passing (True)
				current_test_case_info.set_uuid (l_uuid)
			else
				l_data := recipient_from_trace (l_recipient.feature_name.as_lower, l_recipient_class.name_in_upper, l_trace)
				create current_test_case_info.make (l_recipient_class.name, l_recipient.feature_name, l_data.recipient_class, l_data.recipient, l_exception_code, l_bpslot, l_tag, l_passing, l_uuid)
--				create current_test_case_info.make (l_recipient_class.name, l_recipient.feature_name, l_recipient_class.name, l_recipient.feature_name, l_exception_code, l_bpslot, l_tag, l_passing, l_uuid)
			end

			if is_current_test_case_dry_run then
			else
				l_spot := exception_spots.item (current_test_case_info.id)

				test_case_start_actions.call ([current_test_case_info])

					-- Dispose breakpoint manager for the last test case.
				if current_test_case_breakpoint_manager /= Void then
					current_test_case_breakpoint_manager.toggle_breakpoints (False)
					remove_breakpoint (debugger_manager, current_test_case_breakpoint_manager.class_)
				end

				l_recipient_class := current_test_case_info.recipient_written_class
				l_recipient := current_test_case_info.origin_recipient
				create current_test_case_breakpoint_manager.make (l_recipient_class, l_recipient)
				current_test_case_breakpoint_manager.set_hit_action_with_agent (l_spot.skeleton, agent on_breakpoint_hit_in_test_case, l_recipient)
				current_test_case_breakpoint_manager.set_all_breakpoints_in_feature (l_spot.skeleton, l_recipient)
				current_test_case_breakpoint_manager.toggle_breakpoints (True)
			end
		end

	on_breakpoint_hit_in_test_case (a_breakpoint: BREAKPOINT; a_state: AFX_STATE)
			-- Action to be performed when `a_breakpoint' is hit.
			-- `a_breakpoint' is a break point in a test case.
			-- `a_state' stores the values of all evaluated expressions'.
		do
			a_state.keep_if (
				agent (a_equation: AFX_EQUATION): BOOLEAN
					do
						Result :=
							a_equation.value.is_integer or
							a_equation.value.is_boolean
					end)

			test_case_breakpoint_hit_actions.call ([current_test_case_info, a_state, a_breakpoint.breakable_line_number])
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		do
			if a_dm.application_is_executing or a_dm.application_is_stopped then
				if a_dm.application_status.reason_is_catcall or a_dm.application_status.reason_is_overflow then
					a_dm.application.kill
				else
					if a_dm.application_status.exception_occurred and then is_current_test_case_dry_run then
						collect_exception_info
					end
					if is_mocking then
							-- Mocking is designed for ease of debugging.
--						if attached {AFX_DAIKON_FACILITY_MOCK} daikon_facility as l_daikon then
--							l_daikon.on_new_test_case_found (current_test_case_info)
--						end
						test_case_start_actions.call ([current_test_case_info])
--						test_case_execution_status.on_test_case_start (current_test_case_info, is_mocking)
						a_dm.application.kill
					else
						a_dm.controller.resume_workbench_application
					end
				end
			end
		end

	on_application_exited (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application exited.
		do
			application_exited_actions.call (Void)
		end

	collect_exception_info
			-- Collect information about the current exception.
		local
			l_stack_level: INTEGER
			l_old_stack_level: INTEGER
			l_app: APPLICATION_EXECUTION
			l_value: DUMP_VALUE
			l_stack_ele: CALL_STACK_ELEMENT
			l_recipient_id: STRING
			l_spot_analyzer: AFX_EXCEPTION_SPOT_ANALYZER
		do
				-- Generate state model for current test case.
			l_recipient_id := current_test_case_info.id
			if not exception_spots.has (l_recipient_id) then
				create l_spot_analyzer.make (config)
				l_spot_analyzer.analyze (current_test_case_info, debugger_manager)
				exception_spots.put (l_spot_analyzer.last_spot, l_recipient_id)
			end

--			l_stack_level := call_stack_index (debugger_manager, test_case_routine_header)
--			if l_stack_level > 0 then
--				l_app := debugger_manager.application
--				l_old_stack_level := l_app.current_execution_stack_number
--				l_app.set_current_execution_stack_number (l_stack_level)
--				l_stack_ele := debugger_manager.application_status.current_call_stack_element
--				l_value := debugger_manager.expression_evaluation ("exception_trace")
--				l_app.set_current_execution_stack_number (l_old_stack_level)
--			end
		end

feature{NONE} -- Implication

	is_current_test_case_dry_run: BOOLEAN
			-- Is current test case a dry-run?
			-- In a dry-run, the system states are not retrieved.

	set_is_current_test_case_dry_run (b: BOOLEAN)
			-- Set `is_current_test_case_dry_run' with `b'.
		do
			is_current_test_case_dry_run := b
		ensure
			is_current_test_case_dry_run_set: is_current_test_case_dry_run = b
		end

	test_case_routine_header: STRING = "generated_test_1"
			-- Header for the routine which is used to execute feature under test

	exception_spots: HASH_TABLE [AFX_EXCEPTION_SPOT, STRING]
			-- Set of state models that are already met
			-- Keys are test case info id, check {AFX_TEST_CASE_INFO}.`id' for details.
			-- Values are the associated exception spots.

	on_test_case_breakpoint_hit_print_state (a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER)
			-- Action to perform when a breakpoint `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the set of expressions with their evaluated values.
		local
			l_sorter: DS_QUICK_SORTER [AFX_EQUATION]
			l_equations: DS_ARRAYED_LIST [AFX_EQUATION]
		do
			create l_equations.make (a_state.count)
			a_state.do_all (agent l_equations.force_last)

			create l_sorter.make (equation_tester)
			l_sorter.sort (l_equations)

			check current_test_case_info /= Void end

			io.put_string (a_tc.recipient_class + "." + a_tc.recipient + "@" + a_bpslot.out + "%N")
			l_equations.do_all (
				agent (a_equation: AFX_EQUATION)
					do
						io.put_string (a_equation.debug_output + "%N")
					end)

			io.put_string ("%N")
		end

	equation_tester: AGENT_BASED_EQUALITY_TESTER [AFX_EQUATION] is
			-- Tester to decide the order of two equations.
		do
			create Result.make (agent (a, b: AFX_EQUATION): BOOLEAN
				do
					Result := a.expression.text < b.expression.text
				end)
		end

	test_case_execution_status: AFX_TEST_CASE_EXECUTION_STATUS_COLLECTOR
			-- Test case execution status
			-- Include both passing and failing test cases.

feature -- Fix generation

	fixes: LINKED_LIST [AFX_FIX]
			-- Generated fixes

	generate_fixes
			-- Generate candidate fixes.
		local
			l_gen: AFX_ASSERTION_VIOLATION_FIX_GENERATOR
			l_text_equal_fixes: HASH_TABLE [INTEGER, STRING]
			l_fix: AFX_FIX
			l_text: STRING
		do
			create fixes.make
			check exception_spots.count = 1 end
			exception_spots.start
			create l_gen.make (exception_spots.item_for_iteration, config, test_case_execution_status.status)
			l_gen.generate
			fixes.append (l_gen.fixes)

				-- Remove syntactially equivalent fixes.
			create l_text_equal_fixes.make (fixes.count)
			l_text_equal_fixes.compare_objects
			from
				fixes.start
			until
				fixes.after
			loop
				l_fix := fixes.item_for_iteration
				l_text := l_fix.text
				if l_text_equal_fixes.has (l_text) then
					fixes.remove
				else
					l_text_equal_fixes.put (1, l_text)
					fixes.forth
				end
			end

			store_fixes (fixes)
		end

	validate_fixes
			-- Validate `fix_skeletons'.
		local
			l_validator: AFX_FIX_VALIDATOR
			l_spot: AFX_EXCEPTION_SPOT
		do
			check not exception_spots.is_empty end
			exception_spots.start
			l_spot := exception_spots.item_for_iteration
			create l_validator.make (config, l_spot, fixes, test_case_execution_status.status)
			l_validator.validate
		end

	store_fixes (a_fixes: LINKED_LIST [AFX_FIX])
			-- Store fixes in to files.
		do
			a_fixes.do_all (agent store_fix_in_file (config.fix_directory, ?, False))
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
