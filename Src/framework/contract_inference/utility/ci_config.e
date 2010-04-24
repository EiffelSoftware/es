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

	feature_name_for_test_cases: detachable STRING
			-- Name of the feature whose test cases are used for contract inference.
			-- If Void, test cases for all features in the class are considered.

feature -- Status report

	should_build_project: BOOLEAN
			-- Should project be built to contain infrastructure for contract inference?
		do
			Result := attached test_case_directory
		end

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

end
