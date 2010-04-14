note
	description: "[
		Interpreter for line based Eiffel like interpreter language.
		Depends on a generated Erl-G reflection library.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

deferred class ITP_INTERPRETER

inherit
	ANY

	EXCEPTIONS

	ARGUMENTS
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

feature {NONE} -- Initialization

	execute
			-- Execute interpreter.
			-- Command line for current: interpreter <port> <melt feature id> <log file>
			-- <port> is the port number used in socket IPC
			-- <melt feature id> is the feature body ID whose byte-code is to be injected
			-- <log file> is the file to store logs.
		local
			l_log_filename: STRING
			l_server_url: STRING
			l_port: INTEGER
			l_tc_serialization_file_name: STRING
		do
			if argument_count < 6 then
				check Wrong_number_of_arguments: False end
			end
				-- Read command line argument
			l_server_url := argument (1)
			l_port := argument (2).to_integer
			byte_code_feature_body_id := argument (3).to_integer
			byte_code_feature_pattern_id := argument (4).to_integer
			l_log_filename := argument (5)
			should_generate_log := argument (6).to_boolean

				-- Setup file to store serialized test case.
			if argument_count = 9 then
				only_serialize_failed_test_case := argument (7).to_boolean
				l_tc_serialization_file_name := argument (8)
				is_test_case_serialization_enabled := True
				is_duplicated_test_case_serialized := argument (9).to_boolean
			else
				only_serialize_failed_test_case := True
				l_tc_serialization_file_name := ""
				is_test_case_serialization_enabled := False
			end

				-- Redirect standard output to `output_buffer'.
			create output_buffer.make (buffer_size)
			create error_buffer.make (buffer_size)

				-- Create object pool
			create store.make
			store.set_is_typed_search_enabled (is_test_case_serialization_enabled)

				-- Create storage for object state retrieval.
			create query_values.make
			create query_status.make

			create primitive_types.make (10)
			primitive_types.put (1, "INTEGER_32")
			primitive_types.put (2, "BOOLEAN")

				-- Create log file.
			create log_file.make_open_append (l_log_filename)
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

				-- Initialize precondition table.
			initialize_precondition_table

				-- Initialize predicate related data structure.
			initialize_predicates

				-- Initialize supported query name table.
			initialize_supported_query_name_table

				-- Create test case serializer.
			create test_case_serializer.make (Current)

			start (l_port, (create {INET_ADDRESS_FACTORY}).create_loopback)

				-- Close log file.
			log_file.close

				-- Close test case serialization file.
			if test_case_serialization_file /= Void then
				test_case_serialization_file.close
			end
		end

	start (a_port: INTEGER; a_server_url: INET_ADDRESS)
			-- Connect to EiffelStudio and initiate `main_loop'.
		require
			a_server_url_attached: a_server_url /= Void
			a_port_valid: a_port >= 0
		local
			l_excpt_trace: like exception_trace
			l_trace: STRING
		do
			create socket.make_client_by_address_and_port (a_server_url, a_port)
			socket.connect
			--socket.set_blocking
				-- Wait for test cases and then execute test cases in a loop.
			log_message ("<session>%N")
			main_loop
			log_message ("</session>%N")
		rescue
				-- Get an one line trace by replacing new line characters with space, since
				-- the stream parser from proxy cannot deal with multi line error messages.
				-- TODO: Added support for multi line error message.
			l_excpt_trace:= exception_trace
			check l_excpt_trace /= Void end
			l_trace := l_excpt_trace.twin
			l_trace.replace_substring_all ("%N", " ")

			report_error ("internal. " + l_trace)
			log_internal_error (l_excpt_trace)
			log_message ("</session>%N")
			die (1)
		end

feature -- Status report

	has_error: BOOLEAN
			-- Has an error occured while parsing?

	is_last_protected_execution_successfull: BOOLEAN
			-- Was the last protected execution successfull?
			-- (i.e. did it not trigger an exception)

	should_quit: BOOLEAN
			-- Should main loop quit?

	is_request_type_valid (a_type: NATURAL_32): BOOLEAN is
			-- Is `a_type' a valid request type?
		do
			Result :=
				a_type = start_request_flag or else
				a_type = quit_request_flag or else
				a_type = execute_request_flag or else
				a_type = object_state_request_flag or else
				a_type = type_request_flag or else
				a_type = precondition_evaluation_request_flag or else
				a_type = predicate_evaluation_request_flag
		end

	should_generate_log: BOOLEAN
			-- Should interpreter log be generated?

	only_serialize_failed_test_case: BOOLEAN
			-- Should only failed test cases be serialized?
			-- Only has effect when serialization is enabled.

feature -- Access

	variable_at_index (a_index: INTEGER): detachable ANY
			-- Object in `store' at position `a_index'.
		do
			Result := store.variable_value (a_index)
		end

feature {NONE} -- Handlers

	report_type_request
		require
			last_request_attached: last_request /= Void
			last_request_is_type_request: last_request_type = type_request_flag
		local
			b: BOOLEAN
			l_index: INTEGER
			l_value: detachable ANY
			l_store: like store
			l_type: STRING
			l_generating_type: STRING
		do
			if attached {STRING} last_request as l_obj_index then
				log_message ("report_type_request start%N")
				l_index := l_obj_index.to_integer
				l_store := store
				if l_store.is_variable_defined (l_index) then
					l_value := l_store.variable_value (l_index)
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
					report_error ("Variable `v_" + l_index.out + "' not defined.")
				end
				log_message ("report_type_request end%N")
			else
				report_error (invalid_request_format_error)
			end

				-- Send response to the proxy.
			refresh_last_response_flag
			last_response := [0, Void, output_buffer, error_buffer]
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
			last_request_is_execute_request: last_request_type = execute_request_flag
		local
			l_bcode: STRING
			l_predicate_results: TUPLE [INTEGER, detachable like evaluated_predicate_results]
			i: INTEGER
			l_object_summary: ARRAYED_LIST [STRING]
			l_upper: INTEGER
			l_lower: INTEGER
			l_canned_objects: STRING
			l_serializer: like test_case_serializer
		do
			is_failing_test_case := False
			if attached {TUPLE [l_byte_code: STRING; l_data: detachable ANY]} last_request as l_last_request then
				l_bcode := l_last_request.l_byte_code
				if l_bcode.count = 0 then
					report_error (byte_code_length_error)
				else
					log_message ("report_execute_request start%N")
						-- Inject received byte-code into byte-code array of Current process.
					eif_override_byte_code_of_body (
						byte_code_feature_body_id,
						byte_code_feature_pattern_id,
						pointer_for_byte_code (l_bcode),
						l_bcode.count)

						-- Test case serialization: retrieve pre-TC state.
					retrieve_test_case_prestate (l_last_request.l_data)

						-- Run the feature with newly injected byte-code.
					execute_protected
					log_message ("report_execute_request end%N")

						-- Evaluate relevant predicates.
					if is_last_protected_execution_successfull and then is_predicate_evaluation_enabled then
						if attached {detachable ARRAY [detachable ANY]} l_last_request.l_data as l_extra_data then
							if attached {TUPLE [feature_id: INTEGER; operands: SPECIAL [INTEGER]]} l_extra_data.item (extra_data_index_precondition_satisfaction) as l_feature_data then
								l_predicate_results :=  [l_feature_data.feature_id, evaluated_predicate_results (l_feature_data.feature_id, l_feature_data.operands)]
							else
								l_predicate_results := Void
							end
						end
					end

						-- Test case serialization.
					retrieve_post_test_case_state
					log_test_case_serialization
				end
			else
				report_error (invalid_request_format_error)
			end

				-- Send response to the proxy.
			refresh_last_response_flag
			last_response := [invariant_violating_object_index, l_predicate_results, output_buffer, error_buffer]
			send_response_to_socket
		end

	refresh_last_response_flag is
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
			error_buffer.append ("error: " + a_reason + "%N")
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
				log_file.put_string ("<error type='internal'>%N")
				log_file.put_string ("%T<reason>%N<![CDATA[%N")
				log_file.put_string (a_reason)
				log_file.put_string ("]]>%N</reason>%N")
				log_file.put_string ("</error>%N")
			end
		end

feature {NONE} -- Logging

	log_file: PLAIN_TEXT_FILE
			-- Log file

	log_instance (an_object: detachable ANY)
			-- Log an XML representation of `an_object' to `log_file'.
		do
			log_message ("<instance<![CDATA[%N")
			if an_object = Void then
				log_message ("Void%N")
			else
				log_message (an_object.tagged_out)
			end
			log_message ("]]>%N</instance>%N")
		end

	log_message (a_message: STRING)
			-- Log message `a_messgae' to `log_message'.
		require
			a_message_not_void: a_message /= Void
		do
			if should_generate_log then
				log_file.put_string (a_message)
			end
		end

	report_trace
			-- Report trace information into `error_buffer'.
		require
--			has_exception: An exception happened before
		local
			l_buffer: like error_buffer
			l_exception_code: INTEGER
			l_recipient: like recipient_name
			l_recipient_class_name: like class_name
			l_tag: like tag_name
			l_trace: like exception_trace
			l_meaning: like meaning
		do
				-- Gather exception information.
			l_exception_code := exception
			l_meaning := meaning (l_exception_code)
			l_tag := tag_name
			l_recipient := recipient_name
			l_recipient_class_name := class_name
			l_trace := exception_trace
			check l_trace /= Void end

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
			log_message ("<call_result type='exception'>%N")
			log_message ("%T<meaning value='" + l_meaning + "'/>%N")
			log_message ("%T<tag value='" + l_tag + "'/>%N")
			log_message ("%T<recipient value='" + l_recipient + "'/>%N")
			log_message ("%T<class value='" + l_recipient_class_name + "'>%N")
			log_message ("%T<invariant violation on entry='" + is_last_invariant_violated.out + "'>%N")
			log_message ("%T<exception_trace>%N<![CDATA[%N")
			log_message (l_trace)
			log_message ("]]>%N</exception_trace>%N")
			log_message ("</call_result>%N")
		end

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
				from until
					socket.readable or socket.is_closed
				loop
					sleep (100_000_000)
				end
				if socket.readable then
						-- Read the type of the next request.
					socket.read_natural_32
					last_request_type := socket.last_natural_32

					if attached {like last_request} socket.retrieved as l_request then
						last_request := l_request
					end
				end
			end
		rescue
			l_retried := True
			last_request := Void
			socket.close
			retry
		end

	send_response_to_socket
			-- Send response stored in `output_buffer' and `error_buffer' into `socket'.
			-- If error occurs, close `socket'.
		local
			l_retried: BOOLEAN
			l_last_response: like last_response
		do
			if not l_retried then
				socket.put_natural_32 (last_response_flag)
				l_last_response := last_response
				check l_last_response /= Void end
				socket.independent_store (l_last_response)
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
					report_error ("Received data is not recognized as a request.")
				else
					inspect
						last_request_type
					when execute_request_flag then
						report_execute_request
					when type_request_flag then
						report_type_request

					when start_request_flag then
						report_start_request

					when object_state_request_flag then
						report_object_state_request

					when precondition_evaluation_request_flag then
						report_precondition_evaluation_request

					when predicate_evaluation_request_flag then
						report_predicate_evaluate_request

					when quit_request_flag then
						report_quit_request
					end
				end
			else
				report_error (invalid_request_type_error +" Type code: " + last_request_type.out)
			end
		end

feature {ITP_TEST_CASE_SERIALIZER} -- Object pool

	store: ITP_STORE
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
			is_last_protected_execution_successfull := False
			if not failed then
				execute_byte_code
				is_last_protected_execution_successfull := True
			end
		rescue
			failed := True
			report_trace

				-- Book keeps found faults.
			if not is_last_invariant_violated then
				is_failing_test_case := not (recipient_name.is_equal (once "execute_byte_code") and then exception = {EXCEP_CONST}.Precondition)
			end
--			if exception = Class_invariant then
--					-- A class invariant cannot be recovered from since we
--					-- don't know how many and what objects are now invalid
--				should_quit := True
--			end
			retry
		end

	pointer_for_byte_code (a_byte_code_string: STRING): POINTER
			-- pointer representation for `a_byte_code_string'
		require
			a_byte_code_string_attached: a_byte_code_string /= Void
		local
			l_managed_ptr: MANAGED_POINTER
			l_count: INTEGER
			i: INTEGER
		do
			l_count := a_byte_code_string.count
			create l_managed_ptr.make (l_count)
			from
				i := 1
			until
				i > l_count
			loop
				l_managed_ptr.put_character (a_byte_code_string.item (i), i - 1)
				i := i + 1
			end
			Result := l_managed_ptr.item
		ensure
			result_attached: Result /= default_pointer
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
			-- Store `a_object' at `a_index' in `store'.
		do
			store.assign_value (a_object, a_index)
		end

	eif_override_byte_code_of_body (a_body_id: INTEGER; a_pattern_id: INTEGER; a_byte_code: POINTER; a_length: INTEGER)
			-- Store `a_byte_code' of `a_length' byte long for feature with `a_body_id'.
		require
			a_body_id_not_negative: a_body_id >= 0
			a_byte_code_attached: a_byte_code /= default_pointer
			a_length_positive: a_length > 0
		external
			"C inline use %"eif_interp.h%""
		alias
			"[
#ifdef WORKBENCH
			eif_override_byte_code_of_body ((int) $a_body_id, (int) $a_pattern_id, (unsigned char *) $a_byte_code, (int) $a_length);
#endif
			]"
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

feature{ITP_TEST_CASE_SERIALIZER} -- Invariant checking

	is_last_invariant_violated: BOOLEAN
			-- Is the class invariant violated when `check_invariant' is invoked
			-- the last time?

	is_failing_test_case: BOOLEAN
			-- Is current test case failing, meaning that it reveals a fault?

feature{NONE} -- Invariant checking

	invariant_violating_object_index: INTEGER
			-- Index of the object which violates it class invariant

	check_invariant (a_index: INTEGER; o: detachable ANY) is
			-- Check if the class invariant `o' with index `a_index' is satisfied.
			-- If not satisfied, set `is_last_invariant_violated' to True
			-- and raise the exception.
			-- If satisfied, set `is_last_invariant_violated' to False.
			-- if `o' is detached, set `is_last_invariant_violated' to False and do nothing.
		require
			a_index_positive: a_index > 0
		do
			if attached {ANY} o as l_obj then
				l_obj.do_nothing
			end
			invariant_violating_object_index := 0
		rescue
			is_last_invariant_violated := True
			invariant_violating_object_index := a_index
		end

feature -- Object state checking

	last_exception_trace: detachable STRING
			-- Last exception trace

	report_precondition_evaluation_request is
			-- Report and precondition evaluation request.
		local
			l_result: detachable TUPLE
		do
			output_buffer.wipe_out
			error_buffer.wipe_out
			if attached {TUPLE [l_feature_name: STRING; l_arguments: ARRAY [INTEGER]]} last_request as l_request then
				l_result := objects_satisfying_precondition (l_request.l_feature_name, l_request.l_arguments)
				if l_result /= Void then
					last_response := [l_request.l_arguments, output_buffer, error_buffer]
				else
					last_response := [Void, output_buffer, error_buffer]
				end
				refresh_last_response_flag
				send_response_to_socket
			else
				report_error (invalid_precondition_evaluation_request)
				last_response := [Void, output_buffer, error_buffer]
				refresh_last_response_flag
				send_response_to_socket
			end
		end

	record_object_queries (a_object_index: INTEGER; a_object: ANY) is
			-- Record queries of object with `a_object_index' in object pool into `query_values' and `query_status'.
			-- If there the specified object is invariant-violating, `a_queries' is not changed,
			-- and no error will be reported.
		do
			execute_protected_for_query_recording (a_object)
		end

	object_summary (a_object_index: INTEGER): TUPLE [obj_summary: STRING; hash: INTEGER] is
			-- Summary of `a_object_index'
			-- `obj_summary' is the summary of the variable given by index `a_object_index'.
			-- `hash' is the hash code of the summary, with object index ignored.
		require
			a_object_index_valid: a_object_index > 0
		local
			o: detachable ANY
			l_retried: BOOLEAN
			l_values: like query_values
			l_status: like query_status
			l_queries: LINKED_LIST [STRING]
			l_value: detachable STRING
			l_var_name: STRING
			l_hash: INTEGER
			l_data: STRING
		do
			if not l_retried then
				create l_data.make (256)
				initialize_query_value_holders
				o := variable_at_index (a_object_index)
				create l_var_name.make (6)
				l_var_name.append (once " v_")
				l_var_name.append (a_object_index.out)
				if o = Void then
					l_data.append (once ": [[Void]], [[]]%N")
				else
					check_invariant (a_object_index, o)
					l_data.append (once ": [[" + o.generating_type + "]], [[")
					l_data.append (supported_query_types (o))
					l_data.append (once "]]%N")
					record_object_queries (a_object_index, o)

					l_values := query_values
					l_status := query_status
					l_queries := supported_query_names (o)
					if l_values.count = l_status.count and then l_values.count = l_queries.count then
						from
							l_values.start
							l_status.start
							l_queries.start
						until
							l_values.after
						loop
							l_data.append_character ('|')
							l_data.append (l_queries.item_for_iteration)
							l_data.append (once " = ")
							if l_status.item_for_iteration then
								l_value := l_values.item_for_iteration
								if l_value = Void then
									l_value := once "[[Void]]"
								end
								l_data.append (l_value)
								l_data.append_character ('%N')
							else
								l_data.append (once "[[Error]]%N")
							end
							l_values.forth
							l_status.forth
							l_queries.forth
						end
					end
				end
				l_hash := l_data.hash_code
				l_data.prepend (l_var_name)
			else
				create l_data.make (64)
				l_data.append (once ": [[Invariant_violation]], [[]]%N")
				l_hash := Result.hash_code
				l_data.prepend (" v_" + a_object_index.out)
			end
			Result := [l_data, l_hash]
		ensure
			result_attached: Result /= Void
		rescue
			l_retried := True
			retry
		end


	initialize_query_value_holders is
			-- Initialize `query_values' and `query_status'.
		do
			if query_values = Void then
				create query_values.make
			else
				query_values.wipe_out
			end

			if query_status = Void then
				create query_status.make
			else
				query_status.wipe_out
			end
		end

	report_object_state_request is
			-- Report an object state request.
		local
			o: detachable ANY
			l_retried: BOOLEAN
			l_bcode: STRING
			l_index: INTEGER
			l_ind_str: STRING
		do
			if not l_retried then
				output_buffer.wipe_out
				error_buffer.wipe_out
				if attached {TUPLE [l_byte_code: STRING; l_object_ind: ANY]} last_request as l_request then
						-- Load byte-code.
					l_bcode := l_request.l_byte_code
					if l_bcode.count = 0 then
						report_error (byte_code_length_error)
					else
							-- We first check if the invariant of the object is violated,
							-- if so, we don't need to retrieve any state, instead,
							-- an exception will be rasied, and an error message is sent back
							-- to the interpreter.
						l_ind_str ?= l_request.l_object_ind
						l_index := l_ind_str.to_integer
						o := variable_at_index (l_index)
						if o = Void then
							refresh_last_response_flag
							last_response_flag := object_is_void_flag
							last_response := [Void, Void, output_buffer, error_buffer]
							send_response_to_socket
						else
							check_invariant (l_index, o)

								-- If `o' is OK, we start checking the states of it.
							log_message ("report_object_state_request start%N")
								-- Inject received byte-code into byte-code array of Current process.
							eif_override_byte_code_of_body (
								byte_code_feature_body_id,
								byte_code_feature_pattern_id,
								pointer_for_byte_code (l_bcode),
								l_bcode.count)

							if query_values = Void then
								create query_values.make
							else
								query_values.wipe_out
							end

							if query_status = Void then
								create query_status.make
							else
								query_status.wipe_out
							end

								-- Run the feature with newly injected byte-code.
--							execute_protected
							execute_protected_for_query_recording (o)
							log_message ("report_object_state_request end%N")
							last_response := [query_values, query_status, output_buffer, error_buffer]
							refresh_last_response_flag
							send_response_to_socket
						end
					end
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

	invalid_object_state_request: STRING = "Invalid object state request."
			-- Error message for invalid object state request

	invalid_precondition_evaluation_request: STRING = "Invalid precondition evaluation request."

	invalid_predicate_evaluation_request: STRING = "Invalid predicate evaluation request."

	query_values: LINKED_LIST [detachable STRING]
			-- List to store string representation of query values

	query_status: LINKED_LIST [BOOLEAN]
			-- List to store if query value is retrievable.
			-- An item at position `i' is False means that there was
			-- an exception when that feature is being evaluated, so
			-- the value is not retrievable.

	reference_type_output_format: INTEGER
			-- String representation format for reference type.

	record_query (a_query: FUNCTION [ANY, TUPLE, detachable ANY]) is
			-- Execute `a_query' and extend the string representation of the result into `query_values'.
			-- If the query execution succeeded, a True value will be extended to `query_status',
			-- otherwise, a False value will be extended to `query_status'.
		require
			a_query_attached: a_query /= Void
		local
			l_retried: BOOLEAN
			l_result: detachable ANY
			l_str_result: detachable STRING
		do
			if not l_retried then
				l_result := a_query.item (Void)
				if l_result = Void then
					l_str_result := Void
				else
					if reference_type_output_format = value_as_string then
						l_str_result := l_result.out
					elseif reference_type_output_format = value_as_address then
						l_str_result := ($l_result).out
					end
				end
				query_values.extend (l_str_result)
				query_status.extend (True)
			end
		rescue
			query_values.extend (Void)
			query_status.extend (False)
			l_retried := True
			retry
		end

	record_object_state_basic (a_any: ANY) is
			-- Record the query "out" of `a_any'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				query_values.extend (a_any.out)
				query_status.extend (True)
			end
		rescue
			query_values.extend (Void)
			query_status.extend (False)
			l_retried := True
			retry
		end

	value_as_string: INTEGER = 0
			-- Flag to indicate that the string representation of the query value is retrieved by calling `out' on that value.

	value_as_address: INTEGER = 1
			-- Flag to indicate that the string repsrsentation of the query value is its memory address.

	record_queries (o: ANY) is
		deferred
		end

	execute_protected_for_query_recording (o: ANY)
			-- Execute `procedure' in a protected way.
			-- Note: This is a walkaround for the issue that the interpreter
			-- cannot deal with exceptions in melted code correctly.
			-- Remove this feature when that issue is fixed. 19.03.2009 Jason
		local
			failed: BOOLEAN
		do
			is_last_protected_execution_successfull := False
			if not failed then
				record_queries (o)
				is_last_protected_execution_successfull := True
			end
		rescue
			failed := True
			report_trace
--			if exception = Class_invariant then
--					-- A class invariant cannot be recovered from since we
--					-- don't know how many and what objects are now invalid
--				should_quit := True
--			end
			retry
		end

feature -- Precondition satisfaction

	safe_satisfied_objects (a_agent: FUNCTION [ANY, TUPLE, TUPLE]; a_args: TUPLE): detachable TUPLE is
			-- Evaluate precondition wrapped in `a_agent' using arguments `a_args'.
			-- If the precondition is satisfied, return the set of objects that satisfy
			-- the precondition. In most of the cases, the original objects in `a_args' will be returned
			-- In the case when linear constrain solving is needed, the returned satisfied integers may
			-- be different from the original.
			-- If there is an exception during precondition evaluation, return Void.
		local
			l_retried: BOOLEAN
			l_checking: BOOLEAN
		do
			if not l_retried then
				l_checking := {ISE_RUNTIME}.check_assert (False)
				Result := a_agent.item (a_args)
				l_checking := {ISE_RUNTIME}.check_assert (l_checking)
			else
				Result := Void
			end
		rescue
			l_retried := True
			l_checking := {ISE_RUNTIME}.check_assert (l_checking)
			retry
		end

	precondition_table: HASH_TABLE [FUNCTION [ANY, TUPLE, TUPLE], STRING]
			-- Table for precondition evaluation agents for features under test
			-- [agent, feature_identifier]
			-- Key is the feature identifier in the form of "CLASS_NAME.feature_name".
			-- Value is the agent used to evaluate precondition of that feature.

	argument_arrays: ARRAY [ARRAY [INTEGER]]
			-- Array for arguments used in predicate evaluation

	initialize_precondition_table is
			-- Initialize `precondition_table'.
		deferred
		end

	objects_satisfying_precondition (a_feature: STRING; a_args: ARRAY [INTEGER]): detachable TUPLE is
			--
		local
			l_agent: FUNCTION [ANY, TUPLE, TUPLE]
		do
			l_agent := precondition_table.item (a_feature)
			Result := safe_satisfied_objects (l_agent, arguement_tuple_from_indexes (a_args, a_args.lower, a_args.upper))
		end

	arguement_tuple_from_indexes (a_indexes: ARRAY [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): TUPLE is
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

	initialize_predicates is
			-- Initialize `predicate_table' and `predicate_arity'.
		deferred
		end

	evaluated_predicate_result (a_predicate_id: INTEGER; a_arguments: ARRAY [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): NATURAL_8 is
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

	safe_predicate_evaluation_result (a_predicate: FUNCTION [ANY, TUPLE, BOOLEAN]; a_arguments: TUPLE): NATURAL_8 is
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

	report_predicate_evaluate_request is
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

--					check
--						(l_arity > 0 implies l_objects.count \\ l_arity = 0) and then
--						(l_arity = 0 implies l_objects.count = 0)
--					end
					l_args := l_argument_holder.item (l_arity)
					if l_arity = 0 then
						create l_pred_response.make (1)
					else
						create l_pred_response.make (l_count // l_arity)
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

	evaluated_predicate_results (a_feature_id: INTEGER; a_operands: SPECIAL [INTEGER]): ARRAY [NATURAL_8] is
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

	value_of_object (a_object: ANY; a_type: STRING): STRING is
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

	test_case_serializer: ITP_TEST_CASE_SERIALIZER
			-- Test case serializer

	supported_query_names (o: ANY): LINKED_LIST [STRING] is
			-- Suported query names for `o' for state retrieval
		require
			o_attached: o /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	supported_query_types (o: ANY): STRING is
			-- Suported query types for `o' for state retrieval
		require
			o_attached: o /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	initialize_supported_query_name_table is
			-- Initialize `supported_query_name_table'.
		deferred
		end

	supported_query_name_table: HASH_TABLE [LINKED_LIST [STRING], INTEGER]
			-- Table for supported query names
			-- Key is an integer representing different types,
			-- Value is a list of supported query names.

	supported_query_type_table: HASH_TABLE [STRING, INTEGER]
			-- Table for type of supported query names.
			-- Key is an integer representing different types,
			-- Value is a string containing the query types, for example,
			-- if there are 4 queries supported for a type, the first 3 queries are
			-- of type INTEGER and then fourth query is of type BOOLEAN, the string
			-- will be "iiib".
			-- 'i' for INTEGER types
			-- 'b' for BOOLEAN types

	retrieve_test_case_prestate (a_data: detachable ANY) is
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

				if l_serializer.is_test_case_valid then
					l_serializer.retrieve_pre_state
				end
			end
		end

	retrieve_post_test_case_state is
			-- Retrieve post test case state.		
		do
			if test_case_serializer.is_test_case_valid then
				test_case_serializer.retrieve_post_state
			end
		end

	log_test_case_serialization is
			-- Log serialization of the last test case into log file.
		local
			l_serialization: STRING
		do
			if test_case_serializer.is_test_case_valid and then (only_serialize_failed_test_case implies is_failing_test_case) then
				l_serialization := test_case_serializer.string_representation
				if not l_serialization.is_empty then
					test_case_serialization_file.put_string (l_serialization)
				end
			end
		end

	is_test_case_serialization_enabled: BOOLEAN
			-- Is test case serialization enabled?

	is_duplicated_test_case_serialized: BOOLEAN
			-- Should duplicated test case be serialized?

invariant
	log_file_open_write: log_file.is_open_write
	store_not_void: store /= Void
	output_buffer_attached: output_buffer /= Void
	error_buffer_attached: error_buffer /= Void
	socket_attached: socket /= Void

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end

