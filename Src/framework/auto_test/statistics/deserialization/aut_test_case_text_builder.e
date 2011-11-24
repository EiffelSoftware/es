note
	description: "Summary description for {AUT_TEST_CASE_WRITTER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_TEXT_BUILDER

inherit
	EPA_TYPE_UTILITY

feature -- Access

	last_test_case_text: STRING
			-- The test case text from the last build.

feature -- Status report

	is_last_generation_successful: BOOLEAN
			-- Is last generation successful?
			-- When True, `last_test_case_text' contains a valid test case text.

feature -- Basic operation

	generate_test_case_text (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- Generate the text for the test case file from `a_date'.
			-- Make the text available in `last_test_case_text'.
		require
			data_attached: a_data /= Void
		do
			reset
			current_data := a_data
			generate_test_case_text_internal (a_data)
		end

feature{NONE} -- Implementation

	current_data: AUT_DESERIALIZED_TEST_CASE
			-- Deserialized test case from which to generate test case class.

	generate_test_case_text_internal (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- Generate test case text internal.
		local
			l_class_str: STRING
			l_oper_dec: STRING
			l_var_dec: STRING
		do
			last_test_case_text := tc_class_template.twin
			l_class_str := last_test_case_text

				-- Class body.
			l_class_str.replace_substring_all (ph_class_name, current_data.test_case_class_name)
			l_class_str.replace_substring_all (ph_uuid, current_data.tc_uuid)
			l_class_str.replace_substring_all (ph_feature_name, tc_feature_name)
			l_class_str.replace_substring_all (ph_generation_type, tc_generation_type)
			l_class_str.replace_substring_all (ph_summary, current_data.class_and_feature_under_test)
			l_class_str.replace_substring_all (ph_var_declaration, tc_all_variable_declaration)
			l_class_str.replace_substring_all (ph_var_initialization, tc_var_initialization)
			l_class_str.replace_substring_all (ph_body, tc_body)
			l_class_str.replace_substring_all (ph_is_creation, current_data.tc_is_creation.out)
			l_class_str.replace_substring_all (ph_is_query, current_data.tc_is_query.out)
			l_class_str.replace_substring_all (ph_is_passing, current_data.tc_is_passing.out)
			l_class_str.replace_substring_all (ph_exception_code, current_data.tc_exception_code.out)
			l_class_str.replace_substring_all (ph_breakpoint_index, current_data.tc_breakpoint_index.out)
			l_class_str.replace_substring_all (ph_exception_recipient, current_data.tc_exception_recipient)
			l_class_str.replace_substring_all (ph_exception_recipient_class, current_data.tc_exception_recipient_class)
			l_class_str.replace_substring_all (ph_assertion_tag, current_data.tc_assertion_tag)
			l_class_str.replace_substring_all (ph_argument_count, current_data.tc_argument_count.out)
			l_class_str.replace_substring_all (ph_operand_table_initializer, tc_operand_table_initializer)
			l_class_str.replace_substring_all (ph_trace, current_data.tc_trace)
			l_class_str.replace_substring_all (ph_pre_serialization, tc_pre_serialization)
			l_class_str.replace_substring_all (ph_pre_object_info, tc_pre_object_info)
			l_class_str.replace_substring_all (ph_post_object_info, tc_post_object_info)

				-- Extra information.
			l_class_str.replace_substring_all (ph_start_block_string, start_block_string)
			l_class_str.replace_substring_all (ph_finish_block_string, finish_block_string)
			l_class_str.replace_substring_all (ph_class_under_test, current_data.tc_class_under_test)
			l_class_str.replace_substring_all (ph_feature_under_test, current_data.tc_feature_under_test)
			l_class_str.replace_substring_all (ph_code, current_data.tc_code)
			l_oper_dec := tc_operands_declaration.twin
			l_oper_dec.prune_all ('%R')
			l_oper_dec.prune_all ('%T')
			l_oper_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_operands_declaration_in_one_line, l_oper_dec)
			l_var_dec := tc_variables_declaration.twin
			l_var_dec.prune_all ('%R')
			l_var_dec.prune_all ('%T')
			l_var_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_var_declaration_in_one_line, l_var_dec)
			l_class_str.replace_substring_all (ph_hash_code, current_data.tc_hash_code)
			l_class_str.replace_substring_all (ph_pre_state, current_data.tc_pre_state)
			l_class_str.replace_substring_all (ph_post_state, current_data.tc_post_state)

			last_test_case_text := l_class_str
		end

	tc_body: STRING
			-- <Precursor>
		local
			l_test_call: STRING
			l_variables_table, l_operands_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
		do
			create Result.make (256)
			Result.append (once "%T%T%Tinitialize_objects%N%N")
			Result.append (once "%T%T%Tsetup_before_test%N%N")

			Result.append (once "%T%T%T%T-- Retrieve object information in pre-state.%N")
			Result.append (once "%T%T%Tif is_pre_state_information_enabled then%N")
			Result.append (once "%T%T%T%Tfinish_pre_state_calculation%N")
			Result.append (once "%T%T%Tend%N%N")

			Result.append (once "%T%T%T%T--Execute the feature under test.%N")
			Result.append (once "%T%T%Tinitialize_objects%N%N")
			Result.append (once "%T%T%Tright_before_test%N%N%T%T%T")
			Result.append (test_call)
			Result.append (once "%N%N%T%T%Tright_after_test%N")
			Result.append ("%N%N%T%T%T%T-- Retrieve object information in post-state.%N")
			Result.append ("%T%T%Tif is_post_state_information_enabled then%N")
			Result.append ("%T%T%T%Tpost_serialization_cache := ascii_string_as_array (serialized_object (special_from_tuple (")
			Result.append (tuple_for_objects)
			Result.append (")))%N")
			Result.append ("%T%T%T%Tfinish_post_state_calculation%N")
			Result.append ("%T%T%Tend%N")
			Result.append (once "%N%T%T%Tcleanup_after_test%N")
		end

	test_call: STRING
			-- Actual test as a feature call.
		local
			l_test_call: STRING
			l_operands_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_nested_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			l_op_index: INTEGER
			l_current_occurrence: INTEGER
			l_reindexing: DS_HASH_TABLE [DS_HASH_SET[INTEGER], INTEGER]
			l_op_name, l_new_name: STRING
			l_start_index, l_end_index: INTEGER
		do
			l_operands_table := current_data.operand_type_table

				-- Renaming operands in the test call.
			l_test_call := current_data.code_str.twin
			if current_data.is_feature_creation then
				l_test_call := output_type_name (l_test_call)
			end
			l_nested_table := operand_reindexing_table
			from
				l_operands_table := current_data.operand_type_table
				l_operands_table.start
			until
				l_operands_table.after
			loop
				l_op_name := l_operands_table.key_for_iteration.name (current_data.variable_name_prefix)
				l_op_index := l_operands_table.key_for_iteration.index

				check l_nested_table.has (l_op_index) end
				l_reindexing := l_nested_table.item (l_op_index)

					-- Search for all occurrences of the operand in 'l_test_call',
					-- replace them	with references to new variables.
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
						l_new_name := current_data.variable_name_prefix.twin + l_reindexing.item (l_current_occurrence).first.out
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
			Result := l_test_call
		end

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

	tc_pre_object_info: STRING
			-- String containing the types and indexes of all objects.
			-- E.g. "NONE;1;BOOLEAN;17;INTEGER_32;22".
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

feature{NONE} -- Operand re-indexing

	operand_reindexing_table: EPA_NESTED_HASH_TABLE [INTEGER, INTEGER, INTEGER]
			-- Table for operand reindexing.
			--
			-- Value: index after reindexing
			-- Secondary key: occurrence in original test
			-- Primary key: original index of an operand
			--
			-- Suppose we have a test: v_2.foo (v_2, v_3),
			-- we will have v_2.foo (v_4, v_3) after reindexing.
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

	reindex_operands
			-- Reindex operands if they are used multiple times in the test.
		local
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
			l_operand_types := current_data.operand_type_table
			l_variable_types := current_data.variable_type_table

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
			l_operand_position_name_table := current_data.operand_position_name_table
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
				l_op_name := l_operand.name (current_data.variable_name_prefix)

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

feature{NONE} -- Operands & Arguments

    tc_operand_table_initializer: STRING
            -- Code to initialize operand table.
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

	tc_all_variable_declaration: STRING
			-- Variable declaration of the generated test case.
		local
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
			if all_variable_declaration_cache = Void then
				l_variables_table := current_data.variable_type_table
				l_operands_table := current_data.operand_type_table

					-- Declaration of local variables.
				create l_variables_declaration.make (256)
				from
					l_prefix := current_data.variable_name_prefix
					l_variables_table.start
				until
					l_variables_table.after
				loop
					l_var := l_variables_table.key_for_iteration
					l_type := l_variables_table.item_for_iteration

						-- Declare a local variable if it is no operand.
					if not l_operands_table.has (l_var) then
						l_type_name := output_type_name (l_type.name)
						l_line := once "%T%T%T" + l_var.name (l_prefix) + ": " + l_type_name + once "%N"
						l_variables_declaration.append (l_line)
					end

					l_variables_table.forth
				end
				tc_variables_declaration := l_variables_declaration

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

						l_op_name := current_data.variable_name_prefix.twin + l_new_index.out
						l_type_name := output_type_name (l_type.name.twin)
						l_line := once "%T%T%T" + l_op_name + once ": " + l_type_name + once "%N"
						l_operands_declaration.append (l_line)

						l_reindexing.forth
					end

					l_operands_table.forth
				end
				tc_operands_declaration := l_operands_declaration

				all_variable_declaration_cache := l_variables_declaration.twin + l_operands_declaration
				all_variable_declaration_cache.prune_all_trailing ('%N')
			end

			Result := all_variable_declaration_cache
		end

	tc_var_initialization: STRING
			-- Text for the body of the feature `load_variables'.
		local
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
			l_variables_table := current_data.variable_type_table
			l_operands_table := current_data.operand_type_table

				-- Initialization of local variables.
			l_cursor := l_variables_table.cursor
			from
				l_prefix := current_data.variable_name_prefix
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
					l_line.replace_substring_all (once "$(VAR)", l_var.name (current_data.variable_name_prefix))
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
					l_op_name := current_data.variable_name_prefix.twin + l_new_index.out

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

	tc_operands_declaration: STRING
			-- Operands declaration.

	tc_variables_declaration: STRING
			-- Variable declarations (in STRING} of the generated test case.

	tc_pre_serialization: STRING
			-- Serialization of the objects before test.
		do
			Result := tc_serialized_data (current_data.pre_serialization)
		end

feature{NONE} -- Cache

	tc_operand_table_initializer_cache: detachable STRING
	operand_reindexing_table_cache: like operand_reindexing_table
	all_variable_declaration_cache: STRING

	reset
			-- Reset builder.
		do
				-- Reset external state.
			last_test_case_text := Void
			is_last_generation_successful := True

				-- Reset internal cache.
			tc_variables_declaration := ""
			tc_operands_declaration := ""

				-- Cache
			tc_operand_table_initializer_cache := Void
			operand_reindexing_table_cache := Void
			all_variable_declaration_cache := Void
		end

feature{NONE} -- Auxiliary features

	tc_serialized_data (a_object: ARRAY [NATURAL_8]): STRING
			-- Serialization data, i.e. an array of {NATURAL_8} values, in {STRING}.
		local
			l_data: ARRAY [NATURAL_8]
			l_index: INTEGER
			l_line: STRING
		do
			l_data := a_object

			from
				create Result.make (l_data.count * 4 + 1)
				create l_line.make (128)
				l_index := l_data.lower
			until
				l_index > l_data.upper
			loop
				l_line.append (l_data[l_index].out)
				if l_index < l_data.upper then
					l_line.append (", ")
				end

				if l_line.count > 120 or else l_index >= l_data.upper then
					l_line.append ("%N")
					Result.append (l_line)
					l_line.wipe_out
				end

				l_index := l_index + 1
			end
			Result.prune_all_trailing ('%N')
		end

	truncate_class_name (a_length: INTEGER)
			-- Truncate the class name so that it contains no more than 'a_length' characters.
			-- Due to the constraint on the length of file name, we need to truncate the extra part.
			-- This may result in incomplete information in the file name.
		local
			l_name: STRING
		do
--			l_name := tc_class_name
--			check class_name_attached: l_name /= Void end
--			if l_name.count > a_length then
--				error_handler.report_warning_message ("Class name truncated: " + l_name)
--				tc_class_name_cache := l_name.substring (1, a_length)
--			end
		end

feature{NONE} -- Constants

	ph_class_name: STRING = "$(CLASS_NAME)"
	ph_feature_name: STRING = "$(FEATURE_NAME)"
	ph_success_status: STRING = "$(STATUS)"
	ph_exception_code: STRING = "$(EXCEPTION_CODE)"
	ph_breakpoint_index: STRING = "$(BREAKPOINT_INDEX)"
	ph_assertion_tag: STRING = "$(ASSERTION_TAG)"
	ph_hash_code: STRING = "$(HASH_CODE)"
	ph_uuid: STRING = "$(UUID)"
	ph_generation_type: STRING = "$(GENERATION_TYPE)"
	ph_summary: STRING = "$(SUMMARY)"
	ph_var_declaration: STRING = "$(VAR_DECLARATION)"
	ph_body: STRING = "$(BODY)"
	ph_trace: STRING = "$(TRACE)"
	ph_pre_serialization: STRING = "$(PRE_SERIALIZATION)"
	ph_post_serialization: STRING = "$(POST_SERIALIZATION)"
	ph_is_creation: STRING = "$(IS_CREATION)"
	ph_is_query: STRING = "$(IS_QUERY)"
	ph_is_passing: STRING = "$(IS_PASSING)"
	ph_exception_recipient: STRING = "$(EXCEPTION_RECIPIENT)"
	ph_exception_recipient_class: STRING = "$(EXCEPTION_RECIPIENT_CLASS)"
	ph_argument_count: STRING = "$(ARGUMENT_COUNT)"
	ph_operand_table_initializer: STRING = "$(OPERAND_TABLE_INITIALIZER)"
	ph_operand_index: STRING = "$(OPERAND_INDEX)"
	ph_var_index: STRING = "$(VAR_INDEX)"
	ph_start_block_string: STRING = "$(START_BLOCK_STRING)"
	ph_finish_block_string: STRING = "$(FINISH_BLOCK_STRING)"
	ph_pre_object_info: STRING = "$(PRE_OBJECT_INFO)"
	ph_post_object_info: STRING = "$(POST_OBJECT_INFO)"
	ph_var_initialization: STRING = "$(VAR_INITIALIZATION)"

	ph_class_under_test: STRING = "$(CLASS_UNDER_TEST)"
	ph_feature_under_test: STRING = "$(FEATURE_UNDER_TEST)"
	ph_code: STRING = "$(CODE)"
	ph_operands_declaration_in_one_line: STRING = "$(OPERANDS_DECLARATION_IN_ONE_LINE)"
	ph_var_declaration_in_one_line: STRING = "$(VAR_DECLARATION_IN_ONE_LINE)"
	ph_pre_state: STRING = "$(PRE_STATE)"
	ph_post_state: STRING = "$(POST_STATE)"
	ph_feature_type: STRING = "$(FEATURE_TYPE)"
	ph_command: STRING = "CMD"
	ph_function: STRING = "FUN"
	ph_attribute: STRING = "ATT"

	tc_name_extension: STRING = "e"
	tc_feature_name: STRING = "generated_test_1"
	tc_generation_type: STRING = "AutoTest test case extracted from serialization"

	tc_class_name_template: STRING = "TC__$(CLASS_UNDER_TEST)__$(FEATURE_UNDER_TEST)__$(FEATURE_TYPE)__$(STATUS)__c$(EXCEPTION_CODE)__b$(BREAKPOINT_INDEX)__REC_$(EXCEPTION_RECIPIENT_CLASS)__$(EXCEPTION_RECIPIENT)__TAG_$(ASSERTION_TAG)__$(HASH_CODE)__$(UUID)"
	tc_var_initialization_template: STRING = "$(VAR) ?= pre_variable_table[$(INDEX)]%N"
	tc_operand_table_initializer_template: STRING = "%T%T%T%Ttci_operand_table_cache.put ($(VAR_INDEX),$(OPERAND_INDEX))"

	tc_class_template: STRING = "[
class
	$(CLASS_NAME)

inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routine

    $(FEATURE_NAME)
        note
            testing: "$(GENERATION_TYPE)"
            testing: "$(SUMMARY)"
        do
$(BODY)
        end

feature -- Test case information

$(VAR_DECLARATION)

	initialize_objects
			-- Initialize object used in current test case.
		do
			wipe_out_caches
$(VAR_INITIALIZATION)
		end

	tci_class_name: STRING do Result := "$(CLASS_NAME)" end
			-- Name of current class.

	tci_class_uuid: STRING do Result := "$(UUID)" end
			-- UUID of current test case.

	tci_class_under_test: STRING do Result := "$(CLASS_UNDER_TEST)" end
			-- Name of the class under test.

	tci_feature_under_test: STRING do Result := "$(FEATURE_UNDER_TEST)" end
			-- Name of the feature under test.

	tci_pre_object_info: STRING do Result := "$(PRE_OBJECT_INFO)" end
			-- Information about objects in current test case in pre-state
			-- Format: TYPE_1;position1;TYPE_2;position2;...;TYPE_n;position_n.

	tci_post_object_info: STRING do Result := "$(POST_OBJECT_INFO)" end
			-- Information about objects in current test case in post-state
			-- Format: TYPE_1;object_id1;TYPE_2;object_id2;...;TYPE_n;object_id_n.

	tci_is_creation: BOOLEAN = $(IS_CREATION)
			-- Is the feature under test a creation feature?

	tci_is_query: BOOLEAN = $(IS_QUERY)
			-- Is the feature under test a query?

	tci_is_passing: BOOLEAN = $(IS_PASSING)
			-- Is the test case passing?

	tci_exception_code: INTEGER = $(EXCEPTION_CODE)
			-- Exception code. 0 for passing test cases.

	tci_breakpoint_index: INTEGER = $(BREAKPOINT_INDEX)
			-- Breakpoint index where the test case fails.

	tci_assertion_tag: STRING do Result := "$(ASSERTION_TAG)" end
			-- Tag of the violated assertion, if any.
			-- Empty string for passing test cases.

	tci_exception_recipient_class: STRING do Result := "$(EXCEPTION_RECIPIENT_CLASS)" end
			-- Class of the recipient feature of the exception, same as `tci_class_under_test' in passing test cases.

	tci_exception_recipient: STRING do Result := "$(EXCEPTION_RECIPIENT)" end
			-- Feature of the exception recipient, same as `tci_feature_under_test' in passing test cases.

    tci_exception_trace: STRING
			-- Exception trace.
		do
			Result :=
--<exception_trace>
$(TRACE)
--</exception_trace>
		end

	tci_argument_count: INTEGER = $(ARGUMENT_COUNT)
			-- Number of arguments of the feature under test.

	tci_operand_table: HASH_TABLE[INTEGER, INTEGER]
			-- key is operand position index (0 means target, 1 means the first argument,
			-- and argument_count + 1 means the result, if any), value is the variable
			-- index of that operand.
		do
			if tci_operand_table_cache = Void then
				create tci_operand_table_cache.make ($(ARGUMENT_COUNT) + 2)
$(OPERAND_TABLE_INITIALIZER)
			end
			Result := tci_operand_table_cache
		end

feature -- Serialization data

    pre_serialization: ARRAY [NATURAL_8]
            -- Serialized test case data before the transition.
        do
            Result := <<
--<pre_serialization>
$(PRE_SERIALIZATION)
--</pre_serialization>
>>
        end

    post_serialization: ARRAY [NATURAL_8]
    		-- Serialized test case data after the transition.
    	do
    		if is_post_state_information_enabled then
    			Result := post_serialization_cache
    		else
    			create Result.make (1, 0)
    		end
		end

feature{NONE} -- Implementation

	post_serialization_cache: detachable like post_serialization
			-- Cache for `post_serialization'

	tci_operand_table_cache: detachable like tci_operand_table
			-- Cache for `tci_operand_table'

;note
  extra_information:
$(START_BLOCK_STRING)
--<extra_information>
--<class_under_test>$(CLASS_UNDER_TEST)</class_under_test>
--<feature_under_test>$(FEATURE_UNDER_TEST)</feature_under_test>
--<code>$(CODE)</code>
--<operands_declaration>$(OPERANDS_DECLARATION_IN_ONE_LINE)</operands_declaration>
--<variable_declaration>$(VAR_DECLARATION_IN_ONE_LINE)</variable_declaration>
--<hash_code>$(HASH_CODE)</hash_code>
--<pre_state>
$(PRE_STATE)
--</pre_state>
--<post_state>
$(POST_STATE)
--</post_state>
--</extra_information>
$(FINISH_BLOCK_STRING)
end
		]"

	start_block_string: STRING = "%"["
	finish_block_string: STRING = "]%""

	start_extra_information_tag: STRING = "<extra_information>"
	finish_extra_information_tag: STRING = "</extra_information>"

	start_exception_trace_tag: STRING = "<exception_trace>"
	finish_exception_trace_tag: STRING = "</exception_trace>"

	start_pre_object_tag: STRING = "<pre_serialization>"
	finish_pre_object_tag: STRING = "</pre_serialization>"

	start_class_under_test_tag: STRING = "<class_under_test>"
	finish_class_under_test_tag: STRING = "</class_under_test>"

	start_feature_under_test_tag: STRING = "<feature_under_test>"
	finish_feature_under_test_tag: STRING = "</feature_under_test>"

	start_operands_declaration_tag: STRING = "<operands_declaration>"
	finish_operands_declaration_tag: STRING = "</operands_declaration>"

	start_variable_declaration_tag: STRING = "<variable_declaration>"
	finish_variable_declaration_tag: STRING = "</variable_declaration>"

	start_hashcode_tag: STRING = "<hash_code>"
	finish_hashcode_tag: STRING = "</hash_code>"

	start_pre_state_report_tag: STRING = "<pre_state>"
	finish_pre_state_report_tag: STRING = "</pre_state>"

	start_post_state_report_tag: STRING = "<post_state>"
	finish_post_state_report_tag: STRING = "</post_state>"


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
