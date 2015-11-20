note
	description: "[
		Interpreter for line based Eiffel like interpreter language.
		Depends on a generated Erl-G reflection library.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_INTERPRETER

inherit
	ANY

	EXCEPTIONS

	ARGUMENTS_32
		export {NONE} all end

	ITP_SHARED_CONSTANTS
		export {NONE} all end

	ERL_CONSTANTS
		export {NONE} all end

	EXECUTION_ENVIRONMENT
		rename
			command_line as command_line_arguments
		export
			{NONE} all
		end

	SED_STORABLE_FACILITIES
		export
			{NONE} all
		end

	EQA_EXTERNALS

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	DT_SHARED_SYSTEM_CLOCK

create
	execute

feature {NONE} -- Initialization

	execute
			-- Execute interpreter.
			-- Command line for current: interpreter <port> <melt feature id> <log file>
			-- <port> is the port number used in socket IPC
			-- <melt feature id> is the feature body ID whose byte-code is to be injected
			-- <log file> is the file to store logs.
		local
			l_log_filename: IMMUTABLE_STRING_32
			l_server_url: IMMUTABLE_STRING_32
			l_port: INTEGER
			l_tc_serialization_file_name: STRING
			l_state_file_name: FILE_NAME
		do
			if argument_count < 6 then
				check Wrong_number_of_arguments: False end
			end
				-- Read command line argument
				-- Note that `l_server_ulr' is still read even though not used
				-- because we use the loopback of the current machine to communicate
				-- and thus avoid firewall issues.
			l_server_url := argument (1)
			l_port := argument (2).to_integer
			byte_code_feature_body_id := argument (3).to_integer
			byte_code_feature_pattern_id := argument (4).to_integer
			l_log_filename := argument (5)
			interpreter_log_directory := l_log_filename.substring (1, l_log_filename.count - 19).as_string_8
			should_generate_log := argument (6).to_boolean

				-- Setup file to store serialized test case.
			if argument_count = 12 then
				is_passing_test_case_serialized := argument (7).to_boolean
				is_failing_test_case_serialized := argument (8).to_boolean
				l_tc_serialization_file_name := argument (9).as_string_8
				is_test_case_serialization_enabled := True
				is_duplicated_test_case_serialized := argument (10).to_boolean
				is_post_state_serialized := argument (11).to_boolean
				is_last_test_case_serialization_passed_to_proxy := argument (12).to_boolean
			else
				is_failing_test_case_serialized := True
				l_tc_serialization_file_name := ""
				is_test_case_serialization_enabled := False
			end

				-- Redirect standard output to `output_buffer'.
			create output_buffer.make (buffer_size)
			create error_buffer.make (buffer_size)

				-- Create object pool
			create object_store.make
			object_store.set_is_typed_search_enabled (is_test_case_serialization_enabled)

				-- Create agent creation information book-keeper.
			create agent_creation_info.make (200)

				-- Create storage for object state retrieval.
			initialize_query_value_holders

			create primitive_types.make (10)
			primitive_types.put (1, "INTEGER_32")
			primitive_types.put (2, "BOOLEAN")

				-- Create log file.
			create log_file.make_with_name (l_log_filename)
			log_file.open_append
			if not log_file.is_open_write then
				report_error ("could not open log file '" + l_log_filename + "'.")
				die (1)
			end

				-- Create file for serialized test cases.
			if not l_tc_serialization_file_name.is_empty then
				create test_case_serialization_file.make_open_append (l_tc_serialization_file_name)
				if not test_case_serialization_file.is_open_write then
					report_error ("could not open test case serialization file '" + l_tc_serialization_file_name + "'.")
					die (1)
				end
			end

				-- Create file to store test case states.
			create l_state_file_name.make_from_string (interpreter_log_directory)
			l_state_file_name.set_file_name ("states.txt")
			create test_state_file.make_open_append (l_state_file_name.out)
			if not test_state_file.is_open_write then
				report_error ("could not open test state file '" + l_state_file_name.out + "'.")
				die (1)
			end

				-- Initialize precondition table.

				-- Initialize predicate related data structure.
			initialize_predicates

			create internal

				-- Create test case serializer.
			create test_case_serializer.make (Current, is_post_state_serialized)

			start (l_port, (create {INET_ADDRESS_FACTORY}).create_loopback)

				-- Close log file.
			log_file.close

				-- Close test case serialization file.
			if test_case_serialization_file /= Void and then not test_case_serialization_file.is_closed then
				test_case_serialization_file.close
			end

				-- Close test states file.
			if test_state_file /= Void and then not test_state_file.is_closed then
				test_state_file.close
			end
		end

	start (a_port: INTEGER; a_server_url: INET_ADDRESS)
			-- Connect to EiffelStudio and initiate `main_loop'.
		require
			a_server_url_attached: a_server_url /= Void
			a_port_valid: a_port >= 0
		local
			l_trace: STRING
		do
			create socket.make_client_by_address_and_port (a_server_url, a_port)
			socket.connect
			socket.set_blocking
			socket.set_nodelay
			start_time := System_clock.date_time_now

				-- Wait for test cases and then execute test cases in a loop.
			log_message ("<session>%N")
			main_loop
			log_message ("</session>%N")
		rescue
				-- Get an one line trace by replacing new line characters with space, since
				-- the stream parser from proxy cannot deal with multi line error messages.
				-- TODO: Added support for multi line error message.
			if attached exception_trace as l_excpt_trace then
				l_trace := l_excpt_trace.twin
				l_trace.replace_substring_all ("%N", " ")
				log_internal_error (l_excpt_trace)
			else
				l_trace := "Unknown error"
				log_internal_error (l_trace)
			end
			log_message ("</session>%N")
			report_error ("internal. " + l_trace)
			die (1)
		end

feature -- Status report

	has_error: BOOLEAN
			-- Has an error occurred while parsing?

	is_last_protected_execution_successful: BOOLEAN
			-- Was the last protected execution successful?
			-- (i.e. did it not trigger an exception)

	should_quit: BOOLEAN
			-- Should main loop quit?

	is_request_type_valid (a_type: NATURAL_32): BOOLEAN
			-- Is `a_type' a valid request type?
		do
			Result :=
				a_type = start_request_flag or else
				a_type = quit_request_flag or else
				a_type = execute_request_flag or else
				a_type = object_state_request_flag or else
				a_type = type_request_flag or else
				a_type = precondition_evaluation_request_flag or else
				a_type = predicate_evaluation_request_flag or else
				a_type = execute_agent_creation_flag or else
				a_type = execute_batch_assignment_flag
		end

	is_last_request_batch_assignment: BOOLEAN
			-- Is last request batch assignment?
		do
			Result := last_request_type = execute_batch_assignment_flag
		end

	should_generate_log: BOOLEAN
			-- Should interpreter log be generated?

	is_failing_test_case_serialized: BOOLEAN
			-- Should only failed test cases be serialized?
			-- Only has effect when serialization is enabled.

	is_passing_test_case_serialized: BOOLEAN
			-- Should passing test case be serialized?			
			-- Only has effect when serialization is enabled.

	is_post_state_serialized: BOOLEAN
			-- Should post-state information be serialized?

feature -- Access

	variable_at_index (a_index: INTEGER): detachable ANY
			-- Object in `store' at position `a_index'.
		local
			b: BOOLEAN
		do
			Result := object_store.variable_value (a_index)

debug("AutoTest")
	b := {ISE_RUNTIME}.check_assert (False)
	if Result /= Void then
		log_message ("Load object: " + {ITP_SHARED_CONSTANTS}.variable_name_prefix + a_index.out + ": " + Result.generating_type.name + "%N")
	else
		log_message ("Load object: " + {ITP_SHARED_CONSTANTS}.variable_name_prefix + a_index.out + ": Void%N")
	end
	b := {ISE_RUNTIME}.check_assert (b)
end

		end

	interpreter_log_directory: STRING
			-- Directory to store file interpreter_log.txt

feature {NONE} -- Handlers

	report_batch_assignment
		require
			last_request_attached: last_request /= Void
			last_request_is_batch_assignment: is_last_request_batch_assignment
		local
			l_receivers: SPECIAL [TUPLE [var_with_uuid: STRING; var: ITP_VARIABLE]]
			l_serialized_objects: SPECIAL[STRING]
			l_objects_seri: STRING
			l_uuid_objects_mapping: HASH_TABLE [HASH_TABLE[ANY, INTEGER], STRING]
			i, l_index, l_count: INTEGER
			l_var_with_uuid: STRING
			l_var_name, l_uuid: STRING
			l_var_index, l_at_sign: INTEGER
			l_variable: ITP_VARIABLE
			l_object: ANY
			l_retried: BOOLEAN
			b: BOOLEAN
		do
			if not l_retried then
				if attached {TUPLE [receivers: SPECIAL [TUPLE [var_with_uuid: STRING; var: ITP_VARIABLE]]; serialized_objects: SPECIAL[STRING]]} last_request as lv_operands then
					log_message (once "report batch assignment start%N")

						-- Deserialize objects.
					l_serialized_objects := lv_operands.serialized_objects
					from
						create l_uuid_objects_mapping.make (l_serialized_objects.count)
						l_uuid_objects_mapping.compare_objects
						l_index := 0
					until
						l_index >= l_serialized_objects.count
					loop
						l_uuid := l_serialized_objects.at (l_index)
						l_objects_seri := l_serialized_objects.at (l_index + 1)

						check attached {HASH_TABLE [ANY, INTEGER_32]} deserialized_variable_table (ascii_string_as_array (l_objects_seri)) as lv_mapping then
							l_uuid_objects_mapping.put (lv_mapping, l_uuid)
						end
						l_index := l_index + 2
					end

						-- Store objects into variables.
					from
						l_receivers := lv_operands.receivers
						l_index := 0
					until
						l_index >= l_receivers.count
					loop
						l_variable := l_receivers.at (l_index).var
						l_var_with_uuid := l_receivers.at (l_index).var_with_uuid

						l_at_sign := l_var_with_uuid.index_of ('@', 1)
						l_var_name := l_var_with_uuid.substring (1, l_at_sign - 1)
						l_uuid := l_var_with_uuid.substring (l_at_sign + 1, l_var_with_uuid.count)
						l_var_index := l_var_name.substring (3, l_var_name.count.to_integer).to_integer
						l_object := l_uuid_objects_mapping.item (l_uuid).item (l_var_index)

						store_variable_at_index (l_object, l_variable.index)

debug("AutoTest")
	b := {ISE_RUNTIME}.check_assert (False)
	if l_object /= Void then
		log_message ("Batch assign: " + {ITP_SHARED_CONSTANTS}.variable_name_prefix + l_variable.index.out + ": " + l_object.generating_type.name + "%N")
	else
		log_message ("Batch assign: " + {ITP_SHARED_CONSTANTS}.variable_name_prefix + l_variable.index.out + ": Void%N")
	end
	b := {ISE_RUNTIME}.check_assert (b)
end

						l_index := l_index + 1
					end
					log_message (once "report batch assignment end%N")
				else
					report_error (batch_assignment_error + "[receiving request argument objects failed]%N")
				end
			else
				report_error (batch_assignment_error + "[exception happend]%N")
			end

				-- Send response to the proxy.
			refresh_last_response_flag
			last_response := [0, Void, Void, output_buffer, error_buffer]
			send_response_to_socket
		rescue
			if attached exception_trace as l_exception_trace  then
				log_message (l_exception_trace + "%N")
			end

			l_retried := True
			retry
		end


	report_type_request
		require
			last_request_attached: last_request /= Void
			last_request_is_type_request: last_request_type = type_request_flag
		local
			b: BOOLEAN
			l_index: INTEGER
			l_value: detachable ANY
			l_object_store: like object_store
			l_type: STRING
			l_generating_type: STRING
		do
			if attached {STRING} last_request as l_obj_index then
				log_message (once "report_type_request start%N")
				l_index := l_obj_index.to_integer
				l_object_store := object_store
				if l_object_store.is_variable_defined (l_index) then
					l_value := l_object_store.variable_value (l_index)
					if l_value = Void then
						create l_type.make (4)
						l_generating_type := none_type_name
					else
						create l_type.make (64)

							-- We disable assertion checking here because `l_value'.`generating_type' is
							-- a qualified call, if `l_value' has invariant violation, an exception will be thrown,
							-- causing the interpreter to generate an error. The invariant of `l_value' was violated
							-- indirectly by other objects.
							-- In this case, we don't want a failure here, we want a failure when we actually
							-- try to use `l_value'.
						b := {ISE_RUNTIME}.check_assert (False)
						l_generating_type := l_value.generating_type
						b := {ISE_RUNTIME}.check_assert (b)
					end
					l_type.append (l_generating_type)
					l_type.append_character ('%N')
					l_type.append (value_of_object (l_value, l_generating_type))
					print_line_and_flush (l_type)
				else
					report_error (once "Variable `v_" + l_index.out + "' not defined.")
				end
				log_message (once "report_type_request end%N")
			else
				report_error (invalid_request_format_error)
			end

				-- Send response to the proxy.
			refresh_last_response_flag
			last_response := [0, Void, Void, output_buffer, error_buffer]
			send_response_to_socket
		end

	report_quit_request
		do
			should_quit := True
		end

	report_start_request
		do
		end

	report_execute_request
			-- Report execute request.
		require
			last_request_attached: last_request /= Void
			last_request_is_execute_request: last_request_type = execute_request_flag or last_request_type = execute_agent_creation_flag
		local
			l_bcode: detachable STRING
			l_cstring: C_STRING
			l_predicate_results: TUPLE [INTEGER, detachable like evaluated_predicate_results]
			i: INTEGER
			l_object_summary: ARRAYED_LIST [STRING]
			l_upper: INTEGER
			l_lower: INTEGER
			l_canned_objects: STRING
			l_serializer: like test_case_serializer
			j: INTEGER
		do
			is_failing_test_case := False
			last_test_case_serialization := Void
			if attached {TUPLE [l_byte_code: STRING; l_feat_name: detachable STRING; l_data: detachable ANY]} last_request as l_last_request then
				l_bcode := l_last_request.l_byte_code
				if l_bcode = Void then
					report_error (byte_code_not_found_error)
				elseif l_bcode.count = 0 then
					report_error (byte_code_length_error)
				else
					if l_last_request.l_feat_name /= Void then
						log_message (once "report_execute_request start: " + l_last_request.l_feat_name + "%N")
					else
						log_message (once "report_execute_request start%N")
					end


						-- Inject received byte-code into byte-code array of Current process.
					create l_cstring.make (l_bcode)
					override_byte_code_of_body (
						byte_code_feature_body_id,
						byte_code_feature_pattern_id,
						l_cstring.item,
						l_bcode.count)

						-- Test case serialization: retrieve pre-TC state.
					if is_test_case_serialization_enabled
							and then not is_test_case_agent_creation
					then
log_message_with_timestamp ("* REPORT START *")
						retrieve_test_case_prestate (l_last_request.l_data)
log_message_with_timestamp ("* REPORT END *")
					end

						-- Run the feature with newly injected byte-code.
					execute_protected
					log_message (once "report_execute_request end%N")

						-- Evaluate relevant predicates.
					if is_last_protected_execution_successful and then is_predicate_evaluation_enabled then
						if attached {detachable ARRAY [detachable ANY]} l_last_request.l_data as l_extra_data then
							if attached {TUPLE [feature_id: INTEGER; operands: SPECIAL [INTEGER]]} l_extra_data.item (extra_data_index_precondition_satisfaction) as l_feature_data then

debug("AutoTest")
	log_message ("Feature id: " + l_feature_data.feature_id.out + "%N")
	from
		j := 0
	until
		j = l_feature_data.operands.count
	loop
		log_message ("Object id: " + l_feature_data.operands.item (j).out + ", ")
		j := j + 1
	end
	log_message ("%N")
end
								l_predicate_results :=  [l_feature_data.feature_id, evaluated_predicate_results (l_feature_data.feature_id, l_feature_data.operands)]
							else
								l_predicate_results := Void
							end
						end
					end

						-- Test case serialization.					
					if is_test_case_serialization_enabled
							and then not is_test_case_agent_creation
					then
log_message_with_timestamp ("* REPORT START *")
						retrieve_post_test_case_state
						log_test_case_serialization
log_message_with_timestamp ("* REPORT END *")
					end
				end
			else
				report_error (invalid_request_format_error)
			end

				-- Send response to the proxy.
			refresh_last_response_flag
			last_response := [invariant_violating_object_index, l_predicate_results, last_test_case_serialization, output_buffer, error_buffer]
			send_response_to_socket
		end

	refresh_last_response_flag
			-- Refresh the value of `last_response_flag' according to current status.
		do
			if has_error then
				last_response_flag := internal_error_respones_flag
			elseif is_last_invariant_violated then
				last_response_flag := invariant_violation_on_entry_response_flag
			else
				last_response_flag := normal_response_flag
			end
		end

feature {NONE} -- Error Reporting

	report_error (a_reason: STRING)
		require
			a_reason_not_void: a_reason /= Void
			a_reason_not_empty: not a_reason.is_empty
		do
			error_buffer.append (once "error: " + a_reason + once "%N")
			last_response_flag := internal_error_respones_flag
			has_error := True
			log_message (error_buffer)
		ensure
			has_error: has_error
		end

	log_internal_error (a_reason: STRING)
			-- Put `a_reason' in log file.
		require
			a_reason_attached: a_reason /= Void
			not_a_reason_is_empty: not a_reason.is_empty
		do
			if should_generate_log then
				log_file.put_string (once "<error type='internal'>%N")
				log_file.put_string (once "%T<reason>%N<![CDATA[%N")
				log_file.put_string (a_reason)
				log_file.put_string (once "]]>%N</reason>%N")
				log_file.put_string (once "</error>%N")
			end
		end

feature {ITP_TEST_CASE_SERIALIZER} -- Logging

	log_file: PLAIN_TEXT_FILE
			-- Log file

	log_instance (an_object: detachable ANY)
			-- Log an XML representation of `an_object' to `log_file'.
		do
			log_message (once "<instance<![CDATA[%N")
			if an_object = Void then
				log_message (once "Void%N")
			else
				log_message (an_object.tagged_out)
			end
			log_message (once "]]>%N</instance>%N")
		end

	log_message (a_message: STRING)
			-- Log message `a_messgae' to `log_message'.
		require
			a_message_not_void: a_message /= Void
		do
			log_file.put_string (a_message)
--			log_file.flush
		end

	log_message_with_timestamp (a_msg: STRING)
		local
			duration: DT_DATE_TIME_DURATION
		do
			duration := System_clock.date_time_now.duration (start_time)
			duration.set_time_canonical
			log_message (duration.millisecond_count.out + ":" + a_msg + "%N")
		end

	start_time: DT_DATE_TIME

	report_trace
			-- Report trace information into `error_buffer'.
		require
		local
			l_buffer: like error_buffer
			l_exception_code: INTEGER
			l_recipient: like recipient_name
			l_recipient_class_name: like class_name
			l_tag: like tag_name
			l_trace: like exception_trace
			l_meaning: like meaning
			l_line_number: INTEGER
		do
				-- Gather exception information.
			l_exception_code := original_exception
			l_tag := original_tag_name
			if l_tag = Void then
				l_tag := "noname"
			end
			l_recipient := original_recipient_name
			l_recipient_class_name := original_class_name
			if attached {EXCEPTION} exception_manager.last_exception as l_except then
				if attached {EXCEPTION} l_except.cause as l_cause then
					l_line_number := l_cause.line_number
				end
			end
			last_fault_id := l_recipient_class_name + "." + l_recipient + "." + l_exception_code.out + "." + l_tag

			l_trace := exception_trace

			l_meaning := meaning (l_exception_code)
			check l_trace /= Void end

--			l_tag := tag_name
--			l_recipient := recipient_name
--			if attached class_name as l_class_name then
--				l_recipient_class_name := l_class_name
--			else
--				l_recipient_class_name := "UNKNOWN_CLASS"
--			end
--			if attached exception_trace as l_exception_trace then
--				l_trace := l_exception_trace
--			else
--				l_trace := "Unknown exception trace"
--			end

			if l_meaning = Void then
				l_meaning := ""
			end
			if l_recipient = Void then
				l_recipient := ""
			end
			check l_class_name_not_void: l_recipient_class_name /= Void end
			if l_tag = Void then
				l_tag := ""
			end

				-- Print exception into buffer which will be transfered through socket to proxy.
			l_buffer := error_buffer
			l_buffer.append (l_exception_code.out)
			l_buffer.append_character ('%N')
			l_buffer.append (l_recipient)
			l_buffer.append_character ('%N')
			l_buffer.append (l_recipient_class_name)
			l_buffer.append_character ('%N')
			l_buffer.append (l_tag)
			l_buffer.append_character ('%N')
			l_buffer.append (is_last_invariant_violated.out)
			l_buffer.append_character ('%N')
			l_buffer.append (l_trace)

				-- Store exception into log file.
			log_message (once "<call_result type='exception'>%N")
			log_message (once "%T<meaning value='" + l_meaning + once "'/>%N")
			log_message (once "%T<tag value='" + l_tag + once "'/>%N")
			log_message (once "%T<recipient value='" + l_recipient + once "'/>%N")
			log_message (once "%T<class value='" + l_recipient_class_name + once "'>%N")
			log_message (once "%T<invariant violation on entry='" + is_last_invariant_violated.out + once "'>%N")
			log_message (once "%T<exception_trace>%N<![CDATA[%N")
			log_message (l_trace)
			log_message (once "]]>%N</exception_trace>%N")
			log_message (once "</call_result>%N")
		end

	last_fault_id: detachable STRING
			-- Id of the last detected fault
			-- Only have correct value if is_failing_test_case is True

feature -- IO Buffer

	output_buffer: STRING_8
			-- Buffer used to store standard output from Current process
			-- Fixme: Should store standard error also, but due to an implementation
			-- limitation in STD_FILES, we cannot redirect standard error to a buffer.
			-- So stderr will be ignored for the moment. Jason 2008.10.18

	error_buffer: STRING
			-- Buffer to store error information (either interpreter error or exception trace from testee feature)
			-- Note: Error here does not mean standard error from testee feature, stderr error should be handled by
			-- `output_buffer'.

	wipe_out_buffer
			-- Clear `output_buffer' and `error_buffer'.
		do
			output_buffer.wipe_out
			error_buffer.wipe_out
		ensure
			output_buffer_cleared: output_buffer.is_empty
			error_buffer_cleared: error_buffer.is_empty
		end

	buffer_size: INTEGER = 4096
			-- Size in byte for `output_buffer'

feature {NONE} -- Socket IPC

	socket: NETWORK_STREAM_SOCKET
			-- Socket used for communitation between proxy and current interpreter

	last_request_type: NATURAL_32
			-- Type of the last request retrieved by `retrieve_request'.

	last_request: detachable ANY
			-- Last received request by `retrieve_request'
			-- `flag' indicates request type,
			-- `data' stores data needed for that reques type.

	last_response_flag: NATURAL_32
			-- Flag indicating the status of the response
			-- See {ITP_SHARED_CONSTANTS} for valid values

	last_response: detachable ANY
			-- Last response to be sent back to the proxy

	retrieve_request
			-- Retrieve request from proxy and store it in `last_request'.
			-- Blocking if no request is received.
			-- Close socket on error.
		require
			socket_attached: socket /= Void
			socket_open: socket.is_open_read
		local
			l_retried: BOOLEAN
		do
			last_request := Void
			last_response := Void
			is_last_invariant_violated := False

			if not l_retried then
					-- Get request from proxy through `socket'.
					-- This will block Current process.
				socket.read_natural_32
				last_request_type := socket.last_natural_32

				if attached {like last_request} retrieved_from_medium (socket) as l_request then
					last_request := l_request
				end
			end
		rescue
			l_retried := True
			last_request := Void
			if not socket.is_closed then
				socket.close
			end
			retry
		end

	send_response_to_socket
			-- Send response stored in `output_buffer' and `error_buffer' into `socket'.
			-- If error occurs, close `socket'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
log_message_with_timestamp ("* REQUEST PROCESSED *")
log_message_with_timestamp ("* EXTRA *")

				socket.put_natural_32 (last_response_flag)
				log_message("%TResponse_flag: " + last_response_flag.out + "%N")
				if attached last_response as l_last_response then
					store_in_medium (l_last_response, socket)
				end
			end
		rescue
			l_retried := True
			has_error := True
			socket.close
			retry
		end

	print_line_and_flush (a_text: STRING)
			-- Print `a_text' followed by a newline and flush output stream.
		require
			a_text_not_void: a_text /= Void
		do
			output_buffer.append (a_text)
			output_buffer.append_character ('%N')
		end

feature {NONE} -- Parsing

	parse
			-- Parse input and call corresponding handler routines (`report_*').
		require
			not_has_error: not has_error
		do
			if is_request_type_valid (last_request_type) then
				if last_request = Void then
					report_error (once "Received data is not recognized as a request.")
				else
					is_test_case_agent_creation := False
					inspect
						last_request_type
					when execute_request_flag then
						report_execute_request
					when execute_agent_creation_flag then
						is_test_case_agent_creation := True
						report_execute_request

					when execute_batch_assignment_flag then
						report_batch_assignment

					when type_request_flag then
						report_type_request

					when start_request_flag then
						report_start_request

					when object_state_request_flag then
						report_object_state_request

					when precondition_evaluation_request_flag then
						report_error (invalid_request_type_error + once " Type code: " + last_request_type.out)

					when predicate_evaluation_request_flag then
						report_predicate_evaluate_request

					when quit_request_flag then
						report_quit_request
					end
				end
			else
				report_error (invalid_request_type_error + once " Type code: " + last_request_type.out)
			end
		end

feature {ITP_TEST_CASE_SERIALIZER} -- Object pool

	object_store: ITP_STORE
			-- Object store

feature {NONE} -- Byte code

	byte_code_feature_body_id: INTEGER
			-- ID for feature whose byte-code is to be injected

	byte_code_feature_pattern_id: INTEGER
			-- Pattern ID for feature whose byte-code is to be injected

	execute_protected
			-- Execute `procedure' in a protected way.
		local
			failed: BOOLEAN
			fault_id: STRING
		do
			is_last_protected_execution_successful := False
			if not failed then
				is_failing_test_case := False
				is_invalid_test_case := False
				execute_byte_code
				is_last_protected_execution_successful := True
			end
		rescue
			failed := True
log_message_with_timestamp ("* REPORT START *")
			report_trace
log_message_with_timestamp ("* REPORT END *")

				-- Book keeps found faults.
			if not is_last_invariant_violated then
				if (original_recipient_name.same_string_general (once "execute_byte_code") and then exception = {EXCEP_CONST}.Precondition) then
					is_invalid_test_case := True
					is_failing_test_case := False
				else
					is_invalid_test_case := False
					is_failing_test_case := True
				end
			else
				is_invalid_test_case := True
				is_failing_test_case := False
			end
--			if exception = Class_invariant then
--					-- A class invariant cannot be recovered from since we
--					-- don't know how many and what objects are now invalid
--				should_quit := True
--			end
			retry
		end

	execute_byte_code
			-- Execute test case
			-- The test case will be written as byte-code.
		local
			v_1: detachable STRING
		do
			v_1 := Void
		end

	store_variable_at_index	(a_object: ANY; a_index: INTEGER)
			-- Store `a_object' at `a_index' in `object_store'.
		do
			object_store.assign_value (a_object, a_index)
		end

	main_loop
			-- Main loop
		do
			from
			until
				should_quit or else socket.is_closed
			loop
				wipe_out_buffer
				retrieve_request
log_message_with_timestamp ("* REQUEST RECEIVED *")
				if not has_error then
					parse
				end

				has_error := False
			end
		end

feature{NONE} -- Error message

	invalid_request_format_error: STRING = "Invalid request format."

	byte_code_not_found_error: STRING = "No byte-code is found in request."

	byte_code_length_error: STRING = "Length of retrieved byte-code is not the same as specified in request."

	invalid_request_type_error: STRING = "Request type is invalid."

	batch_assignment_error: STRING = "Batch assignment data invalid "

feature{ITP_TEST_CASE_SERIALIZER} -- Invariant checking

	is_last_invariant_violated: BOOLEAN
			-- Is the class invariant violated when `check_invariant' is invoked
			-- the last time?

	is_failing_test_case: BOOLEAN
			-- Is current test case failing, meaning that it reveals a fault?

	is_invalid_test_case: BOOLEAN
			-- Is current test case invalid, meaning that it violates the feature's precondition?

feature{NONE} -- Invariant checking

	invariant_violating_object_index: INTEGER
			-- Index of the object which violates it class invariant

	check_invariant (a_index: INTEGER; o: detachable ANY)
			-- Check if the class invariant `o' with index `a_index' is satisfied.
			-- If not satisfied, set `is_last_invariant_violated' to True
			-- and raise the exception.
			-- If satisfied, set `is_last_invariant_violated' to False.
			-- if `o' is detached, set `is_last_invariant_violated' to False and do nothing.
		require
			a_index_positive: a_index > 0
		do
			if o /= Void then
				log_message ("Check invariant: " + variable_name (a_index) + ": " + o.generating_type.name + "%N")
			else
				log_message ("Check invariant: " + variable_name (a_index) + ": Void%N")
			end
			if attached {ANY} o as l_obj then
				l_obj.do_nothing
			end
			invariant_violating_object_index := 0
		rescue
			is_last_invariant_violated := True
			invariant_violating_object_index := a_index
			log_message ("Check invariant: " + variable_name (a_index) + " violates its class invariants.%N")
		end

	variable_name (a_index: INTEGER): STRING
			-- Variable name with index `a_index'
		do
			Result := {ITP_SHARED_CONSTANTS}.variable_name_prefix + a_index.out
		end

feature -- Object state checking

	initialize_query_value_holders
			-- Initialize `query_values' and `query_status'.
		do
			if query_values = Void then
				create query_values.make (20)
				create query_value_hash_list.make
			else
				query_values.wipe_out
				query_value_hash_list.wipe_out
			end
		end

	report_object_state_request
			-- Report an object state request.
		local
			o: detachable ANY
			l_retried: BOOLEAN
			l_bcode: STRING
			l_cstring: C_STRING
		do
			if not l_retried then
				output_buffer.wipe_out
				error_buffer.wipe_out
				if attached {TUPLE [pre_state_byte_code: STRING; post_state_byte_code: detachable STRING]} last_request as l_request then
						-- Initialize query result storage
					initialize_query_value_holders

						-- Load byte-code.
					l_bcode := l_request.pre_state_byte_code

					if l_bcode.count = 0 then
						report_error (byte_code_length_error)
					else
						if l_request.post_state_byte_code /= Void and then is_test_case_serialization_enabled and then is_post_state_serialized then
							post_state_retrieveal_byte_code := l_request.post_state_byte_code
						else
							post_state_retrieveal_byte_code := Void
						end
						log_message (once "report_object_state_request start%N")

							-- Inject received byte-code into byte-code array of Current process.
						create l_cstring.make (l_bcode)
						override_byte_code_of_body (
							byte_code_feature_body_id,
							byte_code_feature_pattern_id,
							l_cstring.item,
							l_bcode.count)

							-- Run the feature with newly injected byte-code.
						last_response_flag := normal_response_flag
						execute_protected
						log_message (once "report_object_state_request end%N")
					end
					last_response := [query_values, output_buffer, error_buffer]
					refresh_last_response_flag
					send_response_to_socket
				else
					report_error (invalid_object_state_request)
					last_response := [Void, Void, output_buffer, error_buffer]
					refresh_last_response_flag
					send_response_to_socket
				end
			end
		rescue
			l_retried := True
			last_response := [Void, Void, output_buffer, error_buffer]
			refresh_last_response_flag
			send_response_to_socket
			retry
		end

	retrieve_post_object_state
			-- Retrieve post-execution object states by executing byte-code
			-- stored in `post_state_retrieval_byte_code'.
		local
			l_cstring: C_STRING
		do
			initialize_query_value_holders
			if attached {STRING} post_state_retrieveal_byte_code as l_byte_code then
				create l_cstring.make (l_byte_code)
				override_byte_code_of_body (
					byte_code_feature_body_id,
					byte_code_feature_pattern_id,
					l_cstring.item,
					l_byte_code.count)

					-- Run the feature with newly injected byte-code.
				execute_protected
			end
		end

	invalid_object_state_request: STRING = "Invalid object state request."
			-- Error message for invalid object state request

	invalid_predicate_evaluation_request: STRING = "Invalid predicate evaluation request."

	query_values: HASH_TABLE [STRING, STRING]
			-- Table to store string representation of query values
			-- Key is query name, value is the value of that query

	query_value_hash_list: LINKED_LIST [INTEGER]
			-- List of `query_values'.
			-- The first element is the hash code of the value of the first evaluated query in an object state request,
			-- the second element is the hash code of the value of the second evaluated query in an object state request, and so on.

	record_attribute_value (a_query_name: STRING; a_value: detachable ANY)
			-- Record the query named `a_query_name' to have `a_value' into `query_values'.
		local
			l_internal: like internal
			l_type: INTEGER
			l_value: STRING
		do
			if a_value = Void then
				query_values.put (void_value, a_query_name)
			else
				l_internal := internal
				if special_type_mapping.has (l_internal.dynamic_type (a_value)) then
					l_value := a_value.out
					query_values.put (l_value, a_query_name)
					query_value_hash_list.extend (l_value.hash_code)
				else
					l_value := ($a_value).out
					query_values.put (l_value, a_query_name)
					query_value_hash_list.extend (l_value.hash_code)
				end
			end
		end

	record_integer_function_value (a_query_name: STRING; a_query: FUNCTION [ANY, TUPLE [INTEGER], detachable ANY]; a_argument: INTEGER)
			-- Evaluate the query specified by `a_query' and record its value into `query_values'
			-- under the name `a_query_name'.
			-- `a_query' has an argument, which is given by `a_argument'.
		require
			a_query_attached: a_query /= Void
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
		do
			if not l_retried then
				l_result := a_query.item ([a_argument])
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, a_argument, exception_trace)
			l_retried := True
			retry
		end

	record_boolean_function_value (a_query_name: STRING; a_query: FUNCTION [ANY, TUPLE [BOOLEAN], detachable ANY]; a_argument: BOOLEAN)
			-- Evaluate the query specified by `a_query' and record its value into `query_values'
			-- under the name `a_query_name'.
			-- `a_query' has an argument, which is given by `a_argument'.
		require
			a_query_attached: a_query /= Void
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
		do
			if not l_retried then
				l_result := a_query.item ([a_argument])
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, a_argument, exception_trace)
			l_retried := True
			retry
		end

	record_argumented_function_value (a_query_name: STRING; a_query: FUNCTION [ANY, TUPLE [detachable ANY], detachable ANY]; a_argument: detachable ANY)
			-- Evaluate the query specified by `a_query' and record its value into `query_values'
			-- under the name `a_query_name'.
			-- `a_query' has an argument, which is given by `a_argument'.
		require
			a_query_attached: a_query /= Void
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
		do
			if not l_retried then
				l_result := a_query.item ([a_argument])
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, a_argument, exception_trace)
			l_retried := True
			retry
		end

	record_function_value (a_query_name: STRING; a_query: FUNCTION [ANY, TUPLE, detachable ANY])
			-- Evaluate the query specified by `a_query' and record its value into `query_values'
			-- under the name `a_query_name'.
		require
			a_query_attached: a_query /= Void
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
		do
			if not l_retried then
				l_result := a_query.item (Void)
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, Void, exception_trace)
			l_retried := True
			retry
		end

	record_object_equality_comparison_value (a_query_name: STRING; a_obj1: detachable ANY; a_obj2: detachable ANY)
			-- Record the value of the object equality comparison between `a_obj1' and `a_obj2',
			-- and store result in `query_values'.
		require
			a_query_attached: a_query_name /= Void
		local
			l_retried: BOOLEAN
			l_result: BOOLEAN
			l_agent: FUNCTION [ANY, TUPLE [detachable ANY, detachable ANY], BOOLEAN]
		do
			if not l_retried then
				l_agent := agent is_object_equal
				l_result := l_agent.item ([a_obj1, a_obj2])
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, Void, exception_trace)
			l_retried := True
			retry
		end

	record_reference_equality_comparison_value (a_query_name: STRING; a_obj1: detachable ANY; a_obj2: detachable ANY)
			-- Record the value of the reference equality comparison between `a_obj1' and `a_obj2',
			-- and store result in `query_values'.
		require
			a_query_attached: a_query_name /= Void
		local
			l_retried: BOOLEAN
			l_result: BOOLEAN
			l_agent: FUNCTION [ANY, TUPLE [detachable ANY, detachable ANY], BOOLEAN]
		do
			if not l_retried then
				l_agent := agent is_reference_equal
				l_result := l_agent.item ([a_obj1, a_obj2])
				record_evaluated_value (a_query_name, l_result)
			end
		rescue
			query_values.put (nonsensical_value, a_query_name)
			query_value_hash_list.extend (nonsensical_value.hash_code)
			log_query_evaluation_failure (a_query_name, Void, exception_trace)
			l_retried := True
			retry
		end

	is_object_equal (a_obj1: detachable ANY; a_obj2: detachable ANY): BOOLEAN
			-- Is `a_obj1' object equal to `a_obj2'?
		do
			Result := a_obj1 ~ a_obj2
		end

	is_reference_equal (a_obj1: detachable ANY; a_obj2: detachable ANY): BOOLEAN
			-- Is `a_obj1' reference equal to `a_obj2'?
		do
			Result := a_obj1 = a_obj2
		end

	log_query_evaluation_failure (a_query_name: STRING; a_argument: detachable ANY; a_trace: STRING)
			-- Log that the evaluation of `a_query_name' with `a_argument' failed with trace `a_trace'.
		do
			log_message ("-----------------------------------------------%N")
			log_message (a_query_name + "%N")
			if a_argument /= Void then
				log_message (a_argument.generating_type + "%N")
			else
				log_message ("argument is Void.%N")
			end
			if a_trace /= Void then
				log_message (exception_trace)
			end
		end

	record_void_value (a_variable_index: INTEGER)
			-- Record that object with `a_variable_index' is Void into `query_values'.
		do
			query_values.put (void_value, object_name (a_variable_index))
			query_value_hash_list.extend (void_value.hash_code)
			log_message (variable_name_prefix + a_variable_index.out + " is void.%N")
		end

	record_basic_value (a_variable_index: INTEGER; a_value: STRING)
			-- Record that object with `a_variable_index' has value `a_value' into `query_values'.
			-- That object must be of primitive type.
		do
			query_values.put (a_value, object_name (a_variable_index))
			query_value_hash_list.extend (a_value.hash_code)
			log_message (variable_name_prefix + a_variable_index.out + " is " + a_value + "%N")
		end

	record_invariant_violating_value (a_variable_index: INTEGER)
			-- Record that object with `a_variable_index' voilates its class invariants in `query_values'.
		do
			query_values.put (invariant_violation_value, object_name (a_variable_index))
			query_value_hash_list.extend (invariant_violation_value.hash_code)
		end

	record_evaluated_value (a_query_name: STRING; a_value: detachable ANY)
			-- Record evaluated `a_value' for `a_query_name'.
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
			l_internal: like internal
			l_value: STRING
		do
			if a_value = Void then
				query_values.put (void_value, a_query_name)
			else
				l_internal := internal
				if special_type_mapping.has (l_internal.dynamic_type (a_value)) then
					l_value := a_value.out
					query_values.put (l_value, a_query_name)
					query_value_hash_list.extend (l_value.hash_code)
				else
					l_value := ($a_value).out

					query_values.put (l_value, a_query_name)
					query_value_hash_list.extend (reference_value.hash_code)
				end
			end
		end

	object_name (a_index: INTEGER): STRING
			-- Name of object with `a_index'
		do
			create Result.make (5)
			Result.append (variable_name_prefix)
			Result.append (a_index.out)
		end

	internal: INTERNAL
			-- Internal to get types of an object

	post_state_retrieveal_byte_code: detachable STRING
			-- Byte code used to retrieve post-execute object states

	hash_table_type: TYPE [HASH_TABLE [INTEGER, INTEGER]]
			-- Type anchor

feature -- Function types

	function0: FUNCTION [ANY, TUPLE, INTEGER]
	function1: FUNCTION [ANY, TUPLE, INTEGER_8]
	function2: FUNCTION [ANY, TUPLE, INTEGER_16]
	function3: FUNCTION [ANY, TUPLE, INTEGER_64]
	function4: FUNCTION [ANY, TUPLE, NATURAL]
	function5: FUNCTION [ANY, TUPLE, NATURAL_8]
	function6: FUNCTION [ANY, TUPLE, NATURAL_16]
	function7: FUNCTION [ANY, TUPLE, NATURAL_64]
	function8: FUNCTION [ANY, TUPLE, REAL_32]
	function9: FUNCTION [ANY, TUPLE, REAL_64]
	function10: FUNCTION [ANY, TUPLE, BOOLEAN]
	function11: FUNCTION [ANY, TUPLE, CHARACTER]
	function12: FUNCTION [ANY, TUPLE, CHARACTER_32]
	function13: FUNCTION [ANY, TUPLE, POINTER]
	function14: FUNCTION [ANY, TUPLE, ANY]

--	function20: FUNCTION [ANY, TUPLE [INTEGER], INTEGER]
--	function21: FUNCTION [ANY, TUPLE [INTEGER], INTEGER_8]
--	function22: FUNCTION [ANY, TUPLE [INTEGER], INTEGER_16]
--	function23: FUNCTION [ANY, TUPLE [INTEGER], INTEGER_64]
--	function24: FUNCTION [ANY, TUPLE [INTEGER], NATURAL]
--	function25: FUNCTION [ANY, TUPLE [INTEGER], NATURAL_8]
--	function26: FUNCTION [ANY, TUPLE [INTEGER], NATURAL_16]
--	function27: FUNCTION [ANY, TUPLE [INTEGER], NATURAL_64]
--	function28: FUNCTION [ANY, TUPLE [INTEGER], REAL_32]
--	function29: FUNCTION [ANY, TUPLE [INTEGER], REAL_64]
--	function30: FUNCTION [ANY, TUPLE [INTEGER], BOOLEAN]
--	function31: FUNCTION [ANY, TUPLE [INTEGER], CHARACTER]
--	function32: FUNCTION [ANY, TUPLE [INTEGER], CHARACTER_32]
--	function33: FUNCTION [ANY, TUPLE [INTEGER], POINTER]
--	function34: FUNCTION [ANY, TUPLE [INTEGER], ANY]

--	function40: FUNCTION [ANY, TUPLE [BOOLEAN], INTEGER]
--	function41: FUNCTION [ANY, TUPLE [BOOLEAN], INTEGER_8]
--	function42: FUNCTION [ANY, TUPLE [BOOLEAN], INTEGER_16]
--	function43: FUNCTION [ANY, TUPLE [BOOLEAN], INTEGER_64]
--	function44: FUNCTION [ANY, TUPLE [BOOLEAN], NATURAL]
--	function45: FUNCTION [ANY, TUPLE [BOOLEAN], NATURAL_8]
--	function46: FUNCTION [ANY, TUPLE [BOOLEAN], NATURAL_16]
--	function47: FUNCTION [ANY, TUPLE [BOOLEAN], NATURAL_64]
--	function48: FUNCTION [ANY, TUPLE [BOOLEAN], REAL_32]
--	function49: FUNCTION [ANY, TUPLE [BOOLEAN], REAL_64]
--	function50: FUNCTION [ANY, TUPLE [BOOLEAN], BOOLEAN]
--	function51: FUNCTION [ANY, TUPLE [BOOLEAN], CHARACTER]
--	function52: FUNCTION [ANY, TUPLE [BOOLEAN], CHARACTER_32]
--	function53: FUNCTION [ANY, TUPLE [BOOLEAN], POINTER]
--	function54: FUNCTION [ANY, TUPLE [BOOLEAN], ANY]



--	function40: FUNCTION [ANY, TUPLE [], INTEGER]
--	function41: FUNCTION [ANY, TUPLE [], INTEGER_8]
--	function42: FUNCTION [ANY, TUPLE [], INTEGER_16]
--	function43: FUNCTION [ANY, TUPLE [], INTEGER_64]
--	function44: FUNCTION [ANY, TUPLE [], NATURAL]
--	function45: FUNCTION [ANY, TUPLE [], NATURAL_8]
--	function46: FUNCTION [ANY, TUPLE [], NATURAL_16]
--	function47: FUNCTION [ANY, TUPLE [], NATURAL_64]
--	function48: FUNCTION [ANY, TUPLE [], REAL_32]
--	function49: FUNCTION [ANY, TUPLE [], REAL_64]
--	function50: FUNCTION [ANY, TUPLE [], BOOLEAN]
--	function51: FUNCTION [ANY, TUPLE [], CHARACTER]
--	function52: FUNCTION [ANY, TUPLE [], CHARACTER_32]
--	function53: FUNCTION [ANY, TUPLE [], POINTER]
--	function54: FUNCTION [ANY, TUPLE [], ANY]

		-- Those types are here to make sure the byte-code generated on-the-fly
		-- works.

feature -- Precondition satisfaction

	argument_arrays: ARRAY [ARRAY [INTEGER]]
			-- Array for arguments used in predicate evaluation

	arguement_tuple_from_indexes (a_indexes: ARRAY [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): TUPLE
			-- Tuple containing objects with `a_indexes'
		require
			a_indexes_attached: a_indexes /= Void
		local
			l_count: INTEGER
			l_args: like argument_tuple_cache
			i: INTEGER
			l_arg_tuple: TUPLE
		do
				-- Load arguments from object pool.
			l_count := a_upper - a_lower + 1
			l_args := argument_tuple_cache
			l_args.wipe_out
			from
				i := a_lower
			until
				i > a_upper
			loop
				l_args.extend (variable_at_index (a_indexes.item (i)))
				i := i + 1
			end

				-- Generate tuple for agent call.
			inspect
				l_count
			when 0 then
				l_arg_tuple := []
			when 1 then
				l_arg_tuple := [l_args.i_th (1)]
			when 2 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2)]
			when 3 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3)]
			when 4 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4)]
			when 5 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4), l_args.i_th (5)]
			when 6 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4), l_args.i_th (5), l_args.i_th (6)]
			when 7 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4), l_args.i_th (5), l_args.i_th (6), l_args.i_th (7)]
			when 8 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4), l_args.i_th (5), l_args.i_th (6), l_args.i_th (7), l_args.i_th (8)]
			when 9 then
				l_arg_tuple := [l_args.i_th (1), l_args.i_th (2), l_args.i_th (3), l_args.i_th (4), l_args.i_th (5), l_args.i_th (6), l_args.i_th (7), l_args.i_th (8), l_args.i_th (9)]
			end
			Result := l_arg_tuple
		ensure
			result_attached: Result /= Void Result.count = a_indexes.count
		end


feature -- Predicate evaluation

	predicate_table: HASH_TABLE [FUNCTION [ANY, TUPLE, BOOLEAN], INTEGER]
			-- Table for predicates that are to be monitered during testing
			-- [Agent for the predicate, predicate index]
			-- predicate index is 1-based, it is the identifier associated with
			-- every unique predicate. See {AUT_PREDICATE}.`id' for more information.

	predicate_arity: HASH_TABLE [INTEGER, INTEGER]
			-- Arity of predicates in `preciate_table'.
			-- [Predicate arity, predicate index].
			-- predicate index is 1-based, it is the identifier associated with
			-- every unique predicate. See {AUT_PREDICATE}.`id' for more information.

	initialize_predicates
			-- Initialize `predicate_table' and `predicate_arity'.
		do
		end

	evaluated_predicate_result (a_predicate_id: INTEGER; a_arguments: ARRAY [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): NATURAL_8
			-- Evaluated result of predicate with id `a_predicate_id' on objects with index `a_arguments'.
			-- `a_lower' and `a_upper' indicates that only the part between [`a_lower', `a_upper'] of `a_arguments' is to be used
			-- as arguments during predicate evaluation.
			-- The result can be of one of the following values:
			-- 0 There was an exception during the evaluation.
			-- 1 The evaluation succeeded
			-- 2 The evaluation failed
		local
			l_args: TUPLE
			l_predicate: FUNCTION [ANY, TUPLE, BOOLEAN]
		do
			l_args := arguement_tuple_from_indexes (a_arguments, a_lower, a_upper)
			l_predicate := predicate_table.item (a_predicate_id)
			Result := safe_predicate_evaluation_result (l_predicate, l_args)
		ensure
			result_valid: Result = 0 or Result = 1 or Result = 2
		end

	safe_predicate_evaluation_result (a_predicate: FUNCTION [ANY, TUPLE, BOOLEAN]; a_arguments: TUPLE): NATURAL_8
			-- Evaluated result of `a_predicate' on `a_arguments'.
			-- The result can be of one of the following values:
			-- 0 There was an exception during the evaluation.
			-- 1 The evaluation succeeded
			-- 2 The evaluation failed
		require
			a_predicate_attached: a_predicate /= Void
			a_arguments_attached: a_arguments /= Void
		local
			l_retried: BOOLEAN
			l_result: BOOLEAN
		do
			if not l_retried then
				l_result := a_predicate.item (a_arguments)
				if l_result then
					Result := 1
				else
					Result := 2
				end
			else
				Result := 0
			end
		rescue
			l_retried := True
			retry
		end

	report_predicate_evaluate_request
			-- Report a predicate evaluation request.
		local
			l_checking: BOOLEAN
			l_pred_id: INTEGER
			l_objects: SPECIAL [INTEGER]
			l_arity: INTEGER
			l_pred_table: like predicate_table
			l_arity_table: like predicate_arity
			l_argument_holder: like argument_arrays
			i, j: INTEGER
			l_count: INTEGER
			l_args: ARRAY [INTEGER]
			l_arg_index: INTEGER
			l_response: LINKED_LIST [TUPLE [INTEGER, SPECIAL [NATURAL_8]]]
			l_pred_response: SPECIAL [NATURAL_8]
		do
			output_buffer.wipe_out
			error_buffer.wipe_out
			create l_response.make
			if attached {LINKED_LIST [TUPLE [predicate_id: INTEGER; objects: SPECIAL [INTEGER]]]} last_request as l_request then
				l_checking := {ISE_RUNTIME}.check_assert (False)
				l_pred_table := predicate_table
				l_arity_table := predicate_arity
				l_argument_holder := argument_arrays
				from
					l_request.start
				until
					l_request.after
				loop
					l_pred_id := l_request.item_for_iteration.predicate_id
					l_objects := l_request.item_for_iteration.objects
					l_arity := l_arity_table.item (l_pred_id)
					l_count := l_objects.count

					l_args := l_argument_holder.item (l_arity)
					if l_arity = 0 then
						create l_pred_response.make_filled (0, 1)
					else
						create l_pred_response.make_empty (l_count // l_arity)

					end
					j := 0
					if l_arity = 0 then
						l_pred_response.put (evaluated_predicate_result (l_pred_id, l_args, l_args.lower, l_args.upper), j)
					else
						from
							i := 0
							l_arg_index := 1
						until
							i = l_count
						loop
							l_args.put (l_objects.item (i), l_arg_index)
							if l_arg_index = l_arity then
								l_pred_response.put (evaluated_predicate_result (l_pred_id, l_args, l_args.lower, l_args.upper), j)
								l_arg_index := 1
								j := j + 1
							else
								l_arg_index := l_arg_index + 1
							end
							i := i + 1
						end
					end
					l_response.extend ([l_pred_id, l_pred_response])
					l_request.forth
				end
				l_checking := {ISE_RUNTIME}.check_assert (l_checking)
				last_response := [l_response, output_buffer, error_buffer]
				refresh_last_response_flag
				send_response_to_socket
			else
				report_error (invalid_predicate_evaluation_request)
				report_error (last_request.generating_type)
				refresh_last_response_flag
				send_response_to_socket
			end
		end

	relevant_predicate_table: HASH_TABLE [ARRAY [TUPLE [predicate_id: INTEGER; operand_index: SPECIAL [INTEGER]]], INTEGER]
			-- Table of relevant predicates for feature
			-- Key is the feature id, value is a list of predicates with its predicate id and operand index for that feature.
			-- The array as items of the table are 1-based.

	is_predicate_evaluation_enabled: BOOLEAN
			-- Should predicates in `relevant_predicate_table' be evaluated
			-- after execution of a feature?

	evaluated_predicate_results (a_feature_id: INTEGER; a_operands: SPECIAL [INTEGER]): ARRAY [NATURAL_8]
			-- Evaluate relevant predicates from `relevant_predicat_table' for
			-- feature with `a_feature_id' on operands `a_operands'.
			-- Result is a list of responses for each predicate in `l_predicates', the order of the result
			-- corresponds to the predicate order in `l_predicates'.
			-- 0 means don't know (may because an exception occurred during evaluation)
			-- 1 means the predicate evaluated to True,
			-- 2 means the predicate evaluated to False.
		require
			a_feature_id_positive: a_feature_id > 0
			a_feature_id_exists: relevant_predicate_table.has (a_feature_id)
			a_operands_attached: a_operands /= Void
		local
			i, j: INTEGER
			l_arg_count: INTEGER
			l_upper: INTEGER
			l_count: INTEGER
			l_predicate_result: NATURAL_8
			l_predicates: ARRAY [TUPLE [predicate_id: INTEGER; operand_index: SPECIAL [INTEGER]]]
			l_pred_data: TUPLE [predicate_id: INTEGER; operand_index: SPECIAL [INTEGER]]
			l_arguments: like argument_cache
			l_arg_positions: SPECIAL [INTEGER]
			l_checking: BOOLEAN
		do
			l_predicates := relevant_predicate_table.item (a_feature_id)
			create Result.make (1, l_predicates.count)
			l_arguments := argument_cache
			l_checking := {ISE_RUNTIME}.check_assert (False)
			from
				i := 1
				l_count := l_predicates.upper
			until
				i > l_count
			loop
				l_pred_data := l_predicates.item (i)
				l_arg_positions := l_pred_data.operand_index
				l_upper := l_arg_positions.count
				from
					j := 0
					l_arg_count := l_arg_positions.count
				until
					j = l_arg_count
				loop
					l_arguments.put (a_operands.item (l_arg_positions.item (j)), j + 1)
					j := j + 1
				end

				l_predicate_result := evaluated_predicate_result (l_pred_data.predicate_id, l_arguments, 1, l_upper)
				Result.put (l_predicate_result, i)
				i := i + 1
			end
			l_checking := {ISE_RUNTIME}.check_assert (l_checking)
		ensure
			result_attached: Result /= Void
			result_valid: Result.lower = 1 and then Result.count = relevant_predicate_table.item (a_feature_id).count
		end

	argument_cache: ARRAY [INTEGER]
			-- Cache for arguments used in predicate evaluation

	argument_tuple_cache: ARRAYED_LIST [detachable ANY]
			-- Cache for arguments used in predicate evaluation.

	value_of_object (a_object: ANY; a_type: STRING): STRING
			-- Value of `a_object', which is of type `a_type'
		require
			a_type_attached: a_type /= Void
		do
			if primitive_types.has (a_type) then
				Result := a_object.out
			else
				Result := "__REF__"
			end
		ensure
			result_attached: Result /= Void
			not_result_is_empty: not Result.is_empty
		end

	primitive_types: HASH_TABLE [INTEGER, STRING]
			-- Names for primitive types

feature -- Test case serialization

	test_case_serialization_file: detachable RAW_FILE
			-- File to store serialized test cases.

	test_state_file: PLAIN_TEXT_FILE
			-- File to store test case states

	test_case_serializer: ITP_TEST_CASE_SERIALIZER
			-- Test case serializer

	retrieve_test_case_prestate (a_data: detachable ANY)
			-- Retrieve prestate of operands for the test case to be executed next.
			-- Store serialized objects in `serialized_objects' and
			-- object state information on `objects_summary'.
		local
			l_serializer: like test_case_serializer
		do
			l_serializer := test_case_serializer
			l_serializer.set_is_test_case_valid (False)

			if attached {detachable ARRAY [detachable ANY]} a_data as l_extra_data then
				l_serializer.setup_test_case (l_extra_data.item (extra_data_index_test_case_serialization))

				if l_serializer.is_test_case_setup then
					l_serializer.retrieve_pre_state
				end
			end
		end

	retrieve_post_test_case_state
			-- Retrieve post test case state.		
		do
			if test_case_serializer.is_test_case_setup then
				test_case_serializer.retrieve_post_state (is_failing_test_case)
			end
		end

	log_test_case_serialization
			-- Log serialization of the last test case into log file.
		local
			l_data: TUPLE [serialization:STRING; states: STRING]
		do
			last_test_case_serialization := Void
			if test_case_serializer.is_test_case_setup and then not is_invalid_test_case and then not is_last_invariant_violated then
				if
					(is_passing_test_case_serialized and (not is_failing_test_case)) or
					(is_failing_test_case_serialized and is_failing_test_case)
				then
					l_data := test_case_serializer.string_representation
					if not l_data.serialization.is_empty then
						test_case_serialization_file.put_string (l_data.serialization)
					end
					if not l_data.states.is_empty then
						test_state_file.put_string (l_data.states)
					end
					if is_last_test_case_serialization_passed_to_proxy then
						last_test_case_serialization := [l_data.serialization]
					end
				end
			end
		end

	is_test_case_serialization_enabled: BOOLEAN
			-- Is test case serialization enabled?

	is_duplicated_test_case_serialized: BOOLEAN
			-- Should duplicated test case be serialized?

	agent_creation_info: HASH_TABLE [ITP_AGENT_CREATION_INFO, INTEGER]
			-- Information about already created agent objects.
			-- Key is variable ID, value is the agent creation information describing
			-- how that agent is created.

	is_test_case_agent_creation: BOOLEAN
			-- Is the test case to-be-executed an agent creation?

	last_test_case_serialization: TUPLE [serialization: STRING]
			-- Serialization data for the last executed test case
			-- Void if serialization is disabled or no serialization is retrieved.

	is_last_test_case_serialization_passed_to_proxy: BOOLEAN
			-- Should `last_test_case_serialization' be passed back to the proxy side
			-- during testing? Used for online analysis, for example, precondition-reduction.

feature -- Semantic search

	is_batch_assignment: BOOLEAN
			-- Is last request a batch-assignment?

	special_type_mapping: HASH_TABLE [INTEGER, INTEGER]
			-- Mapping between dynamic type of SPECIAL instances
			-- to abstract element types.
		local
			l_int: INTERNAL
		once
			create l_int
			create Result.make (10)
			Result.put ({INTERNAL}.boolean_type, ({BOOLEAN}).type_id)
			Result.put ({INTERNAL}.character_8_type, ({CHARACTER_8}).type_id)
			Result.put ({INTERNAL}.character_32_type, ({CHARACTER_32}).type_id)

			Result.put ({INTERNAL}.natural_8_type, ({NATURAL_8}).type_id)
			Result.put ({INTERNAL}.natural_16_type, ({NATURAL_16}).type_id)
			Result.put ({INTERNAL}.natural_32_type, ({NATURAL_32}).type_id)
			Result.put ({INTERNAL}.natural_64_type, ({NATURAL_64}).type_id)

			Result.put ({INTERNAL}.integer_8_type, ({INTEGER_8}).type_id)
			Result.put ({INTERNAL}.integer_16_type, ({INTEGER_16}).type_id)
			Result.put ({INTERNAL}.integer_32_type, ({INTEGER_32}).type_id)
			Result.put ({INTERNAL}.integer_64_type, ({INTEGER_64}).type_id)

			Result.put ({INTERNAL}.real_32_type, ({REAL_32}).type_id)
			Result.put ({INTERNAL}.real_64_type, ({REAL_64}).type_id)

			Result.put ({INTERNAL}.pointer_type, ({POINTER}).type_id)
		ensure
			special_type_mapping_not_void: Result /= Void
		end

invariant
	log_file_open_write: log_file.is_open_write
	store_not_void: object_store /= Void
	output_buffer_attached: output_buffer /= Void
	error_buffer_attached: error_buffer /= Void
	socket_attached: socket /= Void

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end

