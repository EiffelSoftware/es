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

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
		end

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
		do
			build_project
		end

feature{NONE} -- Implementation

	build_project
			-- Build fixing project with test cases from `test_case_folder', and compile the project.
		local
			l_test_case_file_selector: AFX_TEST_CASE_FILE_SELECTOR
			l_root_builder: AFX_FIXING_PROJECT_ROOT_BUILDER
			l_file: PLAIN_TEXT_FILE
			l_root_class_path: STRING
		do
				-- Collect passing and failing test cases to construct the fixing project.
			create l_test_case_file_selector.make
			l_test_case_file_selector.collect_all_test_case_files
			l_test_case_file_selector.start_with_first_fault
			check l_test_case_file_selector.has_more_fault_signature end
			current_fault_signature := l_test_case_file_selector.fault_signature
			current_passing_test_cases := l_test_case_file_selector.passing_test_case_files
			current_failing_test_cases := l_test_case_file_selector.failing_test_case_files

			incorporate_relevant_types

				-- Rewrite system root class.
			create l_root_builder.make_with_test_cases (system, current_failing_test_cases, current_passing_test_cases, current_fault_signature)
			l_root_builder.build
			create l_file.make_create_read_write (root_class.file_name)
			l_file.put_string (l_root_builder.last_class_text)
			l_file.close

				-- Copy test case files, both passing and failing, into `system'.
			current_passing_test_cases.do_all (agent copy_test_case_file (?, test_case_folder, project_file_folder))
			current_failing_test_cases.do_all (agent copy_test_case_file (?, test_case_folder, project_file_folder))

				-- Recompile current project.
			compile_project (eiffel_project, True)
		end

	incorporate_relevant_types
			-- Incorporate types relevant to test cases into the project, and compile it.
		local
			l_types: DS_HASH_SET [STRING]
			l_feature_text: STRING
			l_feature_body: STRING
			l_list: LEAF_AS_LIST
		do
			l_types := types_from_test_case_list (current_passing_test_cases)
			l_types := l_types.union (types_from_test_case_list (current_failing_test_cases))

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

			compile_project (eiffel_project, True)
		end

	types_from_test_case_list (a_test_case_files: DS_ARRAYED_LIST [STRING]): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test cases in `a_test_case_files'.
		require
			test_case_files_attached: a_test_case_files /= Void
		local
			l_test_case_folder_path, l_test_case_file_path: FILE_NAME
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_dir: DIRECTORY
			l_file_name: STRING
		do
			create Result.make_equal (5)

			create l_test_case_folder_path.make_from_string (test_case_folder)
			from
				l_cursor := a_test_case_files.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_file_name := l_cursor.item

					-- Prepare absolute file path.
				create l_test_case_file_path.make_from_string (l_test_case_folder_path)
				l_test_case_file_path.set_file_name (l_file_name)
				l_test_case_file_path.add_extension ("e")

				Result.append (types_from_test_case (l_test_case_file_path))

				l_cursor.forth
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_test_case (a_file: STRING): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test case in `a_file'.
			-- `a_file' is the full path to the test case.
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
			-- Get types from the file.
			create l_file.make_open_read (a_file)
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
						if l_start_pos + l_start_count < l_end_pos then
							l_line := l_line.substring (l_start_pos + l_start_count, l_end_pos - 1)
							Result := types_from_variable_declaration (l_line)
						else
							create Result.make (1)
						end
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

feature{NONE} -- Auxiliary utility

	copy_test_case_file (a_test_case_name: STRING; a_source_folder: STRING; a_destination_folder: STRING)
			-- Copy test case named `a_test_case_name' from `a_source_folder' to `a_destination_folder'.
		do
			copy_file (a_test_case_name + once ".e", a_source_folder, a_destination_folder)
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

--	freeze_and_c_compile
--			-- Freeze and C compile project.
--		do
--			eiffel_project.quick_melt (True, True, True)
--			eiffel_project.freeze
--			eiffel_project.call_finish_freezing_and_wait (True)
--		end

end
