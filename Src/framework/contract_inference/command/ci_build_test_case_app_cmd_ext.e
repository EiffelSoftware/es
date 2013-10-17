note
	description: "Summary description for {CI_BUILD_TEST_CASE_APP_CMD_EXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_BUILD_TEST_CASE_APP_CMD_EXT

inherit
	CI_BUILD_TEST_CASE_APP_CMD
		redefine
			find_test_cases,
			copy_test_cases,
			initialize_test_cases_body,
			root_class_template
		end

create
	make

feature -- Access

	number_passing_tests: INTEGER
			-- Number of passing tests collected for config.feature_name_for_test_cases.first.
		require
			available_test_cases /= Void and then available_test_cases.has (config.feature_name_for_test_cases.first)
		local
			l_feat: STRING
		do
			Result := available_test_cases[config.feature_name_for_test_cases.first].item (test_case_category_passing).count
		end

	number_failing_tests: INTEGER
			-- Number of failing tests collected for config.feature_name_for_test_cases.first.
		require
			available_test_cases /= Void and then available_test_cases.has (config.feature_name_for_test_cases.first)
		local
			l_feat: STRING
		do
			Result := available_test_cases[config.feature_name_for_test_cases.first].item (test_case_category_failing).count
		end

	available_test_cases: HASH_TABLE [HASH_TABLE [ARRAYED_LIST [STRING], STRING], STRING]
			-- Test case file names grouped by whether the test is passing or failing.
			-- Structure: 	feature_name --> [category --> [test_file_name]]
			-- where category is either `test_case_category_passing' or `test_case_category_failing'.
			--
			-- The directory structure should be:
			--		|- class_name
			--		|	|- feature_name
			--		|	|	|- test_case_0
			--		|	|	`- test_case_i
			--		|	`- feature_name

feature{CI_BUILD_TEST_CASE_APP_CMD} -- Implementation

	find_test_cases
			-- <Precursor>
		local
			l_test_case_repository_str, l_test_case_repository_direct_str: STRING
			l_max_tc_count, l_nbr_passing_tc, l_nbr_failing_tc: INTEGER
			l_test_repository_dir, l_class_dir, l_feature_dir: DIRECTORY
			l_class_dir_name, l_feature_dir_name, l_test_case_file_name: FILE_NAME
			l_interesting_feature_names: DS_HASH_SET [STRING]
			l_interesting_feature_names_cursor: DS_HASH_SET_CURSOR [STRING]
			l_feature_name, l_test_case_base_name: STRING
			l_tests_for_feature: HASH_TABLE [ARRAYED_LIST [STRING], STRING]
			l_tests_from_category_passing, l_tests_from_category_failing, l_tests_from_category: ARRAYED_LIST [STRING]
			l_done, l_has_passing, l_has_failing: BOOLEAN
		do
			create available_test_cases.make_equal (20)

			if config.test_case_directory /= Void then
				l_test_case_repository_str := config.test_case_directory

				create l_class_dir_name.make_from_string (l_test_case_repository_str)
				l_class_dir_name.extend (config.class_name)
				create l_class_dir.make_with_name (l_class_dir_name)
				if l_class_dir.exists then
					l_interesting_feature_names := config.feature_name_for_test_cases
					l_interesting_feature_names_cursor := l_interesting_feature_names.new_cursor
					from l_interesting_feature_names_cursor.start
					until l_interesting_feature_names_cursor.after
					loop
						l_feature_name := l_interesting_feature_names_cursor.item

							-- One entry for each interested feature, even those with no test cases.
						check not available_test_cases.has (l_feature_name) end
						create l_tests_for_feature.make_equal (2)
						create l_tests_from_category_passing.make (20)
						create l_tests_from_category_failing.make (20)
						l_tests_for_feature.put (l_tests_from_category_passing, Test_case_category_passing)
						l_tests_for_feature.put (l_tests_from_category_failing, Test_case_category_failing)
						available_test_cases.put (l_tests_for_feature, l_feature_name)

							-- Collect enough test cases for passing/failing category
						create l_feature_dir_name.make_from_string (l_class_dir_name)
						l_feature_dir_name.extend (l_feature_name)
						create l_feature_dir.make_with_name (l_feature_dir_name)
						if l_feature_dir.exists then
							find_test_cases_from_dir (l_feature_dir, l_tests_from_category_passing, l_tests_from_category_failing)
						end

						l_interesting_feature_names_cursor.forth
					end
				end
			elseif config.test_case_directory_direct /= Void then
				l_test_case_repository_direct_str := config.test_case_directory_direct
				create l_test_repository_dir.make_with_name (l_test_case_repository_direct_str)
				if l_test_repository_dir.exists then
					l_feature_name := config.feature_name_for_test_cases.first
					create l_tests_for_feature.make_equal (2)
					create l_tests_from_category_passing.make (20)
					create l_tests_from_category_failing.make (20)
					l_tests_for_feature.put (l_tests_from_category_passing, Test_case_category_passing)
					l_tests_for_feature.put (l_tests_from_category_failing, Test_case_category_failing)
					available_test_cases.put (l_tests_for_feature, l_feature_name)
					find_test_cases_from_dir (l_test_repository_dir, l_tests_from_category_passing, l_tests_from_category_failing)
				end
			end
		end

	find_test_cases_from_dir (a_dir: DIRECTORY; a_passing_tests, a_failing_tests: ARRAYED_LIST [STRING])
			-- Find and collect tests from `a_dir' into `a_passing_tests' and `a_failing_tests'.
		require
			dir_exists: a_dir /= Void and then a_dir.exists
			tests_attached: a_passing_tests /= Void and then a_failing_tests /= Void
		local
			l_max_tc_count: INTEGER
			l_test_case_base_name: STRING
			l_tests: ARRAYED_LIST [STRING]
			l_nbr_passing, l_nbr_failing: INTEGER
			l_is_passing_full, l_is_failing_full: BOOLEAN
		do
			if config.max_test_case_for_building_project > 0 then
				l_max_tc_count := config.max_test_case_for_building_project
			end

			a_dir.open_read
			from a_dir.readentry
			until a_dir.last_entry_8 = Void or else l_is_passing_full and then l_is_failing_full
			loop
				l_test_case_base_name := a_dir.last_entry_8.twin
				if l_test_case_base_name.starts_with ("TC__") and then l_test_case_base_name.ends_with (".e") then
					if l_test_case_base_name.has_substring ("__S__") and then (config.should_include_passing_test_cases_for_building_project or else config.is_fixing_contracts) then
						if l_max_tc_count = 0 or else a_passing_tests.count < l_max_tc_count then
							a_passing_tests.extend (l_test_case_base_name)
							l_nbr_passing := l_nbr_passing + 1
						elseif l_max_tc_count > 0 and then a_passing_tests.count >= l_max_tc_count then
							l_is_passing_full := True
						end
					elseif l_test_case_base_name.has_substring ("__F__") and then (config.should_include_failing_test_cases_for_building_project or else config.is_fixing_contracts) then
						if l_max_tc_count = 0 or else a_failing_tests.count < l_max_tc_count then
							a_failing_tests.extend (l_test_case_base_name)
							l_nbr_failing := l_nbr_failing + 1
						elseif l_max_tc_count > 0 and then a_failing_tests.count >= l_max_tc_count then
							l_is_failing_full := True
						end
					end
				end
				a_dir.readentry
			end
			a_dir.close
		end

	copy_test_cases
			-- <Precursor>
		local
			l_cursor: HASH_TABLE_ITERATION_CURSOR [HASH_TABLE [ARRAYED_LIST [STRING], STRING], STRING]
			l_feature_name, l_test_case_base_file_name: STRING
			l_class_dir_name, l_feature_dir_name, l_test_case_file_name: FILE_NAME
			l_dest_dir_name, l_dest_file_name: FILE_NAME
			l_dest_dir: DIRECTORY
			l_tests_from_category: ARRAYED_LIST [STRING]
			l_test_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
		do
			if config.test_case_directory /= Void then
				create l_class_dir_name.make_from_string (config.test_case_directory)
				l_class_dir_name.extend (config.class_name)

				l_cursor := available_test_cases.new_cursor
				from l_cursor.start
				until l_cursor.after
				loop
					l_feature_name := l_cursor.key

						-- Source dir containing test case files
					create l_feature_dir_name.make_from_string (l_class_dir_name)
					l_feature_dir_name.extend (l_feature_name)

						-- Destination dir inside project
					create l_dest_dir_name.make_from_string (config.project_directory)
					l_dest_dir_name.extend (config.class_name)
					l_dest_dir_name.extend (l_feature_name)
					create l_dest_dir.make (l_dest_dir_name)
					if l_dest_dir.exists then
						l_dest_dir.recursive_delete
					end
					l_dest_dir.recursive_create_dir

					copy_files_between_dirs (l_cursor.item.item (test_case_category_passing), l_feature_dir_name, l_dest_dir_name)
					copy_files_between_dirs (l_cursor.item.item (test_case_category_failing), l_feature_dir_name, l_dest_dir_name)

					l_cursor.forth
				end
			elseif config.test_case_directory_direct /= Void then
				l_feature_name := config.feature_name_for_test_cases.first
				create l_dest_dir_name.make_from_string (config.project_directory)
				l_dest_dir_name.extend (config.class_name)
				l_dest_dir_name.extend (l_feature_name)
				create l_dest_dir.make (l_dest_dir_name)
				if l_dest_dir.exists then
					l_dest_dir.recursive_delete
				end
				l_dest_dir.recursive_create_dir

				copy_files_between_dirs (available_test_cases.item (l_feature_name).item (test_case_category_passing),
						create {FILE_NAME}.make_from_string (config.test_case_directory_direct), l_dest_dir_name)
				copy_files_between_dirs (available_test_cases.item (l_feature_name).item (test_case_category_failing),
						create {FILE_NAME}.make_from_string (config.test_case_directory_direct), l_dest_dir_name)
			end
		end

feature -- Exception trace

	exception_trace: STRING
			-- Exception trace from the failing test case.
		local
			l_class_name, l_feature_name: STRING
			l_failing_tests: ARRAYED_LIST [STRING]
			l_failing_test_base_name: STRING
			l_failing_test_full_path: PATH
			l_failing_test: PLAIN_TEXT_FILE

			l_trace, l_cache, l_line, l_seperator: STRING
			l_trace_started: BOOLEAN
		do
			Result := ""
			if config.is_fixing_contracts then
				l_class_name := config.class_name
				l_feature_name := config.feature_name_for_test_cases.first
				if available_test_cases.has (l_feature_name) and available_test_cases.item (l_feature_name).has (test_case_category_failing) then
					l_failing_tests := available_test_cases.item (l_feature_name).item (test_case_category_failing)
					if not l_failing_tests.is_empty then
						l_failing_test_base_name := l_failing_tests.first
						if config.test_case_directory /= Void then
							create l_failing_test_full_path.make_from_string (config.test_case_directory)
							l_failing_test_full_path := l_failing_test_full_path.extended (l_class_name)
							l_failing_test_full_path := l_failing_test_full_path.extended (l_feature_name)
							l_failing_test_full_path := l_failing_test_full_path.extended (l_failing_test_base_name)
						elseif config.test_case_directory_direct /= Void then
							create l_failing_test_full_path.make_from_string (config.test_case_directory_direct)
							l_failing_test_full_path := l_failing_test_full_path.extended (l_failing_test_base_name)
						end

						create l_failing_test.make_with_path (l_failing_test_full_path)
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
				end
			end
		end

	copy_files_between_dirs (a_files: ARRAYED_LIST [STRING]; a_src_dir_name, a_dest_dir_name: FILE_NAME)
			-- Copy `a_files' from `a_src_dir_name' to `a_dest_dir_name'.
		local
			l_test_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
			l_test_case_base_file_name: STRING
		do
			l_test_cursor := a_files.new_cursor
			from l_test_cursor.start
			until l_test_cursor.after
			loop
				copy_file (l_test_cursor.item, a_src_dir_name, a_dest_dir_name)
				l_test_cursor.forth
			end
		end

	initialize_test_cases_body: STRING
			-- <Precursor>
		local
			l_cursor: HASH_TABLE_ITERATION_CURSOR [HASH_TABLE [ARRAYED_LIST [STRING], STRING], STRING]
			l_feature_name, l_test_case_base_file_name: STRING
			l_tests_from_category: ARRAYED_LIST [STRING]
			l_test_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
		do
			create Result.make (2048)

			from
				l_cursor := available_test_cases.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_feature_name := l_cursor.key

				Result.append ("%N%T%T%Tcreate l_tests_by_category.make_equal (2)%N")
				Result.append ("%T%T%Ttest_cases.put (l_tests_by_category, %"" + l_feature_name + "%")%N")
				across <<test_case_category_passing, test_case_category_failing>> as category loop
					Result.append ("%T%T%Tcreate l_tests.make (100)%N")
					Result.append ("%T%T%Tl_tests_by_category.put (l_tests, %"" + category.item + "%")%N")

					l_tests_from_category := l_cursor.item [category.item]
					l_test_cursor := l_tests_from_category.new_cursor
					from l_test_cursor.start
					until l_test_cursor.after
					loop
						l_test_case_base_file_name := l_test_cursor.item

						Result.append (once "%T%T%Tl_tests.extend (create{")
						Result.append (l_test_case_base_file_name.substring (1, l_test_case_base_file_name.count - 2))
						Result.append (once "})%N")

						l_test_cursor.forth
					end
				end

				l_cursor.forth
			end

		end

feature -- Test case categories for each feature

	Test_case_category_passing: STRING = "passing"

	Test_case_category_failing: STRING = "failing"

feature{CI_BUILD_TEST_CASE_APP_CMD} -- Implementation

	root_class_template: STRING
		do
			Result := "[
class
	${CLASS_NAME}
	
inherit
	ARGUMENTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		local
		do
			category_to_execute := Void
			feature_name := Void
			
			create memory
			create test_cases.make (100)
			test_cases.compare_objects
			initialize_test_cases

			if argument_count = 1 then			-- category
				category_to_execute := argument (1)
			elseif argument_count = 2 then		-- feature_name category
				feature_name := argument (1)
				category_to_execute := argument (2)
			end
			
			check category_to_execute.same_string ("passing") or else category_to_execute.same_string ("failing") end
			check feature_name /= Void implies test_cases.has (feature_name) end
			
			execute_test_cases
		end

feature -- Access

	class_name: STRING = "${CLASS_NAME_UNDER_TEST}"
			-- Class under test
			
	feature_name: STRING
			-- Feature to infer contract for.

	category_to_execute: STRING
			-- Category name of test cases to execute.

	test_cases: HASH_TABLE [HASH_TABLE [ARRAYED_LIST [EQA_SERIALIZED_TEST_SET], STRING], STRING]
			-- Table of test cases
			-- feature_name --> [category --> [test_file_name]]
			-- Where category is either "passing" or "failing".
			
	memory: MEMORY
			-- GC controller

feature -- Basic operations

	execute_test_cases
			-- Execute test cases from `category_to_execute' for `feature_name' in `test_cases'.
			-- If `feature_name' is Void, execute all test cases.
		local
			l_cursor: HASH_TABLE_ITERATION_CURSOR [HASH_TABLE [ARRAYED_LIST [EQA_SERIALIZED_TEST_SET], STRING], STRING]
			l_tests_from_category: ARRAYED_LIST [EQA_SERIALIZED_TEST_SET]
			l_test_cursor: INDEXABLE_ITERATION_CURSOR [EQA_SERIALIZED_TEST_SET]
		do
			l_cursor := test_cases.new_cursor			
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				if feature_name /= Void implies feature_name ~ l_cursor.key then
					l_tests_from_category := l_cursor.item [category_to_execute]
					
					from
						l_test_cursor := l_tests_from_category.new_cursor
						l_test_cursor.start
					until
						l_test_cursor.after
					loop
						execute_test_case (l_test_cursor.item)

						l_test_cursor.forth
					end
				end
				l_cursor.forth
			end
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
			l_tests_by_category: HASH_TABLE [ARRAYED_LIST [EQA_SERIALIZED_TEST_SET], STRING]
			l_tests: ARRAYED_LIST [EQA_SERIALIZED_TEST_SET]
		do			
${INITIALIZE_TEST_CASES_FEATURE_BODY}
		end

end
	]"

	end

end
