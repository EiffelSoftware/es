note
	description: "Summary description for {AFX_RELAXED_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RELAXED_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS

inherit

	AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS
		redefine
			register_program_state_monitoring,
			on_application_exception,
			start_debugger
		end

create
	make

feature -- Access

	relaxed_feature: AFX_FEATURE_TO_MONITOR assign set_relaxed_feature

	set_relaxed_feature (a_feature: like relaxed_feature)
		require
			feature_attached: a_feature /= Void
			matching_relaxed_feature: session.config.relaxed_feature /= Void and then session.config.relaxed_feature.same_string_general (a_feature.context_class.name_in_upper + "." + a_feature.feature_.feature_name_32.as_string_8)
		do
			relaxed_feature := a_feature
		end

feature -- Debugger action

	start_debugger
			-- Start debugging with proper arguments.
		do
			entry_breakpoint_manager.toggle_breakpoints (True)
			register_program_state_monitoring
			start_debugger_general (debugger_manager, " --analyze-relaxed-tc " + config.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, config.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
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
			-- <Precursor>
		local
			l_features_on_stack: like features_on_stack
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_contract_expressions: TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_expressions: LINKED_LIST [EPA_EXPRESSION]
			l_skeleton: EPA_STATE_SKELETON
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_nbr_postconditions, l_total_breakpoints: INTEGER
		do
			create l_contract_extractor
			l_feature_to_monitor := relaxed_feature
			l_class := l_feature_to_monitor.context_class
			l_feature := l_feature_to_monitor.feature_
			l_total_breakpoints := l_feature.e_feature.number_of_breakpoint_slots
			l_nbr_postconditions := l_contract_extractor.postcondition_of_feature (l_feature, l_class).count
			l_contract_expressions := expressions_for_contracts (l_feature_to_monitor)
			create l_expressions.make
			l_contract_expressions.post.do_all (agent l_expressions.force)
			create state_skeleton_for_relaxed_feature.make_with_expressions (l_class, l_feature, l_expressions)

			create l_manager.make (l_class, l_feature)
			l_manager.set_breakpoint_with_expression_and_action (1,
																 l_contract_expressions.pre, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
			l_manager.set_breakpoint_with_expression_and_action (l_total_breakpoints - l_nbr_postconditions + 1,   -- l_feature_to_monitor.last_breakpoint_in_body + 1,
																 l_contract_expressions.post, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
			monitored_breakpoint_managers.force_last (l_manager)
		end

feature -- Expressions to monitor

	state_skeleton_for_relaxed_feature: EPA_STATE_SKELETON


end
