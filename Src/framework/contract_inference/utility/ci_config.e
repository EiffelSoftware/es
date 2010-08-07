note
	description: "Configuration for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_CONFIG

inherit
	SHARED_EXEC_ENVIRONMENT

	KL_SHARED_STRING_EQUALITY_TESTER

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

	test_case_directory: detachable STRING
			-- Directory where test cases are stored

	class_name: STRING
			-- Name of class whose contracts are to be inferred

	feature_name_for_test_cases: DS_HASH_SET [STRING]
			-- Name of the features whose test cases are used for contract inference.
			-- If empty, test cases for all features in the class are considered.
		do
			if feature_name_for_test_cases_cache = Void then
				create feature_name_for_test_cases_cache.make (10)
				feature_name_for_test_cases_cache.set_equality_tester (string_equality_tester)
			end
			Result := feature_name_for_test_cases_cache
		end

	project_directory: STRING
			-- Directory of current project
		do
			Result := eiffel_system.eiffel_project.project_directory.path
		end

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := eiffel_system.root_type.associated_class
		end

	data_directory: STRING
			-- Directory for AutoFix data
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (contract_output_directory)
			l_path.extend (once "data")
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	transition_directory: STRING
			-- Directory for AutoFix data
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (contract_output_directory)
			l_path.extend (once "transition")
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	log_directory: STRING
			-- Directory for AutoFix logs
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (contract_output_directory)
			l_path.extend ("log")
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	contract_output_directory: STRING
			-- Directory for output
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (eiffel_system.eiffel_project.project_directory.contract_inference_results_path)
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	working_directory: STRING
			-- Working directory of the project
		do
			Result := Execution_environment.current_working_directory
		end

	output_directory: STRING
			-- Directory to output generated files
			-- Serveral options use this output_directory, including:
			-- `generate-weka'.

	max_test_case_to_execute: INTEGER
			-- The maximal number of test cases to execute.
			-- This is for debug reason, because execute a test case and
			-- evaluate all expressions is expensive, sometimes, you only
			-- want to execute a small number of test cases in a directory
			-- containing many test cases.
			-- Note: There is no control over which test cases will be selected.
			-- 0 means execute all test cases in that directory.
			-- Default: 0

	composite_max_premise_number: INTEGER
			-- The maximal number of premises in a implication frame property
			-- 0 means no limit. Default is 2.
			-- For example, is `composite_max_premise_number' is 2, the longest implication could look like
			-- premise_1 and premise_2 implies consequent.
			-- Only has effect when `is_composite_property_enabled' is True.

	composite_min_premise_number: INTEGER
			-- The minimal number of premises in a implication frame property			
			-- For example, is `composite_max_premise_number' is 2, the longest implication could look like
			-- premise_1 and premise_2 implies consequent.
			-- Minimal value is 1. Default is 1.
			-- Only has effect when `is_composite_property_enabled' is True.

	composite_boolean_premise_connectors: LINKED_SET [STRING]
			-- Set of operators which can connect two boolean premise in a composite frame property
			-- Valid values: "and", "or"
			-- Default: "and", "or"
			-- Only has effect when `is_composite_property_enabled' is True.
		do
			if composite_boolean_premise_connectors_cache = Void then
				create composite_boolean_premise_connectors_cache.make
				composite_boolean_premise_connectors_cache.compare_objects
			end
			Result := composite_boolean_premise_connectors_cache
		end

	composite_boolean_connectors: LINKED_SET [STRING]
			-- Set of operators which can connect the premises and consequant in a composite frame property whose premise is of type boolean
			-- Valid values : "implies", "="
			-- Default: "implies", "="
			-- Only has effect when `is_composite_property_enabled' is True.
		do
			if composite_boolean_connectors_cache = Void then
				create composite_boolean_connectors_cache.make
				composite_boolean_connectors_cache.compare_objects
			end
			Result := composite_boolean_connectors_cache
		end

	composite_integer_premise_connectors: LINKED_SET [STRING]
			-- Set of operators which can connect two integer left-hand components in a composite frame property
			-- Valid values: "+", "-"
			-- Default: "+"
			-- Only has effect when `is_composite_property_enabled' is True.
		do
			if composite_integer_premise_connectors_cache = Void then
				create composite_integer_premise_connectors_cache.make
				composite_integer_premise_connectors_cache.compare_objects
			end
			Result := composite_integer_premise_connectors_cache
		end

	composite_integer_connectors: LINKED_SET [STRING]
			-- Set of operators which can connect the premises and consequant in a composite frame property whose premise is of type integer
			-- Valid values : "=", ">", "<", ">=", "<=", "/="
			-- Default: "="
			-- Only has effect when `is_composite_property_enabled' is True.
		do
			if composite_integer_connectors_cache = Void then
				create composite_integer_connectors_cache.make
				composite_integer_connectors_cache.compare_objects
			end
			Result := composite_integer_connectors_cache
		end

	is_composite_negation_boolean_premise_enabled: BOOLEAN
			-- Is negation enabled for premises in composite frame properties.			
			-- Default: False.
			-- For example, if this attribute is True, frame property candidates
			-- may include expression such as: not old {1}.has ({2}) implies {1}.has ({2})
			-- Only has effect when `is_composite_property_enabled' is True.

	is_composite_property_enabled: BOOLEAN
			-- Should composite frame properties be inferred?
			-- Default: True

	is_sequence_property_enabled: BOOLEAN
			-- Should sequence based frame properties be inferred?
			-- Default: True

	is_simple_property_enabled: BOOLEAN
			-- Should simple frame properties be infferd?
			-- Default: True

	is_daikon_enabled: BOOLEAN
			-- Should Daikon be used as an inferrer?
			-- Default: True

	is_dnf_property_enabled: BOOLEAN
			-- Should properties in DNF format be inferred?
			-- Default: True

	max_dnf_clause: INTEGER
			-- Maximal number of clauses in DNF style properties
			-- Only have effect if `is_dnf_property_enabled' is True.
			-- Default: 2

	is_tilda_enabled: BOOLEAN
			-- Is contract mentioning "~" enabled?
			-- Default: False

	is_implication_property_enabled: BOOLEAN
			-- Should implications be inferred?
			-- Default: True

	is_linear_property_enabled: BOOLEAN
			-- Should linear properties be inferred?
			-- Default: True

	is_simple_equality_property_enabled: BOOLEAN
			-- Should simple equality properties in form of p = q be inferred?
			-- Default: True

	is_dummy_property_enabled: BOOLEAN
			-- Should dummy equality property be inferred?
			-- Default: False

	is_constant_change_property_enabled: BOOLEAN
			-- Should constant-change properties by inferred?
			-- Default: True

	verbose_level: INTEGER
			-- Information output level
			-- Check constants defiend {EPA_LOG_MANAGER} for valid values.
			-- Default: {EPA_LOG_MANAGER}.info_level

	should_freeze: BOOLEAN
			-- Should freeze the project before contract inference?
			-- Default: False

feature -- Status report

	should_build_project: BOOLEAN
			-- Should project be built to contain infrastructure for contract inference?

	should_infer_contracts: BOOLEAN
			-- Should contracts be inferred?

	should_generate_weka_relations: BOOLEAN
			-- Should Weka relations be generated?			

feature -- Weka relation generation

	weka_assertion_selection_mode: INTEGER
			-- The assertion selection mode,

	weka_assertion_union_selection_mode: INTEGER = 1
			-- If multiple transitions for the same feature have different assertions,
			-- those assertions are unioned together.

	weka_assertion_intersection_selection_mode: INTEGER = 0
			-- If multiple transitions for the same feature have different assertions,
			-- those assertions will be ignored, only assertions common to all transitions
			-- will be kept.
			-- This is the default.

	is_weka_assertion_selection_mode_valid (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid Weka assertion selection mode?
		do
			Result :=
				a_mode = weka_assertion_intersection_selection_mode or
				a_mode =weka_assertion_union_selection_mode
		end

feature -- Setting

	set_should_build_project (b: BOOLEAN)
			-- Set `should_build_project' with `b'.
		do
			should_build_project := b
		ensure
			should_build_project_set: should_build_project = b
		end

	set_test_case_directory (a_dir: like test_case_directory)
			-- Set `test_case_directory' with `a_dir'.
			-- Make a copy of `a_dir'
		do
			if a_dir = Void then
				test_case_directory := Void
			else
				test_case_directory := a_dir.twin
			end
		end

	set_feature_name_for_test_cases (a_feature_names: STRING)
			-- Set `feature_name_for_test_cases' with feature names specified in `a_feature_name'.
			-- `a_feature_names' is a comma-separated string, each part is a feature name.
		local
			l_name: STRING
		do
			feature_name_for_test_cases.wipe_out
			across a_feature_names.split (',') as l_cursor loop
				l_name := l_cursor.item
				l_name.left_adjust
				l_name.right_adjust
				l_name.to_lower
				if not l_name.is_empty then
					feature_name_for_test_cases.force_last (l_name)
				end
			end
		end

	set_class_name (a_name: like class_name)
			-- Set `class_name' with `a_name'.
		do
			class_name := a_name.twin
		end

	set_should_infer_contracts (b: BOOLEAN)
			-- Set `should_infer_contracts' with `b'.
		do
			should_infer_contracts := b
		ensure
			should_infer_contracts_set: should_infer_contracts = b
		end

	set_should_generate_weka_relations (b: BOOLEAN)
			-- Set `should_generate_weka_relations' with `b'.
		do
			should_generate_weka_relations := b
		ensure
			should_generate_weka_relations_set: should_generate_weka_relations = b
		end

	set_weka_assertion_selection_mode (i: INTEGER)
			-- Set `weka_assertion_selection_mode' with `i'.
		require
			i_valid: is_weka_assertion_selection_mode_valid (i)
		do
			weka_assertion_selection_mode := i
		ensure
			weka_assertion_selection_mode_set: weka_assertion_selection_mode = i
		end

	set_output_directory (a_directory: like output_directory)
			-- Set `output_directory' with `a_directory'.
			-- Make a new copy of `a_directory'.
		do
			output_directory := a_directory.twin
		end

	set_max_test_case_to_execute (i: INTEGER)
			-- Set `max_test_case_to_execute' with `i'.
		require
			i_non_negative: i >= 0
		do
			max_test_case_to_execute := i
		ensure
			max_test_case_to_execute_set: max_test_case_to_execute = i
		end

	set_composite_max_premise_number (i: INTEGER)
			-- Set `composite_max_premise_number' with `i'.
		require
			i_non_negative: i >= 0
		do
			composite_max_premise_number := i
		ensure
			max_premise_number_set: composite_max_premise_number = i
		end

	set_composite_min_premise_number (i: INTEGER)
			-- Set `composite_min_premise_number' with `i'.
		require
			i_non_negative: i >= 0
		do
			composite_min_premise_number := i
		ensure
			min_premise_number_set: composite_min_premise_number = i
		end

	set_is_composite_negation_boolean_premise_enabled (b: BOOLEAN)
			-- Set `is_composite_negation_boolean_premise_enabled' with `b'.
		do
			is_composite_negation_boolean_premise_enabled := b
		ensure
			is_composite_negation_premise_enabled_set: is_composite_negation_boolean_premise_enabled = b
		end

	set_is_composite_property_enabled (b: BOOLEAN)
			-- Set `is_composite_property_enabled' with `b'.
		do
			is_composite_property_enabled := b
		ensure
			is_composite_property_enabled_set: is_composite_property_enabled = b
		end

	set_is_sequence_property_enabled (b: BOOLEAN)
			-- Set `is_sequence_property_enabled' with `b'.
		do
			is_sequence_property_enabled := b
		ensure
			is_sequence_property_enabled_set: is_sequence_property_enabled = b
		end

	set_is_simple_property_enabled (b: BOOLEAN)
			-- Set `is_simple_property_enabled' with `b'.
		do
			is_simple_property_enabled := b
		ensure
			is_simple_property_enabled_set: is_simple_property_enabled = b
		end

	set_is_daikon_enabled (b: BOOLEAN)
			-- Set `is_daikon_enabled' with `b'.
		do
			is_daikon_enabled := b
		ensure
			is_daikon_enabled_set: is_daikon_enabled = b
		end

	set_is_dnf_property_enabled (b: BOOLEAN)
			-- Set `is_dnf_property_enabled' with `b'.
		do
			is_dnf_property_enabled := b
		ensure
			is_dnf_property_enabled_set: is_dnf_property_enabled = b
		end

	set_max_dnf_clause (i: INTEGER)
			-- Set `max_dnf_clause' with `i'.
		require
			i_positive: i > 0
		do
			max_dnf_clause := i
		ensure
			max_dnf_clause_set: max_dnf_clause = i
		end

	set_is_tilda_enabled (b: BOOLEAN)
			-- Set `is_tilda_enabled' with `b'.
		do
			is_tilda_enabled := b
		ensure
			is_tilda_enabled_set: is_tilda_enabled = b
		end

	set_is_implication_property_enabled (b: BOOLEAN)
			-- Set `is_implication_property_enabled' with `b'.
		do
			is_implication_property_enabled := b
		ensure
			is_implication_property_enabled_set: is_implication_property_enabled = b
		end

	set_is_linear_property_enabled (b: BOOLEAN)
			-- Set `is_liear_property_enabled' with `b'.
		do
			is_linear_property_enabled := b
		ensure
			is_linear_property_enabled_set: is_linear_property_enabled = b
		end

	set_is_simple_equality_property_enabled (b: BOOLEAN)
			-- Set `is_simple_equality_property_enabled' with `b'.
		do
			is_simple_equality_property_enabled := b
		ensure
			is_simple_equality_property_enabled_set: is_simple_equality_property_enabled = b
		end

	set_is_dummy_property_enabled (b: BOOLEAN)
			-- Set `is_dummy_property_enabled' with `b'.
		do
			is_dummy_property_enabled := b
		ensure
			is_dummy_property_enabled_set: is_dummy_property_enabled = b
		end

	set_is_constant_change_property_enabled (b: BOOLEAN)
			-- Set `is_constant_change_property_enabled' with `b'.
		do
			is_constant_change_property_enabled := b
		ensure
			is_constant_change_property_enabled_set: is_constant_change_property_enabled = b
		end

	set_verbose_level (a_level: INTEGER)
			-- Set `verbose_leve' with `a_level'.
		do
			verbose_level := a_level
		ensure
			verbose_level_set: verbose_level = a_level
		end

	set_should_freeze (b: BOOLEAN)
			-- Set `should_freeze' with `b'.
		do
			should_freeze := b
		ensure
			should_freeze_set: should_freeze = b
		end

feature{NONE} -- Implementation

	safe_recursive_create_directory (a_dir: STRING)
			-- Create `a_dir' if it doesnot exist.
		local
			l_dir: KL_DIRECTORY
		do
			create l_dir.make (a_dir)
			if not l_dir.exists then
				l_dir.recursive_create_directory
			end
		end

	feature_name_for_test_cases_cache: detachable like feature_name_for_test_cases
			-- Cache for `feature_name_for_test_cases'

	composite_boolean_premise_connectors_cache: detachable like composite_boolean_premise_connectors
			-- Cache of `composite_boolean_premise_connector'

	composite_integer_premise_connectors_cache: detachable like composite_integer_premise_connectors
			-- Cache of `composite_integer_premise_connector'

	composite_boolean_connectors_cache: detachable like composite_boolean_connectors
			-- Cache of `composite_boolean_connector'

	composite_integer_connectors_cache: detachable like composite_integer_connectors
			-- Cache of `composite_integer_connector'
end
