indexing
	description: "Objects that execute the application for capturing the correct pre-state for some test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_EXAMINATOR

inherit

	CDD_ABSTRACT_TESTER

create
	make

feature {NONE} -- Initialization

	make (a_manager: like manager; a_dbg_manager: EB_DEBUGGER_MANAGER) is
			--
		require
			a_manager_not_void: a_manager /= Void
			a_dbg_manager_not_void: a_dbg_manager /= Void
		do
			make_with_manager (a_manager)
			debugger_manager := a_dbg_manager
			create {LINKED_STACK [CDD_REFLECTION]} reflection_stack.make
		ensure
			a_dbg_set: debugger_manager = a_dbg_manager
		end

feature -- Access

	is_running: BOOLEAN
			-- Are we currently doing something?

	can_start: BOOLEAN is
			-- Can we start the examination?
		do
			Result := not is_running and not debugger_manager.application.is_running
		end

	test_case: CDD_TEST_CASE
			-- Test case beeing examinated

	debugger_manager: EB_DEBUGGER_MANAGER
			-- Debugger manager for running the application

	valid_application_status: BOOLEAN is
			-- Does application in `debugger_manager' have a valid status for break point checking?
		local
			l_app: APPLICATION_EXECUTION
		do
			l_app := debugger_manager.application
			Result := l_app.is_running and then (l_app.status.is_stopped and l_app.status.reason = l_app.status.pg_break)
		end

	has_reflection (a_feature: E_FEATURE): BOOLEAN is
			-- Do we have a reflection for `a_feature'?
		require
			running: is_running
			a_feature_not_void: a_feature /= Void
		do
			if not reflection_stack.is_empty then
				Result := test_case.feature_under_test.is_equal (a_feature)
			end
		end

	current_reflection: CDD_REFLECTION is
			-- Current pre state of top most `feature_under_test' in `test_case'
			-- Void of `feature_under_test' was not called yet
		require
			is_running
		do
			Result := reflection_stack.item
		ensure
			correct_result: Result = Void or else Result.called_feature.is_equal (test_case.feature_under_test)
		end

feature -- Status setting

	examinate (a_test_case: CDD_TEST_CASE) is
			-- Run application for examinating `a_test_case'.
		require
			a_test_case_not_void: a_test_case /= Void
			can_start: can_start
		local
			l_dbg_info: DEBUG_INFO
			l_feature: E_FEATURE
		do
			l_dbg_info := debugger_manager.application.debug_info
			l_dbg_info.disable_all_breakpoints
			l_feature := a_test_case.feature_under_test

				-- NOTE: `first_breakpoint_slot_index' returnes wrong value for empty features
			l_dbg_info.enable_breakpoint (l_feature, 1)

			l_dbg_info.enable_breakpoint (l_feature, l_feature.number_of_breakpoint_slots)
			is_running := True
			test_case := a_test_case
			debugger_manager.application.set_execution_mode ({EXEC_MODES}.user_stop_points)
			debugger_manager.debug_run_cmd.launch_application
		ensure
			is_running
		end

	stop is
			-- Remove breakpoints, wipe out reflection stack and set `is_running' to False.
		require else
			running: is_running
		local
			l_dbg_info: DEBUG_INFO
			l_feature: E_FEATURE
		do
			l_dbg_info := debugger_manager.application.debug_info
			l_feature := test_case.feature_under_test
			l_dbg_info.remove_breakpoint (l_feature, 1)
			l_dbg_info.remove_breakpoint (l_feature, l_feature.number_of_breakpoint_slots)

			reflection_stack.wipe_out
			is_running := False
			test_case := Void
		ensure then
			not_running: not is_running
		end

feature -- Application status

	on_application_stop is
			-- Call when application has breaked (possibly becuase of some breakpoint)
		require
			running: is_running
			valid_status: valid_application_status
		local
			l_status: APPLICATION_STATUS
			l_reflection: CDD_REFLECTION
			l_cse: EIFFEL_CALL_STACK_ELEMENT
		do
			l_status := debugger_manager.application.status
			if l_status.dynamic_class.original_class.name.is_equal (test_case.class_under_test.name) and
				l_status.e_feature.name.is_equal (test_case.feature_under_test.name) then
				if l_status.break_index = 1 then
					l_cse ?= l_status.current_call_stack_element
					check cse_not_void: l_cse /= Void end
						-- NOTE: we assume that the current routine is no creation call
					create l_reflection.make (l_status, l_cse, False)
					reflection_stack.extend (l_reflection)
					debugger_manager.application.continue
				elseif l_status.break_index = test_case.feature_under_test.number_of_breakpoint_slots then
					reflection_stack.remove
					debugger_manager.application.continue
				end
			end
		end

feature {NONE} -- Implementation

	reflection_stack: STACK [CDD_REFLECTION]

invariant
	debugger_manager_not_void: debugger_manager /= Void
	reflection_stack_not_void: reflection_stack /= Void
	not_running_implies_stack_empty: not is_running implies reflection_stack.is_empty

end
