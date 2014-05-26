note
	description: "Summary description for {ES_ADB_TEST_CASE_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_TEST_CASE_REPOSITORY

inherit
	EPA_UTILITY

feature -- Test cases: Access

	test_cases: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE],
						  EPA_FEATURE_WITH_CONTEXT_CLASS]
		do
			Result := test_cases_storage.item
		end

feature -- Test cases: Access

	register_test_case (a_test: ES_ADB_TEST)
			-- Register `a_test' with Current.
		require
			a_test /= Void
		local
			l_path: PATH
			l_sig: EPA_TEST_CASE_SIGNATURE
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_is_passing: BOOLEAN
			l_tests_by_sig: DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE]
			l_tests: DS_HASH_SET [ES_ADB_TEST]
			l_class_name: STRING
		do
			l_path := a_test.location
			l_sig := a_test.test_case_signature

				-- Register test at `test_cases'.
			create l_feature_with_context.make_from_names (l_sig.feature_under_test, l_sig.class_under_test)
			if test_cases.has (l_feature_with_context) then
				l_tests_by_sig := test_cases.item (l_feature_with_context)
			else
				create l_tests_by_sig.make_equal (64)
				test_cases.force (l_tests_by_sig, l_feature_with_context)
			end
			if l_tests_by_sig.has (l_sig) then
				l_tests := l_tests_by_sig.item (l_sig)
			else
				create l_tests.make_equal (512)
				l_tests_by_sig.force (l_tests, l_sig)
			end
			l_tests.force (a_test)

				-- Register timestamps
				-- FIXME: should record timestamps for all classes on the call stack.
			across <<l_sig.class_under_test, l_sig.recipient_class>> as lt_cls_cursor loop
				l_class_name := lt_cls_cursor.item
				register_class_stamp (l_class_name, Void)
			end
		end

	passing_test_cases_for_feature (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): DS_HASH_SET [ES_ADB_TEST]
			-- Set of passing test cases for `a_feature'.
		require
			a_feature /= Void
		local
			l_tests_by_sig: DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE]
			l_sigs: DS_BILINEAR [EPA_TEST_CASE_SIGNATURE]
			l_sig_cursor: DS_BILINEAR_CURSOR [EPA_TEST_CASE_SIGNATURE]
			l_passing_sig: EPA_TEST_CASE_SIGNATURE
		do
			create Result.make_equal (30)
			if test_cases.has (a_feature) then
				l_tests_by_sig := test_cases.item (a_feature)

					-- Passing tests for the feature
				l_sigs := l_tests_by_sig.keys
				from
					l_sig_cursor := l_sigs.new_cursor
					l_sig_cursor.start
				until
					l_sig_cursor.after or else l_passing_sig /= Void
				loop
					if l_sig_cursor.item.is_passing then
						l_passing_sig := l_sig_cursor.item
						Result.append (l_tests_by_sig.item (l_passing_sig))
					end

					l_sig_cursor.forth
				end
			end
		end

	passing_test_case_count_for_feature (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): INTEGER
			-- Number of passing test cases for `a_feature'.
		require
			a_feature /= Void
		local
			l_tests_by_sig: DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE]
			l_sigs: DS_BILINEAR [EPA_TEST_CASE_SIGNATURE]
			l_sig_cursor: DS_BILINEAR_CURSOR [EPA_TEST_CASE_SIGNATURE]
			l_passing_sig: EPA_TEST_CASE_SIGNATURE
		do
			if test_cases.has (a_feature) then
				l_tests_by_sig := test_cases.item (a_feature)
				l_sigs := l_tests_by_sig.keys
				from
					l_sig_cursor := l_sigs.new_cursor
					l_sig_cursor.start
				until
					l_sig_cursor.after or else l_passing_sig /= Void
				loop
					if l_sig_cursor.item.is_passing then
						l_passing_sig := l_sig_cursor.item
						Result := l_tests_by_sig.item (l_passing_sig).count
					end

					l_sig_cursor.forth
				end
			end
		end

	test_cases_for_fault (a_fault: ES_ADB_FAULT): TUPLE [passing, failing: DS_HASH_SET [ES_ADB_TEST]]
			-- Test cases related to `a_fault'.
			-- Both fields of Result are non-void, but `passing' could be empty.
		require
			a_fault /= Void
		local
			l_passings, l_failings: DS_HASH_SET [ES_ADB_TEST]
			l_failing_sig, l_passing_sig: EPA_TEST_CASE_SIGNATURE
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_tests_by_sig: DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE]
			l_sigs: DS_BILINEAR [EPA_TEST_CASE_SIGNATURE]
			l_sig_cursor: DS_BILINEAR_CURSOR [EPA_TEST_CASE_SIGNATURE]
		do
			create l_passings.make_equal (8)
			create l_failings.make_equal (8)
			Result := [l_passings, l_failings]

			l_failing_sig := a_fault.signature
			create l_feature_with_context.make_from_names (l_failing_sig.feature_under_test, l_failing_sig.class_under_test)
			if test_cases.has (l_feature_with_context) then
				l_tests_by_sig := test_cases.item (l_feature_with_context)
				if l_tests_by_sig.has (l_failing_sig) then
					l_failings.append (l_tests_by_sig.item (l_failing_sig))
				end
			end

			l_passings.append (passing_test_cases_for_feature (l_feature_with_context))
		end

	test_case_count_for_fault (a_fault: ES_ADB_FAULT): TUPLE [passing, failing: INTEGER]
			-- Number of test cases related to `a_fault'.
		require
			a_fault /= Void
		local
			l_failing_count, l_passing_count: INTEGER
			l_failing_sig, l_passing_sig: EPA_TEST_CASE_SIGNATURE
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_tests_by_sig: DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE]
			l_sigs: DS_BILINEAR [EPA_TEST_CASE_SIGNATURE]
			l_sig_cursor: DS_BILINEAR_CURSOR [EPA_TEST_CASE_SIGNATURE]
		do
			l_failing_sig := a_fault.signature
			create l_feature_with_context.make_from_names (l_failing_sig.feature_under_test, l_failing_sig.class_under_test)
			if test_cases.has (l_feature_with_context) then
				l_tests_by_sig := test_cases.item (l_feature_with_context)
				if l_tests_by_sig.has (l_failing_sig) then
					l_failing_count := l_tests_by_sig.item (l_failing_sig).count
				end
			end
			l_passing_count := passing_test_case_count_for_feature (l_feature_with_context)

			Result := [l_passing_count, l_failing_count]
		end

feature -- Timestamps: Access

	timestamps: DS_HASH_TABLE [STRING, STRING]
		do
			Result := timestamps_storage.item
		end

	class_timestamps_log_file: PLAIN_TEXT_FILE

feature -- Timestamps: Status report

	is_logging_class_timestamps: BOOLEAN
		do
			Result := class_timestamps_log_file /= Void and then class_timestamps_log_file.is_open_write
		end

feature -- Timestamps: Query

	is_class_changed (a_class_name, a_stamp: STRING): BOOLEAN
			-- Is class with the name
		local
			l_new_stamp, l_old_stamp: STRING
		do
			l_new_stamp := stamp_of_class (a_class_name)
			Result := timestamps.has (a_class_name) and then timestamps.item (a_class_name) /~ l_new_stamp
		end

	stamp_of_class (a_name: STRING): STRING
			-- Stamp of the class with `a_name'.
		do
			check attached first_class_starts_with_name (a_name) as lt_class then
				Result := lt_class.lace_class.file_name.out + "@" + lt_class.lace_class.file_date.out
			end
		end

feature -- Timestamps: Operation

	start_logging_class_timestamps (a_file: PLAIN_TEXT_FILE)
			-- Start logging class timestamps into `a_file'.
		require
			a_file /= Void
		do
			a_file.open_write
			if a_file.is_open_write then
				class_timestamps_log_file := a_file
			else
				class_timestamps_log_file := Void
			end
		end

	register_class_stamp (a_name: STRING; a_stamp: STRING)
			-- Register `a_stamp' as the stamp of the class with `a_name'.
		require
			a_name /= Void
		local
			l_class: CLASS_I
			l_stamp: STRING
		do
			if a_stamp = Void then
				if attached stamp_of_class (a_name) as lt_stamp then
					l_stamp := lt_stamp
				end
			else
				l_stamp := a_stamp.twin
			end

			if attached l_stamp then
				if timestamps.has (a_name) then
					check timestamps.item (a_name) ~ l_stamp end
				else
					timestamps.force (l_stamp, a_name)
				end

				if is_logging_class_timestamps then
					log_class_timestamp (a_name, l_stamp)
				end
			end
		end

	log_class_timestamp (a_name: STRING; a_stamp: STRING)
			-- Log `a_stamp' as the timestamp for class with the name `a_name'.
		do
			if is_logging_class_timestamps then
				class_timestamps_log_file.put_string (a_name + "@" + a_stamp + "%N")
				class_timestamps_log_file.flush
			end
		end

	stop_logging_class_timestamps
			--
		do
			if is_logging_class_timestamps then
				class_timestamps_log_file.close
			end
			class_timestamps_log_file := Void
		end

	load_timestamps (a_path: PATH)
			-- Load timestamps from `a_path'.
			--
			-- Each line is of form "CLASS_NAME@file_path@timestamp".
		require
			a_path /= Void
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_segs: LIST [STRING]
			l_class_name, l_file_path, l_timestamp: STRING
		do
			create l_file.make_with_path (a_path)
			if l_file.exists then
				l_file.open_read
				if l_file.is_open_read then
					from
						l_file.read_line
					until
						l_file.end_of_file
					loop
						l_line := l_file.last_string

						l_segs := l_line.split ('@')
						if l_segs.count = 3 then
							l_class_name := l_segs.i_th (1)
							l_file_path := l_segs.i_th (2)
							l_timestamp := l_segs.i_th (3)

							if attached first_class_starts_with_name (l_class_name) then
								register_class_stamp (l_class_name, l_file_path + "@" + l_timestamp)
							end
						end

						l_file.read_line
					end
				end
			end
		end

feature -- Operation

	reset
		local
			l_storage: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE],
						  EPA_FEATURE_WITH_CONTEXT_CLASS]
		do
			create l_storage.make_equal (100)
			test_cases_storage.put (l_storage)

			timestamps_storage.put (create {DS_HASH_TABLE [STRING, STRING]}.make_equal (256))
		end

feature{NONE} -- Implementation

	test_cases_storage: CELL [DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE],
						  EPA_FEATURE_WITH_CONTEXT_CLASS]
						 ]
		local
			l_storage: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [ES_ADB_TEST], EPA_TEST_CASE_SIGNATURE],
						  EPA_FEATURE_WITH_CONTEXT_CLASS]
		once
			create l_storage.make_equal (100)
			create Result.put (l_storage)
		end

	timestamps_storage: CELL [DS_HASH_TABLE [STRING, STRING]]
		once
			create Result.put (create {DS_HASH_TABLE [STRING, STRING]}.make_equal (256))
		end

note
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
