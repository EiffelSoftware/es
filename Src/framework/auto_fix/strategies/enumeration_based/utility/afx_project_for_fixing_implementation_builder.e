note
	description: "Summary description for {AFX_FIXING_PROJECT_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROJECT_FOR_FIXING_IMPLEMENTATION_BUILDER

inherit
	SHARED_WORKBENCH

	SHARED_EIFFEL_PROJECT

	AFX_SHARED_PROJECT_ROOT_INFO

	EPA_SHARED_CLASS_THEORY

	AFX_SHARED_SESSION

	AUT_SHARED_RANDOM

	AFX_UTILITY

	SHARED_SERVER

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_FILE_UTILITY

	INTERNAL_COMPILER_STRING_EXPORTER

	REFACTORING_HELPER

	EPA_COMPILATION_UTILITY

	KL_SHARED_FILE_SYSTEM

	EPA_UTILITY

feature -- Access

	current_failing_test_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault under fix.

	current_exception_trace_summary: EPA_EXCEPTION_TRACE_SUMMARY
			-- Summary of the exception trace.

	current_failing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of passing test case files for fixing.

	current_relaxed_failing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of failing test case files w.r.t relaxed contracts.

	current_relaxed_passing_test_cases: DS_ARRAYED_LIST [PATH]
			-- List of passing test case files w.r.t. relaxed contracts.

	number_of_test_cases_to_use_for_fixing: INTEGER

feature -- Project root

	path_to_new_root: PATH
		do
			Result := session.afx_tmp_directory.extended (Afx_project_root_class.as_lower + ".e")
		end

	new_root_exists: BOOLEAN
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_path (path_to_new_root)
			Result := l_file.exists
		end

feature -- Basic operation

	collect_test_cases
			--
		local
			l_signatures: DS_LINKED_LIST [EPA_TEST_CASE_SIGNATURE]
			l_signature_id_cursor: DS_LINKED_LIST_CURSOR [EPA_TEST_CASE_SIGNATURE]
			l_test_case_file_selector: AFX_TEST_CASE_FILE_SELECTOR
			l_relaxed_test_case_file_selector: AFX_TEST_CASE_FILE_SELECTOR
			l_fault_signatures: DS_LINKED_LIST [EPA_TEST_CASE_SIGNATURE]
			l_fault_signautre_cursor: DS_LINKED_LIST_CURSOR [EPA_TEST_CASE_SIGNATURE]
			l_fault_signature, l_relaxed_passing_test_signature: EPA_TEST_CASE_SIGNATURE
			l_failure_from_trace: EPA_EXCEPTION_TRACE_SUMMARY
			l_failing_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_unique_relaxed_passings: DS_HASH_SET [PATH]
			l_nbr_failing_tests_per_fault: INTEGER
			l_system: SYSTEM_I
			l_dir: PROJECT_DIRECTORY
			l_afx_test_case_path: PATH
			l_file: PLAIN_TEXT_FILE
			l_file_path: PATH
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_root_builder: AFX_PROJECT_ROOT_FOR_FIXING_CONTRACTS_BUILDER
			l_tc_dir, l_rtc_dir: DIRECTORY
			l_path_to_relaxed_test_cases: PATH
		do
				-- Collect passing and failing test cases.
			create l_test_case_file_selector
			l_test_case_file_selector.use_random_selection (config.is_using_random_test_case_selection)
			l_test_case_file_selector.use_state_based_selection (config.is_using_state_based_test_case_selection)
			l_test_case_file_selector.collect_test_cases (config.test_case_path, Void)
			check not l_test_case_file_selector.failing_test_signatures.is_empty end

				-- Signature of the fault to fix.
			l_signatures := l_test_case_file_selector.failing_test_signatures
			if attached config.fault_signature_id as lt_id then
				from
					l_signature_id_cursor := l_signatures.new_cursor
					l_signature_id_cursor.start
				until
					l_signature_id_cursor.after or else current_failing_test_signature /= Void
				loop
					if l_signature_id_cursor.item.id ~ lt_id then
						current_failing_test_signature := l_signature_id_cursor.item
					end
					l_signature_id_cursor.forth
				end
			end

				-- Fix the first fault from the test case directory, if the target fault is not specified.
			if current_failing_test_signature = Void and then not l_test_case_file_selector.failing_test_signatures.is_empty then
				current_failing_test_signature := l_test_case_file_selector.failing_test_signatures.first
			end

			if current_failing_test_signature /= Void then
					-- Select test cases
				l_test_case_file_selector.set_max_passing_test_case_number (config.max_passing_test_case_number)
				l_test_case_file_selector.set_max_failing_test_case_number (config.max_failing_test_case_number)

				current_passing_test_cases := l_test_case_file_selector.selected_tests (True,
						agent (a_failure, a_match: EPA_TEST_CASE_SIGNATURE): BOOLEAN
							do
								Result := a_failure.feature_under_test ~ a_match.feature_under_test
										and then a_failure.class_under_test ~ a_match.class_under_test
							end (current_failing_test_signature, ?))
				current_failing_test_cases := l_test_case_file_selector.selected_tests (False,
						agent (a_failure, a_match: EPA_TEST_CASE_SIGNATURE): BOOLEAN
							do
								Result := a_failure.id ~ a_match.id
							end (current_failing_test_signature, ?))
				current_exception_trace_summary := exception_summary_from_trace_file (current_failing_test_cases.first)
				number_of_test_cases_to_use_for_fixing := (current_passing_test_cases.count + 1)// 2 + (current_failing_test_cases.count + 1) // 2

				if config.is_fixing_contract and then (current_failing_test_signature.exception_code = 3 or current_failing_test_signature.exception_code = 4) then
						-- Path to relaxed test cases.
					l_failure_from_trace := current_exception_trace_summary
					create l_failing_feature.make (l_failure_from_trace.failing_feature, l_failure_from_trace.failing_context_class)
					create l_path_to_relaxed_test_cases.make_from_string (config.relaxed_test_case_path)
					l_path_to_relaxed_test_cases := l_path_to_relaxed_test_cases.extended (l_failing_feature.context_class.name).extended (l_failing_feature.feature_.feature_name)

						-- Select relaxed test cases
					create l_relaxed_test_case_file_selector
					l_relaxed_test_case_file_selector.collect_test_cases (l_path_to_relaxed_test_cases.out, Void)
					l_relaxed_test_case_file_selector.set_max_passing_test_case_number (config.max_passing_test_case_number)
					l_relaxed_test_case_file_selector.set_max_failing_test_case_number (config.max_failing_test_case_number)
					l_relaxed_test_case_file_selector.use_random_selection (config.is_using_random_test_case_selection)
					l_relaxed_test_case_file_selector.use_state_based_selection (config.is_using_state_based_test_case_selection)
					current_relaxed_passing_test_cases := l_relaxed_test_case_file_selector.selected_tests (True,
							agent (a_target: EPA_FEATURE_WITH_CONTEXT_CLASS; a_match: EPA_TEST_CASE_SIGNATURE): BOOLEAN
								do
									Result := a_target.feature_.feature_name ~ a_match.feature_under_test
											and then a_target.context_class.name ~ a_match.class_under_test
								end (l_failing_feature, ?))
					current_relaxed_failing_test_cases := l_relaxed_test_case_file_selector.selected_tests (False,
							agent (a_target: EPA_FEATURE_WITH_CONTEXT_CLASS; a_match: EPA_TEST_CASE_SIGNATURE): BOOLEAN
								do
									Result := a_target.feature_.feature_name ~ a_match.feature_under_test
											and then a_target.context_class.name ~ a_match.class_under_test
								end (l_failing_feature, ?))
				else
					create current_relaxed_failing_test_cases.make_equal (1)
					create current_relaxed_passing_test_cases.make_equal (1)
				end
			end
		end

	build_project (a_system: SYSTEM_I)
			-- Execute.
		local
			l_relaxed_test_case_file_selector: AFX_TEST_CASE_FILE_SELECTOR
			l_fault_signatures: DS_LINKED_LIST [EPA_TEST_CASE_SIGNATURE]
			l_fault_signautre_cursor: DS_LINKED_LIST_CURSOR [EPA_TEST_CASE_SIGNATURE]
			l_fault_signature, l_relaxed_passing_test_signature: EPA_TEST_CASE_SIGNATURE
			l_failure_from_trace: EPA_EXCEPTION_TRACE_SUMMARY
			l_failing_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_unique_relaxed_passings: DS_HASH_SET [PATH]
			l_nbr_failing_tests_per_fault: INTEGER
			l_system: SYSTEM_I
			l_dir: PROJECT_DIRECTORY
			l_afx_test_case_path: PATH
			l_file: PLAIN_TEXT_FILE
			l_file_path: PATH
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_root_builder: AFX_PROJECT_ROOT_FOR_FIXING_CONTRACTS_BUILDER
			l_tc_dir, l_rtc_dir: DIRECTORY
			l_path_to_relaxed_test_cases: PATH
		do
				-- Build & save the new root class for fixing.
			create l_root_builder
			l_root_builder.build_root (
					paths_to_strings (current_failing_test_cases),
					paths_to_strings (current_passing_test_cases),
					paths_to_strings (current_relaxed_failing_test_cases),
					paths_to_strings (current_relaxed_passing_test_cases))
			l_file_path := path_to_new_root
			create l_file.make_with_path (l_file_path)
			if not l_file.exists then
				a_system.force_rebuild
			end
			l_file.open_write
			if l_file.is_open_write then
				l_file.put_string (l_root_builder.last_class_text)
				l_file.close
			end

			copy_test_case_files (current_passing_test_cases, session.regular_tests_directory)
			copy_test_case_files (current_failing_test_cases, session.regular_tests_directory)
			copy_test_case_files (current_relaxed_passing_test_cases, session.relaxed_tests_directory)
			copy_test_case_files (current_relaxed_failing_test_cases, session.relaxed_tests_directory)

			check new_root_exists end
			if not a_system.is_explicit_root (Afx_project_root_class, Afx_project_root_feature) then
				a_system.add_explicit_root (Void, Afx_project_root_class, Afx_project_root_feature)
			end
			compile_project (Eiffel_project, True)
		end

feature{NONE} -- Implementation

	paths_to_strings (a_paths: DS_ARRAYED_LIST [PATH]): DS_ARRAYED_LIST [STRING]
			--
		do
			create Result.make_equal (10)
			if a_paths /= Void then
				from a_paths.start
				until a_paths.after
				loop
					Result.force_last (a_paths.item_for_iteration.out)
					a_paths.forth
				end
			end
		end

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
