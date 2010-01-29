note
	description: "Summary description for {EWB_AUTO_FIX_TEST_CASE_ANALYZE_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_APP_BUILDER

inherit
	SHARED_WORKBENCH

	SHARED_EIFFEL_PROJECT

	AFX_SHARED_CLASS_THEORY

	AUT_SHARED_RANDOM

	SHARED_SERVER

	KL_SHARED_STRING_EQUALITY_TESTER

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		do
			config := a_config

			create failing_test_cases.make (5)
			failing_test_cases.compare_objects

			create passing_test_cases.make (5)
			passing_test_cases.compare_objects

			create temp_passing_test_cases.make (200)

			create failing_states.make (50)
			failing_states.compare_objects

			create passing_states.make (50)
			passing_states.compare_objects
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config for AutoFix ocmmand line	

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
		end

	max_test_case_number: INTEGER
			-- Maximum number of test cases
			-- for each fault
			-- If there are more than this number of test cases
			-- found, a randomly selected subset will be kept.
			-- 0 means no upper bound.
			-- Default: 0
		do
			Result := config.max_test_case_number
		end

	passing_states: HASH_TABLE [NATURAL_8, STRING]
			-- Object states stored in passing test cases
			-- Key is predicate name,
			-- Value is the value of that predicate.
			-- The predicate name is prefixed with the object index. For example,
			-- a predicate `is_empty' in the first object is renamed as "v1_is_empty".

	failing_states: HASH_TABLE [NATURAL_8, STRING]
			-- Object states stored in failing test cases
			-- Key is predicate name,
			-- Value is the value of that predicate.
			-- The predicate name is prefixed with the object index. For example,
			-- a predicate `is_empty' in the first object is renamed as "v1_is_empty".

	found_passing_test_case_count: INTEGER
			-- Number of passing test cases that are found so far

	found_failing_test_case_count: INTEGER
			-- Number of failing test cases that are found so far

feature -- Basic operations

	execute
			-- Execute.
		do
			build_project
		end

feature{NONE} -- Implementation

	failing_test_cases: HASH_TABLE [ARRAYED_LIST [STRING], AFX_TEST_CASE_INFO]
			-- Table of failing test cases in `test_case_folder'
			-- Key is the test case id, value is the list of test cases revealing the same fault.

	passing_test_cases: HASH_TABLE [ARRAYED_LIST [STRING], AFX_TEST_CASE_INFO]
			-- Table of passing test cases in `test_case_folder'
			-- for each failing test cases.
			-- Key is the failing test cases, Value is the list of passing test cases for the same feature.

	temp_passing_test_cases: ARRAYED_LIST [STRING];
			-- List of name of passing test cases in `test_case_folder'.

feature{NONE} -- Implementation

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
		end

	find_test_cases
			-- Find all test cases in specified
		local
			l_dir: DIRECTORY
			l_tc_name: STRING
			l_done: BOOLEAN
			l_max_tc_number: INTEGER
		do
			l_max_tc_number := config.max_test_case_number
			create l_dir.make_open_read (test_case_folder)
			from
				l_dir.readentry
			until
				l_dir.lastentry = Void or l_done
			loop
				l_tc_name := l_dir.lastentry.twin
				if
					not l_tc_name.is_equal (once ".") and then
					not l_tc_name.is_equal (once "..") and then
					l_tc_name.ends_with (once ".e")
				then
					l_tc_name.remove_tail (2)
					on_test_case_found (l_tc_name)
					if l_max_tc_number > 0 then
						l_done := found_passing_test_case_count = l_max_tc_number and then found_failing_test_case_count = l_max_tc_number
					end
				end
				l_dir.readentry
			end

			from
				failing_test_cases.start
			until
				failing_test_cases.after
			loop
				passing_test_cases.put (temp_passing_test_cases.twin, failing_test_cases.key_for_iteration)
				failing_test_cases.forth
			end
		end

	on_test_case_found (a_test_case_name: STRING)
			-- Action to be performed when a test case named `a_test_case_name' is found
		local
			l_tc_info: AFX_TEST_CASE_INFO
			l_list: ARRAYED_LIST [STRING]
		do
			create l_tc_info.make_with_string (a_test_case_name)

			if l_tc_info.is_failing then
				if failing_test_cases.has (l_tc_info) then
					l_list := failing_test_cases.item (l_tc_info)
				else
					create l_list.make (100)
					failing_test_cases.extend (l_list, l_tc_info)
				end
			else
				l_list := temp_passing_test_cases
			end

			if max_test_case_number = 0 or else l_list.count < max_test_case_number then
				if is_test_case_contain_new_state (a_test_case_name, l_tc_info) then
					l_list.extend (a_test_case_name)
					if l_tc_info.is_passing then
						found_passing_test_case_count := found_passing_test_case_count + 1
					else
						found_failing_test_case_count := found_failing_test_case_count + 1
					end
				end
			else
--				random.forth
--				l_list.put_i_th (a_test_case_name, random.item \\ max_test_case_number + 1)
			end
		end

	is_test_case_contain_new_state (a_test_case_name: STRING; a_tc_info: AFX_TEST_CASE_INFO): BOOLEAN
			-- Does test case in `a_test_case_name' contain new states?
			-- Note: This routine will update `passing_states' and `failing_states' when needed.
		local
			l_state: like passing_states
			l_state_extractor: AFX_TEST_CASE_STATE_EXTRACTOR
			l_file_name: FILE_NAME
			l_tc_states: like passing_states
			l_expr: STRING
			l_value: NATURAL_8
			l_found_value: NATURAL_8
		do
			fixme ("Non-pure query. 29.1.2010 Jasonw")
			if a_tc_info.is_passing then
				l_state := passing_states
			else
				l_state := failing_states
			end
			create l_file_name.make_from_string (test_case_folder)
			l_file_name.set_file_name (a_test_case_name)
			create l_state_extractor.make (l_file_name + ".e")
			l_tc_states := l_state_extractor.states
			from
				l_tc_states.start
			until
				l_tc_states.after
			loop
				l_expr := l_tc_states.key_for_iteration
				l_value := l_tc_states.item_for_iteration
				l_state.search (l_expr)
				if l_state.found then
					l_found_value := l_state.found_item
					if l_found_value.bit_or (l_value) /= l_found_value then
						l_state.force (l_found_value.bit_or (l_value), l_expr)
						if not Result then
							Result := True
						end
					end
				else
					if not Result then
						Result := True
					end
					l_state.put (l_value, l_expr)
				end
				l_tc_states.forth
			end
		end

	copy_file (a_test_case_name: STRING; a_source_folder: STRING; a_destination_folder: STRING)
			-- Copy test case named `a_test_case_name' from `a_source_folder' to `a_destination_folder'.
		local
			l_source_path: FILE_NAME
			l_source_file: PLAIN_TEXT_FILE
			l_dest_path: FILE_NAME
			l_dest_file: PLAIN_TEXT_FILE
		do
			create l_source_path.make_from_string (a_source_folder)
			l_source_path.set_file_name (a_test_case_name + ".e")

			create l_dest_path.make_from_string (a_destination_folder)
			l_dest_path.set_file_name (a_test_case_name + ".e")

			create l_source_file.make_open_read (l_source_path)
			create l_dest_file.make_create_read_write (l_dest_path)
			l_source_file.copy_to (l_dest_file)
			l_source_file.close
			l_dest_file.close
		end

	build_project
			-- Build project consisting test cases by copying all test cases specified in
			-- `config'.`test_case_path' into currently loaded project and rewriting the root
			-- class to execute all those test cases.
			-- C compile current porject after copying and rewriting.
		local
			l_genreator: AFX_TEST_CASE_RUNNER_GENERATOR
			l_file: PLAIN_TEXT_FILE
			l_root_class_folder: STRING
		do
			l_root_class_folder := root_class.group.location.evaluated_path
			find_test_cases

				-- Reference classes that are mentioned in failing test cases in the interpreter
				-- project, then compile the project.
			compile_project_with_mentioned_types

				-- Rewrite system root class.
			create l_genreator.make (system, config, failing_test_cases, passing_test_cases)
			l_genreator.generate
			create l_file.make_create_read_write (root_class.file_name)
			l_file.put_string (l_genreator.last_class_text)
			l_file.close

				-- Copy failing test case classes into `system'.
			from
				failing_test_cases.start
			until
				failing_test_cases.after
			loop
				failing_test_cases.item_for_iteration.do_all (agent copy_file (?, config.test_case_path, l_root_class_folder))
				failing_test_cases.forth
			end

				-- Copy passing test cases into `system'.
			temp_passing_test_cases.do_all (agent copy_file (?, config.test_case_path, l_root_class_folder))

				-- Recompile current project.
			freeze_and_c_compile
		end

	freeze_and_c_compile
			-- Freeze and C compile project.
		do
			eiffel_project.quick_melt
			eiffel_project.freeze
			eiffel_project.call_finish_freezing_and_wait (True)
		end

	compile_project_with_mentioned_types
			-- Compile project after adding types that are mentioned in failing test cases.
		local
			l_type_feat: E_FEATURE
			l_tc_info: AFX_TEST_CASE_INFO
			l_list: LEAF_AS_LIST
			l_feat_text: STRING
			l_tc_file: PLAIN_TEXT_FILE
			l_tc_path: FILE_NAME
			l_types: DS_HASH_SET [STRING]
		do
			failing_test_cases.start

				-- Find out types used
			l_tc_info := failing_test_cases.key_for_iteration
			create l_tc_path.make_from_string (config.test_case_path)
			l_tc_path.set_file_name (failing_test_cases.item_for_iteration.first + ".e")

			l_types := types_from_file (l_tc_path)


			l_feat_text := "types_mentioned_in_test_cases local l_type: TYPE [detachable ANY] do%N"
			from
				l_types.start
			until
				l_types.after
			loop
				l_feat_text.append ("%T%T%Tl_type := {" + l_types.item_for_iteration + "}%N")
				l_types.forth
			end
			l_feat_text.append ("end%N")

			l_list := match_list_server.item (root_class.class_id)
			if attached {FEATURE_I} root_class.feature_named ("types_mentioned_in_test_cases") as l_feat then
				l_feat.e_feature.ast.replace_text (l_feat_text, l_list)
			else
				root_class.ast.end_keyword.replace_text (l_feat_text + "%N" + "end%N", l_list)
			end
			rewrite_class (root_class, root_class.ast.text (l_list))
			freeze_and_c_compile
		end

	rewrite_class (a_class: CLASS_C; a_new_text: STRING)
			-- Rewrite the text of `a_class' with `a_new_text' in file.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_class.file_name)
			l_file.put_string (a_new_text)
			l_file.close
		end

	types_from_file (a_file: STRING): DS_HASH_SET [STRING]
			-- Types mentioned in test case in `a_file'.
			-- `a_file' is the full path to a test case file.
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_reg: RX_PCRE_REGULAR_EXPRESSION
			l_type: STRING
		do
			create Result.make (5)
			Result.set_equality_tester (string_equality_tester)
			create l_reg.make
			l_reg.compile ("-- v_[0-9]+.*\[\[(.+)\]\], \[\[(.*)\]\]")

			create l_file.make_open_read (a_file)
			from
				l_file.read_line
			until
				l_file.after
			loop
				l_line := l_file.last_string.twin
				l_reg.match (l_line)
				if l_reg.has_matched then
					Result.force_last (l_reg.captured_substring (1))
				end
				l_file.read_line
			end
			l_file.close
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
