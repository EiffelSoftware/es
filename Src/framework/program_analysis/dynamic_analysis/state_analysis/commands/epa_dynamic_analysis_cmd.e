note
	description: "Command to collect runtime data through dynamic means"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DYNAMIC_ANALYSIS_CMD

inherit
	EPA_DEBUGGER_UTILITY

	SHARED_WORKBENCH

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_CFG_UTILITY

	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current command.
		do
			check_config_validity (a_config)
			if not is_config_valid then
				io.put_string ("%N" + error_message + "%N")
				die (-1)
			end
			config := a_config
			class_ := config.location.class_
			feature_ := config.location.feature_
		ensure
			config_set: config = a_config
			class_set: class_ = config.location.class_
			feature_set: feature_ = config.location.feature_
		end

feature -- Access

	config: EPA_DYNAMIC_ANALYSIS_CONFIG
			-- Config for runtime data collection

feature -- Basic operations

	execute
			-- Execute Current command
		local
			l_processor: EPA_COLLECTED_RUNTIME_DATA_PROCESSOR
			l_writer: EPA_COLLECTED_RUNTIME_DATA_WRITER
			l_reader: EPA_COLLECTED_RUNTIME_DATA_READER
		do
			-- Find post-state(s) for all pre-states in `l_feature'.
			find_all_post_states

			-- Choose pre-states
			choose_pre_states

			-- Setup expressions which are evaluated
			setup_expressions

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, config.root_class)

			-- Set up the action for the evaluation of pre- and post-states.
			create l_processor.make (interesting_pre_states, post_state_map, config.prgm_locs_with_exprs, debugger_manager)
			setup_action_for_evaluation (l_processor)

			-- Start program execution in debugger.
			start_debugger (debugger_manager, "", config.working_directory, {EXEC_MODES}.run, False)

			-- Remove the last debugging session.
			remove_debugger_session

			-- Post process data for writing to disk.
			l_processor.post_process

			-- Write data to disk			
			create l_writer.make (class_, feature_, l_processor.last_data, l_processor.last_analysis_order, config.output_path)
			l_writer.write

			create l_reader
			l_reader.read_from_path (config.output_path)
		end

feature {NONE} -- Implemenation

	check_config_validity (a_config: EPA_DYNAMIC_ANALYSIS_CONFIG)
			-- Checks, if `a_config' a valid configuration and makes result available
			-- in `is_config_valid' and makes error message available in `error_message'.
		require
			a_config_not_void: a_config /= Void
		local
			l_class_valid, l_feature_valid, l_prgm_locs_valid, l_exprs_valid, l_exprs_locs_comb_valid, l_vars_locs_comb_valid, l_outputh_path_valid: BOOLEAN
			l_file_name: FILE_NAME
		do
			error_message := "-------------------------------%NThe configuration is not valid:%N-------------------------------%N%N"

			l_class_valid := a_config.location.class_ /= Void
			if not l_class_valid then
				error_message.append ("Specified class is invalid.%N")
			end

			l_feature_valid := a_config.location.feature_ /= Void
			if not l_feature_valid then
				error_message.append ("Specified feature is invalid.%N")
			end

			l_prgm_locs_valid :=
				a_config.is_all_prgm_locs_set xor
				a_config.is_aut_choice_of_prgm_locs_set xor
				a_config.is_specific_prgm_locs_set

			l_exprs_valid :=
				a_config.is_aut_choice_of_exprs_set xor
				a_config.is_specific_exprs_set xor
				a_config.is_specific_vars_set

			l_exprs_locs_comb_valid :=
				(l_prgm_locs_valid and l_exprs_valid) xor
				a_config.is_prgm_locs_with_exprs_set xor
				a_config.is_prgm_locs_with_vars_set
			if not l_exprs_locs_comb_valid then
				error_message.append (
					"The combination of program locations and expressions must fulfill the following property: " +
					"((all_prgm_locs xor aut_choice_of_prgm_locs xor specific_prgm_locs) and " +
					"(aut_choice_of_exprs xor specific_exprs xor specific_vars)) xor " +
					"prgm_locs_with_exprs xor" +
					"prgm_locs_with_vars%N"
				)
			end

			if a_config.output_path /= Void then
				create l_file_name.make_from_string (a_config.output_path)
				if not l_file_name.is_valid then
					error_message.append ("The output-path is not valid.%N")
				end
				l_outputh_path_valid := True
			else
				error_message.append ("The output-path is void.%N")
			end

			is_config_valid :=
				l_class_valid and
				l_feature_valid and
				l_exprs_locs_comb_valid and
				l_outputh_path_valid
		end

	is_config_valid: BOOLEAN
			-- Is the configuration a valid configuration?

feature {NONE} -- Implementation

	find_all_post_states
			-- Find post-state(s) for all pre-states.
		local
			l_post_state_finder: EPA_POST_STATE_FINDER
		do
			create l_post_state_finder.make (class_, feature_)
			l_post_state_finder.find
			post_state_map := l_post_state_finder.post_state_map
		end

	choose_pre_states
			-- Choose pre-states
		local
			i, l_upper: INTEGER
			l_pre_state_finder: EPA_INTERESTING_PRE_STATE_FINDER
			l_bp_interval: INTEGER_INTERVAL
		do
			-- Choose pre-states
			if config.is_all_prgm_locs_set then
				-- Use all pre-states
				l_bp_interval := feature_body_breakpoint_slots (feature_)
				create interesting_pre_states.make_default
				l_bp_interval.do_all (agent interesting_pre_states.force_last)
			elseif config.is_specific_prgm_locs_set then
				-- Use selected pre-states
				interesting_pre_states := config.specific_prgm_locs
			elseif config.is_prgm_locs_with_exprs_set  then
				create interesting_pre_states.make_default
				config.prgm_locs_with_exprs.keys.do_all (agent interesting_pre_states.force_last)
			elseif config.is_prgm_locs_with_vars_set  then
				create interesting_pre_states.make_default
				config.prgm_locs_with_vars.keys.do_all (agent interesting_pre_states.force_last)
			elseif config.is_aut_choice_of_prgm_locs_set then
				-- Find and use interesting pre-states in `l_feature'.
				create l_pre_state_finder.make_with (feature_.e_feature.ast)
				l_pre_state_finder.find
				interesting_pre_states := l_pre_state_finder.interesting_pre_states
			end
		end

	setup_expressions
			-- Setup expressions to evaluate
		local
			l_expr_builder: EPA_EXPRESSIONS_TO_EVALUATE_BUILDER
			l_locs_with_exprs, l_locs_with_vars: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			l_keys: DS_BILINEAR [INTEGER]
			l_mapping: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_vars: DS_HASH_SET [STRING]
			l_set: DS_HASH_SET [STRING]
		do
			create l_expr_builder.make (class_, feature_)
			if config.is_specific_vars_set then
				l_expr_builder.build_from_variables (config.variables)
			elseif config.is_prgm_locs_with_vars_set then
				l_expr_builder.store_vars_exprs_mapping (True)
				l_expr_builder.build_from_variables (config.variables)
			elseif config.is_specific_exprs_set or config.is_prgm_locs_with_exprs_set then
				l_expr_builder.build_from_expressions (config.expressions)
			elseif config.is_aut_choice_of_exprs_set then
				l_expr_builder.build_from_ast (feature_.e_feature.ast)
			end

			monitored_expressions := l_expr_builder.expressions_to_evaluate

			if l_expr_builder.is_storage_of_vars_exprs_mapping_activated then
				create l_locs_with_exprs.make_default
				l_mapping := l_expr_builder.vars_with_exprs
				l_locs_with_vars := config.prgm_locs_with_vars
				l_keys := l_locs_with_vars.keys
				from
					l_keys.start
				until
					l_keys.after
				loop
					l_vars := l_locs_with_vars.item (l_keys.item_for_iteration)
					from
						l_vars.start
					until
						l_vars.after
					loop
						l_set := l_mapping.item (l_vars.item_for_iteration)
						if l_set = Void then
							create l_set.make_default
							l_set.set_equality_tester (string_equality_tester)
						end
						l_locs_with_exprs.force_last (l_set, l_keys.item_for_iteration)
						l_vars.forth
					end
					l_keys.forth
				end
				config.set_prgm_locs_with_exprs (l_locs_with_exprs)
			end
		end

	setup_action_for_evaluation (a_processor: EPA_COLLECTED_RUNTIME_DATA_PROCESSOR)
			-- Setup action for evaluation
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_bp_count, l_pre_state_bp: INTEGER
		do
			l_bp_count := breakpoint_count (feature_)
			across interesting_pre_states.to_array as l_pre_states loop
				l_pre_state_bp := l_pre_states.item
				if l_pre_state_bp < l_bp_count then
					create l_bp_mgr.make (class_, feature_)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_state_bp, monitored_expressions, agent a_processor.process)
					l_bp_mgr.toggle_breakpoints (True)

					across post_state_map.item (l_pre_state_bp).to_array as l_post_states loop
						create l_bp_mgr.make (class_, feature_)
						l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, monitored_expressions, agent a_processor.process)
						l_bp_mgr.toggle_breakpoints (True)
					end
				end
			end
		end

feature {NONE} -- Implementation

	class_: CLASS_C
			-- Class containing the feature which will be analyzed.

	feature_: FEATURE_I
			-- Feature which will be analyzed.

	monitored_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions which are monitored

	interesting_pre_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting pre-states

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

	error_message: STRING
			-- Error message indicating why the configuration is not a valid configuration.

end
