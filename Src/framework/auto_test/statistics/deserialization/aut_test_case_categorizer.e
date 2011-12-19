note
	description: "Summary description for {AUT_TEST_CASE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_TEST_CASE_CATEGORIZER

inherit

	AUT_DESERIALIZATION_DATA_REGISTER
		undefine
			copy,
			is_equal
		end

	AUT_TEST_CASE_DESERIALIZATION_OBSERVER

	AUT_FILE_SYSTEM_ROUTINES
		rename make as make_routines end

	EPA_UTILITY

	SHARED_TYPES

	ITP_VARIABLE_CONSTANTS

	ERL_G_TYPE_ROUTINES

	EPA_COMPILATION_UTILITY

feature -- Initialization

	make (a_conf: TEST_GENERATOR)
			-- Initialization.
		do
			configuration := a_conf
			create test_case_dir.make_from_string (a_conf.data_output)
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- Categorize `a_data', and return a group of categories where `a_data' fits.
			-- The resultant categories are in increasing order of specificity.
		deferred
		end

feature -- Access

	configuration: TEST_GENERATOR
			-- Configuration.

	error_handler: UT_ERROR_HANDLER
			-- <Precursor>
		do
			result := configuration.error_handler
		end

	test_case_dir: DIRECTORY_NAME
			-- Directory where the test cases would be saved.

	test_case_text_builder: AUT_TEST_CASE_TEXT_BUILDER
			-- Test case text builder.
		once
			create Result
		end

	validator: AUT_TEST_CASE_DESERIALIZABILITY_CHECKER
			-- Test case validator.

feature{NONE} -- Implementation

	write_test_case (a_data: AUT_DESERIALIZED_TEST_CASE; a_categories: DS_ARRAYED_LIST [STRING])
			-- Write the test case for `a_data' to a file.
			-- `a_categories' gives a list of category names, with increasing granularity.
			-- Categories will be mapped to directory names when writing the file.
			-- E.g. ["ARRAY", "extend"] will be mapped to `test_case_dir'/ARRAY/extend.
		require
			non_empty: a_data /= Void and then a_categories /= Void and then not a_categories.is_empty
		local
			l_retried: BOOLEAN
			l_dir_name: FILE_NAME
			l_category: STRING
			l_class_content: STRING
			l_file_name: STRING
			l_dir: DIRECTORY
			l_file: KL_TEXT_OUTPUT_FILE
			l_length: INTEGER
		do
			if not l_retried then
					-- Prepare the directory to save the file.
				create l_dir_name.make_from_string (test_case_dir)
				a_categories.do_all (agent l_dir_name.set_subdirectory)
				recursive_create_directory (l_dir_name.string)

				l_dir_name.set_file_name (a_data.test_case_class_name)
				l_dir_name.add_extension ("e")
				create l_file.make (l_dir_name)
				l_file.recursive_open_write
				if l_file.is_open_write then
					l_file.put_string (a_data.test_case_text)
					l_file.close
				end
			end
		rescue
			if l_file /= Void and then l_file.is_open_write then
					-- Delete incomplete class file.
				l_file.close
				l_file.delete
			end

			l_retried := True
			retry
		end

	all_unique_test_cases: DS_ARRAYED_LIST [AUT_DESERIALIZED_TEST_CASE]
			-- All unique test cases from the deserialization.
		deferred
		ensure
			result_attached: Result /= Void
		end

	write_test_case_list_to_time_uuid_log (a_list: DS_ARRAYED_LIST [AUT_DESERIALIZED_TEST_CASE])
			-- Write <time,uuid> pairs, in increasing order of time, into 'test_case_dir'/'time_uuid_log_file_name'.
			-- The argument list may be reordered.
			-- Format of the log file is:
			--     time1:uuid1
			--     time2:uuid2
			--     ...
			--     timen:uuidn
		local
			l_sorter: DS_QUICK_SORTER [AUT_DESERIALIZED_TEST_CASE]
			l_is_before: AGENT_BASED_EQUALITY_TESTER [AUT_DESERIALIZED_TEST_CASE]
			l_log_name: FILE_NAME
			l_log: KL_TEXT_OUTPUT_FILE
			l_tc: AUT_DESERIALIZED_TEST_CASE
		do
				-- Sort test cases.
			create l_is_before.make (agent is_test_case_before)
			create l_sorter.make (l_is_before)
			l_sorter.sort (a_list)

				-- Write to log.
			create l_log_name.make_from_string (test_case_dir)
			l_log_name.set_file_name (time_uuid_log_file_name)
			create l_log.make (l_log_name)
			l_log.recursive_open_write
			if l_log.is_open_write then
				from a_list.start
				until a_list.after
				loop
					l_tc := a_list.item_for_iteration
					l_log.put_string ("" + l_tc.time_str + ":" + l_tc.tc_uuid + "%N")
					a_list.forth
				end

				l_log.close
			end
		end

	is_test_case_before (a_tc1, a_tc2: AUT_DESERIALIZED_TEST_CASE): BOOLEAN
			-- Is `a_tc1' before `a_tc2'?
		do
			Result := a_tc1.time < a_tc2.time
		end

	time_uuid_log_file_name: STRING = "time_uuid.log"


note
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
