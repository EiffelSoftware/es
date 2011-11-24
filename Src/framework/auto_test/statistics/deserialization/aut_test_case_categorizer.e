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
			error_handler := a_conf.error_handler
			create test_case_dir.make_from_string (a_conf.data_output)
--			create validator.make (test_case_dir)
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- Categorize `a_data', and return a group of categories where `a_data' fits.
			-- The resultant categories are in increasing order of specificity.
		deferred
		end

feature -- Access

	error_handler: UT_ERROR_HANDLER
			-- <Precursor>

	test_case_dir: DIRECTORY_NAME
			-- Directory where the test cases would be saved.

	test_case_text_builder: AUT_TEST_CASE_TEXT_BUILDER
			-- Test case text builder.
		once
			create Result
		end

	validator: AUT_TEST_CASE_DESERIALIZABILITY_CHECKER
			-- Test case validator.

--feature -- Validation

--	validation_log_file_name: STRING = "validation.log"
--			-- Name of the file where the time stamp, UUID, and the validation state of all test cases are logged.

--	validation_log_file_full_path: FILE_NAME
--			-- Full path of the validation log file.
--		do
--			if validation_log_file_full_path_cache = Void then
--				create validation_log_file_full_path_cache.make_from_string (test_case_dir)
--				validation_log_file_full_path_cache.set_file_name (validation_log_file_name)
--			end
--			Result := validation_log_file_full_path_cache
--		end

--	validation_log_file_full_path_cache: FILE_NAME
--			-- Cache for `validation_log_file_full_path'.

--feature -- Redefinition

--	on_deserialization_started
--			-- <Precursor>
--		do
--			validator.start_checking
--		end

--	on_deserialization_finished
--			-- <Precursor>
--		do
--			validator.finish_checking
--		end

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

--feature{AUT_TEST_CASE_CATEGORIZER} -- Test case validation: Access

--	validation_log_file_name: STRING = "validation.log"
--			-- Name of the file where the time stamp, UUID, and the validation state of all test cases are logged.

--	validation_log_file_full_path: FILE_NAME
--			-- Full path of the validation log file.
--		do
--			if validation_log_file_name_cache = Void then
--				create validation_log_file_full_path_cache.make_from_string (test_case_dir)
--				validation_log_file_full_path_cache.set_file_name (validation_log_file_name)
--			end
--			Result := validation_log_file_full_path_cache
--		end

--	categorizer_log_file_full_path_cache: FILE_NAME
--			-- Cache for `categorizer_log_file_full_path'.

--	validation_log_end_str: STRING = "<<END>>"
--			-- End string of a validation log.

--	validation_log_file: KL_TEXT_OUTPUT_FILE
--			-- File where time stamp, UUID, and validation state of all test cases are logged.

--	has_pending_validation_state: BOOLEAN
--			-- If catigorization log has any pending validation state due to, for example, failed object deserialization.

--	test_case_validation_state_table: DS_HASH_TABLE [BOOLEAN, STRING]
--			-- Table of test cases and their validation states.

--feature{AUT_TEST_CASE_CATEGORIZER} -- Test case validation: Implementation

--	load_existing_validation_log
--			-- Load existing validation log, if any, into `test_case_validation_state_table'.
--		local
--			l_table: like test_case_validation_state_table
--			l_file: KL_TEXT_INPUT_FILE
--			l_line, l_uuid, l_state_str: STRING
--			l_state, l_end: BOOLEAN
--			l_fields: LIST [STRING]
--		do
--			log_has_pending_state := False
--			l_table := test_case_validation_state_table

--			create l_file.make (validation_log_file_full_path)
--			l_file.open_read
--			if l_file.is_open_read then
--				from
--				until l_file.end_of_file or else l_end
--				loop
--					l_file.read_line
--					l_line := l_file.last_string

--					if l_line ~ validation_log_end_str then
--						l_end := True
--					else
--						l_fields := l_line.split (':')
--						check l_fields.count = 3 end
--						l_uuid := l_fields.i_th (2)
--						l_state_str := l_fields.i_th (3)
--						if l_state_str.is_boolean then
--							l_state := l_state_str.to_boolean
--						else
--							l_state := False
--							has_pending_validation_state := True
--						end
--						check unique_uuid: not l_table.has (l_uuid) end
--						l_table.force (l_state, l_uuid)
--					end
--				end
--				l_file.close
--			end
--		end

--	prepare_log_for_new_validation
--			-- Prepare log file for new validations, complete pending validation state, if any.
--		local
--			l_file: KL_TEXT_OUTPUT_FILE
--		do
--			create l_file.make (validation_log_file_full_path)
--			l_file.recursive_open_append
--			if l_file.is_open_write then
--				validation_log_file := l_file
--				if log_has_pending_state then
--					l_file.put_boolean (False)
--					l_file.put_new_line
--					l_file.flush
--				end
--			end
--		end

--	log_validation_state (a_data: AUT_DESERIALIZED_TEST_CASE; a_state: BOOLEAN)
--			-- Log the state `a_state' of a test case `a_data' into `validation_log_file'.
--			--	`a_data': test case;
--			--	`a_state': validation state of `a_data';
--		local
--			l_str: STRING
--		do
--			if validation_log_file /= Void and then validation_log_file.is_open_write then
--				create l_str.make_empty
--				l_str.append (a_data.time_str + ",%T" + a_data.tc_uuid + ",%T" + a_state.out + "%N")
--				validation_log_file.put_string (l_str)
--				validation_log_file.flush
--			end
--		end

--	finish_validation
--			-- Finish test case validation.
--		do
--			if validation_log_file /= Void and then validation_log_file.is_open_write then
--				validation_log_file.put_string (validation_log_end_str)
--				validation_log_file.put_new_line
--				validation_log_file.close
--			end
--		end

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
