indexing
	description: "Objects that support cdd classes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CONSTANTS

feature -- Access

feature -- Project constants

	library_name: STRING is "cdd"
			-- Name for cdd library

	tests_directory_name: STRING is "cdd_tests"
			-- Name for directories containing cdd tests

	class_name_prefix: STRING is "CDD_TEST_"
			-- Prefix for all test case class names

	abstract_extracted_class_name: STRING is "CDD_EXTRACTED_TEST_CASE"
			-- Class name of the abstract extracted test case

	cluster_name_suffix: STRING is "_tests"

	default_cluster_name: STRING is "cdd_test_suite"
			-- Name of cdd cluster

	unknown_name: STRING is "<unknown>"
			-- Replacement for unknown cluster/class/feature names

	max_reference_depth: INTEGER is 5
			-- Max depth capturer will follow object references when extracting

feature -- TTY

	confirm_enabling: STRING is "CDD is currently enabled, would you like to%Ncontinue having CDD enabled"

	confirm_disabling: STRING is "CDD is currently disabled, would you like to%Nenable CDD"

	confirm_extracting: STRING is "Shall test cases be automatically created in%Ncase of a runtime violation"

	confirm_capture_replay: STRING is "Would you like to use capture/replay for%Nextracting and executing test cases%N(Warning: this tool is experimental)"

feature -- Error constants

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
