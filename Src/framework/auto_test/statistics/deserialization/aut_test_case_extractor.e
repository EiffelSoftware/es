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

	configuration: TEST_GENERATOR
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
		do
			reset_cache
			current_data := a_data
			write_to (test_case_dir)

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
		do
			create l_file_name.make_from_string (a_dir_name)
			l_file_name.set_subdirectory (tc_class_under_test)
			l_file_name.set_subdirectory (tc_feature_under_test + "__" + tc_directory_postfix)

			-- Make sure the length of file name does not exceed 255 characters.			
			truncate_class_name (253)
			l_file_name.set_file_name (tc_class_name)
			l_file_name.add_extension (tc_name_extension)

			Result := l_file_name.string
		end

feature{NONE} -- Class content

	tc_class_content: STRING
			-- <Precursor>
			-- Set `is_successful' if there was error during the extraction.
		local
			l_content: STRING
		do
			l_content := Precursor
			is_successful := is_successful and then current_data.is_summarization_available
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
				if tc_is_query then
					l_name.replace_substring_all (ph_feature_type, ph_query)
				else
					l_name.replace_substring_all (ph_feature_type, ph_command)
				end
				l_name.replace_substring_all (ph_success_status, tc_success_status)
				l_name.replace_substring_all (ph_exception_code, tc_exception_code.out)
				l_name.replace_substring_all (ph_breakpoint_index, tc_breakpoint_index.out)
				l_name.replace_substring_all (ph_exception_recipient, tc_exception_recipient)
				l_name.replace_substring_all (ph_exception_recipient_class, tc_exception_recipient_class)
--				l_name.replace_substring_all (ph_recipient, tc_recipient)
				l_name.replace_substring_all (ph_assertion_tag, tc_assertion_tag)
				l_name.replace_substring_all (ph_hash_code, tc_hash_code)
				l_name.replace_substring_all (ph_uuid, tc_uuid)
				l_name.replace_substring_all (ph_pre_object_info, tc_pre_object_info)
				l_name.replace_substring_all (ph_post_object_info, tc_post_object_info)
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
			if not tc_is_passing then
				if not is_exception_information_resolved then
					resolve_exception_information
				end
				Result := tc_exception_recipient_cache
			else
				Result := tc_feature_under_test
			end
        end

	tc_exception_recipient_class: STRING
			-- <Precursor>
        do
        	if not tc_is_passing then
				if not is_exception_information_resolved then
					resolve_exception_information
				end
				Result := tc_exception_recipient_class_cache
			else
				Result := tc_class_under_test
        	end
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
			l_operand_occurrences: HASH_TABLE [INTEGER, INTEGER]
			l_operand_reindexing_table: like operand_reindexing_table
			l_line: STRING
			l_index: INTEGER
			l_old_index, l_new_index: INTEGER
			l_occurrence: INTEGER
        do
			if tc_operand_table_initializer_cache = Void then
				l_feature_call := current_data.test_case
				l_operand_indexes := l_feature_call.operand_indexes

				create l_operand_occurrences.make (l_operand_indexes.count)
				l_operand_occurrences.compare_objects
				l_operand_reindexing_table := operand_reindexing_table

				from
					create tc_operand_table_initializer_cache.make (20 * l_operand_indexes.count + 1)
					l_index := 0
				until
					l_index >= l_operand_indexes.count
				loop
					l_line := tc_operand_table_initializer_template.twin
					l_old_index := l_operand_indexes[l_index]

					-- Use the reindexed
					if l_operand_occurrences.has (l_old_index) then
						l_occurrence := l_operand_occurrences.item (l_old_index)
						l_occurrence := l_occurrence + 1
						l_operand_occurrences.replace (l_occurrence, l_old_index)
						l_new_index := l_operand_reindexing_table.item (l_old_index).item (l_occurrence).first
					else
						l_occurrence := 1
						l_operand_occurrences.force (l_occurrence, l_old_index)
						l_new_index := l_old_index
					end

					l_line.replace_substring_all (ph_operand_index, l_index.out)
					l_line.replace_substring_all (ph_var_index, l_new_index.out)
					tc_operand_table_initializer_cache.append (l_line + "%N")
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
			Result := tc_uuid_cache.hash_code.out
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
		require else
			used_after_tc_body: True
		do
			Result := tc_code_cache
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
			if current_data.is_execution_successful then
				Result := "S"
			else
				Result := "F"
			end
		end

	tc_operands_declaration: STRING
			-- <Precursor>
		do
			Result := tc_operands_declaration_cache
		end

	tc_variables_declaration: STRING
			-- <Precursor>
		do
			Result := tc_variables_decleration_cache
		end

	tc_all_variable_declaration: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_line: STRING
			l_variables_table, l_operands_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_var: ITP_VARIABLE
			l_type: TYPE_A
			l_prefix: STRING
			l_nested_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			l_op_index: INTEGER
			l_occurrence, l_new_index: INTEGER
			l_reindexing: DS_HASH_TABLE [DS_HASH_SET[INTEGER], INTEGER]
			l_op_name: STRING
			l_variables_declaration, l_operands_declaration: STRING
			l_type_name: STRING
		do
			l_data := current_data
			l_variables_table := l_data.variable_type_table
			l_operands_table := l_data.operand_type_table

			-- Declaration of local variables.
			create l_variables_declaration.make (256)
			from
				l_prefix := l_data.variable_name_prefix
				l_variables_table.start
			until
				l_variables_table.after
			loop
				l_var := l_variables_table.key_for_iteration
				l_type := l_variables_table.item_for_iteration

				-- Declare a local variable if it is no operand.
				if not l_operands_table.has (l_var) then
					l_type_name := l_type.name.twin
					l_type_name.replace_substring_all (once "?", once "")
					l_line := "%T" + l_var.name (l_prefix) + ": " + l_type_name + "%N"
					l_variables_declaration.append (l_line)
				end

				l_variables_table.forth
			end
			tc_variables_decleration_cache := l_variables_declaration

			-- Declaration of operands.
			l_nested_table := operand_reindexing_table
			create l_operands_declaration.make (256)
			from
				l_operands_table.start
			until
				l_operands_table.after
			loop
				l_op_index := l_operands_table.key_for_iteration.index
				l_type := l_operands_table.item_for_iteration

				-- Declare one variable for each occurrence of the operand.
				check l_nested_table.has (l_op_index) end
				l_reindexing := l_nested_table.item (l_op_index)
				from l_reindexing.start
				until l_reindexing.after
				loop
					l_occurrence := l_reindexing.key_for_iteration
					l_new_index := l_reindexing.item_for_iteration.first

					l_op_name := l_data.variable_name_prefix.twin + l_new_index.out
					l_type_name := l_type.name.twin
					l_type_name.replace_substring_all (once "?", once "")
					l_line := "%T%T%T" + l_op_name + ": " + l_type_name + "%N"
					l_operands_declaration.append (l_line)

					l_reindexing.forth
				end

				l_operands_table.forth
			end
			tc_operands_declaration_cache := l_operands_declaration

			Result := l_variables_declaration.twin + l_operands_declaration
			Result.prune_all_trailing ('%N')
		end

	tc_body: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_test_call: STRING
			l_variables_table, l_operands_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_nested_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			l_op_index: INTEGER
			l_current_occurrence: INTEGER
			l_reindexing: DS_HASH_TABLE [DS_HASH_SET[INTEGER], INTEGER]
			l_op_name, l_new_name: STRING
			l_start_index, l_end_index: INTEGER
		do
			create Result.make (256)
			l_data := current_data
			l_variables_table := l_data.variable_type_table
			l_operands_table := l_data.operand_type_table

			-- Renaming operands in the test call.
			l_test_call := l_data.code_str.twin
			l_nested_table := operand_reindexing_table
			from
				l_operands_table := l_data.operand_type_table
				l_operands_table.start
			until
				l_operands_table.after
			loop
				l_op_name := l_operands_table.key_for_iteration.name (l_data.variable_name_prefix)
				l_op_index := l_operands_table.key_for_iteration.index

				check l_nested_table.has (l_op_index) end
				l_reindexing := l_nested_table.item (l_op_index)

				-- Search for all occurrences of the operand in 'l_test_call', and replace them
				--		with references to new variables.
				from
					l_start_index := 1
					l_start_index := l_test_call.substring_index (l_op_name, l_start_index)
					l_current_occurrence := 1
				until
					l_start_index = 0
				loop
					l_end_index := l_start_index + l_op_name.count

					-- On finding a complete identifier.
					if l_end_index >= l_test_call.count or else not (l_test_call[l_end_index].is_alpha_numeric or else l_test_call[l_end_index] = '_') then
						l_new_name := l_data.variable_name_prefix.twin + l_reindexing.item (l_current_occurrence).first.out
						if l_new_name /~ l_op_name then
							l_test_call.replace_substring (l_new_name, l_start_index, l_end_index - 1)
						end
						l_current_occurrence := l_current_occurrence + 1
						l_start_index := l_start_index + l_new_name.count
					else
						l_start_index := l_end_index
					end

					l_start_index := l_test_call.substring_index (l_op_name, l_start_index)
				end

				l_operands_table.forth
			end
			tc_code_cache := l_test_call
			Result.append (once "%N%T%T%Tsetup_before_test%N")
			Result.append (once "%T%T%Tload_variables%N%N")

			Result.append (once "%T%T%T%T-- Retrieve object information in pre-state.%N")
			Result.append (once "%T%T%Tif is_pre_state_information_needed then%N")
			Result.append (once "%T%T%T%Tfinish_pre_state_calculation%N")
			Result.append (once "%T%T%T%Twipe_out_variables%N")
			Result.append (once "%T%T%T%Tload_variables%N")
			Result.append (once "%T%T%Tend%N")

			Result.append (once "%T%T%T%T-- Execute feature under test.%N%T%T%T")

			Result.append (l_test_call)
			Result.append ("%N%N%T%T%T%T-- Retrieve object information in post-state.%N")
			Result.append ("%T%T%Tif is_post_state_information_enabled then%N")
			Result.append ("%T%T%T%Tpost_serialization_cache := ascii_string_as_array (serialized_object (special_from_tuple (")
			Result.append (tuple_for_objects)
			Result.append (")))%N")
			Result.append ("%T%T%T%Tfinish_post_state_calculation%N")
			Result.append ("%T%T%Tend%N")
			Result.append (once "%N%T%T%Tcleanup_after_test%N")
		end

	tc_load_variables_body: STRING
			-- Text for the body of feature `load_variables'
		local
			l_data: like current_data
			l_variables_table, l_operands_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_var: ITP_VARIABLE
			l_type: TYPE_A
			l_prefix: STRING
			l_line: STRING
			l_cursor: CURSOR
			l_nested_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			l_op_index: INTEGER
			l_new_index: INTEGER
			l_reindexing: DS_HASH_TABLE [DS_HASH_SET[INTEGER], INTEGER]
			l_op_name: STRING
			l_occurrence: INTEGER
		do
			create Result.make (256)
			l_data := current_data
			l_variables_table := l_data.variable_type_table
			l_operands_table := l_data.operand_type_table

				-- Initialization of local variables.
			l_cursor := l_variables_table.cursor
			from
				l_prefix := l_data.variable_name_prefix
				l_variables_table.start
			until
				l_variables_table.after
			loop
				l_var := l_variables_table.key_for_iteration
				l_type := l_variables_table.item_for_iteration

					-- Output local variable initialization, if it is no operand.
				if not l_operands_table.has (l_var) then
					create l_line.make (64)
					l_line.append (once "%T%T%T")
					l_line.append (tc_var_initialization_template)
					l_line.replace_substring_all (once "$(VAR)", l_var.name (l_data.variable_name_prefix))
					l_line.replace_substring_all (once "$(INDEX)", l_var.index.out)
					Result.append (l_line)
				end
				l_variables_table.forth
			end
			l_variables_table.go_to (l_cursor)

				-- Initialization of operands.
			l_nested_table := operand_reindexing_table
			l_cursor := l_operands_table.cursor
			from
				l_operands_table.start
			until
				l_operands_table.after
			loop
				l_op_index := l_operands_table.key_for_iteration.index
				l_type := l_operands_table.item_for_iteration

					-- Use the same object to initialize variables from repeated occurrences of the operand.
				check l_nested_table.has (l_op_index) end
				l_reindexing := l_nested_table.item (l_op_index)
				from l_reindexing.start
				until l_reindexing.after
				loop
					l_occurrence := l_reindexing.key_for_iteration
					l_new_index := l_reindexing.item_for_iteration.first
					l_op_name := l_data.variable_name_prefix.twin + l_new_index.out

					create l_line.make (64)
					l_line.append (once "%T%T%T")
					l_line.append (tc_var_initialization_template)
					l_line.replace_substring_all (once "$(VAR)", l_op_name)
					l_line.replace_substring_all (once "$(INDEX)", l_op_index.out)
					Result.append (l_line)

					l_reindexing.forth
				end

				l_operands_table.forth
			end
			l_operands_table.go_to (l_cursor)
		end

	tc_code_cache: STRING
			-- Cache for test code.

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
			Result.append ("%N]%"")
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
		do
			Result := current_data.trans_hashcode.hash_code.out
		end

	tc_pre_object_info: STRING
			-- String representing for objects in current test case in pre-state
		local
			l_vars: LIST [STRING]
			l_declaration: LIST [STRING]
			l_var_name: STRING
			l_var_index: STRING
			l_var_type: STRING
		do
			create Result.make (256)

			l_vars := tc_all_variable_declaration.split ('%N')
			from
				l_vars.start
			until
				l_vars.after
			loop
				l_declaration := l_vars.item_for_iteration.split (':')
				l_var_name := l_declaration.first
				l_var_name.left_adjust
				l_var_name.right_adjust
				l_var_type := l_declaration.last
				l_var_type.left_adjust
				l_var_type.right_adjust
				l_var_index := l_var_name.substring (3, l_var_name.count)

				if not Result.is_empty then
					Result.append_character (';')
				end
				Result.append (l_var_type)
				Result.append_character (';')
				Result.append (l_var_index)
				l_vars.forth
			end
		end

	tc_post_object_info: STRING
			-- String representing for objects in current test case in post-state
		do
			Result := tc_pre_object_info
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
	tc_variables_decleration_cache: detachable STRING
	tc_operands_declaration_cache: detachable STRING

	operand_reindexing_table_cache: like operand_reindexing_table
			-- Cache for `operand_reindexing_table'.

	reset_cache
			-- Reset all cached information.
		do
			operand_reindexing_table_cache := Void
			tc_class_name_cache := Void
			tc_uuid_cache := Void

			-- Exception information.
			is_exception_information_resolved := False
			tc_exception_code_cache := 0
			tc_breakpoint_index_cache := 0
			tc_assertion_tag_cache := "noname"
			tc_exception_recipient_cache := ""
			tc_exception_recipient_class_cache := ""

			tc_operand_table_initializer_cache := Void
			tc_code_cache := Void
			tc_variables_decleration_cache := Void
			tc_operands_declaration_cache := Void
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
			check class_name_attached: l_name /= Void end
			if l_name.count > a_length then
				error_handler.report_warning_message ("Class name truncated: " + l_name)
				tc_class_name_cache := l_name.substring (1, a_length)
			end
		end

	reindex_operands
			-- Reindex operands if they are used multiple times in the test.
		local
			l_data: like current_data
			l_reindexing_table: like operand_reindexing_table
			l_operand_types, l_variable_types: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_used_indexes: DS_HASH_SET [INTEGER]
			l_var_index: INTEGER
			l_operand_position_name_table: HASH_TABLE [STRING, INTEGER]
			l_operand_name_occurrence_table: HASH_TABLE [INTEGER, STRING]
			l_op_name: STRING
			l_occurrence, l_current_occurrence: INTEGER
			l_operand: ITP_VARIABLE
			l_new_index: INTEGER
		do
			l_data := current_data

			l_operand_types := l_data.operand_type_table
			l_variable_types := l_data.variable_type_table

			-- Collect all the indexes of operands and variables into 'l_used_indexes',
			create l_used_indexes.make (l_operand_types.count + l_variable_types.count)

			from l_operand_types.start
			until l_operand_types.after
			loop
				l_var_index := l_operand_types.key_for_iteration.index
				l_used_indexes.force (l_var_index)

				l_operand_types.forth
			end
			from l_variable_types.start
			until l_variable_types.after
			loop
				l_used_indexes.force (l_variable_types.key_for_iteration.index)
				l_variable_types.forth
			end

			-- Find out the occurrence of each operand in this test.
			l_operand_position_name_table := l_data.operand_position_name_table
			create l_operand_name_occurrence_table.make (l_operand_types.count)
			l_operand_name_occurrence_table.compare_objects
			from l_operand_position_name_table.start
			until l_operand_position_name_table.after
			loop
				l_op_name := l_operand_position_name_table.item_for_iteration

				if l_operand_name_occurrence_table.has (l_op_name) then
					l_occurrence := l_operand_name_occurrence_table.item (l_op_name)
					l_occurrence := l_occurrence + 1
					l_operand_name_occurrence_table.replace (l_occurrence, l_op_name)
				else
					l_operand_name_occurrence_table.put (1, l_op_name)
				end

				l_operand_position_name_table.forth
			end

			-- Reindex the operands, and put the mapping from original indexes to final indexes
			--		in `operand_reindexing_table_cache'.
			l_reindexing_table := operand_reindexing_table_cache
			check operand_reindexing_table_reset: l_reindexing_table.is_empty end

			from l_operand_types.start
			until l_operand_types.after
			loop
				l_operand := l_operand_types.key_for_iteration
				l_var_index := l_operand.index
				l_op_name := l_operand.name (l_data.variable_name_prefix)

				check l_operand_name_occurrence_table.has (l_op_name) end
				l_occurrence := l_operand_name_occurrence_table.item (l_op_name)

				-- Reindex operands after their first occurrences.
				l_reindexing_table.put_value (l_var_index, 1, l_var_index)
				from l_current_occurrence := 2
				until l_current_occurrence > l_occurrence
				loop
					l_new_index := next_available_index (l_used_indexes)
					l_used_indexes.force (l_new_index)
					l_reindexing_table.put_value (l_new_index, l_current_occurrence, l_var_index)

					l_current_occurrence := l_current_occurrence + 1
				end

				l_operand_types.forth
			end

		end

	operand_reindexing_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			-- Table for operand reindexing.
			--
			-- Value: index after reindexing
			-- Secondary key: occurrence in original test
			-- Primary key: original index of an operand
			--
			-- Suppose we have a test: v_2.foo (v_2, v_3), we will have for example v_2.foo (v_4, v_3) after reindexing.
			-- The table is like: [ <2, 1, 2>, <4, 2, 2>, <3, 1, 3> ]
		do
			if operand_reindexing_table_cache = Void then
				create operand_reindexing_table_cache.make (10)
				reindex_operands
			end
			Result := operand_reindexing_table_cache
		ensure
			result_attached: Result /= Void
		end

	next_available_index (a_set: DS_HASH_SET [INTEGER]): INTEGER
			-- Next integer that is not in 'a_set'.
		require
			set_attached: a_set /= Void
		local
			l_last, l_index: INTEGER
			l_done: BOOLEAN
		do
			l_last := a_set.last
			from l_index := l_last + 1
			until l_index > l_last + 500 or else l_done
			loop
				if not a_set.has (l_index) then
					l_done := True
					Result := l_index
				else
					l_index := l_index + 1
				end
			end

			if not l_done then
				check no_available_index_found: False end
			end
		ensure
			valid_index: Result > 0
		end

	resolve_exception_information
			-- Resolve relevant exception information from the exception trace, if any.
		require
			trace_attached: current_data /= Void and then current_data.trace_str /= Void
			exception_information_not_resolved: not is_exception_information_resolved
		local
			l_trace: STRING
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
		do
			l_trace := current_data.trace_str
			if not l_trace.is_empty then
				create l_explainer
				l_explainer.explain (l_trace)

				if l_explainer.was_successful and then l_explainer.last_explanation.is_exception_supported then
					-- Only test cases with supported exception types will be extracted.
					l_summary := l_explainer.last_explanation
					tc_exception_code_cache := l_summary.exception_code
					tc_exception_recipient_class_cache := l_summary.recipient_context_class_name.twin
					tc_exception_recipient_cache := l_summary.recipient_feature_name.twin
					tc_assertion_tag_cache := l_summary.failing_assertion_tag.twin
					tc_breakpoint_index_cache := l_summary.failing_position_breakpoint_index
				else
					is_successful := False
				end
			end

			is_exception_information_resolved := True
		ensure
			exception_information_resolved: is_exception_information_resolved
		end

	update_uuid
			-- Get a new uuid string from `uuid_generator', and reset the class name.
			-- The new uuid is available in `tc_uuid'.
		do
			tc_uuid_cache := uuid_generator.generate_uuid.out
			tc_uuid_cache.prune_all ('-')

			-- Reset class name cache.
			tc_class_name_cache := Void
		end

	current_data: detachable AUT_DESERIALIZED_DATA
			-- Current data from which the test case would be extracted.

	tuple_for_objects: STRING
			-- TUPLE representation for objects in current test case
		local
			l_vars: LIST [STRING]
			l_declaration: LIST [STRING]
			l_var_name: STRING
			l_var_index: STRING
		do
			create Result.make (256)
			Result.append_character ('[')
			l_vars := tc_all_variable_declaration.split ('%N')
			from
				l_vars.start
			until
				l_vars.after
			loop
				l_declaration := l_vars.item_for_iteration.split (':')
				l_var_name := l_declaration.first
				l_var_name.left_adjust
				l_var_name.right_adjust
				l_var_index := l_var_name.substring (3, l_var_name.count)

				if l_vars.index > 1 then
					Result.append_character (',')
				end
				Result.append (l_var_index)
				Result.append_character (',')
				Result.append (l_var_name)
				l_vars.forth
			end
			Result.append_character (']')
		end

note
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
