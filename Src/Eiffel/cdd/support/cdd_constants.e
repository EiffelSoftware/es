indexing
	description: "Objects that support cdd classes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CONSTANTS

feature -- Project constants

	library_name: STRING is "cdd"
			-- Name for cdd library

	tests_directory_name: STRING is "cdd_tests"
			-- Name for directories containing cdd tests

	log_file_name: STRING is "cdd.log"
			-- Name of the cdd log file

	class_name_prefix: STRING is "CDD_TEST_"
			-- Prefix for all test case class names

	test_ancestor_class_name: STRING is "CDD_TEST_CASE"
			-- Class name of ancestor of all test classes

	extracted_test_class_name: STRING is "CDD_EXTRACTED_TEST_CASE"
			-- Class name of ancestor of extracted test classes

	synthesized_test_class_name: STRING is "CDD_AUT_TEST_CASE"
			-- Class name of ancestor of synthesized test classes

	cluster_name_suffix: STRING is "_tests"

	tester_target_suffix: STRING is "_tester"

	test_routine_prefix: STRING is "test"

	default_cluster_name: STRING is "cdd_test_suite"
			-- Name of cdd cluster

	unknown_name: STRING is "<unknown>"
			-- Replacement for unknown cluster/class/feature names

	max_reference_depth: INTEGER is 5
			-- Max depth capturer will follow object references when extracting

	max_object_count: INTEGER is 2000
			-- Max number of objects that will be extracted per test class

	max_execution_attempts: INTEGER is 3
			-- How many time do we try to execute a test case which has killed or jammed to interpreter?

	max_manifest_string_size: INTEGER is 1000
			-- max size of manifest strings written in extracted test classes, larger strings are split in several parts

	max_test_cases_per_sut_class: INTEGER is 1000
			-- max amount of test cases that are generated per "original-class-name"

	cdd_homepage_url: STRING is "http://dev.eiffel.com/CddBranch"

feature -- TTY

	confirm_enabling: STRING is "CDD is currently enabled, would you like to%Ncontinue having CDD enabled"

	confirm_disabling: STRING is "CDD is currently disabled, would you like to%Nenable CDD"

	confirm_extracting: STRING is "Shall test cases be automatically created in%Ncase of a runtime violation"

	confirm_capture_replay: STRING is "Would you like to use capture/replay for%Nextracting and executing test cases%N(Warning: this tool is experimental)"

end
