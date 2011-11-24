note
	description: "Summary description for {AUT_TEST_CASE_CATEGORIZER_BY_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_CATEGORIZER_BY_FAULT

inherit
	AUT_TEST_CASE_CATEGORIZER
		redefine
			on_deserialization_started,
			on_deserialization_finished
		end

create
	make

feature -- Data event handler

	on_deserialization_started
			-- <Precursor>
		do
			create passing_repository.make_equal (128)
			create failing_repository.make_with_default_equality_testers (128)
		end

	on_test_case_deserialized (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- <Precursor>
		local
			l_summary, l_signature: STRING
			l_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]
			l_builder: AUT_TEST_CASE_TEXT_BUILDER
			l_name, l_text: STRING
			l_categories: DS_ARRAYED_LIST [STRING]
		do
			if not a_data.test_case_text.is_empty then
				l_summary := a_data.class_and_feature_under_test
				l_signature := a_data.exception_signature

				if l_signature /= Void then
					if a_data.is_execution_successful then
						if passing_repository.has (l_summary) then
							l_set := passing_repository.item (l_summary)
						else
							create l_set.make_equal (16)
							passing_repository.force (l_set, l_summary)
						end
						l_set.force (a_data)
					else
						failing_repository.put_value (a_data, l_summary, l_signature)
					end
				end
			end
		end

	on_deserialization_finished
			-- <Precursor>
		local
			l_summary, l_signature: STRING
			l_data: AUT_DESERIALIZED_TEST_CASE
			l_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]
			l_table: like passing_repository
			l_categories: DS_ARRAYED_LIST [STRING]
		do
				-- Log time and UUID of test cases.
			log_uuids_in_order_of_time

				-- Write test cases.
			from failing_repository.start
			until failing_repository.after
			loop
				l_signature := failing_repository.key_for_iteration
				l_table := failing_repository.item_for_iteration

				from l_table.start
				until l_table.after
				loop
					l_summary := l_table.key_for_iteration
					l_set := l_table.item_for_iteration
					check set_not_empty: not l_set.is_empty end

					l_categories := categorize (l_set.first)
					write_test_cases (l_set, l_categories)
					if passing_repository.has (l_summary) and then not passing_repository.item (l_summary).is_empty then
							-- Fault with both passing and failing test cases.
						write_test_cases (passing_repository.item (l_summary), l_categories)
					end

					l_table.forth
				end

				failing_repository.forth
			end
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- <Precursor>
		do
			create Result.make (2)
			Result.force_last (a_data.class_and_feature_under_test)
			Result.force_last (a_data.exception_signature)
		end

feature{NONE} -- Implementation

	write_test_cases (a_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]; a_categories: DS_ARRAYED_LIST [STRING])
			-- Write `a_set' of test cases into `test_case_dir', in `a_categories'.
		do
			from a_set.start
			until a_set.after
			loop
				write_test_case (a_set.item_for_iteration, a_categories)
				a_set.forth
			end
		end

feature{NONE} -- Time-UUID log

	log_uuids_in_order_of_time
			-- Log <time, UUID> pairs into file named `time_uuid_log_file_name'.
			-- Format of the log file is:
			-- time_uuids = [
			--     [time1, uuid1],
			--     [time2, uuid2],
			--     ...
			--     [timen, uuidn],
			--  ]
		local
			l_test_cases: DS_ARRAYED_LIST [AUT_DESERIALIZED_TEST_CASE]
			l_sorter: DS_QUICK_SORTER [AUT_DESERIALIZED_TEST_CASE]
			l_is_before: AGENT_BASED_EQUALITY_TESTER [AUT_DESERIALIZED_TEST_CASE]
			l_log_name: FILE_NAME
			l_log: KL_TEXT_OUTPUT_FILE
			l_tc: AUT_DESERIALIZED_TEST_CASE
		do
				-- Collect all test cases.
			create l_test_cases.make (1000)
			from passing_repository.start
			until passing_repository.after
			loop
				l_test_cases.append_last (passing_repository.item_for_iteration)
				passing_repository.forth
			end
			l_test_cases.append_last (failing_repository.all_values)

			if l_test_cases.count > 0 then
					-- Sort test cases.
				create l_is_before.make (agent is_test_case_before)
				create l_sorter.make (l_is_before)
				l_sorter.sort (l_test_cases)

					-- Write to log.
				create l_log_name.make_from_string (test_case_dir)
				l_log_name.set_file_name (time_uuid_log_file_name)
				create l_log.make (l_log_name)
				l_log.recursive_open_write
				if l_log.is_open_write then
					l_log.put_string ("time_uuid_log = [%N")

					from l_test_cases.start
					until l_test_cases.after
					loop
						l_tc := l_test_cases.item_for_iteration
						l_log.put_string ("%T[" + l_tc.time_str + ", %"" + l_tc.tc_uuid + "%"],%N")
						l_test_cases.forth
					end

					l_log.put_string ("]%N")
					l_log.close
				end
			end

		end

	is_test_case_before (a_tc1, a_tc2: AUT_DESERIALIZED_TEST_CASE): BOOLEAN
			-- Is `a_tc1' before `a_tc2'?
		do
			Result := a_tc1.time < a_tc2.time
		end

	time_uuid_log_file_name: STRING = "time_uuid.py"

feature{NONE} -- Access

	passing_repository: DS_HASH_TABLE [EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE], STRING]
			-- Repository of all passing tests.
			-- Key: summary of tests, in the form of "CLASS_UNDER_TEST.feature_under_test'.
			-- Val: set of deserialized test cases.

	failing_repository: EPA_NESTED_HASH_TABLE [AUT_DESERIALIZED_TEST_CASE, STRING, STRING]
			-- Repository of all failing tests.
			-- 1-Key: exception signatures
			-- 2-key: summary of tests
			-- Value: set of deserialized test cases.

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
