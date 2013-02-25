note
	description: "Summary description for {AFX_INTRA_FEATURE_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INTRA_FEATURE_TRACE_COLLECTOR

inherit

	AFX_TRACE_COLLECTOR
		redefine
			set_up,
			wrap_up
		end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			make_general
		end

feature -- Basic operation

	set_up
			-- <Precursor>
		do
			Precursor

			arff_generator_cache := Void

			if config.is_using_model_based_strategy and then config.is_arff_generation_enabled then
				test_case_execution_event_listeners.force_last (arff_generator)
			end
		end

--	start_debugger
--			-- <Precursor>
--		do
--			start_debugger_general (debugger_manager, " --analyze-tc " + config.interpreter_log_path.utf_8_name + " false -eif_root " + afx_project_root_class + "." + afx_project_root_feature, config.working_directory.utf_8_name, {EXEC_MODES}.Run, False)
--		end

	wrap_up
			-- <Precursor>
		do
			Precursor

			if session.exception_signature /= Void and then not session.is_canceled then
				if config.is_using_random_based_strategy then
						-- Interprete program states based on the observed evaluations.
					set_trace_repository (trace_repository.derived_repository (exception_recipient_feature.derived_state_skeleton))
				end
			else
				session.cancel
			end
		end

	register_program_state_monitoring
			-- <Precursor>
		local
			l_recipient_class: CLASS_C
			l_recipient: FEATURE_I
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_expressions: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_expression_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_recipient_class := exception_recipient_feature.context_class
			l_recipient := exception_recipient_feature.feature_
			l_expressions := exception_recipient_feature.expressions_to_monitor
			create l_expression_set.make_equal (l_expressions.count)
			l_expressions.keys.do_all (agent l_expression_set.force)

			create l_manager.make (l_recipient_class, l_recipient)
			l_manager.set_all_breakpoints_with_expression_and_actions (l_expression_set, agent on_breakpoint_hit_in_test_case (l_recipient_class, l_recipient, ?, ?))

			monitored_breakpoint_managers.force_last (l_manager)
		end

feature{NONE} -- Execution Evetn Listener

	arff_generator: AFX_ARFF_GENERATOR
			-- Generator for ARFF file, ARFF file is used for the Weka tool.
		do
			if arff_generator_cache = Void then
				create arff_generator_cache.make
			end
			Result := arff_generator_cache
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Cache

	arff_generator_cache: detachable AFX_ARFF_GENERATOR
			-- Cache for `arff_generator'.

end
