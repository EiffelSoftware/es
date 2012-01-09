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

	current_failing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [STRING]
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
			Result := root_class.group.location.evaluated_path
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
			l_eifgens_dir_path: DIRECTORY_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_file_name: FILE_NAME
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_root_builder: AFX_FIXING_PROJECT_ROOT_BUILDER
		do
				-- Collect passing and failing test cases.
			create l_test_case_file_selector.make
			l_test_case_file_selector.collect_all_test_case_files
			l_test_case_file_selector.start_with_first_fault
			check l_test_case_file_selector.has_more_fault_signature end
			current_fault_signature := l_test_case_file_selector.fault_signature
			current_passing_test_cases := l_test_case_file_selector.passing_test_case_files
			current_failing_test_cases := l_test_case_file_selector.failing_test_case_files

			l_system := system
			check l_system /= Void end

				-- Build new root class for fixing.
			create l_root_builder.make_with_test_cases (l_system, current_failing_test_cases, current_passing_test_cases, current_fault_signature)
			l_root_builder.build
			l_eifgens_dir_path := l_system.project_location.eifgens_cluster_path
			create l_file_name.make_from_string (l_eifgens_dir_path)
			l_file_name.set_file_name (afx_project_root_class.as_lower)
			l_file_name.add_extension ("e")
			create l_file.make (l_file_name)
			if not l_file.exists then
				l_system.force_rebuild
			end
			l_file.recursive_open_write
			if l_file.is_open_write then
				l_file.put_string (l_root_builder.last_class_text)
				l_file.close
			end

				-- Copy test case files, both passing and failing, into `system'.
			copy_test_case_files (current_passing_test_cases, test_case_folder, l_eifgens_dir_path)
			copy_test_case_files (current_failing_test_cases, test_case_folder, l_eifgens_dir_path)

--			if not l_system.is_explicit_root (afx_project_root_class, afx_project_root_feature) then
--				l_system.add_explicit_root (Void, afx_project_root_class, afx_project_root_feature)
--			end

				-- Recompile current project.
			compile_project (eiffel_project, True)
		end

feature{NONE} -- Implementation

	copy_test_case_files (a_class_names: DS_ARRAYED_LIST [STRING]; a_src_dir, a_dest_dir: STRING)
			-- Copy test cases, with names in `a_class_names', from `a_src_dir' to `a_dest_dir'.
			-- Existing files in `a_dest_file' with the same names will be overwritten.
		require
			class_names_attached: a_class_names /= Void
			dirs_not_empty: a_src_dir /= Void and then not a_src_dir.is_empty
						and then a_dest_dir /= Void and then not a_dest_dir.is_empty
		local
			l_src_file_name, l_dest_file_name: FILE_NAME
			l_class_name: STRING
		do
			from a_class_names.start
			until a_class_names.after
			loop
				l_class_name := a_class_names.item_for_iteration.as_lower
				create l_dest_file_name.make_from_string (a_dest_dir)
				l_dest_file_name.set_file_name (l_class_name)
				l_dest_file_name.add_extension ("e")
				create l_src_file_name.make_from_string (a_src_dir)
				l_src_file_name.set_file_name (l_class_name)
				l_src_file_name.add_extension ("e")
				File_system.copy_file (l_src_file_name, l_dest_file_name)

				a_class_names.forth
			end
		end

end
