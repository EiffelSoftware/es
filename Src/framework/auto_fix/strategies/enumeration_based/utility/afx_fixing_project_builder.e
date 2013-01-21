note
	description: "Summary description for {AFX_FIXING_PROJECT_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_PROJECT_BUILDER

inherit
	SHARED_WORKBENCH

	SHARED_EIFFEL_PROJECT

	AFX_SHARED_PROJECT_ROOT_INFO

	EPA_SHARED_CLASS_THEORY

	AFX_SHARED_SESSION

	AUT_SHARED_RANDOM

	SHARED_SERVER

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_FILE_UTILITY

	INTERNAL_COMPILER_STRING_EXPORTER

	INTERNAL_COMPILER_STRING_EXPORTER

	REFACTORING_HELPER

	EPA_COMPILATION_UTILITY

	KL_SHARED_FILE_SYSTEM

feature -- Access

	current_fault_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault under fix.

	current_failing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of passing test case files for fixing.

feature{NONE} -- Access

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
		end

	project_file_folder: STRING
			-- Folder storing project files.
		do
			Result := root_class.group.location.evaluated_path.out
		end

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

feature -- Basic operation

	execute
			-- Execute.
		local
			l_test_case_file_selector: AFX_TEST_CASE_FILE_SELECTOR
			l_system: SYSTEM_I
			l_dir: PROJECT_DIRECTORY
			l_afx_test_case_path: PATH
			l_file: PLAIN_TEXT_FILE
			l_file_path: PATH
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_root_builder: AFX_FIXING_PROJECT_ROOT_BUILDER
		do
				-- Collect passing and failing test cases.
			create l_test_case_file_selector
			l_test_case_file_selector.select_fault_and_test_cases
			check l_test_case_file_selector.fault_signature /= Void end
			current_fault_signature := l_test_case_file_selector.fault_signature
			current_passing_test_cases := l_test_case_file_selector.passing_test_case_files
			current_failing_test_cases := l_test_case_file_selector.failing_test_case_files

			l_system := system
			check l_system /= Void end

				-- Build new root class for fixing.
			create l_root_builder.make_with_test_cases (l_system, current_failing_test_cases, current_passing_test_cases, current_fault_signature)
			l_root_builder.build
			l_afx_test_case_path := l_system.project_location.eifgens_cluster_path
			l_file_path := l_afx_test_case_path.extended (afx_project_root_class.as_lower + ".e")
			create l_file.make_with_path (l_file_path)
			if not l_file.exists then
				l_system.force_rebuild
			end
			l_file.open_write
			if l_file.is_open_write then
				l_file.put_string (l_root_builder.last_class_text)
				l_file.close
			end

				-- Copy test case files, both passing and failing, into `system'.
			copy_test_case_files (current_passing_test_cases, l_afx_test_case_path)
			copy_test_case_files (current_failing_test_cases, l_afx_test_case_path)

				-- Recompile current project.
			compile_project (eiffel_project, True)
		end

feature{NONE} -- Implementation

	copy_test_case_files (a_class_file_paths: DS_ARRAYED_LIST [PATH]; a_dest_dir: PATH)
			-- Copy test cases, with names in `a_class_file_names' to `a_dest_dir'.
			-- Existing files in `a_dest_file' with the same names will be overwritten.
		require
			class_file_paths_attached: a_class_file_paths /= Void
			dirs_not_empty: a_dest_dir /= Void and then not a_dest_dir.is_empty
		local
			l_src_file_path, l_dest_file_path: PATH
			l_utilities: FILE_UTILITIES
		do
			from a_class_file_paths.start
			until a_class_file_paths.after
			loop
				l_src_file_path := a_class_file_paths.item_for_iteration
				l_dest_file_path := a_dest_dir.extended (base_eiffel_file_name_from_full_path(l_src_file_path.utf_8_name) + ".e")

				l_utilities.copy_file_path (l_src_file_path, l_dest_file_path)

				a_class_file_paths.forth
			end
		end

end
