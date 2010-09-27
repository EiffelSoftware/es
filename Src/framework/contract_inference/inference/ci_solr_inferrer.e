note
	description: "Inferred to generate Solr related files (instead of actually inferring contracts)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SOLR_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
			data := a_data
			setup_data_structures

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts

				-- Generate Solr files.
			process_transitions
		end

feature{NONE} -- Implementation

	process_transitions
			-- Process transitions.
		local
			l_file_path: STRING
			l_uuid: UUID

		do
			across data.transition_data as l_transitions loop
				if attached {SEM_FEATURE_CALL_TRANSITION} l_transitions.item.transition as l_tran then
						-- Store current transition into a file.
					l_uuid := uuid_generator.generate_uuid
					l_file_path := tranisition_file_path (l_tran, l_uuid)
					write_transition_into_file (l_transitions.item, l_file_path, l_uuid)

						-- Store post-state objects into a file.
					if attached {CI_TEST_CASE_SERIALIZATION_INFO} l_transitions.item.serialization_info as l_serialization then
						l_uuid := uuid_generator.generate_uuid
						l_file_path := object_file_path (l_tran, l_uuid)
						write_object_into_file (l_transitions.item, l_file_path, l_uuid)
					end
				end
			end
		end

	tranisition_file_path (a_transition: SEM_FEATURE_CALL_TRANSITION; a_uuid: UUID): STRING
			-- Absolute path for the file to store the semantic document for `a_transition'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.solr_directory)
			l_path.set_file_name (once "tran_" + a_transition.class_.name_in_upper + "__" + a_transition.feature_.feature_name.as_lower + "__" + a_uuid.out + ".solr")
			Result := l_path.out
		end

	object_file_path (a_transition: SEM_FEATURE_CALL_TRANSITION; a_uuid: UUID): STRING
			-- Absolute path for the file to store the semantic document for post-state objects in `a_transition'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.solr_directory)
			l_path.set_file_name (once "objt_" + a_transition.class_.name_in_upper + "__" + a_transition.feature_.feature_name.as_lower + "__" + a_uuid.out + ".solr")
			Result := l_path.out
		end

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

	write_transition_into_file (a_transition_data: CI_TEST_CASE_TRANSITION_INFO; a_file_path: STRING; a_uuid: UUID)
			-- Write transition into `a_file_path'.
		local
			l_transition_writer: SOLR_FEATURE_CALL_WRITER
			l_file: PLAIN_TEXT_FILE
			l_transition: SEM_FEATURE_CALL_TRANSITION
		do
			l_transition := a_transition_data.transition.cloned_object
			l_transition.add_written_precondition
			l_transition.add_written_postcondition

			create l_file.make_create_read_write (a_file_path)
			create l_transition_writer.make_with_medium (l_file)
			l_transition_writer.set_uuid (a_uuid)
			l_transition_writer.write (l_transition)
			l_file.close
		end

	write_object_into_file (a_transition_data: CI_TEST_CASE_TRANSITION_INFO; a_file_path: STRING; a_uuid: UUID)
			-- Write post-state object from `a_transition_data' into `a_file_path'.
		local
			l_writer: SOLR_OBJECTS_WRITER
			l_file: PLAIN_TEXT_FILE
			l_object_writer: SOLR_OBJECTS_WRITER
			l_objects: SEM_OBJECTS
		do
			create l_file.make_create_read_write (a_file_path)
			create l_objects.make_with_serialization (a_transition_data.transition.context, a_transition_data.serialization_info.post_serialization)
			l_objects.set_properties (a_transition_data.transition.postconditions)

			create l_writer.make_with_medium (l_file)
			l_writer.set_uuid (a_uuid)
			l_writer.write (l_objects)
			l_file.close
		end

end
