note
	description: "Summary description for {AFX_COMMAND_LINE_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_COMMAND_LINE_PARSER

inherit
	AFX_UTILITY

create
	make_with_arguments

feature{NONE} -- Initialization

	make_with_arguments (a_args: LINKED_LIST [STRING]; a_system: SYSTEM_I)
			-- Initialize Current with arguments `a_args'.
		do
			create config.make (a_system)
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
			options_set: config.eiffel_system = a_system
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_fix_strategy: AP_STRING_OPTION
			l_rank_control_dependance: AP_STRING_OPTION
			l_generate_report: AP_STRING_OPTION
			l_fault_localization_strategy: AP_STRING_OPTION
			l_state_based_test_case_selection_option: AP_FLAG
--			l_program_state: AP_STRING_OPTION
			l_breakpoint_specific_option: AP_FLAG
			l_rank_computation_mean_type: AP_STRING_OPTION
			l_max_fixing_target: AP_STRING_OPTION
			l_max_fix_candidate: AP_STRING_OPTION
			l_retrieve_state_option: AP_FLAG
			l_recipient: AP_STRING_OPTION
			l_feat_under_test: AP_STRING_OPTION
			l_build_tc_option: AP_STRING_OPTION
			l_analyze_tc_option: AP_FLAG
			l_combination_strategy: STRING
			l_max_test_case_no_option: AP_INTEGER_OPTION
			l_max_passing_test_case_number_option: AP_INTEGER_OPTION
			l_max_failing_test_case_number_option: AP_INTEGER_OPTION
			l_arff_option: AP_FLAG
			l_daikon_option: AP_FLAG
			l_max_valid_fix_option: AP_INTEGER_OPTION
			l_max_tc_time: AP_INTEGER_OPTION
			l_fix_skeleton: AP_STRING_OPTION
			l_skeleton_types: LIST [STRING]
			l_mocking_option: AP_FLAG
			l_freeze_option: AP_FLAG
			l_max_fix_postcondition: AP_INTEGER_OPTION
			l_model_dir_option: AP_STRING_OPTION
			l_path_name: FILE_NAME

			l_report_file_name_str: FILE_NAME
			l_report_file: PLAIN_TEXT_FILE
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_fix_strategy.make_with_long_form ("strategy")
			l_fix_strategy.set_description ("Choose the strategy to be used in automatic fixing. Supported strategies include: model and random.")
			l_parser.options.force_last (l_fix_strategy)

			create l_rank_control_dependance.make_with_long_form ("CFG-usage")
			l_rank_control_dependance.set_description ("Choose how CFG would be used to rank the fixing locations. Options: optimistic|pessimistic.")
			l_parser.options.force_last (l_rank_control_dependance)

			create l_fault_localization_strategy.make_with_long_form ("fault-localization-strategy")
			l_fault_localization_strategy.set_description ("Choose the strategy for fault localization.")
			l_parser.options.force_last (l_fault_localization_strategy)

			create l_generate_report.make_with_long_form ("generate-report")
			l_generate_report.set_description ("Generate AutoFix report. Optional argument: name of the file to which the report will be appended.")
			l_parser.options.force_last (l_generate_report)

			create l_rank_computation_mean_type.make_with_long_form ("rank-computation-mean-type")
			l_rank_computation_mean_type.set_description ("The kind of mean value calculation to use for computing ranking.")
			l_parser.options.force_last (l_rank_computation_mean_type)

			create l_max_fixing_target.make_with_long_form ("max-fixing-target")
			l_max_fixing_target.set_description ("Maximum number of fixing targets to be examined.")
			l_parser.options.force_last (l_max_fixing_target)

			create l_max_fix_candidate.make_with_long_form ("max-fix-candidate")
			l_max_fix_candidate.set_description ("Maximum number of fix candidates to be evaluated.")
			l_parser.options.force_last (l_max_fix_candidate)

			create l_retrieve_state_option.make ('s', "retrieve-state")
			l_retrieve_state_option.set_description ("Retrieve system state at specified break points.")
			l_parser.options.force_last (l_retrieve_state_option)

			create l_breakpoint_specific_option.make_with_long_form ("breakpoint-specific")
			l_breakpoint_specific_option.set_description ("Should we differentiate expressions based on their corresponding breakpoints?")
			l_parser.options.force_last (l_breakpoint_specific_option)

			create l_state_based_test_case_selection_option.make_with_long_form ("state-based-tc-selection")
			l_state_based_test_case_selection_option.set_description ("Should we select test cases based on states of the objects used in the test case?")
			l_parser.options.force_last (l_state_based_test_case_selection_option)

			create l_build_tc_option.make_with_long_form ("build-tc")
			l_build_tc_option.set_description ("Build current project to contain test cases storing in the folder specified by the parameter.")
			l_parser.options.force_last (l_build_tc_option)

			create l_max_test_case_no_option.make_with_long_form ("max-tc-number")
			l_max_test_case_no_option.set_description ("Maximum number of test cases that are used for invariant inference. 0 means no upper bound. Default: 0")
			l_parser.options.force_last (l_max_test_case_no_option)

			create l_max_passing_test_case_number_option.make_with_long_form ("max-passing-tc-number")
			l_max_passing_test_case_number_option.set_description ("Maximum number of test cases that are used in fixing. 0 means using all available. Default: 0")
			l_parser.options.force_last (l_max_passing_test_case_number_option)

			create l_max_failing_test_case_number_option.make_with_long_form ("max-failing-tc-number")
			l_max_failing_test_case_number_option.set_description ("Maximum number of test cases that are used in fixing. 0 means using all available. Default: 0")
			l_parser.options.force_last (l_max_failing_test_case_number_option)

			create l_analyze_tc_option.make_with_long_form ("analyze-tc")
			l_analyze_tc_option.set_description ("Analyze test cases in current project. This assumes that the test cases are already built with the build-tc command.")
			l_parser.options.force_last (l_analyze_tc_option)

			create l_arff_option.make_with_long_form ("arff")
			l_arff_option.set_description ("Enable ARFF file generation during test case analysis. ARFF is a format used by the Weka machine learning tool. Default: False")
			l_parser.options.force_last (l_arff_option)

			create l_daikon_option.make_with_long_form ("daikon")
			l_daikon_option.set_description ("Enable Daikon to infer invariants on system states. Default: False")
			l_parser.options.force_last (l_daikon_option)

			create l_max_valid_fix_option.make_with_long_form ("max-valid-fix")
			l_max_test_case_no_option.set_description ("Maximal number of valid fix, stop after found this number of valid fixes. 0 means not bounded. Default: 0.")
			l_parser.options.force_last (l_max_valid_fix_option)

			create l_max_tc_time.make_with_long_form ("max-tc-execution-time")
			l_max_tc_time.set_description ("Maximal time in second to allow a test case to execute. Default: 5")
			l_parser.options.force_last (l_max_tc_time)

			create l_fix_skeleton.make_with_long_form ("skeleton")
			l_fix_skeleton.set_description ("Only allow certion type of fix to be generated, value is a comma separated string list, possible types are: %"afore%", %"wrap%". Default: both.")
			l_parser.options.force_last (l_fix_skeleton)

			create l_mocking_option.make ('m', "mocking")
			l_mocking_option.set_description ("Enable mocking mode. When in mocking mode, the tool will use pregenerated data files instead of doing time-consuming on-the-fly data analysis. Only works if those data files are up to date. Default: False.")
			l_parser.options.force_last (l_mocking_option)

			create l_freeze_option.make ('f', "freeze")
			l_freeze_option.set_description ("Freeze project before auto-fixing? Default: False")
			l_parser.options.force_last (l_freeze_option)

			create l_max_fix_postcondition.make ('p', "max-fix-postcondition-assertion")
			l_max_fix_postcondition.set_description ("Maximal number of assertions that can appear as fix postcondition. If there are too many fix postcondition assertions, the number of possible fixes are very large, the fix generation will be extremely time-consuming. Default: 10.")
			l_parser.options.force_last (l_max_fix_postcondition)

			create l_model_dir_option.make_with_long_form ("model-dir")
			l_model_dir_option.set_description ("The directory to find behavior model files. Default: EIFGENs/target/AutoFix/model")
			l_parser.options.force_last (l_model_dir_option)

				-- Parse `arguments'.
			l_parser.parse_list (l_args)

				-- Setup `config'.
			config.set_should_retrieve_state (l_retrieve_state_option.was_found)

			config.set_should_build_test_cases (l_build_tc_option.was_found)
			if config.should_build_test_cases then
				config.set_test_case_path (l_build_tc_option.parameter)
			end

			if l_max_test_case_no_option.was_found then
				config.set_max_test_case_number (l_max_test_case_no_option.parameter)
			else
				config.set_max_test_case_number (0)
			end

			if l_max_passing_test_case_number_option.was_found then
				config.set_max_passing_test_case_number (l_max_passing_test_case_number_option.parameter)
			else
				config.set_max_passing_test_case_number (0)
			end

			if l_max_failing_test_case_number_option.was_found then
				config.set_max_failing_test_case_number (l_max_failing_test_case_number_option.parameter)
			else
				config.set_max_failing_test_case_number (0)
			end

			if l_max_valid_fix_option.was_found then
				config.set_max_valid_fix_number (l_max_valid_fix_option.parameter)
			else
				config.set_max_valid_fix_number (0)
			end

			if l_max_tc_time.was_found then
				config.set_max_test_case_execution_time (l_max_tc_time.parameter)
			else
				config.set_max_test_case_execution_time (5)
			end

			if l_rank_computation_mean_type.was_found then
				if attached l_rank_computation_mean_type.parameter as lt_mean_type then
					lt_mean_type.to_lower
					if lt_mean_type ~ "arithmetic" then
						config.set_rank_computation_mean_type ({AFX_CONFIG}.Mean_type_arithmetic)
					elseif lt_mean_type ~ "geometric" then
						config.set_rank_computation_mean_type ({AFX_CONFIG}.Mean_type_geometric)
					elseif lt_mean_type ~ "harmonic" then
						config.set_rank_computation_mean_type ({AFX_CONFIG}.Mean_type_harmonic)
					else
						-- Error: invalid parameter.
						config.set_rank_computation_mean_type ({AFX_CONFIG}.Default_mean_type)
					end
				end
			else
				config.set_rank_computation_mean_type ({AFX_CONFIG}.Default_mean_type)
			end

			if l_fault_localization_strategy.was_found then
				if attached l_fault_localization_strategy.parameter as lt_suspicious then
					lt_suspicious.to_lower
					if lt_suspicious ~ "heuristicIII-old" then
						config.set_type_of_fault_localization_strategy ({AFX_CONFIG}.Fault_localization_strategy_heuristicIII_old)
					elseif lt_suspicious ~ "heuristicIII-new" then
						config.set_type_of_fault_localization_strategy ({AFX_CONFIG}.Fault_localization_strategy_heuristicIII_new)
					else
						-- Error: invalid parameter.
						config.set_type_of_fault_localization_strategy ({AFX_CONFIG}.Fault_localization_strategy_heuristicIII_new)
					end
				end
			else
				config.set_type_of_fault_localization_strategy ({AFX_CONFIG}.Fault_localization_strategy_heuristicIII_new)
			end

			config.set_generate_report (l_generate_report.was_found)
			if l_generate_report.was_found then
				if attached l_generate_report.parameter as lt_report_file_name then
					create l_report_file.make_open_read_append (lt_report_file_name)
					if l_report_file.is_open_append then
						config.set_report_file (l_report_file)
					end
				end
				if config.report_file = Void then
					config.set_report_file (io.output)
				end
			end

			if l_fix_strategy.was_found then
				if attached l_fix_strategy.parameter as lt_strategy then
					lt_strategy.to_lower
					if lt_strategy ~ "model" then
						config.set_is_using_model_based_strategy (True)
					elseif lt_strategy ~ "random" then
						config.set_is_using_random_based_strategy (True)
					else
						-- Use the default strategy: model
					end
				end
			end

			if l_max_fixing_target.was_found then
				if attached l_max_fixing_target.parameter as lt_max_fixing_target and then lt_max_fixing_target.is_integer then
					config.set_max_fixing_target (lt_max_fixing_target.to_integer)
				else
					-- Ignoring invalid parameter.
				end
			end

			if l_max_fix_candidate.was_found then
				if attached l_max_fix_candidate.parameter as lt_max_fix_candidate and then lt_max_fix_candidate.is_integer then
					config.set_max_fix_candidate (lt_max_fix_candidate.to_integer)
				else
					-- Ignoring invalid parameter.
				end
			end

			if l_rank_control_dependance.was_found then
				if attached l_rank_control_dependance.parameter as lt_cd then
					lt_cd.to_lower
					if lt_cd ~ "optimistic" then
						config.set_CFG_usage_optimistic
					elseif lt_cd ~ "pessimistic" then
						config.set_CFG_usage_pessimistic
					else
						-- Use CFG in the default way.
					end
				end
			end

			config.set_state_based_test_case_selection (l_state_based_test_case_selection_option.was_found)

			if l_fix_skeleton.was_found then
				l_skeleton_types := l_fix_skeleton.parameter.split (',')
				from
					l_skeleton_types.start
				until
					l_skeleton_types.after
				loop
					if l_skeleton_types.item_for_iteration.is_case_insensitive_equal ("afore") then
						config.set_is_afore_fix_enabled (True)
					elseif l_skeleton_types.item_for_iteration.is_case_insensitive_equal ("wrap") then
						config.set_is_wrapping_fix_enabled (True)
					end
					l_skeleton_types.forth
				end
			else
				config.set_is_afore_fix_enabled (True)
				config.set_is_wrapping_fix_enabled (True)
			end

			if l_max_fix_postcondition.was_found then
				config.set_max_fix_postcondition_assertion (l_max_fix_postcondition.parameter)
			else
				config.set_max_fix_postcondition_assertion (10)
			end

			if l_model_dir_option.was_found then
				config.set_model_directory (l_model_dir_option.parameter)
			else
				create l_path_name.make_from_string (config.output_directory)
				l_path_name.extend ("model")
				config.set_model_directory (l_path_name)
			end

			config.set_should_freeze (l_freeze_option.was_found)

			config.set_is_mocking_mode_enabled (l_mocking_option.was_found)

			config.set_is_arff_generation_enabled (l_arff_option.was_found)

			config.set_should_analyze_test_cases (l_analyze_tc_option.was_found)

			config.set_is_daikon_enabled (l_daikon_option.was_found)
		end

feature{NONE} -- Implementation

	feature_from_string (a_string: STRING): detachable FEATURE_I
			-- Feature from string in format "CLASS_NAME.feature_name".
			-- Void if no such feature exists.
		local
			l_dot_index: INTEGER
			l_class_name: STRING
			l_feat_name: STRING
			l_classes: LIST [CLASS_I]
			l_class_c: CLASS_C
		do
			l_dot_index := a_string.index_of ('.', 1)
			if l_dot_index > 0 then
				l_class_name := a_string.substring (1, l_dot_index - 1).as_upper
				l_feat_name := a_string.substring (l_dot_index + 1, a_string.count).as_lower
				l_classes := universe.classes_with_name (l_class_name)
				if not l_classes.is_empty then
					l_class_c := l_classes.first.compiled_representation
					Result := l_class_c.feature_named (l_feat_name)
				end
			end
		end

end
