note
	description: "Summary description for {CI_FEATURE_CALL_TRANSITION_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FEATURE_CALL_TRANSITION_LOADER

inherit
	SEM_FIELD_NAMES

	EPA_UTILITY

	CI_SHARED_EQUALITY_TESTERS

feature -- Access

	last_feature_call_transition: SEM_FEATURE_CALL_TRANSITION
			-- Last transition loaded by `load_from_file'

	last_test_case_info: CI_TEST_CASE_INFO
			-- Last test case info loaded by `load_from_file'

	last_serialization_info: CI_TEST_CASE_SERIALIZATION_INFO
			-- Last serialization info loaded by `load_from_file'

	last_integer_bounded_functions: HASH_TABLE [DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN], BOOLEAN]
			-- Integer bounded functions loaded by `load_from_file'
			-- Key is a boolean indicating pre-/post-state.
			-- Value is the set of functions in that state.

feature -- Basic operations

	load_from_file (a_absolute_path: STRING)
			-- Load feature call from file with `a_absolute_path',
			-- make result available at `last_feature_call_transition',
			-- `last_test_case_info' and `last_serialization_info'.
		local
			l_data: like transition_data_from_file
		do
			l_data := transition_data_from_file (a_absolute_path)
			last_feature_call_transition := l_data.transition
			last_test_case_info := l_data.test_case_info
			last_serialization_info := l_data.serialization_info
			last_integer_bounded_functions := l_data.integer_bounded_functions
		end

feature{NONE} -- Implementation

	transition_data_from_file (a_file_path: STRING): TUPLE [transition: SEM_FEATURE_CALL_TRANSITION; test_case_info: CI_TEST_CASE_INFO; serialization_info: CI_TEST_CASE_SERIALIZATION_INFO; integer_bounded_functions: HASH_TABLE [DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN], BOOLEAN]]
			-- Transition data from `a_file_path'
		local
			l_file: PLAIN_TEXT_FILE
			l_transition_loader: SEM_FEATURE_CALL_TRANSITION_LOADER
			l_test_case_info: CI_TEST_CASE_INFO
			l_serialization_info: CI_TEST_CASE_SERIALIZATION_INFO
			l_bounded_functions: like bounded_functions_from_fields
		do
			create l_file.make_open_read (a_file_path)
			create l_transition_loader
			l_transition_loader.set_medium (l_file)
			l_transition_loader.load
			l_file.close

			l_test_case_info := test_case_info_from_fields (l_transition_loader.fields)
			l_serialization_info := serialization_info_from_fields (l_transition_loader.last_queryable, l_test_case_info, l_transition_loader.fields)
			l_bounded_functions := bounded_functions_from_fields (l_transition_loader.last_queryable, l_transition_loader.fields)
			Result := [l_transition_loader.last_queryable, l_test_case_info, l_serialization_info, l_bounded_functions]
		end

	bounded_functions_from_fields (a_transition: SEM_FEATURE_CALL_TRANSITION; a_fields: HASH_TABLE [IR_FIELD, STRING]): HASH_TABLE [DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN], BOOLEAN]
			-- Bounded functions from `a_fields'
		local
			l_field_name: STRING
			l_parts: LIST [STRING]
			l_context: EPA_CONTEXT
			l_target_operand_index: INTEGER
			l_target_variable_name: STRING
			l_function_name: STRING
			l_lower_bound: INTEGER
			l_upper_bound: INTEGER
			l_lower_bound_expr: STRING
			l_upper_bound_expr: STRING
			l_func: CI_FUNCTION_WITH_INTEGER_DOMAIN
			l_func_set: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
		do
			l_context := a_transition.context

			create Result.make (2)
			create l_func_set.make (10)
			l_func_set.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)
			Result.force (l_func_set, True)
			create l_func_set.make (10)
			l_func_set.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)
			Result.force (l_func_set, False)

			across <<True, False>> as l_states loop
				l_func_set := Result.item (l_states.item)
				if l_states.item then
					l_field_name := prestate_bounded_functions_field
				else
					l_field_name := poststate_bounded_functions_field
				end

				a_fields.search (l_field_name)
				if a_fields.found then
					across string_slices (a_fields.found_item.value.text, field_value_separator.out) as l_functions loop
						l_parts := l_functions.item.split (';')
						l_target_operand_index := l_parts.i_th (1).to_integer
						l_target_variable_name := l_parts.i_th (2)
						l_function_name := l_parts.i_th (3)
						l_lower_bound := l_parts.i_th (4).to_integer
						l_upper_bound := l_parts.i_th (5).to_integer
						l_lower_bound_expr := l_parts.i_th (6)
						l_upper_bound_expr := l_parts.i_th (7)
						create l_func.make (l_target_operand_index, l_target_variable_name, l_function_name, l_lower_bound, l_upper_bound, l_context, l_lower_bound_expr, l_upper_bound_expr)
						l_func_set.force_last (l_func)
					end
				end
			end
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
			l_is_passing: BOOLEAN
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

			a_fields.search (test_case_status_field)
			l_is_passing := a_fields.found_item ~ test_case_status_passing
			create Result.make_with_data (l_test_case_class, l_test_feature, l_class_under_test, l_feature_under_test, l_is_query, l_is_creation, l_operand_variable_indexes ,l_is_passing)
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

end
