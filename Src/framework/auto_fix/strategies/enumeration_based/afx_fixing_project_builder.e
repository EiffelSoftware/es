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

	AFX_SHARED_CLASS_THEORY

	AFX_SHARED_SESSION

	AUT_SHARED_RANDOM

	SHARED_SERVER

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_FILE_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			create failing_test_cases.make (5)
			failing_test_cases.compare_objects

			create passing_test_cases.make (5)
		end

feature -- Access

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
		end

	max_passing_test_case_number: INTEGER
			-- Maximum number of passing test cases that will be used for fixing.
			-- A value greater than 0 means no more than this number of
			-- 		test cases would be (randomly) selected to build the
			--		fixing project.
			-- A value of 0 means ALL test cases would be used for fixing.
			-- Default: 0
		do
			Result := (number_of_passing_test_case * percentage_of_test_case_use).truncated_to_integer
			if Result = 0 or else (absolute_max_passing_test_case_number /= 0 and then Result > absolute_max_passing_test_case_number) then
				Result := absolute_max_passing_test_case_number
			end
		end

	max_failing_test_case_number: INTEGER
			-- Maximum number of failing test cases that will be used for fixing.
			-- Refer to: `max_passing_test_case_number'.
		do
			Result := (number_of_failing_test_case * percentage_of_test_case_use).truncated_to_integer
			if Result = 0 or else (absolute_max_failing_test_case_number /= 0 and then Result > absolute_max_failing_test_case_number) then
				Result := absolute_max_failing_test_case_number
			end
		end

	percentage_of_test_case_use: REAL assign set_percentage_of_test_case_use
			-- How many percentage of test cases from `test_case_folder'
			-- 		would be used for fixing.

	absolute_max_passing_test_case_number: INTEGER assign set_absolute_max_passing_test_case_number
			-- Maximum number of passing test cases that we use for fixing, in absolute value.

	absolute_max_failing_test_case_number: INTEGER assign set_absolute_max_failing_test_case_number
			-- Maximum number of failing test cases that we use for fixing, in absolute value.

	failing_test_cases: HASH_TABLE [ARRAYED_LIST [STRING], EPA_TEST_CASE_INFO]
			-- Table of failing test cases from `test_case_folder'.
			-- Key: {EPA_TEST_CASE_INFO}.`id' describing a failure senario;
			-- Value: List of test cases revealing the same fault.

	passing_test_cases: ARRAYED_LIST [STRING]
			-- List of passing test cases from `test_case_folder'.

	number_of_passing_test_case: INTEGER
			-- Number of passing test cases.
		require
			passing_test_cases_list_attached: passing_test_cases /= Void
		do
			Result := passing_test_cases.count
		end

	number_of_failing_test_case: INTEGER
			-- Number of failing test cases.
		require
			failing_test_cases_list_attached: failing_test_cases /= Void
		do
			Result := failing_test_cases.count
		end

feature -- Basic operation

	execute
			-- Execute.
		do
			build_project
		end

feature -- Status set

	set_percentage_of_test_case_use (a_percentage: like percentage_of_test_case_use)
			-- Set `percentage_of_test_case_use'.
		require
			percentage_in_range: 0 <= a_percentage and then a_percentage <= 1.0
		do
			percentage_of_test_case_use := a_percentage
		end

	set_absolute_max_passing_test_case_number (a_val: INTEGER)
			-- Set `absolute_max_passing_test_case_number'.
		require
			val_gt_zero: a_val > 0
		do
			absolute_max_passing_test_case_number := a_val
		end

	set_absolute_max_failing_test_case_number (a_val: INTEGER)
			-- Set `absolute_max_failing_test_case_number'.
		require
			val_gt_zero: a_val > 0
		do
			absolute_max_failing_test_case_number := a_val
		end

feature{NONE} -- Implementation

	build_project
			-- Build fixing project with test cases from `test_case_path', and compile the project.
		local
			l_root_builder: AFX_FIXING_PROJECT_ROOT_BUILDER
			l_file: PLAIN_TEXT_FILE
			l_root_class_path: STRING
		do
			l_root_class_path := root_class.group.location.evaluated_path

			collect_all_test_cases

			select_test_cases

			incorporate_relevant_types

			-- Rewrite system root class.
			create l_root_builder.make (system, config, failing_test_cases, passing_test_cases)
			l_root_builder.build
			create l_file.make_create_read_write (root_class.file_name)
			l_file.put_string (l_root_builder.last_class_text)
			l_file.close

			-- Copy failing test case classes into `system'.
			from
				failing_test_cases.start
			until
				failing_test_cases.after
			loop
				failing_test_cases.item_for_iteration.do_all (agent copy_test_case_file (?, config.test_case_path, l_root_class_path))
				failing_test_cases.forth
			end

			-- Copy passing test cases into `system'.
			passing_test_cases.do_all (agent copy_test_case_file (?, config.test_case_path, l_root_class_path))

			-- Recompile current project.
			freeze_and_c_compile
		end

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

	copy_test_case_file (a_test_case_name: STRING; a_source_folder: STRING; a_destination_folder: STRING)
			-- Copy test case named `a_test_case_name' from `a_source_folder' to `a_destination_folder'.
		do
			copy_file (a_test_case_name + once ".e", a_source_folder, a_destination_folder)
		end

feature{NONE} -- Test collection

	collect_all_test_cases
			-- Collect all test cases in `test_case_path'.
			-- Put test cases into `passing_test_cases' and `failing_test_cases'.
		local
			l_dir: DIRECTORY
			l_tc_name: STRING
		do
			create l_dir.make_open_read (test_case_folder)
			from l_dir.readentry
			until l_dir.lastentry = Void
			loop
				l_tc_name := l_dir.lastentry.twin
				if not l_tc_name.is_equal (once ".") and then
						not l_tc_name.is_equal (once "..") and then
						l_tc_name.ends_with (once ".e")
				then
					l_tc_name.remove_tail (2)
					collect_test_case (l_tc_name)
				end
				l_dir.readentry
			end
		end

	collect_test_case (a_name: STRING)
			-- Collect a test case with the name 'a_name'.
		local
			l_tc_info: EPA_TEST_CASE_INFO
			l_list: like passing_test_cases
		do
			create l_tc_info.make_with_string (a_name)

			if l_tc_info.is_failing then
				if failing_test_cases.has (l_tc_info) then
					l_list := failing_test_cases.item (l_tc_info)
				else
					create l_list.make (20)
					failing_test_cases.extend (l_list, l_tc_info)
				end
			else
				l_list := passing_test_cases
			end

			l_list.extend (a_name)
		end

feature{NONE} -- Test case selection

	select_test_cases
			-- Randomly select test cases up to `percentage_of_test_case_use' for fixing.
			-- Update `passing_test_cases' and `failing_test_cases'.
		local
			l_max_passing, l_max_failing: INTEGER
--			l_passings, l_failings:
		do
			l_max_passing := max_passing_test_case_number
			l_max_failing := max_failing_test_case_number


		end

feature{NONE} -- Types from test cases

	types_from_all_test_cases: DS_HASH_SET [STRING]
			-- All variable types mentioned by the test cases in `test_case_folder'.
		local
			l_dir: DIRECTORY
			l_tc_name: STRING
		do
			create Result.make (5)
			Result.set_equality_tester (String_equality_tester)

			create l_dir.make_open_read (test_case_folder)
			from l_dir.readentry
			until l_dir.lastentry = Void
			loop
				l_tc_name := l_dir.lastentry.twin
				if not l_tc_name.is_equal (once ".") and then
						not l_tc_name.is_equal (once "..") and then
						l_tc_name.ends_with (once ".e")
				then
					Result.append (types_from_test_case (l_tc_name))
				end
				l_dir.readentry
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_test_case (a_file: STRING): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test case in 'a_file'.
			-- 'a_file' contains only the name of the test case.
		require
			file_name_not_empty: a_file /= Void and then not a_file.is_empty
		local
			l_tc_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_type: STRING
			l_start_mark, l_end_mark: STRING
			l_start_count, l_end_count: INTEGER
			l_start_pos, l_end_pos: INTEGER
			l_done: BOOLEAN
		do
			-- Construct full path to the test case file.
			create l_tc_path.make_from_string (test_case_folder)
			l_tc_path.set_file_name (a_file)

			-- Get types from the file.
			create l_file.make_open_read (l_tc_path)
			if l_file.is_open_read then
				l_start_mark := once "<variable_declaration>"
				l_start_count := l_start_mark.count
				l_end_mark := once "</variable_declaration>"
				l_end_count := l_end_mark.count

				from l_file.read_line
				until l_file.after or l_done
				loop
					l_line := l_file.last_string.twin
					l_start_pos := l_line.substring_index (l_start_mark, 1)
					l_end_pos := l_line.substring_index (l_end_mark, 1)

					if l_start_pos /= 0 and then l_end_pos /= 0 then
						check variable_declaration_not_empty: l_start_pos + l_start_count < l_end_pos end
						l_line := l_line.substring (l_start_pos + l_start_count, l_end_pos - 1)
						Result := types_from_variable_declaration (l_line)
						l_done := True
					end

					l_file.read_line
				end
				l_file.close
			else
				create Result.make (1)
				Result.set_equality_tester (String_equality_tester)
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_variable_declaration (a_dec: STRING): DS_HASH_SET [STRING]
			-- Types referenced by a variable declaration.
		require
			dec_not_empty: a_dec /= Void and then not a_dec.is_empty
		local
			l_dec: STRING
			l_vars: LIST [STRING]
			l_var, l_type: STRING
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
			create l_reg.make
			l_reg.compile ("v_[0-9]+:(.+)")

			l_dec := a_dec.twin
			l_dec.prune_all_trailing ('$')
			l_dec.prune_all (' ')
			l_vars := l_dec.split ('$')

			create Result.make (l_vars.count)
			Result.set_equality_tester (String_equality_tester)

			from l_vars.start
			until l_vars.after
			loop
				l_var := l_vars.item_for_iteration
				l_reg.match (l_var)
				check l_reg.has_matched end
				Result.force (l_reg.captured_substring (1))

				l_vars.forth
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

feature{NONE} -- Incorporating relevant types

	incorporate_relevant_types
			-- Incorporate types relevant to test cases into the project, and compile it.
		local
			l_types: DS_HASH_SET [STRING]
			l_feature_text: STRING
			l_feature_body: STRING
			l_list: LEAF_AS_LIST
		do
			l_types := types_from_all_test_cases

			l_feature_text := "%Trelevant_types%N%T%Tlocal%N%T%T%Tl_type: TYPE [detachable ANY]%N%T%Tdo%N$(FEAT_BODY)%N%T%Tend%N"
			from
				l_feature_body := ""
				l_types.start
			until
				l_types.after
			loop
				l_feature_body.append ("%T%T%Tl_type := {" + l_types.item_for_iteration + "}%N")
				l_types.forth
			end
			l_feature_text.replace_substring_all ("$(FEAT_BODY)", l_feature_body)

			l_list := match_list_server.item (root_class.class_id)
			if attached {FEATURE_I} root_class.feature_named ("relevant_types") as l_feat then
				l_feat.e_feature.ast.replace_text (l_feature_text, l_list)
			else
				root_class.ast.end_keyword.replace_text (l_feature_text + "%Nend%N", l_list)
			end
			rewrite_class (root_class, root_class.ast.text (l_list))
			freeze_and_c_compile
		end

	rewrite_class (a_class: CLASS_C; a_new_text: STRING)
			-- Rewrite the text of 'a_class' with 'a_new_text'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_class.file_name)
			l_file.put_string (a_new_text)
			l_file.close
		end

	freeze_and_c_compile
			-- Freeze and C compile project.
		do
			eiffel_project.quick_melt (False, False, True)
			eiffel_project.freeze
			eiffel_project.call_finish_freezing_and_wait (True)
		end

feature{NONE} -- Implementation

	max_passing_test_case_number_cache: INTEGER
			-- Internal cache for `max_passing_test_case_number'.

	max_failing_test_case_number_cache: INTEGER
			-- Internal cache for `max_failing_test_case_number'.

end
