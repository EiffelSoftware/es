note
	description: "Summary description for {EWB_AUTO_FIX_TEST_CASE_ANALYZE_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AFX_BUILD_TEST_CASE_CMD

inherit
	SHARED_WORKBENCH

	SHARED_EXEC_ENVIRONMENT
	SHARED_EIFFEL_PROJECT
	PROJECT_CONTEXT
	SYSTEM_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	SHARED_BENCH_NAMES

	AFX_SHARED_CLASS_THEORY

	AUT_SHARED_RANDOM

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		require
			analyze_test_case_set: a_config.should_build_test_cases
		do
			config := a_config

			create failing_test_cases.make (5)
			failing_test_cases.compare_objects

			create passing_test_cases.make (5)
			passing_test_cases.compare_objects

			create temp_passing_test_cases.make (200)
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

	find_test_cases
			-- Find all test cases in specified
		local
			l_dir: DIRECTORY
			l_tc_name: STRING
		do
			create l_dir.make_open_read (test_case_folder)
			from
				l_dir.readentry
			until
				l_dir.lastentry = Void
			loop
				l_tc_name := l_dir.lastentry.twin
				if
					not l_tc_name.is_equal (once ".") and then
					not l_tc_name.is_equal (once "..") and then
					l_tc_name.ends_with (once ".e")
				then
					l_tc_name.remove_tail (2)
					on_test_case_found (l_tc_name)
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
				l_list.extend (a_test_case_name)
			else
				random.forth
				l_list.put_i_th (a_test_case_name, random.item \\ max_test_case_number + 1)
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

				-- Rewrite system root class.
			create l_genreator.make (system, config, failing_test_cases, passing_test_cases)
			l_genreator.generate
			create l_file.make_create_read_write  (root_class.file_name)
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
			eiffel_project.quick_melt
			eiffel_project.freeze
			eiffel_project.call_finish_freezing_and_wait (True)
		end

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := system.root_type.associated_class
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
