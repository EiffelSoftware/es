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
			l_transition_writer: SEM_FEATURE_CALL_TRANSITION_WRITER
			l_file: PLAIN_TEXT_FILE
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_transition_loader: SEM_FEATURE_CALL_TRANSITION_LOADER
			l_file_path: STRING
		do
			across data.transition_data as l_transitions loop
				if attached {SEM_FEATURE_CALL_TRANSITION} l_transitions.item.transition as l_tran then
					l_transition := l_tran.cloned_object
					l_transition.add_written_precondition
					l_transition.add_written_postcondition

					create l_transition_writer
					l_file_path := tranisition_file_path (l_transition)
					create l_file.make_create_read_write (l_file_path)
					l_transition_writer.set_output_medium (l_file)
					l_transition_writer.auxiliary_field_agents.extend (agent test_case_info_fields (?, l_transitions.item.test_case_info))
					l_transition_writer.set_is_anonymous_expression_enabled (True)
					l_transition_writer.set_is_dynamic_typed_expression_enabled (True)
					l_transition_writer.set_is_static_typed_expression_enabled (True)
					if attached {CI_TEST_CASE_SERIALIZATION_INFO} l_transitions.item.serialization_info as l_ser_info then
						l_transition_writer.set_prestate_serialization (l_ser_info.pre_serialization_as_string.twin)
						l_transition_writer.set_poststate_serialization (l_ser_info.post_serialization_as_string.twin)
					end
					l_transition_writer.write (l_transition)
					l_file.close

					create l_file.make_open_read (l_file_path)
					create l_transition_loader
					l_transition_loader.set_input (l_file)
					l_transition_loader.load
					l_file.close
				end
			end
		end

feature{NONE} -- Implementation

	test_case_info_fields (a_transition: SEM_FEATURE_CALL_TRANSITION; a_tc_info: CI_TEST_CASE_INFO): DS_HASH_SET [SEM_DOCUMENT_FIELD]
			-- Set of semantic search document fields representing the test case for `a_test_case_info'
		do
			create Result.make (10)
			Result.set_equality_tester (document_field_equality_tester)
			Result.force_last (create {SEM_DOCUMENT_FIELD}.make (test_case_class_field, a_tc_info.test_case_class.name_in_upper, string_field_type, default_boost_value))
			Result.force_last (create {SEM_DOCUMENT_FIELD}.make (test_feature_field, a_tc_info.test_feature.feature_name.as_lower, string_field_type, default_boost_value))
			Result.force_last (create {SEM_DOCUMENT_FIELD}.make (is_feature_under_test_query_field, a_tc_info.is_feature_under_test_query.out, boolean_field_type, default_boost_value))
			Result.force_last (create {SEM_DOCUMENT_FIELD}.make (is_feature_under_test_creation_field, a_tc_info.is_feature_under_test_creation.out, boolean_field_type, default_boost_value))
			Result.force_last (create {SEM_DOCUMENT_FIELD}.make (operand_variable_indexes_field, a_tc_info.operand_variable_indexes, string_field_type, default_boost_value))
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
