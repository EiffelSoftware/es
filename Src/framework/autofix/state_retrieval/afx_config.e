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

	model_directory: STRING is
			-- Directory for state transition summary.
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("model")
			Result := l_path
		end

	backward_model_directory: STRING
			-- Directory to store backward state transition models
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (model_directory)
			l_path.extend ({AFX_BACKWARD_STATE_TRANSITION_MODEL}.model_directory)
			Result := l_path
		end

	forward_model_directory: STRING
			-- Directory to store forward state transition models
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (model_directory)
			l_path.extend ({AFX_FORWARD_STATE_TRANSITION_MODEL}.model_directory)
			Result := l_path
		end

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

	interpreter_log_path: STRING
			-- Full path to the interpreter log file
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (log_directory)
			l_path.set_file_name ("interpreter_log.txt")
			Result := l_path
		end

feature -- State retrieval related

	state_test_case_class_name: detachable STRING
			-- Name of the test case class used for state retrieval
			-- A test case class name starts with "TC__".
		do
			if state_test_case_class_name_cache = Void then
				state_test_case_class_name_cache := first_test_case_class_name
			end
			Result := state_test_case_class_name_cache
		end

	state_class_under_test: detachable CLASS_C
			-- CLASS_C for `state_test_case_class_name'
			-- Void if no such class exists.
		local
			l_feat: like state_feature_under_test
		do
			l_feat := state_feature_under_test
			if l_feat /= Void then
				Result := l_feat.access_class
			end
		end

	state_feature_under_test: detachable FEATURE_I
			-- FEATURE_I for `state_feature_under_test',
			-- Void if no such feature exists.
		do
			if state_test_case_class_name_cache = Void then
				analyze_test_case_class_name
			end
			Result := state_feature_under_test_cache
		end

	state_recipient_class: detachable CLASS_C
			-- Class containing the feature `state_feature_under_test'
			-- Void if no such class exists.
		do
			if state_recipient /= Void then
				Result := state_recipient.access_class
			end
		end

	state_recipient: detachable FEATURE_I
			-- Recipient feature of the exception in a failed test case.
			-- In a passing test case, same as `state_feature_under_test'.
		do
			if state_recipient_cache = Void then
				analyze_test_case_class_name
			end
			Result := state_recipient_cache
		end

feature -- Test case analysis

	test_case_path: detachable STRING
			-- Full path of the folder storing test cases

	max_test_case_number: INTEGER
			-- Max number of test cases
			-- Default: 0

	is_arff_generation_enabled: BOOLEAN
			-- Should ARFF file be generated during test case analysis?
			-- ARFF is used by the Weka machine learning tool.
			-- Default: False

	is_daikon_enabled: BOOLEAN
			-- Should Daikon be used to infer invariants on system states?
			-- Default: False

feature -- Fix generation

	max_valid_fix_number: INTEGER
			-- Maximal number of valid fixes
			-- Stop after found this number of fixes.
			-- 0 means not bounded.
			-- Default: 0

feature -- Status report

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

	set_should_retrieve_state (b: BOOLEAN)
			-- Set `should_retrieve_state' with `b'.
		do
			should_retrieve_state_cache := b
		ensure
			should_retrieve_state_set: should_retrieve_state = b
		end

	set_state_recipient (a_recipient: like state_recipient)
			-- Set `state_recipient' with `a_recipient'.
		do
			state_recipient_cache := a_recipient
		ensure
			state_recipient_set: state_recipient = a_recipient
		end

	set_state_feature_under_test (a_feature_under_test: like state_feature_under_test)
			-- Set `state_feature_under_test' with `a_feature_under_test'.
		do
			state_feature_under_test_cache := a_feature_under_test
		ensure
			state_feature_under_test_set: state_feature_under_test = a_feature_under_test
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

feature{NONE} -- Implementation

	working_directory_cache: detachable STRING
			-- Cache for working_directory

	state_output_file_cache: detachable STRING
			-- Cache for `state_output_file'

	state_test_case_class_name_cache: detachable STRING
			-- Cache for `state_test_case_class_name'

	should_retrieve_state_cache: BOOLEAN
			-- Cache for `should_retrieve_state'

	state_feature_under_test_cache: like state_feature_under_test
			-- Cache for `state_feature_under_test'

	state_recipient_cache: detachable FEATURE_I
			-- Cache for `state_recipient'

feature{NONE} -- Implementation

	first_test_case_class_name: detachable STRING is
			-- Name of the test case class
			-- Search for a class whose name starts with "TC__", it is a naming convention
			-- for test cases. The first found class is returned.
			-- Note: If there are more than one test case classes in a probject, there is no
			-- guarantee which one will be returned.
		local
			l_classes: CLASS_C_SERVER
			i: INTEGER
			n: INTEGER
			l_done: BOOLEAN
			l_class: CLASS_C
		do
			l_classes := eiffel_system.classes
			i := l_classes.lower
			n := l_classes.count

			from
			until
				i = n or else Result /= Void
			loop
				l_class := l_classes.item (i)
				if l_class /= Void then
--					io.put_string ("--> " + l_class.name + "%N")
				end
				if l_class /= Void and then l_class.already_compiled and then l_class.name.starts_with (once "TC__") then
					Result := l_class.name.twin
				end
				i := i + 1
			end
		end

	analyze_test_case_class_name
			-- Analyze `state_test_case_class_name' to find out
			-- tested feature, and (in case of a failed test case, recipient of the exception'.
		local
			l_tc_info: AFX_TEST_CASE_INFO
		do
			if state_test_case_class_name /= Void then
				create l_tc_info.make_with_string (state_test_case_class_name)
				state_feature_under_test_cache := feature_from_class (l_tc_info.class_under_test, l_tc_info.feature_under_test)
				state_recipient_cache := feature_from_class (l_tc_info.recipient_class, l_tc_info.recipient)
			end
		end

end
