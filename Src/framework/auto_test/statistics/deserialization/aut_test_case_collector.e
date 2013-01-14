note
	description: "Summary description for {AUT_TEST_CASE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_COLLECTOR

inherit
	EPA_FILE_UTILITY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
			create test_case_sources.make
			create passing_test_cases.make_equal (20)
			create failing_test_cases.make_equal (20)
		end

feature -- Access

	is_recursive: BOOLEAN
			-- Should test cases from subdirectories also be collected?

	passing_test_cases: DS_HASH_TABLE [DS_ARRAYED_LIST[PATH], EPA_TEST_CASE_SIGNATURE]
			-- All passing test cases from `test_case_dir'.
			-- Key: Test case signautre
			-- Val: List of paths to the passing test cases, relative to `test_case_dir'.

	failing_test_cases: DS_HASH_TABLE [DS_ARRAYED_LIST[PATH], EPA_TEST_CASE_SIGNATURE]
			-- All failing test cases from `test_case_dir'.
			-- Key: Test case signautre
			-- Val: List of paths to the failing test cases, relative to `test_case_dir'.

	passing_test_cases_by_feature_under_test: DS_HASH_TABLE [DS_ARRAYED_LIST[PATH], STRING]
			-- All passing test cases from `test_case_dir', organized by feature under test.
			-- Key: feature under test, e.g. "ARRAY.put"
			-- Val: List of paths to the passing test cases, relative to `test_case_dir'.
		require
			passing_test_cases_attached: passing_test_cases /= Void
		local
			l_table: like passing_test_cases_by_feature_under_test
		do
			if passing_test_cases_by_feature_under_test_cache = Void then
				create l_table.make_equal (passing_test_cases.count)
				from passing_test_cases.start
				until passing_test_cases.after
				loop
					l_table.force (passing_test_cases.item_for_iteration, passing_test_cases.key_for_iteration.class_and_feature_under_test)
					passing_test_cases.forth
				end
				passing_test_cases_by_feature_under_test_cache := l_table
			end
			Result := passing_test_cases_by_feature_under_test_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	collect (a_path: PATH; a_recursive: BOOLEAN)
			-- Collect test cases from `a_path', recursively or not.
			-- The results are available in `passing_test_cases' and `failing_test_cases'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			test_case_sources.wipe_out
			test_case_sources.extend (a_path)

			is_recursive := a_recursive

			internal_collect
		end

	collect_all (a_paths: LINKED_LIST [PATH]; a_recursive: BOOLEAN)
			-- Collect test cases from `a_paths', recursively or not.
			-- The results are available in `passing_test_cases' and `failing_test_cases'.
		require
			paths_not_empty: a_paths /= Void and then not a_paths.is_empty
		do
			test_case_sources.wipe_out
			test_case_sources.append (a_paths)

			is_recursive := a_recursive

			internal_collect
		end

feature{NONE} -- Implementation

	internal_collect
			-- Collect all test cases from `test_case_dir'.
		require
			test_case_sources_not_empty: not test_case_sources.is_empty
		local
			l_entry_name: STRING
			l_source_item, l_entry_path: PATH
			l_source, l_entry: RAW_FILE
			l_dir: DIRECTORY
		do
			create passing_test_cases.make_equal (20)
			create failing_test_cases.make_equal (20)

			from test_case_sources.start
			until test_case_sources.after
			loop
				test_case_sources.start
				l_source_item := test_case_sources.item

				create l_source.make_with_path (l_source_item)
				if l_source.exists then
					if l_source.is_directory and then is_recursive then
						create l_dir.make_with_path (l_source_item)
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
									l_entry_path := l_source_item.extended (l_entry_name)
									create l_entry.make_with_path (l_entry_path)
									check l_entry.exists then
										if l_entry.is_directory and then is_recursive then
											test_case_sources.extend (l_entry_path)
										elseif l_entry_name.ends_with (".e") then
											collect_test_case (l_entry_path)
										end
									end
								end
								l_dir.readentry
							end
						end
					elseif l_source_item.extension.same_string (".e") then
						collect_test_case (l_source_item)
					end
				end

				test_case_sources.remove
			end
		end

	collect_test_case (a_path: PATH)
			-- Collect a test case at `a_path'.
			-- Put the information into `passing_test_cases' or `failing_test_cases'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			valid_relative_path: True
		local
			l_base_name: STRING
			l_signature: EPA_TEST_CASE_SIGNATURE
			l_test_cases: DS_HASH_TABLE [DS_ARRAYED_LIST[PATH], EPA_TEST_CASE_SIGNATURE]
			l_list: DS_ARRAYED_LIST[PATH]
		do
			l_base_name := base_eiffel_file_name_from_full_path (a_path.out)
			create l_signature.make_with_string (l_base_name)
			if l_signature.is_passing then
				l_test_cases := passing_test_cases
			else
				l_test_cases := failing_test_cases
			end

			if l_test_cases.has (l_signature) then
				l_list := l_test_cases.item (l_signature)
			else
				create l_list.make (16)
				l_test_cases.force (l_list, l_signature)
			end
			l_list.force_last (a_path)
		end

feature{NONE} -- Access

	test_case_sources: LINKED_LIST [PATH]
			-- List of sources from where the test cases would be collected.

	passing_test_cases_by_feature_under_test_cache: like passing_test_cases_by_feature_under_test
			-- Cache for `passing_test_cases_by_feature_under_test'.


;note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
