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

	make_with_arguments (a_args: LINKED_LIST [STRING])
			-- Initialize Current with arguments `a_args'.
		do
			create config
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
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

				-- Type of task.
			l_fixing_implementation_option: AP_FLAG
			l_fixing_contract_option: AP_FLAG
			l_not_fixing_option: AP_FLAG

				-- Fix shared
			l_cutoff_time_option: AP_STRING_OPTION
			l_test_case_dir: AP_STRING_OPTION
			l_fault_signature_id: AP_STRING_OPTION
			l_max_passing_test_case_number_option: AP_STRING_OPTION
			l_max_failing_test_case_number_option: AP_STRING_OPTION
			l_state_based_test_case_selection_option: AP_FLAG
			l_random_test_case_selection_option: AP_FLAG
			l_max_tc_time: AP_STRING_OPTION
			l_max_fix_candidate: AP_STRING_OPTION
			l_max_valid_fix_option: AP_STRING_OPTION
			l_result_dir_option: AP_STRING_OPTION
			l_report_file_option: AP_STRING_OPTION

				-- Fix implementation
			l_max_fixing_target: AP_STRING_OPTION

				-- Fix contract
			l_relaxed_test_case_dir: AP_STRING_OPTION
			l_max_fix_postcondition: AP_STRING_OPTION

				-- Not fixing
			l_postmortem_analysis_of_fixes: AP_STRING_OPTION
			l_postmortem_analysis_output_dir: AP_STRING_OPTION

				-- Log for debugging
			l_should_log_for_debugging: AP_FLAG

				-- Enabling experimental features
			l_enable_experimental: AP_FLAG
		do
			create l_args.make
			arguments.do_all (agent l_args.force_last)

				-- Setup command line argument parser.
			create l_parser.make

				-- Type of task.
			create l_fixing_implementation_option.make_with_long_form ("fix-implementation")
			l_fixing_implementation_option.set_description ("Generate fixes to implementation.")
			l_parser.options.force_last (l_fixing_implementation_option)

			create l_fixing_contract_option.make_with_long_form ("fix-contract")
			l_fixing_contract_option.set_description ("Generate fixes to contracts.")
			l_parser.options.force_last (l_fixing_contract_option)

			create l_not_fixing_option.make_with_long_form ("not-fixing")
			l_not_fixing_option.set_description ("Perform non-fixing task.")
			l_parser.options.force_last (l_not_fixing_option)

				-- Fix shared.
			create l_cutoff_time_option.make ('t', "time-out")
			l_cutoff_time_option.set_description ("Cutoff time in minutes for the whole AutoFix session. %N%TArgument: natural number. 0 means never to cutoff. %N%TOptional. Default: 0")
			l_parser.options.force_last (l_cutoff_time_option)

			create l_test_case_dir.make_with_long_form ("test-case-dir")
			l_test_case_dir.set_description ("Directory containing the test cases to be used in fixing.%N%TCompulsory in fixing.")
			l_parser.options.force_last (l_test_case_dir)

			create l_fault_signature_id.make_with_long_form ("fault-signature-id")
			l_fault_signature_id.set_description ("Signature id of a failing test case revealing the fault to fix. Format: class_under_test.feature_under_test.exception_code.breakpoint_slot.recipient_class.recipient_feature.tag")
			l_parser.options.force_last (l_fault_signature_id)

			create l_max_passing_test_case_number_option.make_with_long_form ("max-passing-tc-number")
			l_max_passing_test_case_number_option.set_description ("Maximum number of passing test cases to use in fixing. %N%TArgument: natural number. 0 means as many as possible. %N%TOptional. Default: 0")
			l_parser.options.force_last (l_max_passing_test_case_number_option)

			create l_max_failing_test_case_number_option.make_with_long_form ("max-failing-tc-number")
			l_max_failing_test_case_number_option.set_description ("Maximum number of failing test cases to use in fixing. %N%TArgument: natural number. 0 means as many as possible. %N%TOptional. Default: 0")
			l_parser.options.force_last (l_max_failing_test_case_number_option)

			create l_state_based_test_case_selection_option.make_with_long_form ("state-based-tc-selection")
			l_state_based_test_case_selection_option.set_description ("Select test cases based on the involved object states? %N%TOptional. ")
			l_parser.options.force_last (l_state_based_test_case_selection_option)

			create l_random_test_case_selection_option.make_with_long_form ("random-tc-selection")
			l_random_test_case_selection_option.set_description ("Select test cases randomly from all the candidates (as opposed to select the first N)? %N%TOptional. ")
			l_parser.options.force_last (l_random_test_case_selection_option)

			create l_max_tc_time.make_with_long_form ("max-tc-execution-time")
			l_max_tc_time.set_description ("Cutoff time in seconds for each test case. %N%TArgument: natural number. 0 means never to cutoff. %N%TOptional. Default: 5")
			l_parser.options.force_last (l_max_tc_time)

			create l_max_fix_candidate.make_with_long_form ("max-fix-candidate")
			l_max_fix_candidate.set_description ("Maximum number of fix candidates to evaluate. %N%TArgument: natural number. 0 means all fix candidates. %N%TOptional. Default: 200")
			l_parser.options.force_last (l_max_fix_candidate)

			create l_max_valid_fix_option.make_with_long_form ("max-valid-fix")
			l_max_valid_fix_option.set_description ("Maximum number of valid fixes to report. %N%TArgument: natural number. 0 means all valid fixes. %N%TOptional. Default: 10.")
			l_parser.options.force_last (l_max_valid_fix_option)

			create l_result_dir_option.make_with_long_form ("result-dir")
			l_result_dir_option.set_description ("Directory to store the AutoFix result. %N%TOptional. Default: Generate report in %%EIFGENs%%\%%Target%%\AutoFix.")
			l_parser.options.force_last (l_result_dir_option)

			create l_report_file_option.make_with_long_form ("report-file")
			l_report_file_option.set_description ("File to report the AutoFix result. %N%TOptional. Default: Generate report in `result-dir'.")
			l_parser.options.force_last (l_report_file_option)

				-- Fix implementation
			create l_max_fixing_target.make_with_long_form ("max-fixing-target")
			l_max_fixing_target.set_description ("Maximum number of fixing targets to be examined. %N%TArgument: natural number. 0 means all fixing targets. %N%TOptional. Default: 30.")
			l_parser.options.force_last (l_max_fixing_target)

				-- Fix contract.
			create l_relaxed_test_case_dir.make_with_long_form ("relaxed-test-case-dir")
			l_relaxed_test_case_dir.set_description ("Directory containing the test cases to be used in contract weakening. %N%TCompulsory in contract fixing.")
			l_parser.options.force_last (l_relaxed_test_case_dir)

			create l_max_fix_postcondition.make_with_long_form ("max-fix-postcondition-assertion")
			l_max_fix_postcondition.set_description ("Maximal number of assertions that can appear as fix postcondition. If there are too many fix postcondition assertions, the number of possible fixes are very large, the fix generation will be extremely time-consuming. Default: 10.")
			l_parser.options.force_last (l_max_fix_postcondition)

				-- Not fixing.
			create l_postmortem_analysis_of_fixes.make_with_long_form ("postmortem-analysis")
			l_postmortem_analysis_of_fixes.set_description ("Conduct postmortem analysis on the collection of generated proper fixes.")
			l_parser.options.force_last (l_postmortem_analysis_of_fixes)

			create l_postmortem_analysis_output_dir.make_with_long_form ("postmortem-analysis-output")
			l_postmortem_analysis_output_dir.set_description ("Directory to store the results from postmortem analysis. %N%TOptional.")
			l_parser.options.force_last (l_postmortem_analysis_output_dir)

				-- Log for debugging
			create l_should_log_for_debugging.make_with_long_form ("log-for-debugging")
			l_should_log_for_debugging.set_description ("Enable verbose logging for the sake of debugging.")
			l_parser.options.force_last (l_should_log_for_debugging)

				-- Experimental.
			create l_enable_experimental.make_with_long_form ("enable-experimental")
			l_enable_experimental.set_description ("Enable experimental features.")
			l_parser.options.force_last (l_enable_experimental)

				-----------------------------------  Parse `arguments'.  -------------------------------------------

			l_parser.parse_list (l_args)

				-- Type of task.
			config.set_fixing_implementation (l_fixing_implementation_option.was_found)
			config.set_fixing_contract (l_fixing_contract_option.was_found)
			config.set_not_fixing (l_not_fixing_option.was_found)

				-- Fix shared.
			if l_cutoff_time_option.was_found then
				if attached l_cutoff_time_option.parameter as lt_cutoff_time and then lt_cutoff_time.is_natural then
					config.set_maximum_session_length_in_minutes (lt_cutoff_time.to_natural)
				else
					Io.put_string ("Missing or invalid maximum session length, setting to 0.")
				end
			end

			if l_test_case_dir.was_found then
				config.set_test_case_path (l_test_case_dir.parameter)
			end

			if l_fault_signature_id.was_found then
				config.set_fault_signature_id (l_fault_signature_id.parameter)
			end

			if l_max_passing_test_case_number_option.was_found then
				if attached l_max_passing_test_case_number_option.parameter as lt_max_passing_test_case_number and then lt_max_passing_test_case_number.is_natural  then
					config.set_max_passing_test_case_number (lt_max_passing_test_case_number.to_natural)
				else
					Io.put_string ("Missing or invalid maximum number of passing tests, setting to 0.")
				end
			end

			if l_max_failing_test_case_number_option.was_found then
				if attached l_max_failing_test_case_number_option.parameter as lt_max_failing_test_case_number and then lt_max_failing_test_case_number.is_natural  then
					config.set_max_failing_test_case_number (lt_max_failing_test_case_number.to_natural)
				else
					Io.put_string ("Missing or invalid maximum number of failing tests, setting to 0.")
				end
			end

			config.set_state_based_test_case_selection (l_state_based_test_case_selection_option.was_found)
			config.set_random_test_case_selection (l_random_test_case_selection_option.was_found)

			if l_max_tc_time.was_found then
				if attached l_max_tc_time.parameter as lt_max_tc_time and then lt_max_tc_time.is_natural then
					config.set_max_test_case_execution_time (lt_max_tc_time.to_natural)
				else
					Io.put_string ("Missing or invalid maximum length of test case execution, setting to 0.")
				end
			end

			if l_max_fix_candidate.was_found then
				if attached l_max_fix_candidate.parameter as lt_max_fix_candidate and then lt_max_fix_candidate.is_natural then
					config.set_max_fix_candidate (lt_max_fix_candidate.to_natural)
				else
					Io.put_string ("Missing or invalid maximum number of fix candidate, setting to 0.")
				end
			end

			if l_max_valid_fix_option.was_found then
				if attached l_max_valid_fix_option.parameter as lt_max_valid_fix_option and then lt_max_valid_fix_option.is_natural then
					config.set_max_valid_fix_number (lt_max_valid_fix_option.to_natural)
				else
					Io.put_string ("Missing or invalid maximum number of valid fixes, setting to 0.")
				end
			end

			if l_result_dir_option.was_found and then attached l_result_dir_option.parameter as lt_result_dir_name and then not lt_result_dir_name.is_empty then
				config.set_result_dir (lt_result_dir_name)
			end

			if l_report_file_option.was_found and then attached l_report_file_option.parameter as lt_report_file and then not lt_report_file.is_empty then
				config.set_report_file (lt_report_file)
			end

				-- Fix implementation
			if l_max_fixing_target.was_found then
				if attached l_max_fixing_target.parameter as lt_max_fixing_target and then lt_max_fixing_target.is_natural then
					config.set_max_fixing_target (lt_max_fixing_target.to_natural)
				else
					Io.put_string ("Missing or invalid maximum number of fixing targets, setting to 0.")
				end
			end

				-- Fix contract.
			if l_relaxed_test_case_dir.was_found then
				config.set_relaxed_test_case_path (l_relaxed_test_case_dir.parameter)
			end

			if l_max_fix_postcondition.was_found then
				if attached l_max_fix_postcondition.parameter as lt_max_fix_postcondition and then lt_max_fix_postcondition.is_natural then
					config.set_max_fix_postcondition_assertion (lt_max_fix_postcondition.to_natural)
				else
					Io.put_string ("Missing or invalid maximum fix postcondition, setting to 0.")
				end
			end

				-- Not fixing.
			if l_postmortem_analysis_of_fixes.was_found then
				if attached {STRING} l_postmortem_analysis_of_fixes.parameter as lt_fixes_file then
					config.postmortem_analysis_source := lt_fixes_file
				end
			end

			if l_postmortem_analysis_output_dir.was_found then
				if attached {STRING} l_postmortem_analysis_output_dir.parameter as lt_postmortem_analysis_output_dir then
					config.postmortem_analysis_output_dir := lt_postmortem_analysis_output_dir
				end
			end

			config.set_experimental_enabled (l_enable_experimental.was_found)

			config.set_log_for_debugging (l_should_log_for_debugging.was_found)
		end

end
