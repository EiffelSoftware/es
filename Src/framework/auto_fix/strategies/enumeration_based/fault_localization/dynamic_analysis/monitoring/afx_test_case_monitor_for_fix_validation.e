note
	description: "Summary description for {AFX_TEST_CASE_MONITOR_FOR_FIX_VALIDATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_MONITOR_FOR_FIX_VALIDATION

inherit

	AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS
		redefine
			register_program_state_monitoring,
			on_application_exception,
			start_debugger
		end

--create
--	default_create

--feature -- Access

--	features_to_monitor: DS_HASH_SET [AFX_FEATURE_TO_MONITOR] assign set_features_to_monitor
--			--

--feature -- Setter
--	set_features_to_monitor (a_features: like features_to_monitor)
--			--
--		do
--			features_to_monitor := a_features
--		end

feature -- Debugger action

	start_debugger
			-- Start debugging with proper arguments.
		do
			entry_breakpoint_manager.toggle_breakpoints (True)
			register_program_state_monitoring
			start_debugger_general (debugger_manager, " --validate_contract_fix " + session.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, session.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- Action on application exception.
		do
				if is_inside_test_case then
						-- During monitoring, mark the trace as from a FAILED execution.
					trace_repository.current_trace.set_status_as_failing
				end
		end

feature -- Basic operation

	register_program_state_monitoring
			-- Register program state monitors.
		local
			l_features_to_monitor: like features_to_monitor
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_contract_expressions: TUPLE [pre: EPA_HASH_SET [EPA_EXPRESSION]; post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_expressions: LINKED_LIST [EPA_EXPRESSION]
			l_state_skeleton: EPA_STATE_SKELETON
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_nbr_postconditions, l_total_breakpoints: INTEGER
		do
			l_features_to_monitor := features_to_monitor
			create l_contract_extractor
			from
				l_features_to_monitor.start
			until
				l_features_to_monitor.after
			loop
				l_feature_to_monitor := l_features_to_monitor.item_for_iteration

				l_class := l_feature_to_monitor.context_class
				l_feature := l_feature_to_monitor.feature_
				l_total_breakpoints := l_feature.e_feature.number_of_breakpoint_slots
				l_nbr_postconditions := l_contract_extractor.postcondition_of_feature (l_feature, l_class).count
				l_contract_expressions := l_feature_to_monitor.expressions_to_monitor_at_entry_and_exit
				create l_expressions.make
				l_contract_expressions.post.do_all (agent l_expressions.force)
				create l_manager.make (l_class, l_feature)
				l_manager.set_breakpoint_with_expression_and_action (1, l_contract_expressions.pre, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
				l_manager.set_breakpoint_with_expression_and_action (l_total_breakpoints - l_nbr_postconditions + 1,   -- l_feature_to_monitor.last_breakpoint_in_body + 1,
						l_contract_expressions.post, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
				monitored_breakpoint_managers.force_last (l_manager)

				l_features_to_monitor.forth
			end
		end

end
