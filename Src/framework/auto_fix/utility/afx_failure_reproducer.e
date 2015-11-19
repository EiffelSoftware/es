note
	description: "Summary description for {AFX_FAILURE_REPRODUCER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FAILURE_REPRODUCER

inherit
	AFX_EXECUTION_MONITOR
		rename collect as reproduce end

feature{NONE} -- Implementation

	start_debugger
			-- Start debugging with proper arguments.
		do
			start_debugger_general (debugger_manager, " --reproduce-failure " + session.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, session.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
		end

	register_program_state_monitoring
			-- <Precursor>
		do
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- Action on application exception.
		do
				analyze_exception (a_dm)
				initialize_features_to_monitor (a_dm)
		end

feature{NONE} -- Exception analysis

	analyze_exception (a_dm: DEBUGGER_MANAGER)
			-- Analyze exception statically.
		require
			exception_raised: a_dm /= Void and then a_dm.application_status.exception_occurred
		local
			l_exception_code: INTEGER
			l_exception_tag: STRING

			l_call_stack: EIFFEL_CALL_STACK
			l_current_stack_element, l_previous_stack_element: CALL_STACK_ELEMENT
			l_current_class, l_previous_class: CLASS_C
			l_current_feature, l_previous_feature: FEATURE_I
			l_current_breakpoint, l_previous_breakpoint: INTEGER
			l_current_breakpoint_nested, l_previous_breakpoint_nested: INTEGER
			l_exception_signature: AFX_EXCEPTION_SIGNATURE
		do
			l_exception_code := a_dm.application_status.exception.code
			l_exception_tag := a_dm.application_status.exception.message.twin

			l_call_stack := a_dm.application_status.current_call_stack
			l_current_stack_element := l_call_stack.i_th (1)
			l_current_class := first_class_starts_with_name (l_current_stack_element.class_name)
			l_current_feature := l_current_class.feature_named_32 (l_current_stack_element.routine_name)
			l_current_breakpoint := l_current_stack_element.break_index
			l_current_breakpoint_nested := l_current_stack_element.break_nested_index
			l_previous_stack_element := l_call_stack.i_th (2)
			l_previous_class := first_class_starts_with_name (l_previous_stack_element.class_name)
			l_previous_feature := l_previous_class.feature_named_32 (l_previous_stack_element.routine_name)
			l_previous_breakpoint := l_previous_stack_element.break_index
			l_previous_breakpoint_nested := l_previous_stack_element.break_nested_index

			if l_exception_code = {EXCEP_CONST}.Void_call_target then
				create {AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_exception_tag,
						l_current_class, l_current_feature,
						l_current_breakpoint, l_current_breakpoint_nested)
			elseif l_exception_code = {EXCEP_CONST}.precondition then
				create {AFX_PRECONDITION_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint,
						l_previous_class, l_previous_feature, l_previous_breakpoint, l_previous_breakpoint_nested)
			elseif l_exception_code = {EXCEP_CONST}.postcondition then
				create {AFX_POSTCONDITION_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint)
			elseif l_exception_code = {EXCEP_CONST}.Class_invariant then
				create {AFX_INVARIANT_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_exception_tag, l_previous_class, l_previous_feature)
			elseif l_exception_code = {EXCEP_CONST}.Check_instruction then
				create {AFX_CHECK_VIOLATION_SIGNATURE}l_exception_signature.make (
						l_current_class, l_current_feature, l_current_breakpoint)
			elseif l_exception_code = {EXCEP_CONST}.Incorrect_inspect_value then
				create {AFX_UNMATCHED_INSPECT_VALUE_EXCEPTION_SIGNATURE}l_exception_signature.make(
						l_current_class, l_current_feature, l_current_breakpoint)
			end
			session.set_exception_from_execution (l_exception_signature)
		end

	initialize_features_to_monitor (a_dm: DEBUGGER_MANAGER)
		local
			l_features: like features_to_monitor
			l_stack: EIFFEL_CALL_STACK
			l_stack_element, l_test_element: CALL_STACK_ELEMENT
			i: INTEGER_32
			l_test_element_depth: INTEGER_32
			l_class, l_last_class: CLASS_C
			l_feature, l_last_feature: FEATURE_I
			l_feature_under_test, l_feature_to_monitor, l_recipient: AFX_FEATURE_TO_MONITOR
			l_done: BOOLEAN
			l_observed_features: EPA_HASH_SET [STRING]
			l_observed_feature_name: STRING
		do
			create l_features.make_equal (10)
			l_recipient := session.exception_from_execution.recipient_feature_with_context

			l_stack := a_dm.application_status.current_call_stack
			from
				i := 1
				create l_observed_features.make_equal (l_stack.count + 1)
			until
				i > l_stack.count or else l_test_element /= Void or else l_done
			loop
				l_stack_element := l_stack.i_th (i)
				if l_stack_element.routine_name.same_string_general ("generated_test_1") then
					create l_feature_under_test.make (l_last_feature, l_last_class)
					session.set_feature_under_test (l_feature_under_test)

					l_done := True
				else
					l_class := first_class_starts_with_name (l_stack_element.class_name)
					if l_class /= Void then
						l_feature := l_class.feature_named (l_stack_element.routine_name)
						if l_feature /= Void then
							l_last_class := l_class
							l_last_feature := l_feature

							if config.is_fixing_contract then
								l_observed_feature_name := l_class.name_in_upper + "." + l_feature.feature_name_32
								if not l_observed_features.has (l_observed_feature_name) then
									l_observed_features.force (l_observed_feature_name)
									create l_feature_to_monitor.make (l_feature, l_class)
									l_feature_to_monitor.set_monitor_contracts (True)
									l_feature_to_monitor.set_monitor_body (config.is_fixing_implementation and then l_feature_to_monitor.is_about_same_feature (l_recipient))
									l_features.force_last (l_feature_to_monitor)
								end
							end
						end
					end
				end
				i := i + 1
			end

			if l_features.is_empty then
					-- Fixing implementation only.
				l_recipient.set_monitor_body (True)
				l_features.force_last (l_recipient)
			end

			set_features_to_monitor (l_features)
		end

end
