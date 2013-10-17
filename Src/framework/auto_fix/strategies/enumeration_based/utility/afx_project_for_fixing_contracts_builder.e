note
	description: "Summary description for {AFX_PROJECT_FOR_FIXING_CONTRACTS_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROJECT_FOR_FIXING_CONTRACTS_BUILDER

inherit
	SHARED_WORKBENCH

	SHARED_EIFFEL_PROJECT

	SHARED_EXECUTION_ENVIRONMENT

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

create
	default_create

feature -- Access

--	current_fault_signature: EPA_TEST_CASE_SIGNATURE
--			-- Signature of the fault under fix.


	current_failing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of passing test case files for fixing.

	current_relaxed_passing_test_cases: DS_ARRAYED_LIST [STRING]
	current_relaxed_failing_test_cases: DS_ARRAYED_LIST [STRING]

feature {NONE} -- Access

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
		end

	test_case_file_list: STRING
		do
			Result := config.test_case_file_list
		end

	relaxed_test_case_folder: STRING
		do
			Result := config.relaxed_test_case_path
		end

	relaxed_test_case_file_list: STRING
		do
			Result := config.relaxed_test_case_file_list
		end

	project_file_folder: STRING_8
			-- Folder storing project files.
		do
			Result := root_class.group.location.evaluated_path.out
		end

	root_class: CLASS_C
			-- Root class in System.
		do
			Result := System.root_type.associated_class
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
			l_root_builder: AFX_PROJECT_ROOT_FOR_FIXING_CONTRACTS_BUILDER
			l_tc_dir, l_rtc_dir: DIRECTORY
		do
			prepare_test_cases
--			analyse_exception_signature
			prepare_relaxed_test_cases

				-- Build root class.
			l_system := System
			check
				l_system /= Void
			end
			create l_root_builder.make_with_test_cases (l_system, current_failing_test_cases, current_passing_test_cases, current_relaxed_failing_test_cases, current_relaxed_passing_test_cases)
			l_root_builder.build
			l_afx_test_case_path := l_system.Project_location.location
			l_file_path := l_afx_test_case_path.extended (Afx_project_root_class.as_lower + ".e")
			create l_file.make_with_path (l_file_path)
			if not l_file.exists then
				l_system.force_rebuild
			end
			l_file.open_write
			if l_file.is_open_write then
				l_file.put_string (l_root_builder.last_class_text)
				l_file.close
			end

				-- Prepare directories for the test cases.
			create l_tc_dir.make_with_path (l_afx_test_case_path.extended ("tc"))
			if l_tc_dir.exists then
				l_tc_dir.recursive_delete
			end
			create l_tc_dir.make_with_path (l_afx_test_case_path.extended ("tc"))
			l_tc_dir.recursive_create_dir

			create l_rtc_dir.make_with_path (l_afx_test_case_path.extended ("rtc"))
			if l_rtc_dir.exists then
				l_rtc_dir.recursive_delete
			end
			create l_rtc_dir.make_with_path (l_afx_test_case_path.extended ("rtc"))
			l_rtc_dir.recursive_create_dir
--			execution_environment.sleep((10^9).truncated_to_integer_64 * 3)
--			wait_till_directory_is_ready (l_rtc_dir)

			copy_test_case_files (current_passing_test_cases, False, l_afx_test_case_path)
			copy_test_case_files (current_failing_test_cases, False, l_afx_test_case_path)
			copy_test_case_files (current_relaxed_passing_test_cases, True, l_afx_test_case_path)
			copy_test_case_files (current_relaxed_failing_test_cases, True, l_afx_test_case_path)
		end

	wait_till_directory_is_ready (a_dir: DIRECTORY)
		local
			l_maximum_retries, l_retried_times: INTEGER
			l_exception: DEVELOPER_EXCEPTION
		do
			from
				l_retried_times := 0
				l_maximum_retries := 3
			until
				l_retried_times >= l_maximum_retries
			loop
				execution_environment.sleep((10^9).truncated_to_integer_64 * 3)
				if a_dir.exists then
					l_retried_times := l_maximum_retries
				else
					l_retried_times := l_retried_times + 1
				end
			end
			if not a_dir.exists then
				create l_exception
				l_exception.set_description ("Failed to create directory: " + a_dir.path.out)
				l_exception.raise
			end
		end

	prepare_test_cases
		local
			l_all_test_cases: like all_test_cases_from_location
		do
			l_all_test_cases := all_test_cases_from_location (test_case_folder)
			current_passing_test_cases := select_test_cases_to_use (l_all_test_cases.passings, config.max_passing_test_case_number)
			current_failing_test_cases := select_test_cases_to_use (l_all_test_cases.failings, config.max_failing_test_case_number)
		end

	analyse_exception_signature
		local
			l_failing_file_name: STRING
			l_failing_path: PATH
			l_exception_trace: STRING
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
			l_exception_code: INTEGER_32
			l_exception_signature: AFX_EXCEPTION_SIGNATURE
		do
				-- COllect exception trace
			l_failing_file_name := current_failing_test_cases.first
			create l_failing_path.make_from_string (test_case_folder)
			l_failing_path := l_failing_path.extended (l_failing_file_name)
			l_exception_trace := exception_trace_from_failing_test_case (l_failing_path)
			if l_exception_trace /= Void and then not l_exception_trace.is_empty then
				create l_explainer
				l_explainer.explain (l_exception_trace)
				if l_explainer.was_successful then
					l_summary := l_explainer.last_explanation
					l_exception_code := l_summary.exception_code
					if l_exception_code = {EXCEP_CONST}.void_call_target then
						create {AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE} l_exception_signature.make (l_summary.failing_assertion_tag, l_summary.failing_context_class, l_summary.failing_feature, l_summary.failing_position_breakpoint_index, 1)
					elseif l_exception_code = {EXCEP_CONST}.precondition then
						create {AFX_PRECONDITION_VIOLATION_SIGNATURE} l_exception_signature.make (l_summary.failing_context_class, l_summary.failing_feature, l_summary.failing_position_breakpoint_index, l_summary.recipient_context_class, l_summary.recipient_feature, l_summary.recipient_breakpoint_index, 1)
					elseif l_exception_code = {EXCEP_CONST}.postcondition then
						create {AFX_POSTCONDITION_VIOLATION_SIGNATURE} l_exception_signature.make (l_summary.failing_context_class, l_summary.failing_feature, l_summary.failing_position_breakpoint_index)
					elseif l_exception_code = {EXCEP_CONST}.class_invariant then
						create {AFX_INVARIANT_VIOLATION_SIGNATURE} l_exception_signature.make (l_summary.failing_assertion_tag, l_summary.recipient_context_class, l_summary.recipient_feature)
					elseif l_exception_code = {EXCEP_CONST}.check_instruction then
						create {AFX_CHECK_VIOLATION_SIGNATURE} l_exception_signature.make (l_summary.failing_context_class, l_summary.failing_feature, l_summary.failing_position_breakpoint_index)
					end
					session.set_exception_signature (l_exception_signature)
				end
			end
		end

	prepare_relaxed_test_cases
		local
			l_all_test_cases: like all_test_cases_from_location
			l_failing_tests: DS_ARRAYED_LIST [STRING]
			l_failing_categories: DS_HASH_TABLE[DS_ARRAYED_LIST[STRING], STRING]
			l_maximum, l_average: INTEGER
			l_failing_test_name, l_temp, l_signature: STRING
			l_parts: LIST[STRING]
		do
			l_all_test_cases := all_test_cases_from_location (relaxed_test_case_folder)
			current_relaxed_passing_test_cases := select_test_cases_to_use (l_all_test_cases.passings, config.max_relaxed_passing_test_case_number)

			l_failing_tests := l_all_test_cases.failings
			if  config.max_relaxed_failing_test_case_number = 0 or else config.max_relaxed_failing_test_case_number >= l_failing_tests.count  then
				current_relaxed_failing_test_cases := select_test_cases_to_use (l_failing_tests, 0)
			else
					-- Put failing test cases into categories
				from
					create l_failing_categories.make_equal (20)
					l_failing_tests.start
				until
					l_failing_tests.after
				loop
					l_failing_test_name := l_failing_tests.item_for_iteration
					l_temp := l_failing_test_name.twin
					l_temp.replace_substring_all ("__", "#")
					l_parts := l_temp.split ('#')
					l_signature := l_parts[2] + "#" + l_parts[3] + "#" + l_parts[6] + "#" + l_parts[7] + "#" + l_parts[8] + "#" + l_parts[9]
					if not l_failing_categories.has (l_signature) then
						l_failing_categories.force_last (create {DS_ARRAYED_LIST [STRING]}.make (50), l_signature)
					end
					l_failing_categories.item (l_signature).force_last (l_failing_test_name)

					l_failing_tests.forth
				end
					-- Select test cases from each category
				l_maximum := config.max_relaxed_failing_test_case_number
				check l_failing_categories.count > 0 end
				l_average := l_maximum // l_failing_categories.count
				create current_relaxed_failing_test_cases.make (l_maximum + 1)
				from l_failing_categories.start
				until l_failing_categories.after
				loop
					current_relaxed_failing_test_cases.append_last (select_test_cases_to_use (l_failing_categories.item_for_iteration, l_average))
					l_failing_categories.forth
				end
			end
		end

	exception_trace_from_failing_test_case (a_path: PATH): STRING
		local
			l_failing_test: PLAIN_TEXT_FILE
			l_trace, l_cache, l_line, l_seperator: STRING_8
			l_trace_started: BOOLEAN
		do
			Result := ""
			create l_failing_test.make_with_path (a_path)
			l_failing_test.open_read
			if l_failing_test.is_open_read then
				from
					l_cache := ""
					l_seperator := "-------------------------------------------------------------------------------"
					l_failing_test.read_line
				until
					l_failing_test.end_of_file
				loop
					l_line := l_failing_test.last_string
					if l_line.same_string_general (l_seperator) then
						if not l_trace_started then
							l_trace_started := True
							Result.append_string (l_line + "%N")
						else
							Result.append_string (l_cache)
							Result.append_string (l_line + "%N")
							l_cache := ""
						end
					elseif l_trace_started then
						l_cache.append (l_line + "%N")
					end
					l_failing_test.read_line
				end
				l_failing_test.close
			end
		end

	select_test_cases_to_use (a_test_cases: DS_ARRAYED_LIST[STRING]; a_maximum_number: INTEGER): like current_passing_test_cases
		local
			l_maximum: INTEGER
		do
			if a_maximum_number > 0 then
				l_maximum := a_maximum_number
			else
				l_maximum := a_test_cases.count
			end
			create Result.make (l_maximum + 1)
			from a_test_cases.start
			until a_test_cases.after or else Result.count >= l_maximum
			loop
				Result.force_last (a_test_cases.item_for_iteration)
				a_test_cases.forth
			end
		end

	all_test_cases_from_location (a_location: STRING): TUPLE [passings, failings: DS_ARRAYED_LIST[STRING]]
		local
			l_passings, l_failings: DS_ARRAYED_LIST[STRING]
			l_dir: DIRECTORY
			l_file_name: STRING
			l_dir_path, l_file_path: PATH
		do
			create l_passings.make (100)
			create l_failings.make (100)
			Result := [l_passings, l_failings]

			create l_dir.make (a_location)
			if l_dir.exists then
				create l_dir_path.make_from_string (a_location)
				l_dir.open_read
				if not l_dir.is_closed then
					from
						l_dir.start
						l_dir.readentry
					until
						l_dir.lastentry = Void
					loop
						l_file_name := l_dir.lastentry
						if l_file_name /~ "." and then l_file_name /~ ".." then
							if l_file_name.has_substring ("__F__") then
								l_failings.force_last (l_file_name)
							elseif l_file_name.has_substring ("__S__") then
								l_passings.force_last (l_file_name)
							end
						end
						l_dir.readentry
					end
				end
			end
		end

feature {NONE} -- Implementation

	copy_test_case_files (a_class_file_names: DS_ARRAYED_LIST [STRING]; a_is_relaxed: BOOLEAN; a_dest_dir: PATH)
			-- Copy test cases, with names in `a_class_file_names' to `a_dest_dir'.
			-- Existing files in `a_dest_file' with the same names will be overwritten.
		require
			class_file_paths_attached: a_class_file_names /= Void
			dirs_not_empty: a_dest_dir /= Void and then not a_dest_dir.is_empty
		local
			l_dir_path, l_src_file_path, l_dest_dir_path, l_dest_file_path: PATH
			l_utilities: FILE_UTILITIES
			l_file_name: STRING
			l_dir: DIRECTORY
		do
			if a_is_relaxed then
				create l_dir_path.make_from_string (config.relaxed_test_case_path)
				l_dest_dir_path := a_dest_dir.extended ("rtc")
			else
				create l_dir_path.make_from_string (config.test_case_path)
				l_dest_dir_path := a_dest_dir.extended ("tc")
			end

			from
				a_class_file_names.start
			until
				a_class_file_names.after
			loop
				l_file_name := a_class_file_names.item_for_iteration
				l_src_file_path := l_dir_path.extended (l_file_name)
				l_dest_file_path := l_dest_dir_path.extended (l_file_name)
				l_utilities.copy_file_path (l_src_file_path, l_dest_file_path)
				a_class_file_names.forth
			end
		end

end
