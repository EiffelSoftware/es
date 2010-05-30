note
	description: "Command to rewrite current project into one that contains infrastructure to support contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_BUILD_TEST_CASE_APP_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

create
	make

feature{NONE} -- Initialization

	make (a_config: CI_CONFIG)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: CI_CONFIG
			-- Configuration for contract inference

feature -- Basic operations

	execute
			-- Execute current command
		do
			find_test_cases
			copy_test_cases
			update_root_class
		end

feature{NONE} -- Implementation

	test_cases: HASH_TABLE [HASH_TABLE [LINKED_LIST [STRING], STRING], STRING]
			-- Test case location information.
			-- Key of the outer hash table is feature name.
			-- Key of the inner hash table is the directory storing some test cases,
			-- value of the inner hash table is the file names of the test cases stored in that directory.

	find_test_cases
			-- Find test cases, and store them in `test_cases'.
		local
			l_class_dir: DIRECTORY
			l_subdir: DIRECTORY
			l_subdir_name: STRING
			l_file_name: FILE_NAME
			l_feature_name: STRING
			l_sections: LIST [STRING]
			l_test_tbl: HASH_TABLE [LINKED_LIST [STRING], STRING]
			l_tests: LINKED_LIST [STRING]
			l_test_name: STRING
			l_feature_specified: BOOLEAN
		do
			l_feature_specified := attached config.feature_name_for_test_cases
			create test_cases.make (100)
			test_cases.compare_objects

			create l_class_dir.make_open_read (config.test_case_directory)
			from
				l_class_dir.readentry
			until
				l_class_dir.lastentry = Void
			loop
				l_subdir_name := l_class_dir.lastentry.twin
				if not (l_subdir_name ~ once "." or l_subdir_name ~ once "..") then
					l_sections := string_slices (l_subdir_name, once "__")
					if l_sections.count = 2 then
						l_feature_name := l_sections.first
						if l_feature_specified implies l_feature_name ~ config.feature_name_for_test_cases then
							if test_cases.has (l_feature_name) then
								l_test_tbl := test_cases.item (l_feature_name)
							else
								create l_test_tbl.make (200)
								l_test_tbl.compare_objects
								test_cases.put (l_test_tbl, l_feature_name)
							end

								-- Go into feature level sub-directory.
							create l_tests.make

							create l_file_name.make_from_string (l_class_dir.name)
							l_file_name.extend (l_subdir_name)
							create l_subdir.make (l_file_name)
							if l_subdir.exists then
								l_subdir.open_read
								from
									l_subdir.readentry
								until
									l_subdir.lastentry = Void
								loop
									l_test_name := l_subdir.lastentry.twin
									if l_test_name.starts_with (once "TC__") and then l_test_name.ends_with (once ".e") then
											-- Found a test case.
										l_tests.extend (l_test_name)
									end
									l_subdir.readentry
								end
								l_subdir.close
								if not l_tests.is_empty then
									l_test_tbl.put (l_tests, l_subdir_name)
								end
							end
						end
					end
				end
				l_class_dir.readentry
			end
			l_class_dir.close
		end

	copy_test_cases
			-- Copy test cases from locations specified in `test_cases' into Current project.
		local
			l_cursor: CURSOR
			l_dir_name: DIRECTORY_NAME
			l_dir: DIRECTORY
			l_feature_dir_name: STRING
			l_test_tbl: HASH_TABLE [LINKED_LIST [STRING], STRING]
			l_tests: LINKED_LIST [STRING]
			l_test_case_path: FILE_NAME
		do
			l_cursor := test_cases.cursor
			from
				test_cases.start
			until
				test_cases.after
			loop
				create l_dir_name.make_from_string (config.project_directory)
				l_dir_name.extend (test_cases.key_for_iteration)
				create l_dir.make (l_dir_name)

					-- Remove existing directory.
				if l_dir.exists then
					l_dir.recursive_delete
				end
				l_dir.create_dir

					-- Copy over test case files.
				l_test_tbl := test_cases.item_for_iteration
				from
					l_test_tbl.start
				until
					l_test_tbl.after
				loop
					l_feature_dir_name := l_test_tbl.key_for_iteration
					l_tests := l_test_tbl.item_for_iteration
					from
						l_tests.start
					until
						l_tests.after
					loop
						create l_test_case_path.make_from_string (config.test_case_directory)
						l_test_case_path.extend (l_feature_dir_name)
						copy_file (l_tests.item_for_iteration, l_test_case_path, l_dir_name)
						l_tests.forth
					end
					l_test_tbl.forth
				end
				test_cases.forth
			end
			test_cases.go_to (l_cursor)
		end

	update_root_class
			-- Update root class of Current system to take
			-- test cases into consideration.
		local
			l_text: STRING
			l_file: PLAIN_TEXT_FILE
		do
				-- Generate text of the new root class.
			l_text := root_class_template.twin
			l_text.replace_substring_all ("${CLASS_NAME}", config.root_class.name.as_upper)
			l_text.replace_substring_all ("${CLASS_NAME_UNDER_TEST}", config.class_name.as_upper)
			l_text.replace_substring_all ("${INITIALIZE_TEST_CASES_FEATURE_BODY}", initialize_test_cases_body)

				-- Create new root class.
			create l_file.make_create_read_write (config.root_class.file_name)
			l_file.put_string (l_text)
			l_file.close

				-- Recompile project.
			freeze_and_c_compile_project
		end

	freeze_and_c_compile_project
			-- Freeze and C compile current project.
		do
			eiffel_project.quick_melt (False, False, True)
			eiffel_project.freeze
			eiffel_project.call_finish_freezing_and_wait (True)
		end


feature{NONE} -- Root class building

	initialize_test_cases_body: STRING
			-- Body of the `initialize_test_cases' feature in the root class.
		local
			l_feature_name: STRING
			l_tests_tbl: HASH_TABLE [LINKED_LIST [STRING], STRING]
			l_tests: LINKED_LIST [STRING]
		do
			create Result.make (2048)
			from
				test_cases.start
			until
				test_cases.after
			loop
				Result.append ("%T%T%Tcreate l_tests.make (100)%N")
				l_tests_tbl := test_cases.item_for_iteration
				from
					l_tests_tbl.start
				until
					l_tests_tbl.after
				loop
					l_tests := l_tests_tbl.item_for_iteration
					from
						l_tests.start
					until
						l_tests.after
					loop
						Result.append (once "%T%T%Tl_tests.extend (create{")
						Result.append (l_tests.item_for_iteration.substring (1, l_tests.item_for_iteration.count - 2))
						Result.append (once "})%N")
						l_tests.forth
					end
					l_tests_tbl.forth
				end
				l_feature_name := test_cases.key_for_iteration
				Result.append (once "%T%T%Ttest_cases.put (l_tests, %"")
				Result.append (l_feature_name)
				Result.append ("%")%N%N")
				test_cases.forth
			end
		end

feature{NONE} -- Implementation

	root_class_template: STRING = "[
class
	${CLASS_NAME}
	
inherit
	ARGUMENTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create memory
			create test_cases.make (100)
			test_cases.compare_objects
			initialize_test_cases
			if argument_count = 0 then
				execute_test_cases (Void)
			else
				execute_test_cases (argument (1))
			end
		end

feature -- Access

	class_name: STRING = "${CLASS_NAME_UNDER_TEST}"
			-- Class under test

	test_cases: HASH_TABLE [ARRAYED_LIST [EQA_SERIALIZED_TEST_SET], STRING]
			-- Table of test cases
			-- Key is feature name, value is a list of test cases for that feature
			
	memory: MEMORY
			-- GC controller

feature -- Basic operations

	execute_test_cases (a_feature_name: detachable STRING)
			-- Execute test cases for `a_feature_name' in `test_cases'.
			-- If `a_feature_name' is Void, execute all test cases.
		local
			l_cursor: CURSOR
			l_tests: ARRAYED_LIST [EQA_SERIALIZED_TEST_SET]
		do
			l_cursor := test_cases.cursor
			from
				test_cases.start
			until
				test_cases.after
			loop
				if a_feature_name /= Void implies a_feature_name ~ test_cases.key_for_iteration then
					l_tests := test_cases.item_for_iteration
					l_tests.do_all (agent execute_test_case)
				end
				test_cases.forth
			end
			test_cases.go_to (l_cursor)
		end
		
	execute_test_case (a_test_case: EQA_SERIALIZED_TEST_SET)
			-- Execute `a_test_case'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				memory.collection_off
				a_test_case.generated_test_1
				memory.collection_on
			end
		rescue
			l_retried := True
			memory.collection_on
			retry
		end

	initialize_test_cases
			-- Initialize `test_cases'.
		local
			l_tests: ARRAYED_LIST [EQA_SERIALIZED_TEST_SET]
		do
${INITIALIZE_TEST_CASES_FEATURE_BODY}
		end

end
	]"
end
