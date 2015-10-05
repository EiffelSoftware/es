note
	description: "Summary description for {AFX_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONFIG

inherit
	AFX_UTILITY

feature -- Status report

	is_valid: BOOLEAN
			-- Is current configuration valid?

feature -- Operation

	check_validity
			-- Check the configuration validity.
		local
			l_directory: DIRECTORY
		do
			is_valid := True
			if not (is_not_fixing or else is_fixing_contract or else is_fixing_implementation) then
				print_message ("Error: Missing task type.")
				is_valid := False
			end

			if is_valid then
				if is_not_fixing and then (is_fixing_contract or else is_fixing_implementation) then
					print_message ("Error: Mixed task type.")
					is_valid := False
				end
			end

			if is_valid and then is_fixing then
				if test_case_path = Void then
					print_message ("Error: Missing test case path.")
					is_valid := False
				else
					create l_directory.make_with_name (test_case_path)
					if not l_directory.exists then
						print_message ("Error: Non-existing test case path.")
						is_valid := False
					end
				end
			end

			if is_valid and then is_fixing then
				if result_dir /= Void then
					create l_directory.make_with_name (result_dir)
					if not l_directory.exists then
						print_message ("Warning: Non-existing result dir.")
						print_message ("%TProducing results in the default directory.")
						set_result_dir (Void)
					end
				end
			end

			if is_valid and then is_fixing_contract then
				if relaxed_test_case_path = Void then
					print_message ("Error: Missing relaxed test case path.")
					is_valid := False
				else
					create l_directory.make_with_name (relaxed_test_case_path)
					if not l_directory.exists then
						print_message ("Error: Non-existing relaxed test case path.")
						is_valid := False
					end
				end
			end

		end

feature -- Type of tasks: Access

	is_fixing_contract: BOOLEAN assign set_fixing_contract

	is_fixing_implementation: BOOLEAN assign set_fixing_implementation

	is_not_fixing: BOOLEAN assign set_not_fixing

	is_fixing: BOOLEAN
		do
			Result := is_fixing_contract or else is_fixing_implementation
		end

feature -- Type of tasks: Set

	set_fixing_contract (a_flag: BOOLEAN)
			--
		do
			is_fixing_contract := a_flag
		end

	set_fixing_implementation (a_flag: BOOLEAN)
			--
		do
			is_fixing_implementation := a_flag
		end

	set_not_fixing (a_flag: BOOLEAN)
		do
			is_not_fixing := a_flag
		end

	set_experimental_enabled (a_flag: BOOLEAN)
		do
			experimental_enabled := a_flag
		end

	set_log_for_debugging (a_flag: BOOLEAN)
		do
			should_log_for_debugging := a_flag
		end

feature -- Logging

	should_log_for_debugging: BOOLEAN

feature -- Experimental features

	experimental_enabled: BOOLEAN

feature -- Fix shared configurations: Access

	maximum_session_length_in_minutes: NATURAL
			-- Maximum AutoFix session length in minutes.
			-- '0' means unlimited length.

	test_case_path: detachable STRING
			-- Full path of the folder storing test cases

	fault_signature_id: detachable STRING
			-- Signature id of a failing test case revealing the fault to fix.

	max_passing_test_case_number: NATURAL
			-- Max number of passing test cases.
			-- Default: 0. (All passing test cases)

	max_failing_test_case_number: NATURAL
			-- Max number of failing test cases.
			-- Default: 0. (All faiing test cases)

	is_using_state_based_test_case_selection: BOOLEAN
			-- Is the current fixing process selecting test cases based on
			-- the states of objects in the test cases?

	is_using_random_test_case_selection: BOOLEAN
			-- Should test cases be examined in random order?

	max_test_case_execution_time: NATURAL
			-- Maximal time in second to allow a test case to execute
			-- Default: 5

	max_fix_candidate: NATURAL
			-- Maximal number of fixes to be generated and evaluated.
			-- 0 for no limit.

	max_valid_fix_number: NATURAL
			-- Maximal number of valid fixes
			-- Stop after found this number of fixes.
			-- 0 means not bounded.
			-- Default: 0

	result_dir: STRING
			-- Directory to store AutoFix result.

	report_file: STRING
			-- File to store the final report.

feature -- Fix shared configurations: Access

	set_maximum_session_length_in_minutes (a_length: NATURAL)
			-- Set `maximum_session_length_in_minutes' with `a_length'.
		do
			maximum_session_length_in_minutes := a_length
		end

	set_test_case_path (a_path: like test_case_path)
			-- Set `test_case_path' with `a_path'.
			-- Make a copy of `a_path'.
		do
			create test_case_path.make_from_string (a_path)
		ensure
			test_case_path_set: test_case_path ~ a_path
		end

	set_fault_signature_id (a_id: like fault_signature_id)
		do
			fault_signature_id := a_id.twin
		end

	set_max_passing_test_case_number (a_number: NATURAL)
			-- Set `max_passing_test_case_number' with `a_number'.
		do
			max_passing_test_case_number := a_number
		ensure
			max_passing_test_case_number_set: max_passing_test_case_number  = a_number
		end

	set_max_failing_test_case_number (a_number: NATURAL)
			-- Set `max_failing_test_case_number' with `a_number'.
		do
			max_failing_test_case_number := a_number
		ensure
			max_failing_test_case_number_set: max_failing_test_case_number = a_number
		end

	set_state_based_test_case_selection (a_flag: BOOLEAN)
			-- Set `is_using_state_based_test_case_selection' with `a_flag'.
		do
			is_using_state_based_test_case_selection := a_flag
		ensure
			is_using_state_based_test_case_selection_set:
					is_using_state_based_test_case_selection = a_flag
		end

	set_random_test_case_selection (a_flag: BOOLEAN)
		do
			is_using_random_test_case_selection := a_flag
		ensure
			is_using_random_test_case_selection = a_flag
		end

	set_max_test_case_execution_time (t: NATURAL)
			-- Set `max_test_case_execution_time' with `t'.
		do
			max_test_case_execution_time := t
		ensure
			max_test_case_execution_time_set: max_test_case_execution_time = t
		end

	set_max_fix_candidate (a_max: NATURAL)
			-- Set `max_fix_candidate'.
		require
			max_ge_zero: a_max >= 0
		do
			max_fix_candidate := a_max
		end

	set_max_valid_fix_number (i: NATURAL)
			-- Set `max_valid_fix_number' with `i'.
		do
			max_valid_fix_number := i
		ensure
			max_valid_fix_number_set: max_valid_fix_number = i
		end

	set_result_dir (a_path_string: STRING)
			-- Set `result_dir'.
		do
			result_dir := a_path_string.twin
		end

	set_report_file (a_file_string: STRING)
		do
			report_file := a_file_string.twin
		end

feature -- Fix implementation: Access

	max_fixing_target: NATURAL
			-- Maximal number of fixing targets to be examined.
			-- 0 for no limit.

feature -- Fix implementation: Constant

	max_fixing_location_scope_level: NATURAL = 2
			-- The control structure distance level away from the failing assertion.
			-- Minimal is 1. Default: 2

feature -- Fix implementation: Set

	set_max_fixing_target (a_max: NATURAL)
			-- Set `max_fixing_target'.
		do
			max_fixing_target := a_max
		end

feature -- Fix contract: Access

	relaxed_test_case_path: STRING

	max_fix_postcondition_assertion: NATURAL
			-- Maximal number of assertions that can appear as fix postcondition.
			-- If there are too many fix postcondition assertions, the number of possible fixes are very large,
			-- the fix generation will be extremely time-consuming.
			-- Default: 10

feature -- Fix contract: Set

	set_relaxed_test_case_path (a_path_string: STRING)
		do
			relaxed_test_case_path := a_path_string.twin
		end

	set_max_fix_postcondition_assertion (i: NATURAL)
			-- Set `max_fix_postcondition_assertion' with `i'.
		do
			max_fix_postcondition_assertion := i
		ensure
			max_fix_postcondition_assertion_set: max_fix_postcondition_assertion = i
		end

feature -- Postmortem analysis: Access

	is_for_postmortem_analysis: BOOLEAN
			-- Is the configuration for postmortem analysis?
		do
			Result := postmortem_analysis_source /= Void
		end

	postmortem_analysis_source: STRING assign set_postmortem_analysis_source
			-- Full path indicating the set of generated proper fixes to be postmortemly analyzed.
			-- Possibly invalid.

	postmortem_analysis_output_dir: STRING assign set_postmortem_analysis_output_dir
			-- Directory to store the results from postmortem analysis.
			-- Valid or Void.

feature -- Postmortem analysis: Set

	set_postmortem_analysis_source (a_source: STRING)
			-- Set `postmortem_analysis_source' with `a_source'.
		do
			postmortem_analysis_source := a_source
		ensure
			source_set: a_source = postmortem_analysis_source
		end

	set_postmortem_analysis_output_dir (a_dir: STRING)
			-- Set `postmortem_analysis_output_dir' with `a_dir', if `a_dir' is a valid directory path;
			-- Set `postmortem_analysis_output_dir' to Void, otherwise.
		local
			l_retried: BOOLEAN
			l_path: DIRECTORY
		do
			if not l_retried then
				if attached {STRING} a_dir as lt_dir and then not lt_dir.is_empty then
					create l_path.make (lt_dir)
					if not l_path.exists then
						l_path.recursive_create_dir
					end
					if l_path.exists and then l_path.is_writable then
						postmortem_analysis_output_dir := a_dir.twin
					else
						postmortem_analysis_output_dir := Void
					end
				else
					postmortem_analysis_output_dir := Void
				end
			end
		rescue
			l_retried := True
			postmortem_analysis_output_dir := Void
			retry
		end

feature{NONE} -- Implementation

	print_message (a_msg: STRING)
			--
		do
			Io.put_string (a_msg + "%N")
		end

end
