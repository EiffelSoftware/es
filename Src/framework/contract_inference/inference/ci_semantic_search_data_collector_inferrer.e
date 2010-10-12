note
	description: "Class to generate semantic search related data. Note: This class does not infer contracts, it instead generates data for semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEMANTIC_SEARCH_DATA_COLLECTOR_INFERRER

inherit
	CI_INFERRER

	SEM_SHARED_EQUALITY_TESTER

	SEM_FIELD_NAMES

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- Initialize.
			data := a_data
			setup_data_structures

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts

			process_transitions
		end

feature{NONE} -- Implementation

	process_transitions
			-- Process transitions.
		local
			l_file_path: STRING
			l_loaded_data: like transition_data_from_file
		do
			across data.transition_data as l_transitions loop
				if attached {SEM_FEATURE_CALL_TRANSITION} l_transitions.item.transition as l_tran then
						-- Store current transition into a file.
					l_file_path := tranisition_file_path (l_tran)
					write_transition_into_file (l_transitions.item, l_file_path)

						-- Load transition from the stored file and restore it, to validate equality.
--					l_loaded_data := transition_data_from_file (l_file_path)
--					write_transition_into_file (l_loaded_data.transition, l_loaded_data.test_case_info, l_loaded_data.serialization_info, l_file_path + "2")
				end
			end
		end

feature{NONE} -- Implementation

	write_transition_into_file (a_transition_data: CI_TEST_CASE_TRANSITION_INFO; a_file_path: STRING)
			-- Write transition into `a_file_path'.
		local
			l_transition_writer: SEM_FEATURE_CALL_TRANSITION_WRITER
			l_file: PLAIN_TEXT_FILE
			l_transition: SEM_FEATURE_CALL_TRANSITION
		do
			l_transition := a_transition_data.transition.cloned_object
			l_transition.add_written_precondition
			l_transition.add_written_postcondition

			create l_file.make_create_read_write (a_file_path)
			create l_transition_writer.make_with_medium (l_file)
			l_transition_writer.auxiliary_field_agents.extend (agent test_case_info_fields (?, a_transition_data))
			l_transition_writer.write (l_transition)
			l_file.close
		end

	transition_data_from_file (a_file_path: STRING): TUPLE [transition: SEM_FEATURE_CALL_TRANSITION; test_case_info: CI_TEST_CASE_INFO; serialization_info: CI_TEST_CASE_SERIALIZATION_INFO]
			-- Transition data from `a_file_path'
		local
			l_file: PLAIN_TEXT_FILE
			l_transition_loader: SEM_FEATURE_CALL_TRANSITION_LOADER
			l_test_case_info: CI_TEST_CASE_INFO
			l_serialization_info: CI_TEST_CASE_SERIALIZATION_INFO
		do
			create l_file.make_open_read (a_file_path)
			create l_transition_loader
			l_transition_loader.set_medium (l_file)
			l_transition_loader.load
			l_file.close

			l_test_case_info := test_case_info_from_fields (l_transition_loader.fields)
			l_serialization_info := serialization_info_from_fields (l_transition_loader.last_queryable, l_test_case_info, l_transition_loader.fields)
			Result := [l_transition_loader.last_queryable, l_test_case_info, l_serialization_info]
		end

feature{NONE} -- Implementation

	test_case_info_fields (a_transition: SEM_FEATURE_CALL_TRANSITION; a_transition_info: CI_TEST_CASE_TRANSITION_INFO): DS_HASH_SET [IR_FIELD]
			-- Set of semantic search document fields representing the test case for `a_test_case_info' and `a_serialization_info'.
		do
			create Result.make (10)

				-- Setup fields for test case information.
			Result.set_equality_tester (ir_field_equality_tester)
			Result.force_last (create {IR_FIELD}.make_as_string (test_case_class_field, a_transition_info.test_case_info.test_case_class.name_in_upper, default_boost_value))
			Result.force_last (create {IR_FIELD}.make_as_string (test_feature_field, a_transition_info.test_case_info.test_feature.feature_name.as_lower, default_boost_value))
			Result.force_last (create {IR_FIELD}.make_as_boolean (is_feature_under_test_query_field, a_transition_info.test_case_info.is_feature_under_test_query, default_boost_value))
			Result.force_last (create {IR_FIELD}.make_as_boolean (is_feature_under_test_creation_field, a_transition_info.test_case_info.is_feature_under_test_creation, default_boost_value))
			Result.force_last (create {IR_FIELD}.make_as_string (operand_variable_indexes_field, a_transition_info.test_case_info.operand_variable_indexes, default_boost_value))

				-- Setup fields for object serialization.
			if a_transition_info.serialization_info /= Void then
				Result.force_last (create {IR_FIELD}.make_as_string (prestate_serialization_field, a_transition_info.serialization_info.pre_serialization_as_string.twin, default_boost_value))
				Result.force_last (create {IR_FIELD}.make_as_string (poststate_serialization_field, a_transition_info.serialization_info.post_serialization_as_string.twin, default_boost_value))
			end

				-- Setup fields for integer-bounded functions.
			across a_transition_info.integer_bounded_functions as l_states loop
				Result.force_last (feild_for_integer_bounded_functions (l_states.item, l_states.key))
			end
		end

	feild_for_integer_bounded_functions (a_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]; a_pre_state: BOOLEAN): IR_FIELD
			-- Field for `a_function'
			-- `a_pre_state' inidcates prestate or poststate.
		local
			l_field_name: STRING
			l_cursor: DS_HASH_SET_CURSOR [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			l_value: STRING
			l_func: CI_FUNCTION_WITH_INTEGER_DOMAIN
		do
			if a_pre_state then
				l_field_name := prestate_bounded_functions_field
			else
				l_field_name := poststate_bounded_functions_field
			end

			create l_value.make (256)
			from
				l_cursor := a_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_func := l_cursor.item
				l_value.append (l_func.target_operand_index.out)
				l_value.append_character (';')
				l_value.append (l_func.target_variable_name)
				l_value.append_character (';')
				l_value.append (l_func.function_name)
				l_value.append_character (';')
				l_value.append (l_func.lower_bound.out)
				l_value.append_character (';')
				l_value.append (l_func.upper_bound.out)
				l_value.append_character (';')
				l_value.append (l_func.lower_bound_expression)
				l_value.append_character (';')
				l_value.append (l_func.upper_bound_expression)

				if not l_cursor.is_last then
					l_value.append_character (field_value_separator)
				end
				l_cursor.forth
			end
			create Result.make_as_string (l_field_name, l_value, default_boost_value)
		end

	test_case_info_from_fields (a_fields: HASH_TABLE [IR_FIELD, STRING]): CI_TEST_CASE_INFO
			-- Test case info from `a_fields'
		local
			l_class_under_test: CLASS_C
			l_feature_under_test: FEATURE_I
			l_test_case_class: CLASS_C
			l_test_feature: FEATURE_I
			l_is_query: BOOLEAN
			l_is_creation: BOOLEAN
			l_operand_variable_indexes: STRING
		do
			a_fields.search (test_case_class_field)
			l_test_case_class := first_class_starts_with_name (a_fields.found_item.value.text)

			a_fields.search (test_feature_field)
			l_test_feature := l_test_case_class.feature_named (a_fields.found_item.value.text)

			a_fields.search (is_feature_under_test_query_field)
			l_is_query := a_fields.found_item.value.text.to_boolean

			a_fields.search (is_feature_under_test_creation_field)
			l_is_query := a_fields.found_item.value.text.to_boolean

			a_fields.search (operand_variable_indexes_field)
			l_operand_variable_indexes := a_fields.found_item.value.text

			a_fields.search (class_field)
			l_class_under_test := first_class_starts_with_name (a_fields.found_item.value.text)

			a_fields.search (feature_field)
			l_feature_under_test := l_class_under_test.feature_named (a_fields.found_item.value.text)

			create Result.make_with_data (l_test_case_class, l_test_feature, l_class_under_test, l_feature_under_test, l_is_query, l_is_creation, l_operand_variable_indexes)
		end

	serialization_info_from_fields (a_transition: SEM_FEATURE_CALL_TRANSITION; a_test_case_info: CI_TEST_CASE_INFO; a_fields: HASH_TABLE [IR_FIELD, STRING]): CI_TEST_CASE_SERIALIZATION_INFO
			-- Test case serialization information from `a_fields'
		local
			l_object_info: HASH_TABLE [TYPE_A, INTEGER]
			l_vars: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_var_name: STRING
			l_prefix_count: INTEGER
			l_objects: STRING
			l_pre_serialization, l_post_serialization: STRING
			l_operand_variable_indexes: STRING
		do
			l_prefix_count := default_variable_prefix.count
			create l_object_info.make (20)
			create l_objects.make (128)
			from
				l_vars := a_transition.variables.new_cursor
				l_vars.start
			until
				l_vars.after
			loop
				l_var_name := l_vars.item.text
				l_objects.append (output_type_name (l_vars.item.type.name))
				l_objects.append_character (';')
				l_objects.append (l_var_name.substring (l_prefix_count + 1, l_var_name.count))
				if not l_vars.is_last then
					l_objects.append_character (';')
				end
				l_vars.forth
			end

			a_fields.search (prestate_serialization_field)
			l_pre_serialization := a_fields.found_item.value.text

			a_fields.search (poststate_serialization_field)
			l_post_serialization := a_fields.found_item.value.text

			a_fields.search (operand_variable_indexes_field)
			l_operand_variable_indexes := a_fields.found_item.value.text

			create Result.make (a_test_case_info, l_pre_serialization, l_post_serialization, l_operand_variable_indexes, l_objects, l_objects)
		end

	tranisition_file_path (a_transition: SEM_FEATURE_CALL_TRANSITION): STRING
			-- Absolute path for the file to store the semantic document for `a_transition'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.semantic_search_document_directory)
			l_path.set_file_name (a_transition.class_.name_in_upper + "__" + a_transition.feature_.feature_name.as_lower + "__" + uuid_generator.generate_uuid.out + ".tran")
			Result := l_path.out
		end

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

end
