note
	description: "Summary description for {AUT_TEST_CASE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_EXTRACTOR

inherit

	AUT_TEST_CASE_WRITTER_I
		redefine
			tc_class_content
		end

	AUT_DESERIALIZATION_DATA_REGISTER
		undefine
			copy,
			is_equal
		end

	EPA_UTILITY

	SHARED_TYPES

	ITP_VARIABLE_CONSTANTS

	ERL_G_TYPE_ROUTINES

create
	default_create

feature -- Data event handler

	on_serialization_data (a_data: AUT_DESERIALIZED_DATA; a_is_unique: BOOLEAN)
			-- <Precursor>
		do
			if a_is_unique then
				generate_test_case (a_data)
			end
		end

feature -- Configuration

	config (a_error_handler: like error_handler; a_conf: like configuration)
			-- <Precursor>
		local
			l_dir_name: STRING
			l_dir: DIRECTORY
		do
			error_handler := a_error_handler
			configuration := a_conf

			-- Prepare directory.
			l_dir_name := test_case_dir.twin
			create l_dir.make (l_dir_name)
			if l_dir.exists then
				l_dir.recursive_delete
			end
		end

feature -- Access

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration of current AutoTest run.

	error_handler: UT_ERROR_HANDLER
			-- <Precursor>

	test_case_dir: STRING
			-- Directory where the generated test cases would be saved.
		do
			Result := configuration.data_output
		end

feature{NONE} -- Status report

	is_exception_information_resolved: BOOLEAN
			-- Is the exception information resolved?

feature{NONE} -- Implementation

	generate_test_case (a_data: AUT_DESERIALIZED_DATA)
			-- Generate the test case from 'a_data' and save it into `test_case_dir'.
		local
			l_file_name: STRING
			l_loader: SEM_FEATURE_CALL_TRANSITION_LOADER_FROM_TEST_CASE
			l_transition: SEM_FEATURE_CALL_TRANSITION
		do
			reset_cache
			current_data := a_data
			write_to (test_case_dir)

--			-- For testing
--			l_file_name := tc_class_full_path (test_case_dir)
--			create l_loader.make(error_handler)
--			l_loader.load_transition (l_file_name)
--			l_transition := l_loader.last_transition

			current_data := Void
		end

	prepare_directory (a_dir_name: STRING)
			-- <Precursor>
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (a_dir_name)
			l_file_name.set_subdirectory (tc_class_under_test)
			l_file_name.set_subdirectory (tc_feature_under_test + "__" + tc_directory_postfix)
			recursive_create_directory (l_file_name.string)
		end

	tc_class_full_path (a_dir_name: STRING): STRING
			-- <Precursor>
		local
			l_file_name: FILE_NAME
			l_length: INTEGER
		do
			create l_file_name.make_from_string (a_dir_name)
			l_file_name.set_subdirectory (tc_class_under_test)
			l_file_name.set_subdirectory (tc_feature_under_test + "__" + tc_directory_postfix)
			-- Make sure the length of file name does not exceed 255.
			l_length := 255 - l_file_name.string.count - 2
			truncate_class_name (l_length)
			l_file_name.set_file_name (tc_class_name)
			l_file_name.add_extension (tc_name_extension)

			Result := l_file_name.string
		end

feature{NONE} -- Class content

	tc_class_content: STRING
			-- <Precursor>
			-- Return empty string if there was error during the extraction.
		local
			l_content: STRING
		do
			l_content := Precursor
			if not current_data.is_summarization_available then
				l_content := ""
			end
			Result := l_content
		end

	tc_class_name: STRING
			-- <Precursor>
		local
			l_name: STRING
		do
			if tc_class_name_cache = Void then
				create l_name.make (128)
				l_name.copy (tc_class_name_template)
				l_name.replace_substring_all (ph_class_under_test, tc_class_under_test)
				l_name.replace_substring_all (ph_feature_under_test, tc_feature_under_test)
				l_name.replace_substring_all (ph_success_status, tc_success_status)
				l_name.replace_substring_all (ph_exception_code, tc_exception_code.out)
				l_name.replace_substring_all (ph_breakpoint_index, tc_breakpoint_index.out)
				l_name.replace_substring_all (ph_exception_recipient, tc_exception_recipient)
				l_name.replace_substring_all (ph_exception_recipient_class, tc_exception_recipient_class)
--				l_name.replace_substring_all (ph_recipient, tc_recipient)
				l_name.replace_substring_all (ph_assertion_tag, tc_assertion_tag)
				l_name.replace_substring_all (ph_hash_code, tc_hash_code)
				l_name.replace_substring_all (ph_uuid, tc_uuid)

				tc_class_name_cache := l_name
			end
			Result := tc_class_name_cache
		end

	tc_is_query: BOOLEAN
			-- <Precursor>
		do
			Result := current_data.is_feature_query
		end

    tc_is_creation: BOOLEAN
            -- <Precursor>
        do
        	Result := current_data.is_feature_creation
        end

    tc_is_passing: BOOLEAN
            -- <Precursor>
        do
        	Result := current_data.is_execution_successful
        end

	tc_exception_recipient: STRING
			-- <Precursor>
		do
			if not is_exception_information_resolved then
				resolve_exception_information
			end
			Result := tc_exception_recipient_cache
        end

	tc_exception_recipient_class: STRING
			-- <Precursor>
        do
			if not is_exception_information_resolved then
				resolve_exception_information
			end
			Result := tc_exception_recipient_class_cache
        end

	tc_argument_count: INTEGER
			-- <Precursor>
		do
			Result := current_data.test_case.argument_count
        end

    tc_operand_table_initializer: STRING
            -- <Precursor>
		local
			l_feature_call: AUT_CALL_BASED_REQUEST
			l_operand_indexes: SPECIAL[INTEGER]
			l_line: STRING
			l_index: INTEGER
        do
			if tc_operand_table_initializer_cache = Void then
				l_feature_call := current_data.test_case
				l_operand_indexes := l_feature_call.operand_indexes
				create tc_operand_table_initializer_cache.make (20 * l_operand_indexes.count + 1)
				from
					l_index := 0
				until
					l_index >= l_operand_indexes.count
				loop
					l_line := tc_operand_table_initializer_template.twin
					l_line.replace_substring_all (ph_operand_index, l_index.out)
					l_line.replace_substring_all (ph_var_index, l_operand_indexes[l_index].out)
					tc_operand_table_initializer_cache.append (l_line + "%N")
--					Result.put (variable_name_prefix + l_operand_indexes[l_index].out, l_index)
					l_index := l_index + 1
				end
			end
			tc_operand_table_initializer_cache.prune_all_trailing ('%N')
			Result := tc_operand_table_initializer_cache
        end

	tc_exception_code: INTEGER
			-- If the test case is a failing one, return the exception code.
			-- Otherwise, return 0.
		do
			if not is_exception_information_resolved then
				resolve_exception_information
			end
			Result := tc_exception_code_cache
		end

	tc_breakpoint_index: INTEGER
			-- If the test case is a failing one, return the breakpoint index.
			-- Otherwise, return 0.
		do
			if not is_exception_information_resolved then
				resolve_exception_information
			end
			Result := tc_breakpoint_index_cache
		end

	tc_assertion_tag: STRING
			-- If the test case is a failing one, return the tag of violated assertion
			--	in the format of "TAG_$(ASSERTION_TAG)".
			-- Otherwise, return "TAG_noname".
		do
			if tc_assertion_tag_cache = Void then
				resolve_exception_information
			end
			Result := tc_assertion_tag_cache
		end

	tc_uuid: STRING
			-- <Precursor>
		do
			if tc_uuid_cache = Void then
				update_uuid
			end
			Result := tc_uuid_cache
		end

	tc_summary: STRING
			-- <Precursor>
			-- in the format of 'class_name.feature_name'.
		do
			Result := tc_class_under_test.twin
			Result.append (once ".")
			Result.append (tc_feature_under_test)
		end

	tc_directory_postfix: STRING
			-- <Precursor>
		local
			l_value_set: DS_HASH_SET [AUT_DESERIALIZED_DATA]
			l_count: INTEGER
		do
			l_value_set := register.value_set (current_data.feature_, current_data.class_)
			l_count := l_value_set.count
			Result := (l_count // 5000).out
		end

	tc_code: STRING
			-- <Precursor>
		do
			Result := current_data.code_str
		end

	tc_class_under_test: STRING
			-- <Precursor>
		do
			Result := current_data.class_name_str
		end

	tc_feature_under_test: STRING
			-- <Precursor>
		do
			Result := current_data.feature_.feature_name
		end

	tc_success_status: STRING
			-- <Precursor>
		do
--			Result := current_data.is_execution_successful
			if current_data.is_execution_successful then
				Result := "S"
			else
				Result := "F"
			end
		end

	tc_operands_declaration: STRING
			-- <Precursor>
		do
			Result := current_data.operands_str.twin
		end

	tc_variables_declaration: STRING
			-- <Precursor>
		do
			Result := current_data.variables_str.twin
		end

	tc_all_variable_declaration: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_table, l_all_var_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_var_name: STRING
			l_var: ITP_VARIABLE
			l_type: TYPE_A
			l_line, l_dec: STRING
		do
			l_data := current_data
			create l_all_var_table.make (l_data.operand_type_table.count + l_data.variable_type_table.count)
			l_all_var_table.copy (l_data.operand_type_table)
			from
				l_table := l_data.variable_type_table
				l_table.start
			until l_table.after
			loop
				l_all_var_table.put (l_table.item_for_iteration, l_table.key_for_iteration)
				l_table.forth
			end

			from
				create l_dec.make (128)
				l_all_var_table.start
			until
				l_all_var_table.after
			loop
				l_var := l_all_var_table.key_for_iteration
				l_type := l_all_var_table.item_for_iteration
				l_line := "%T%T%T" + l_var.name (l_data.variable_name_prefix) + ": " + l_type.name + "%N"
				l_dec.append (l_line)

				l_all_var_table.forth
			end
			l_dec.prune_all_trailing ('%N')
			Result := l_dec
		end

	tc_body: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_testcase: AUT_CALL_BASED_REQUEST
			l_arg_list: DS_LINEAR [ITP_EXPRESSION]
			l_var: ITP_VARIABLE
			l_var_name: STRING
			l_var_index: INTEGER
			l_line: STRING
			l_operand_types, l_variable_types, l_all_types: HASH_TABLE [TYPE_A, ITP_VARIABLE]
		do
			create Result.make (128)
			l_data := current_data

			-- Collect all the operands and variables types into 'l_all_types'
			l_operand_types := l_data.operand_type_table
			l_variable_types := l_data.variable_type_table
			create l_all_types.make (l_operand_types.count + l_variable_types.count)
			l_all_types.compare_objects
			l_all_types.copy (l_operand_types)
			from l_variable_types.start
			until l_variable_types.after
			loop
				l_all_types.put (l_variable_types.item_for_iteration, l_variable_types.key_for_iteration)
				l_variable_types.forth
			end

			-- Initialize all local variables.
			from
				l_all_types.start
			until
				l_all_types.after
			loop
				l_var := l_all_types.key_for_iteration
				l_var_name := l_var.name (l_data.variable_name_prefix)
				l_var_index := l_var.index

				-- Output one line.
				create l_line.make (64)
				l_line.append (once "%T%T%T")
				l_line.append (tc_var_initialization_template)
				l_line.replace_substring_all (once "$(VAR)", l_var_name)
				l_line.replace_substring_all (once "$(INDEX)", l_var_index.out)
				Result.append (l_line)
				l_all_types.forth
			end

			-- Output test case.
			Result.append (once "%N%T%T%Tsetup_before_test%N%N")
			Result.append (once "%T%T%T%T-- Execute feature under test.%N%T%T%T")
			Result.append (l_data.code_str)
			Result.append (once "%N%N%T%T%Tcleanup_after_test")
		end

	tc_pre_state: STRING
			-- <Precursor>
		do
			Result := current_data.pre_state_str.twin
--			Result.prepend_string ("--")
--			Result.replace_substring_all ("%N", "%N--")
		end

	tc_post_state: STRING
			-- <Precursor>
		do
			Result := current_data.post_state_str.twin
--			Result.prepend_string ("--")
--			Result.replace_substring_all ("%N", "%N--")
		end

	tc_trace: STRING
			-- <Precursor>
		do
			Result := "%"[%N"
			Result.append (current_data.trace_str)
			Result.append ("]%"")
		end

	tc_pre_serialization: STRING
			-- <Precursor>
		do
			Result := tc_serialized_data (current_data.pre_serialization)
		end

--	tc_post_serialization: STRING
--			-- <Precursor>
--		do
--			Result := tc_serialized_data (current_data.post_serialization)
--		end

	tc_serialized_data (a_object: ARRAYED_LIST[NATURAL_8]): STRING
			-- Serialization data, i.e. an array of {NATURAL_8} values, in {STRING}.
		local
			l_data: ARRAYED_LIST[NATURAL_8]
			l_index: INTEGER
			l_line: STRING
		do
			l_data := a_object

			from
				create Result.make (l_data.count * 4 + 1)
				create l_line.make (128)
				l_index := 1
				l_data.start
			until
				l_data.after
			loop
				l_line.append (l_data.item.out)
				if not l_data.islast then
					l_line.append (", ")
				end

				if l_line.count > 120 or else l_data.islast then
					l_line.append ("%N")
					Result.append (l_line)
					l_line.wipe_out
				end

				l_index := l_index + 1
				l_data.forth
			end
			Result.prune_all_trailing ('%N')
		end

	tc_hash_code: STRING
			-- <Precursor>
		local
			l_hash_string: STRING
			l_index: INTEGER
			l_hash_value: INTEGER
		do
			Result := current_data.trans_hashcode.hash_code.out
		end

feature{NONE} -- Cache

	tc_class_name_cache: STRING
			-- Cache for calculated class name.

	tc_uuid_cache: STRING
			-- Cache for the uuid generated last time.

	tc_exception_code_cache: INTEGER
			-- Cache for breakpoint index in case of a failing test case.

	tc_breakpoint_index_cache: INTEGER
	tc_exception_recipient_cache: detachable STRING
	tc_exception_recipient_class_cache: detachable STRING
	tc_assertion_tag_cache: detachable STRING
	tc_test_case_cache: detachable AUT_CALL_BASED_REQUEST
	tc_operand_table_initializer_cache: detachable STRING

	reset_cache
			-- Reset all cached information.
		do
			tc_class_name_cache := Void
			tc_uuid_cache := Void

			-- test case information.
			is_exception_information_resolved := False
			tc_assertion_tag_cache := Void
			tc_exception_recipient_cache := Void
			tc_exception_recipient_class_cache := Void
			tc_operand_table_initializer_cache := Void
		end

feature{NONE} -- Auxiliary features

	truncate_class_name (a_length: INTEGER)
			-- Truncate the class name so that it contains no more than 'a_length' characters.
			-- Due to the constraint on the length of file name, we need to truncate the extra part.
			-- This may result in incomplete information in the file name.
		local
			l_name: STRING
		do
			l_name := tc_class_name
			if l_name.count > a_length then
				error_handler.report_warning_message ("Class name truncated: " + l_name)
				tc_class_name_cache := l_name.substring (1, a_length)
			end
		end

	string_to_identifier (a_str: STRING): STRING
			-- Get an identifier out of 'a_str' by removing all the invalid characters.
		local
			l_is_start: BOOLEAN
			l_char: CHARACTER
			l_index: INTEGER
		do
			l_is_start := True
			from
				create Result.make (a_str.count)
				l_index := 1
			until
				l_index > a_str.count
			loop
				l_char := a_str[l_index]
				if (l_is_start and then l_char.is_alpha)
						or else (not l_is_start and then (l_char.is_alpha_numeric or else l_char = '_')) then
					Result.append_character (l_char)
					if l_is_start then
						l_is_start := False
					end
				end
				l_index := l_index + 1
			end
		end


	resolve_exception_information
			-- Resolve relevant exception information from the exception trace, if any.
		require
			trace_attached: current_data /= Void and then current_data.trace_str /= Void
			exception_information_not_resolved: not is_exception_information_resolved
		local
			l_trace: STRING
			l_lines: LIST[STRING]
			l_exception_code: STRING
			l_recipient_class, l_recipient_feature: STRING
			l_assertion_tag, l_assertion_tag_new: STRING
			l_start, l_end: INTEGER
			l_str: STRING
			l_done: BOOLEAN
			l_analyzer: EPA_EXCEPTION_TRACE_ANALYZER
			l_frames: DS_LINEAR [EPA_EXCEPTION_CALL_STACK_FRAME_I]
			l_frame: EPA_EXCEPTION_CALL_STACK_FRAME_I
		do
			is_exception_information_resolved := False
			l_trace := current_data.trace_str
			if l_trace.is_empty then
				tc_exception_code_cache := 0
				tc_breakpoint_index_cache := 0
				tc_exception_recipient_cache := tc_feature_under_test
				tc_exception_recipient_class_cache := tc_class_under_test
				tc_assertion_tag_cache := "noname"
			else
				l_trace.prune_all_leading ('%N')
				l_trace.prune_all_trailing ('%N')
				l_lines := l_trace.split ('%N')

				-- Exception code.
				l_exception_code := l_lines[1]
				l_exception_code.prune_all_leading ('-')
				check valid_exception_code: l_exception_code.is_integer end
				tc_exception_code_cache := l_exception_code.to_integer_32

				-- Recipient feature
				l_recipient_feature := l_lines[2]
				l_recipient_feature.prune_all_leading ('-')
				tc_exception_recipient_cache := l_recipient_feature

				-- Recipient class
				l_recipient_class := l_lines[3]
				l_recipient_class.prune_all_leading ('-')
				tc_exception_recipient_class_cache := l_recipient_class

				-- Assertion tag
				l_assertion_tag := l_lines[4]
				l_assertion_tag.prune_all_leading ('-')
				if l_assertion_tag.is_empty then
					tc_assertion_tag_cache := "noname"
				else
					l_assertion_tag_new := string_to_identifier (l_assertion_tag)
					if l_assertion_tag /~ l_assertion_tag_new then
						error_handler.report_error_message ("Unexpected character(s) in the failing assertion tag: " + l_assertion_tag)
					end
					tc_assertion_tag_cache := l_assertion_tag_new
				end

				-- Breakpoint index
				l_start := l_trace.substring_index ("----", 1)
				l_trace := l_trace.substring (l_start, l_trace.count)
				create l_analyzer
				l_analyzer.analyse (l_trace)
				from
					l_frames := l_analyzer.last_relevant_exception_frames
					l_frames.start
				until
					l_frames.after or else l_done
				loop
					l_frame := l_frames.item_for_iteration
					if l_frame /= Void and then l_recipient_class ~ l_frame.origin_class_name and then l_recipient_feature ~ l_frame.feature_name then
						tc_breakpoint_index_cache := l_frame.breakpoint_slot_index
						l_done := True
					end
					l_frames.forth
				end
				check tc_breakpoint_index_attached: tc_breakpoint_index /= Void end

				is_exception_information_resolved := True
			end
		ensure
			test_case_information_attached:
				tc_assertion_tag_cache /= Void
		end

	update_uuid
			-- Ask `uuid_generator' to provide a new uuid string.
		do
			tc_uuid_cache := uuid_generator.generate_uuid.out
			tc_uuid_cache.prune_all ('-')

			-- Reset class name cache.
			tc_class_name_cache := Void
		end

	current_data: detachable AUT_DESERIALIZED_DATA
			-- Current data from which the test case would be extracted.

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
