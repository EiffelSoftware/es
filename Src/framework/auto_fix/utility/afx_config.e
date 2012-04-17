note
	description: "Summary description for {AFX_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONFIG

inherit
	AFX_UTILITY

	SHARED_EXEC_ENVIRONMENT

create
	make

feature{NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		do
			eiffel_system := a_system
		ensure
			eiffel_system_set: eiffel_system = a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system

	working_directory: STRING is
			-- Working directory of the project
		do
			if working_directory_cache = Void then
				Result := Execution_environment.current_working_directory
			else
				Result := working_directory_cache
			end
		end

	state_output_file: STRING is
			-- Full path of the output file
		do
			if state_output_file_cache = Void then
				Result := once "state_log.txt"
			else
				Result := state_output_file_cache
			end
		end

	output_directory: STRING is
			-- Directory for output
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (eiffel_system.eiffel_project.project_directory.fixing_results_path)
			Result := l_path
		end

	log_directory: STRING is
			-- Directory for AutoFix logs
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("log")
			Result := l_path
		end

	data_directory: STRING is
			-- Directory for AutoFix data
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("data")
			Result := l_path
		end

	daikon_directory: STRING is
			-- Directory to store daikon related data
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("daikon")
			Result := l_path
		end

	model_directory: STRING
		-- Directory for state transition summary.

	theory_directory: STRING
			-- Directory to store theory related files
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("theory")
			Result := l_path
		end

	fix_directory: STRING
			-- Directory to store generated fixes
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("fix")
			Result := l_path
		end

	afx_cluster_directory: STRING
			-- Directory to store the classes useful for fixing.
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend (Afx_cluster_name)
			Result := l_path
		end

	valid_fix_directory: STRING
			-- Directory to store generated fixes
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("valid_fix")
			Result := l_path
		end

	interpreter_log_path: STRING
			-- Full path to the interpreter log file
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (log_directory)
			l_path.set_file_name ("interpreter_log.txt")
			Result := l_path
		end

	proxy_log_path: STRING
			-- Full path to the proxy log file
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (log_directory)
			l_path.set_file_name ("proxy_log.txt")
			Result := l_path
		end

	is_using_default_report_file_path: BOOLEAN
			-- Is AutoFix using the default report file path?

	set_using_default_report_file_path (a_flag: BOOLEAN)
			-- Set `is_using_default_report_file_path' using `a_flag'.
		do
			is_using_default_report_file_path := a_flag
		end

	report_file_path: STRING
			-- Path to the AutoFix report file.
		local
			l_report_file: FILE_NAME
		do
			if is_using_default_report_file_path and then report_file_path_cache = Void then
				create l_report_file.make_from_string (output_directory)
				l_report_file.set_file_name (default_report_file_name)
				l_report_file.add_extension (report_file_extension)
				report_file_path_cache := l_report_file
			end
			Result := report_file_path_cache
		end

	default_report_file_name: STRING
			-- Default report file name for fixing.
		once
			Result := "default_report_file"
		end

	report_file_extension: STRING
			-- Extension name of the report file.
		once
			Result := "afr"
		end

	maximum_session_length_in_minutes: NATURAL
			-- Maximum AutoFix session length in minutes.
			-- '0' means unlimited length.

	set_maximum_session_length_in_minutes (a_length: NATURAL)
			-- Set `maximum_session_length_in_minutes' with `a_length'.
		do
			maximum_session_length_in_minutes := a_length
		end

feature -- Constant

	Afx_cluster_name: STRING = "afx_cluster"
			-- Name of AFX_cluster.

feature -- Test case analysis

	test_case_path: detachable STRING
			-- Full path of the folder storing test cases

	test_case_file_list: STRING
			-- Full path to a file, where test cases to be used to build the fixing project are listed.

	max_test_case_number: INTEGER
			-- Max number of test cases
			-- Default: 0

	max_passing_test_case_number: INTEGER
			-- Max number of passing test cases.
			-- Default: 0. (All passing test cases)

	max_failing_test_case_number: INTEGER
			-- Max number of failing test cases.
			-- Default: 0. (All faiing test cases)

	is_arff_generation_enabled: BOOLEAN
			-- Should ARFF file be generated during test case analysis?
			-- ARFF is used by the Weka machine learning tool.
			-- Default: False

	is_daikon_enabled: BOOLEAN
			-- Should Daikon be used to infer invariants on system states?
			-- Default: False

	should_freeze: BOOLEAN
			-- Should project be freezed before auto-fixing?
			-- Default: False

feature -- Usage of Control Flow Graph (CFG) in rank computation

	CFG_usage: INTEGER
			-- How to use the dependance information from CFG.
			-- The value can be `CFG_usage_optimistic' or `CFG_usage_pessimistic'.

	set_CFG_usage_optimistic
			-- Set `CFG_usage'.
		do
			CFG_usage := CFG_usage_optimistic
		end

	set_CFG_usage_pessimistic
			-- Set `CFG_usage'.
		do
			CFG_usage := CFG_usage_pessimistic
		end

	is_CFG_usage_optimistic: BOOLEAN
			-- Is CFG usage optimistic?
		do
			Result := CFG_usage = CFG_usage_optimistic
		end

	is_CFG_usage_pessimistic: BOOLEAN
			-- Is CFG usage pessimistic?
		do
			Result := CFG_usage = CFG_usage_pessimistic
		end

	CFG_usage_optimistic: INTEGER = 0
	CFG_usage_pessimistic: INTEGER = 1

feature -- Type of mean value for rank computation

	rank_computation_mean_type: INTEGER
			-- The ranks of fixing targets are computed as the mean values of the suspiciousness value, the data distance, and the control distance.
			-- The attribute specifies which kind of mean value would be used.
			-- Refer to {AFX_RANK_COMPUTATION_MEAN_TYPE_CONSTANT}.

	set_rank_computation_mean_type (a_type: INTEGER)
			-- Set `rank_computation_mean_type'.
		require
			valid_mean_type: is_valid_mean_type (a_type)
		do
			rank_computation_mean_type := a_type
		end

	is_valid_mean_type (a_mean_type: INTEGER): BOOLEAN
			-- Is `a_mean_type' a valid mean type?
		do
			Result := a_mean_type = Mean_type_arithmetic
					or else a_mean_type = Mean_type_geometric
					or else a_mean_type = Mean_type_harmonic
		end

	is_using_arithmetic_mean: BOOLEAN
			-- Is using arithmetic mean value as the ranking value.
		do
			Result := rank_computation_mean_type = Mean_type_arithmetic
		end

	is_using_geometric_mean: BOOLEAN
			-- Is using geometric mean value as the ranking value.
		do
			Result := rank_computation_mean_type = Mean_type_geometric
		end

	is_using_harmonic_mean: BOOLEAN
			-- Is using harmonic mean value as the ranking value.
		do
			Result := rank_computation_mean_type = Mean_type_harmonic
		end

	Mean_type_arithmetic: INTEGER = 1
	Mean_type_geometric: INTEGER = 2
	Mean_type_harmonic: INTEGER = 3
	Default_mean_type: INTEGER = 3

feature -- Type of fault localization algorithm

	type_of_fault_localization_strategy: INTEGER
			-- Type of fault localization strategy.

	set_type_of_fault_localization_strategy (a_type: INTEGER)
			-- Set `type_of_fault_localization_strategy'.
		require
			is_valid_type: is_valid_fault_localization_strategy (a_type)
		do
			type_of_fault_localization_strategy := a_type
		end

	is_valid_fault_localization_strategy (a_strategy: INTEGER): BOOLEAN
			-- Is `a_strategy' standing for a valid localization strategy?
		do
			Result := a_strategy = Fault_localization_strategy_heuristicIII_old
					or else a_strategy = Fault_localization_strategy_heuristicIII_new
		end

	is_using_strategy_heuristicIII_old: BOOLEAN
			-- Is using HeuristicIII-old as the fault localization strategy?
		do
			Result := type_of_fault_localization_strategy = Fault_localization_strategy_heuristicIII_old
		end

	is_using_strategy_heuristicIII_new: BOOLEAN
			-- Is using heuristicIII-new as the fault localization strategy?
		do
			Result := type_of_fault_localization_strategy = Fault_localization_strategy_heuristicIII_new
		end

	Fault_localization_strategy_heuristicIII_old: INTEGER = 11
	Fault_localization_strategy_heuristicIII_new: INTEGER = 12
	Default_fault_localization_strategy: INTEGER = 12

feature -- Fix generation

	max_fix_candidate: INTEGER
			-- Maximal number of fixes to be generated and evaluated.
			-- 0 for no limit.

	max_fixing_target: INTEGER
			-- Maximal number of fixing targets to be examined.
			-- 0 for no limit.

	max_valid_fix_number: INTEGER
			-- Maximal number of valid fixes
			-- Stop after found this number of fixes.
			-- 0 means not bounded.
			-- Default: 0

	is_afore_fix_enabled: BOOLEAN
			-- Should fix of afore type be generated?
			-- Default: True

	is_wrapping_fix_enabled: BOOLEAN
			-- Should fix of wrapping type be generated?
			-- Default: True

	is_mocking_mode_enabled: BOOLEAN
			-- Is mocking mode enabled during fix analysis and generation?
			-- When in mocking mode, the tool will use pregenerated data files
			-- instead of doing time-consuming on-the-fly data analysis.
			-- Only works if those data files are up to date.
			-- Default: False

	max_test_case_execution_time: INTEGER
			-- Maximal time in second to allow a test case to execute
			-- Default: 5

	max_fix_postcondition_assertion: INTEGER
			-- Maximal number of assertions that can appear as fix postcondition.
			-- If there are too many fix postcondition assertions, the number of possible fixes are very large,
			-- the fix generation will be extremely time-consuming.
			-- Default: 10

	max_fixing_location_scope_level: INTEGER = 2
			-- The control structure distance level away from the failing assertion.
			-- Minimal is 1. Default: 2

feature -- Fix validation

	min_socket_port_number: NATURAL
	max_socket_port_number: NATURAL
			-- Min and Max port number to use for socket connection.

	set_socket_port_range (a_min, a_max: NATURAL)
			-- Set `min_socket_port_number' and `max_socket_port_number'.
		require
			valid_range: 0 < a_min and then a_min <= a_max and then a_max < 65536
		do
			min_socket_port_number := a_min
			max_socket_port_number := a_max
		end

feature -- AutoFix report

	report_file: PLAIN_TEXT_FILE
			-- File to which the AutoFix report will be sent.

	set_report_file (a_file: PLAIN_TEXT_FILE)
			-- Set `report_file'.
		require
			file_appendable: a_file.is_open_append
		do
			report_file := a_file
		end

feature -- Status report

	is_using_model_based_strategy: BOOLEAN
			-- Is current fixing process using model-based strategy?
		do
			Result := is_using_model_based_strategy_cache
		ensure
			same_as_cache: Result = is_using_model_based_strategy_cache
		end

	is_using_random_based_strategy: BOOLEAN
			-- Is current fixing process using random-based strategy?
		do
			Result := is_using_random_based_strategy_cache
		ensure
			same_as_cache: Result = is_using_random_based_strategy_cache
		end

	is_using_state_based_test_case_selection: BOOLEAN
			-- Is the current fixing process selecting test cases based on
			-- the states of objects in the test cases?

	set_state_based_test_case_selection (a_flag: BOOLEAN)
			-- Set `is_using_state_based_test_case_selection' with `a_flag'.
		do
			is_using_state_based_test_case_selection := a_flag
		ensure
			is_using_state_based_test_case_selection_set:
					is_using_state_based_test_case_selection = a_flag
		end

	should_retrieve_state: BOOLEAN
			-- Should state of the system be retrieved?
		do
			Result := should_retrieve_state_cache
		ensure
			result_set: Result = should_retrieve_state_cache
		end

	should_build_test_cases: BOOLEAN
			-- Should test case be analyzed?

	should_analyze_test_cases: BOOLEAN
			-- Should test cases first be built?

feature -- Setting

	set_is_using_random_based_strategy (b: BOOLEAN)
			-- Set `is_using_random_based_strategy_cache' with 'b'.
		do
			is_using_random_based_strategy_cache := b
			is_using_model_based_strategy_cache := not b
		end

	set_is_using_model_based_strategy (b: BOOLEAN)
			-- Set `is_using_model_based_strategy_cache' with 'b'.
		do
			is_using_model_based_strategy_cache := b
			is_using_random_based_strategy_cache := not b
		end

	set_max_passing_test_case_number (a_number: INTEGER)
			-- Set `max_passing_test_case_number' with `a_number'.
		require
			positive_number: a_number >= 0
		do
			max_passing_test_case_number := a_number
		ensure
			max_passing_test_case_number_set: max_passing_test_case_number  = a_number
		end

	set_max_failing_test_case_number (a_number: INTEGER)
			-- Set `max_failing_test_case_number' with `a_number'.
		require
			positive_number: a_number >= 0
		do
			max_failing_test_case_number := a_number
		ensure
			max_failing_test_case_number_set: max_failing_test_case_number = a_number
		end

	set_should_retrieve_state (b: BOOLEAN)
			-- Set `should_retrieve_state' with `b'.
		do
			should_retrieve_state_cache := b
		ensure
			should_retrieve_state_set: should_retrieve_state = b
		end

	set_should_build_test_cases (b: BOOLEAN)
			-- Set `should_build_test_cases' with `b'.
		do
			should_build_test_cases := b
		ensure
			should_analyze_test_cases_set: should_build_test_cases = b
		end

	set_test_case_path (a_path: like test_case_path)
			-- Set `test_case_path' with `a_path'.
			-- Make a copy of `a_path'.
		do
			create test_case_path.make_from_string (a_path)
		ensure
			test_case_path_set: test_case_path ~ a_path
		end

	set_test_case_file_list (a_path: STRING)
			-- Set `test_case_file_list'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			create test_case_file_list.make_from_string (a_path)
		ensure
			file_list_set: test_case_file_list ~ a_path
		end

	set_max_test_case_number (b: INTEGER)
			-- Set `max_test_case_number' with `b'.
		do
			max_test_case_number := b
		ensure
			max_test_case_number_set: max_test_case_number = b
		end

	set_should_analyze_test_cases (b: BOOLEAN)
			-- Set `should_analyze_test_cases' with `b'.
		do
			should_analyze_test_cases := b
		ensure
			should_analyze_test_case_set: should_analyze_test_cases = b
		end

	set_is_arff_generation_enabled (b: BOOLEAN)
			-- Set `is_arff_generation_enabled' with `b'.
		do
			is_arff_generation_enabled := b
		ensure
			is_arff_generation_enabled_set: is_arff_generation_enabled = b
		end

	set_is_daikon_enabled (b: BOOLEAN)
			-- Set `is_daikon_enabled' with `b'.
		do
			is_daikon_enabled := b
		ensure
			is_daikon_enabled_set: is_daikon_enabled = b
		end

	set_max_valid_fix_number (i: INTEGER)
			-- Set `max_valid_fix_number' with `i'.
		do
			max_valid_fix_number := i
		ensure
			max_valid_fix_number_set: max_valid_fix_number = i
		end

	set_max_test_case_execution_time (t: INTEGER)
			-- Set `max_test_case_execution_time' with `t'.
		do
			max_test_case_execution_time := t
		ensure
			max_test_case_execution_time_set: max_test_case_execution_time = t
		end

	set_is_afore_fix_enabled (b: BOOLEAN)
			-- Set `is_afore_fix_enabled' with `b'.
		do
			is_afore_fix_enabled := b
		ensure
			is_afore_fix_enabled_set: is_afore_fix_enabled = b
		end

	set_is_wrapping_fix_enabled (b: BOOLEAN)
			-- Set `is_wrapping_fix_enabled' with `b'.
		do
			is_wrapping_fix_enabled := b
		ensure
			is_wrapping_fix_enabled_set: is_wrapping_fix_enabled = b
		end

	set_is_mocking_mode_enabled (b: BOOLEAN)
			-- Set `is_mocking_mode_enabled' with `b'.
		do
			is_mocking_mode_enabled := b
		ensure
			is_mocking_mode_enabled_set: is_mocking_mode_enabled = b
		end

	set_should_freeze (b: BOOLEAN)
			-- Set `should_freeze' with `b'.
		do
			should_freeze := b
		ensure
			should_freeze_set: should_freeze = b
		end

	set_max_fix_postcondition_assertion (i: INTEGER)
			-- Set `max_fix_postcondition_assertion' with `i'.
		do
			max_fix_postcondition_assertion := i
		ensure
			max_fix_postcondition_assertion_set: max_fix_postcondition_assertion = i
		end

	set_model_directory (a_directory: like model_directory)
			-- Set `model_directory' with `a_directory'.
		do
			model_directory := a_directory.twin
		end

	set_max_fix_candidate (a_max: INTEGER)
			-- Set `max_fix_candidate'.
		require
			max_ge_zero: a_max >= 0
		do
			max_fix_candidate := a_max
		end

	set_max_fixing_target (a_max: INTEGER)
			-- Set `max_fixing_target'.
		require
			max_ge_zero: a_max >= 0
		do
			max_fixing_target := a_max
		end

	set_report_file_path (a_path: STRING)
			-- Set `report_file_path'.
		require
			path_not_empty: a_path /= VOid and then not a_path.is_empty
		do
			report_file_path_cache := a_path
			is_using_default_report_file_path := false
		end

feature{NONE} -- Implementation

	report_file_path_cache: STRING
			-- Cache of `report_file_path'.

	working_directory_cache: detachable STRING
			-- Cache for working_directory

	state_output_file_cache: detachable STRING
			-- Cache for `state_output_file'

	state_test_case_class_name_cache: detachable STRING
			-- Cache for `state_test_case_class_name'

	should_retrieve_state_cache: BOOLEAN
			-- Cache for `should_retrieve_state'

	state_recipient_cache: detachable FEATURE_I
			-- Cache for `state_recipient'

	is_using_model_based_strategy_cache: BOOLEAN
			-- Cache for `is_using_model_based_strategy'.

	is_using_random_based_strategy_cache: BOOLEAN
			-- Cache for `is_using_random_based_strategy'.

invariant

	one_fixing_strategy_specified: is_using_model_based_strategy xor is_using_random_based_strategy

end
