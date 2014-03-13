note
	description: "Summary description for {AFX_INTRA_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TRACE_COLLECTOR

inherit

	AFX_EXECUTION_MONITOR
		redefine
			set_up
		end

feature -- Monitor mode

	monitor_mode: STRING assign set_monitor_mode

	is_valid_monitor_mode (a_mode: STRING): BOOLEAN
		do
			Result := a_mode ~ Mode_analyze_tc or else a_mode ~ Mode_analyze_relaxed_tc or else a_mode ~ Mode_analyze_all_tc
		end

	set_monitor_mode (a_mode: STRING)
			--
		require
			is_valid_monitor_mode (a_mode)
		do
			monitor_mode := a_mode
		end

	Mode_analyze_tc: STRING
		once
			Result := "analyze-tc"
		end

	Mode_analyze_relaxed_tc: STRING
		once
			Result := "analyze-relaxed-tc"
		end

	Mode_analyze_all_tc: STRING
		once
			Result := "analyze-all-tc"
		end

feature -- Redefinition

	set_up
			-- <Precursor>
		do
			Precursor
			register_program_state_monitoring
		end

	start_debugger
			-- <Precursor>
		local
			l_argument: STRING
		do
			start_debugger_general (debugger_manager, " --" + monitor_mode + " " + session.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, session.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- <Precursor>
		do
			if is_inside_test_case then
				trace_repository.current_trace.set_status_as_failing
					-- Disable monitoring so that the trace is not polluted during exception handling.
				enable_state_monitoring (False)
			end
		end

	register_program_state_monitoring
			-- <Precursor>
		local
			l_features_to_monitor: like features_to_monitor
			l_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FEATURE_TO_MONITOR]
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_expressions_to_monitor_at_breakpoints: DS_HASH_TABLE [EPA_HASH_SET [EPA_EXPRESSION], INTEGER]
			l_breakpoint_cursor: DS_HASH_TABLE_CURSOR [EPA_HASH_SET [EPA_EXPRESSION], INTEGER]

			l_recipient: AFX_FEATURE_TO_MONITOR
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_expressions: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_expression_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_features_to_monitor := features_to_monitor
			from
				l_cursor := l_features_to_monitor.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_feature_to_monitor := l_cursor.item

				create l_manager.make (l_feature_to_monitor.context_class, l_feature_to_monitor.feature_)
				l_expressions_to_monitor_at_breakpoints := l_feature_to_monitor.expressions_to_monitor_at_breakpoints
				from
					l_breakpoint_cursor := l_expressions_to_monitor_at_breakpoints.new_cursor
					l_breakpoint_cursor.start
				until
					l_breakpoint_cursor.after
				loop
					l_manager.set_breakpoint_with_expression_and_action (l_breakpoint_cursor.key, l_breakpoint_cursor.item, agent on_breakpoint_hit_in_test_case (l_feature_to_monitor.context_class, l_feature_to_monitor.feature_, ?, ?))
					l_breakpoint_cursor.forth
				end
				monitored_breakpoint_managers.force_last (l_manager)

				l_cursor.forth
			end

		end

end
