note
	description: "Class to output transition/object data for SQL-based semantic search engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SQL_INFERRER

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
					write_transition_into_file (l_transitions.item, l_file_path, l_uuid, l_transitions.item.serialization_info)

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
			create l_path.make_from_string (config.sql_directory)
			l_path.set_file_name (once "tran_" + a_transition.class_.name_in_upper + "__" + a_transition.feature_.feature_name.as_lower + "__" + a_uuid.out + ".ssql")
			Result := l_path.out
		end

	object_file_path (a_transition: SEM_FEATURE_CALL_TRANSITION; a_uuid: UUID): STRING
			-- Absolute path for the file to store the semantic document for post-state objects in `a_transition'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.sql_directory)
			l_path.set_file_name (once "objt_" + a_transition.class_.name_in_upper + "__" + a_transition.feature_.feature_name.as_lower + "__" + a_uuid.out + ".ssql")
			Result := l_path.out
		end

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

	write_transition_into_file (a_transition_data: CI_TEST_CASE_TRANSITION_INFO; a_file_path: STRING; a_uuid: UUID; a_serialization: detachable CI_TEST_CASE_SERIALIZATION_INFO)
			-- Write transition into `a_file_path'.
		local
			l_transition_writer: SQL_FEATURE_CALL_WRITER
			l_file: PLAIN_TEXT_FILE
			l_transition: SEM_FEATURE_CALL_TRANSITION
		do
			l_transition := a_transition_data.transition.cloned_object
			l_transition.add_written_precondition
			l_transition.add_written_postcondition

			create l_file.make_create_read_write (a_file_path)
			create l_transition_writer.make_with_medium (l_file)
			l_transition_writer.set_uuid (a_uuid)
			if a_serialization /= Void then
				l_transition_writer.set_pre_state_serialization (a_serialization.pre_serialization_as_string)
				l_transition_writer.set_pre_state_object_info (a_serialization.pre_object_type_as_string)
			end

				-- Setup exception related data if Current test case is a failing one.
			if not a_transition_data.test_case_info.is_passing then
				l_transition_writer.set_recipient (a_transition_data.test_case_info.recipient)
				l_transition_writer.set_recipient_class (a_transition_data.test_case_info.recipient_class)
				l_transition_writer.set_exception_break_point_slot (a_transition_data.test_case_info.exception_break_point_slot)
				l_transition_writer.set_exception_code (a_transition_data.test_case_info.exception_code)
				l_transition_writer.set_exception_meaning (a_transition_data.test_case_info.exception_meaning)
				l_transition_writer.set_exception_trace (a_transition_data.test_case_info.exception_trace)
				l_transition_writer.set_exception_tag (a_transition_data.test_case_info.exception_tag)
				l_transition_writer.set_fault_id (a_transition_data.test_case_info.fault_id)
			end
			l_transition_writer.write (l_transition)
			l_file.close
		end

	write_object_into_file (a_transition_data: CI_TEST_CASE_TRANSITION_INFO; a_file_path: STRING; a_uuid: UUID)
			-- Write post-state object from `a_transition_data' into `a_file_path'.
		local
			l_file: PLAIN_TEXT_FILE
			l_writer: SQL_OBJECTS_WRITER
			l_objects: SEM_OBJECTS
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_file.make_create_read_write (a_file_path)
				create l_writer.make_with_medium (l_file)
				l_writer.set_uuid (a_uuid)
				if a_transition_data.transition.is_passing then
					create l_objects.make (a_transition_data.transition.context, a_transition_data.transition.variable_positions)
--					create l_objects.make_with_serialization (a_transition_data.transition.context, a_transition_data.serialization_info.post_serialization)
					l_objects.set_serialization_internal (a_transition_data.serialization_info.post_serialization)
					l_objects.set_properties (a_transition_data.transition.postconditions)
					l_writer.set_pre_state_object_info (a_transition_data.serialization_info.post_object_type_as_string)
				else
--					fixme ("We only use pre-state serialization because quite often, post-state serialization will cause a deserialization mismatch crash, don't know why. Perhaps because we evaluated expressions through the debugger. 30.10.2010 Jasonw")
					create l_objects.make (a_transition_data.transition.context, a_transition_data.transition.variable_positions)
					l_objects.set_serialization_internal (a_transition_data.serialization_info.pre_serialization)
					l_objects.set_properties (a_transition_data.transition.preconditions)
					l_writer.set_pre_state_object_info (a_transition_data.serialization_info.pre_object_type_as_string)
--					create l_objects.make_with_serialization (a_transition_data.transition.context, a_transition_data.serialization_info.pre_serialization)
--					l_objects.set_properties (a_transition_data.transition.preconditions)
				end

				l_writer.write (l_objects)
				l_file.close
			end
		rescue
			l_retried := True
			if l_file /= Void and then l_file.is_open_write then
				l_file.close
			end
			retry
		end

end

