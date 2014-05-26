note
	description: "Summary description for {ES_ADB_INFO_CENTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_INFO_CENTER

inherit
	ES_ADB_ACTIONS

	ES_ADB_ACTION_PUBLISHER

	ES_ADB_SHARED_CONFIG

	ES_ADB_FAULT_REPOSITORY
		rename reset as reset_fault_repository end

	ES_ADB_TEST_CASE_REPOSITORY
		rename reset as reset_test_case_repository end

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do

		end

feature -- Operation

	reset
			-- Reset the information center.
		do
			reset_test_case_repository
			reset_fault_repository
		end

	load_from_working_directory
			-- Load information from the working directory, as given in `config'.
		local
			l_config: ES_ADB_CONFIG
			l_working_dir: ES_ADB_WORKING_DIRECTORY
			l_testing_result_dir, l_fixing_result_dir: PATH
			l_tests: DS_ARRAYED_LIST [PATH]
			l_fixing_results: DS_ARRAYED_LIST [PATH]
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
			l_timestamps_path: PATH
		do
			reset

			l_config := config
			l_working_dir := l_config.working_directory

				-- Tests
			l_testing_result_dir := l_working_dir.testing_result_dir
			l_tests := files_from_path (l_testing_result_dir,
					agent (a_path: PATH): BOOLEAN do Result := a_path.out.ends_with (".e") end)
			from
				l_cursor := l_tests.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				register_test_case (create {ES_ADB_TEST}.make (l_cursor.item))
				l_cursor.forth
			end

				-- Class timestamps
			l_timestamps_path := l_working_dir.tested_class_timestamps_path
			load_timestamps (l_timestamps_path)

				-- Fixing results
			l_fixing_result_dir := l_working_dir.fixing_result_dir
			l_fixing_results := files_from_path (l_fixing_result_dir,
					agent (a_path: PATH): BOOLEAN do Result := a_path.out.ends_with (".afr") end)
			from
				l_cursor := l_fixing_results.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				load_fixing_result_for_one_fault (l_cursor.item)
				l_cursor.forth
			end
		end

feature -- Status report

	is_in_sync_with_project: BOOLEAN assign set_in_sync_with_project
			-- Is UI in sync with the debugging result.

	set_in_sync_with_project (a_flag: BOOLEAN)
		do
			is_in_sync_with_project := a_flag
		end

feature -- Actions

	on_project_loaded
			-- <Precursor>
		do
			config.load (workbench.eiffel_project)
			load_from_working_directory
			set_in_sync_with_project (True)

			project_load_actions.call (Void)
		end

	on_project_unloaded
			-- <Precursor>
		do
			project_unload_actions.call (Void)

			if config.is_project_loaded then
				config.save
				config.unload

				reset
				set_in_sync_with_project (False)
			end
		end

	on_compile_start
			-- <Precursor>
		do

		end

	on_compile_stop
			-- <Precursor>
		do
		end

	on_debugging_start
			-- <Precursor>
		do
			reset
		end

	on_debugging_stop
			-- <Precursor>
		do
			-- Do nothing.
		end

	on_testing_start
			-- <Precursor>
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_path (config.working_directory.tested_class_timestamps_path)
			start_logging_class_timestamps (l_file)
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		do
			register_test_case (a_test)

			test_case_generated_actions.call (a_test)
		end

	on_testing_stop
			-- <Precursor>
		do
			stop_logging_class_timestamps
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
		do
			l_fault := a_fix.fault
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fixing_stop (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
		local
			l_index: INTEGER
			l_tc_path: PATH
			l_test: ES_ADB_TEST
		do
			output_actions.call (a_line)

			if a_line.starts_with ("%T%T[TC generated]") then
				l_index := a_line.index_of (']', 1)
				create l_tc_path.make_from_string (a_line.substring (l_index + 2, a_line.count))
				create l_test.make (l_tc_path)
				if config.all_classes.has (l_test.test_case_signature.class_under_test_) then
					on_test_case_generated (l_test)
				end
			end
		end

feature{NONE} -- Implementation

	load_fixes_to_fault (a_fault: ES_ADB_FAULT)
			-- Load fixing result for `a_fault'.
		require
			a_fault /= Void
		local
			l_fixing_result_dir: PATH
			l_file: PLAIN_TEXT_FILE
		do
			l_fixing_result_dir := config.working_directory.fixing_result_file_path (a_fault)
			create l_file.make_with_path (l_fixing_result_dir)

				-- Load fixes.

		end

	load_fixing_result_for_one_fault (a_path: PATH)
			-- Load fixes to a fault from `a_path'.
		require
			a_path /= Void
		local
		do

		end

	files_from_path (a_path: PATH; a_filter: PREDICATE[ANY, TUPLE[PATH]]): DS_ARRAYED_LIST [PATH]
			-- Paths of all files from `a_path' that is accepted by `a_filter'.
		local
			l_paths: DS_ARRAYED_LIST [PATH]
			l_path: PATH
			l_dir: DIRECTORY
			l_entry_name: STRING
			l_entry_path: PATH
			l_entry: RAW_FILE
			l_entry_dir: DIRECTORY
		do
			create Result.make_equal (10)
			if a_path /= Void then
				create l_paths.make_equal (10)
				from
					l_paths.force_last (a_path)
				until
					l_paths.is_empty
				loop
					l_path := l_paths.first
					l_paths.remove_first

						-- Collect from `l_dir'.
					create l_dir.make_with_path (l_path)
					l_dir.open_read
					if not l_dir.is_closed then
						from
							l_dir.start
							l_dir.readentry
						until
							l_dir.lastentry = Void
						loop
							l_entry_name := l_dir.lastentry
							if l_entry_name /~ once "." and then l_entry_name /~ once ".." then
								l_entry_path := l_path.extended (l_entry_name)
								create l_entry.make_with_path (l_entry_path)
								check l_entry.exists then
									if l_entry.is_directory then
										l_paths.force_last (l_entry_path)
									else
										if a_filter = Void or else a_filter.item ([l_entry_path]) then
											Result.force_last (l_entry_path)
										end
									end
								end
							end

							l_dir.readentry
						end
					end
				end
			end
		end

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
