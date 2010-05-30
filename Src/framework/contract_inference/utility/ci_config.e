note
	description: "Configuration for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_CONFIG

inherit
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

	test_case_directory: detachable STRING
			-- Directory where test cases are stored

	class_name: STRING
			-- Name of class whose contracts are to be inferred

	feature_name_for_test_cases: detachable STRING
			-- Name of the feature whose test cases are used for contract inference.
			-- If Void, test cases for all features in the class are considered.

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

	data_directory: STRING is
			-- Directory for AutoFix data
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend (once "data")
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	log_directory: STRING is
			-- Directory for AutoFix logs
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (output_directory)
			l_path.extend ("log")
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	output_directory: STRING is
			-- Directory for output
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (eiffel_system.eiffel_project.project_directory.contract_inference_results_path)
			Result := l_path
			safe_recursive_create_directory (l_path)
		end

	working_directory: STRING is
			-- Working directory of the project
		do
			Result := Execution_environment.current_working_directory
		end

feature -- Status report

	should_build_project: BOOLEAN
			-- Should project be built to contain infrastructure for contract inference?
		do
			Result := attached test_case_directory
		end

	should_infer_contracts: BOOLEAN
			-- Should contracts be inferred?

feature -- Setting

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

	set_feature_name_for_test_cases (a_name: like feature_name_for_test_cases)
			-- Set `feature_name_for_test_cases' with `a_name'.
			-- Make a copy of `a_name'
		do
			if a_name = Void then
				feature_name_for_test_cases := Void
			else
				feature_name_for_test_cases := a_name.twin
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

end
