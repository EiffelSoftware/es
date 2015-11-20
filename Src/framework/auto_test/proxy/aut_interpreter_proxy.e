note
	description:

		"Proxy for Erl-G interpreters"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_INTERPRETER_PROXY

inherit
	AUT_PROXY_EVENT_PRODUCER
		rename
			make as make_event_producer
		end

	AUT_RESPONSE_PARSER
		rename
			make as make_response_parser
		redefine
			parse_response
		end

	PROCESS_FACTORY
		export {NONE} all end

	DT_SHARED_SYSTEM_CLOCK
		export {NONE} all end

	KL_SHARED_OPERATING_SYSTEM
		export {NONE} all end

	UNIX_SIGNALS
		export {NONE} all end

	EXECUTION_ENVIRONMENT
		rename
			system as execution_system
		export
			{NONE} all
		end

	AUT_SHARED_INTERPRETER_INFO

	EXCEPTIONS
		rename
			ignore as exc_ignore,
			catch as exc_catch,
			meaning as exc_meaning
		end

	COMPILER_EXPORTER

	AUT_SHARED_CONSTANTS

	SED_STORABLE_FACILITIES

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		undefine
			system
		end

	AUT_SHARED_PREDICATE_CONTEXT
		undefine
			system
		end

	AUT_SHARED_RANDOM

	AUT_SHARED_TYPE_FORMATTER

	AUT_SHARED_ONLINE_STATISTICS

	EPA_UTILITY
		undefine
			system
		end

create
	make

feature {NONE} -- Initialization

	make (an_executable_file_name: READABLE_STRING_GENERAL;
			a_system: like system;
			an_interpreter_log_filename: READABLE_STRING_GENERAL;
			a_proxy_log_filename: READABLE_STRING_GENERAL;
			a_serialization_file_name: STRING;
			a_error_handler: like error_handler;
			a_config: like configuration)
			-- Create a new proxy for the interpreter found at `an_executable_file_name'.
		require
			an_executable_file_name_not_void: an_executable_file_name /= Void
			a_system_not_void: a_system /= Void
			an_interpreter_log_filename_not_void: an_interpreter_log_filename /= Void
			a_proxy_log_filename_not_void: a_proxy_log_filename /= Void
			a_serialization_file_name_attached: a_serialization_file_name /= Void
			a_error_handler_not_void: a_error_handler /= Void
			interpreter_root_class_attached: interpreter_root_class /= Void
		local
			l_itp_class: CLASS_C
			l_file_printer: AUT_PROXY_LOG_TEXT_STREAM_PRINTER
			l_dir: DIRECTORY_NAME
			u: GOBO_FILE_UTILITIES
		do
			configuration := a_config

			make_event_producer

			l_itp_class := interpreter_class
			create variable_table.make (a_system)
			create raw_response_analyzer
			make_response_parser (a_system)

				-- You can only do this after the compilation of the interpreter.
			check attached feature_for_byte_code_injection as l_feature then
				l_itp_class := l_feature.written_class
				injected_feature_body_id := l_feature.real_body_index (l_itp_class.types.first)
				injected_feature_pattern_id := l_feature.real_pattern_id (l_itp_class.types.first)
			end

				-- Setup socket data printer.
			create socket_data_printer.make (system, variable_table, Current)

			executable_file_name := an_executable_file_name
			create melt_path.make_from_string (an_executable_file_name)
			melt_path := melt_path.parent
			interpreter_log_filename := an_interpreter_log_filename
			test_case_serialization_filename := a_serialization_file_name.twin
			create proxy_log_file.make (a_proxy_log_filename)
				-- Create proxy log printers.
			create proxy_log_printers.make
			proxy_log_file.open_write

			if not configuration.proxy_log_options.is_empty then
				create l_file_printer.make (system, configuration, variable_table, proxy_log_file)
				l_file_printer.set_with_config_string (configuration.proxy_log_options)
				proxy_log_printers.extend (l_file_printer)
			end

			disable_catcall_warnings
			set_is_logging_enabled (True)
			set_is_speed_logging_enabled (True)
			set_is_test_case_index_logging_enabled (True)
			log_types_under_test

			log_line ("-- A new proxy has been created.")
			proxy_start_time := system_clock.date_time_now
			error_handler := a_error_handler
			timeout := default_timeout

			if configuration.is_object_state_exploration_enabled then
				create object_state_table.make
			end
			generate_typed_object_pool
			setup_online_statistics

			if configuration.is_test_case_serialization_retrieved_online and configuration.output_dir_for_test_case_online /= Void then
				online_test_case_directory := configuration.output_dir_for_test_case_online
				output_test_case_online_filter := configuration.output_test_case_online_filter
				setup_online_test_case_directory
				on_test_case_serialization_actions.extend (agent output_test_case)
			end
		ensure
			executable_file_name_set: executable_file_name = an_executable_file_name
			system_set: system = a_system
			proxy_log_file_created: proxy_log_file /= Void
			test_case_serialization_filename_set: test_case_serialization_filename.same_string_general (a_serialization_file_name)
			error_handler_set: error_handler = a_error_handler
			timeout_set: timeout = default_timeout
			is_logging_enabled: is_logging_enabled
			configuration_set: configuration = a_config
		end

feature -- Status

	is_ready: BOOLEAN
			-- Is client ready for new commands?

	is_running: BOOLEAN
			-- Is the client currently running?
		do
			Result := process /= Void and then process.is_running
		ensure
			result_implies_attached: Result implies process /= Void
			result_implies_running: Result implies process.is_running
		end

	is_launched: BOOLEAN
			-- Has the client been launched?
			-- Note that `is_launched' will be True also when the child has
			-- terminated in the meanwhile.
		do
			Result := process /= Void and then process.is_launched
		ensure
			result_implies_attached: Result implies process /= Void
			result_implies_launched: Result implies process.is_launched
		end

	is_executing: BOOLEAN = True
			-- <Precursor>
			--
			-- Note: `Current' always sends request to an interpreter.

	is_replaying: BOOLEAN
			-- Is Current in replay mode?
			-- If so, no extra "type" request will be generated
			-- after every "assign" request and every query invokation.
			-- Default: False

	is_logging_enabled: BOOLEAN
			-- Should logging be enabled?

	is_test_case_index_logging_enabled: BOOLEAN
			-- Should `test_case_index' be logged?

	is_last_test_case_executed: BOOLEAN
			-- Is last test case executed?
			-- True if either:
			-- 1. the test case executed with no exception
			-- 2. the test case executed with some exception
			-- False if there is a precondition violation or class invariant violation in pre-state.

	is_last_test_case_passing: BOOLEAN
			-- Is last test case passing?

feature -- Access

	timeout: INTEGER
			-- Client timeout in seconds

	last_request: AUT_REQUEST
			-- Last request sent via this proxy

	variable_table: AUT_VARIABLE_TABLE
			-- Table for index and types of object in object pool

	proxy_log_filename: PATH
			-- File name of proxy log
		do
			Result := proxy_log_file.path
		ensure
			filename_not_void: Result /= Void
			valid_filename: Result.name.same_string (proxy_log_file.name)
		end

	configuration: TEST_GENERATOR
			-- Configuration associated with current AutoTest run

	proxy_failure_log_filename: STRING
			-- File name of proxy failure log
			-- Ilinca, "number of faults law" experiment
		do
			Result := proxy_failure_log_file.name
		ensure
			filename_not_void: Result /= Void
			valid_filename: Result.same_string_general (proxy_failure_log_file.name)
		end

	on_test_case_serialization_actions: ACTION_SEQUENCE [TUPLE [serialization: detachable STRING]]
			-- Actions to be performed when test case serialization data arrived.
			-- Have effect only if test case serialization is enabled.
		do
			if attached on_test_case_serialization_actions_internal as l_actions then
				Result := l_actions
			else
				create on_test_case_serialization_actions_internal
				Result := on_test_case_serialization_actions_internal
			end
		end

feature -- Settings

	set_timeout (a_timeout: like timeout)
			-- Set `timeout' with `a_timeout'.
		require
			a_timeout_valid: a_timeout > 0
		do
			timeout := a_timeout
		ensure
			timeout_set: timeout = a_timeout
		end

	set_is_logging_enabled (b: BOOLEAN)
			-- Set `is_logging_enabled' with `b'.
		do
			is_logging_enabled := b
		ensure
			is_logging_enabled_set: is_logging_enabled = b
		end

	set_is_in_replay_mode (b: BOOLEAN)
			-- Set `is_in_replay_mode' with `b'.
		do
			is_replaying := b
		ensure
			is_in_replay_mode_set: is_replaying = b
		end

	set_proxy_log_filename (a_filename: like proxy_log_filename)
			-- Make `a_filename' the new proxy filename.
		require
			a_filename_not_void: a_filename /= Void
		do
			if proxy_log_file.is_open_write then
				proxy_log_file.close
			end
			create proxy_log_file.make_with_path (a_filename)
			proxy_log_file.open_write
			log_line ("-- An existing proxy has switched to this log file.")
		end

	set_is_test_case_index_logging_enabled (b: BOOLEAN)
			-- Set `is_test_case_index_logging_enabled' with `b'.
		do
			is_test_case_index_logging_enabled := b
		ensure
			is_test_case_index_logging_enabled_set: is_test_case_index_logging_enabled = b
		end

	set_is_last_test_case_executed (b: BOOLEAN)
			-- Set `is_last_test_case_executed' with `b'.
		do
			is_last_test_case_executed := b
		ensure
			is_last_test_case_executed_set: is_last_test_case_executed = b
		end

	analyze_last_test_case_status (a_last_request: like last_request)
			-- Analyze the status of last test case
		do
			set_is_last_test_case_executed (is_last_test_case_executed_internal (a_last_request))
			set_is_last_test_case_passing (is_last_test_case_passing_internal (a_last_request))
		end

feature -- Execution

	start
			-- Start the client.
		require
			not_running: not is_running
		local
			l_listener: AUT_SOCKET_LISTENER
			l_tried_times: INTEGER
			l_max_tring_times: INTEGER
		do
			from
				l_max_tring_times := 5
			until
				l_tried_times = l_max_tring_times or else is_ready
			loop
--				log_time_stamp ("start")
				proxy_log_printers.set_start_time (test_duration)
				log_seed
				create {AUT_START_REQUEST} last_request.make (system)
				variable_table.wipe_out

					-- Create socket and start listening on `port'.
				if socket /= Void and then socket.exists and then not socket.is_closed then
					socket.cleanup
				end

	--				-- Initialize a new socket for IPC.
	--				-- Fixeme: port number is increased every time when we try to launch the interpreter
	--				-- It should be possible to reuse port number, but when I tried it, I always got
	--				-- socket connection problems. Jason 2008.10.21
	--			fixme ("Try to reuse port number.")
	--			port := next_port_number
	--			create l_socket.make_server_by_port (port)
	--			l_socket.set_blocking
	--			l_socket.listen (1)

				create l_listener.make
				l_listener.open_new_socket
				if l_listener.is_listening then
					port := l_listener.current_port

						-- Launch interpreter process.			
					launch_process

					if is_running then
							-- Get socket to communicate with interpreter.
	--					l_socket.accept
	--					fixme ("If interpreter process dies now, current thread will be blocked forever.")
	--					(create {EXECUTION_ENVIRONMENT}).sleep (1000000000)
	--					socket := l_socket.accepted
						if attached {like socket} l_listener.wait_for_connection (5000) as l_socket then
							socket := l_socket
							process.set_timeout (timeout)
							last_request.process (socket_data_printer)
							flush_process
							log_line (proxy_has_started_and_connected_message)
							log_line (itp_start_time_message + error_handler.duration_to_now.second_count.out)
							online_statistics.report_session_restart (test_duration)
							parse_start_response
							last_request.set_response (last_response)
							proxy_log_printers.report_request (Current, last_request)
							if last_response.is_bad then
								log_line ("-- Proxy received a bad response.")
							end
							is_ready := True
						else
							log_line ("-- Error: Interpreter was not able to connect.")
							is_ready := False
	--						failure_log ("-- Error: Interpreter was not able to connect.%N")
						end
					else
						is_ready := False
						log_line ("-- Error: Could not start and connect to interpreter.")
					end
				else
					log_line ("-- Error: Could not find available port for listening.")
				end
				proxy_log_printers.set_end_time (test_duration)
				if not is_ready then
					stop
				end
				l_tried_times := l_tried_times + 1
			end
		ensure
			last_request_not_void: last_request /= Void
		end

	stop
			-- Close connection to client and terminate it.
			-- If the client is not responsive to a regular shutdown,
			-- its process will be forced to shut down
		require
			is_running: is_launched
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				if process.is_running then

					create {AUT_STOP_REQUEST} last_request.make (system)
					last_request.process (socket_data_printer)
					flush_process
					parse_stop_response
					last_request.set_response (last_response)
					proxy_log_printers.report_request (Current, last_request)
						-- Give the `process' 50 milliseconds to terminate itself
					process.wait_for_exit_with_timeout (50)
					if not process.has_exited then
							-- Force shutdown of `process' because it has not terminated regularly
						log_line ("-- Warning: proxy was not able to terminate interpreter.")

							-- Set flag to indicate that the interpreter should be terminated.
							-- When `time_out_checker_thread' sees this flag, it will terminate the interpreter.
						process.terminate
						is_ready := False
						log_line ("-- Warning: proxy forced termination of interpreter.")
					else
						log_line ("-- Proxy has terminated interpreter.")
					end
				end
				if socket /= Void then
					cleanup_socket
				end
			end
		ensure
			last_request_not_void: last_request /= Void
		rescue
			l_retried := True
			cleanup_socket
			retry
		end

	create_agent (a_receiver: ITP_VARIABLE; a_receiver_type: TYPE_A;
				  a_feature: AUT_FEATURE_OF_TYPE;
				  a_operands: DS_BILINEAR_TABLE [detachable ITP_VARIABLE, INTEGER])
			-- Create an agent object of `a_type' and store it `a_receiver'.
			-- The created agent should wrap around `a_feature'.
			-- `a_operands' specify which operands are closed for the created agent.
			-- `a_operands' is a table, key is 0-based operand index, value is the expression for that closed operand
		require
			a_feature_is_procedure: a_feature.feature_.has_return_value implies a_feature.feature_.is_function
		local
			normal_response:AUT_NORMAL_RESPONSE
			l_request:AUT_CREATE_AGENT_REQUEST
		do
log_time_stamp ("* TEST START *")

			create l_request.make (system, a_receiver, a_receiver_type, a_feature, a_operands)
			last_request := l_request
			last_request.process (socket_data_printer)

			set_test_case_index (l_request)

			proxy_log_printers.set_start_time (test_duration)
log_time_stamp ("* REQUEST SET *")

			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
			proxy_log_printers.set_end_time (test_duration)
log_time_stamp ("* RESPONSE SET * create_agent")
log_time_stamp ("* EXTRA *")

			proxy_log_printers.report_request (Current, last_request)
			if not last_response.is_bad then
				if not last_response.is_error then
					normal_response ?= last_response
					check
						normal_response_not_void: normal_response /= Void
					end
				end
			else
				is_ready := False
			end

			stop_process_on_problems (last_response)
			if is_ready and normal_response /= Void and then normal_response.exception = Void then
				if not is_replaying then
						-- If we are not in replay mode, we generate "type" request to get the
						-- dynamic type of the assignment target. If we are in replay mode,
						-- the "type" request will be already in the replay list, so we don't need to
						-- generate them automatically.					
					retrieve_type_of_variable (a_receiver)
				end
			end
			log_speed
		ensure
			last_request_not_void: last_request /= Void
		end

	create_object (a_receiver: ITP_VARIABLE; a_type: TYPE_A; a_procedure: FEATURE_I; an_argument_list: DS_LINEAR [ITP_EXPRESSION]; a_feature: detachable AUT_FEATURE_OF_TYPE)
			-- Create new object of type `a_type' using creation
			-- procedure `a_feature' and the arguments `an_argument_list'.
			-- Store the created object in variable `a_receiver'.
		require
			is_launched: is_launched
			is_ready: is_ready
			a_receiver_not_void: a_receiver /= Void
			a_type_not_void: a_type /= Void
			a_type_not_expanded: not a_type.is_expanded
			a_procedure_not_void: a_procedure /= Void
			a_procedure_is_not_infix_or_prefix: not a_procedure.is_prefix and then not a_procedure.is_infix
			an_argument_list_doesnt_have_void: not an_argument_list.has (Void)
		local
			normal_response: AUT_NORMAL_RESPONSE
			l_arg_list: DS_LINEAR [ITP_EXPRESSION]
			l_request: AUT_CREATE_OBJECT_REQUEST
			l_is_passing: BOOLEAN
			l_test_duration: INTEGER
		do
			l_arg_list := an_argument_list
			if l_arg_list = Void then
				create {DS_LINKED_LIST [ITP_EXPRESSION]} l_arg_list.make
			end

log_time_stamp ("* TEST START *")

			create l_request.make (system, a_receiver, a_type, a_procedure, l_arg_list)
			if a_feature /= Void then
				l_request.set_feature_id (a_feature.id)
			end
			last_operands := l_request.operand_indexes

			set_test_case_index (l_request)

				-- Object state recording.
			if is_state_recording_enabled then
				record_operand_states (l_request, True)
			end

			last_request := l_request
			last_request.process (socket_data_printer)
			proxy_log_printers.set_start_time (test_duration)
log_time_stamp ("* REQUEST SET *")

			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * create_object")
log_time_stamp ("* EXTRA *")

			l_test_duration := test_duration
			proxy_log_printers.set_end_time (l_test_duration)
			proxy_log_printers.report_request (Current, last_request)
			online_statistics.report_test_case (last_request, l_test_duration, variable_table.variable_count)
			if not last_response.is_bad then
--				is_ready := True
				if not last_response.is_error then
					normal_response ?= last_response
					check
						normal_response_not_void: normal_response /= Void
					end
					if not normal_response.has_exception then
						l_is_passing := True
						variable_table.define_variable (a_receiver, a_type)
							-- Predicate evaluation.
						evaluate_predicates_after_test_case (create {AUT_FEATURE_OF_TYPE}.make (a_procedure, a_type), a_receiver, an_argument_list, Void)
					else
						evaluate_predicates_after_test_case (create {AUT_FEATURE_OF_TYPE}.make (a_procedure, a_type), Void, an_argument_list, Void)
					end
				end
			else
				is_ready := False
			end
			analyze_last_test_case_status (last_request)
			stop_process_on_problems (last_response)
			log_speed
		ensure
			last_request_not_void: last_request /= Void
		end

	invoke_feature (a_type: TYPE_A; a_feature: FEATURE_I; a_target: ITP_VARIABLE; an_argument_list: DS_LINEAR [ITP_EXPRESSION]; aut_feature: detachable AUT_FEATURE_OF_TYPE)
			-- Invoke feature `a_feature' from `a_type' with arguments `an_argument_list'.
		require
			is_running: is_launched
			is_ready: is_ready
			a_feature_not_void: a_feature /= Void
			a_feature_is_not_infix_or_prefix: not a_feature.is_prefix and then not a_feature.is_infix
			class_has_feature: has_feature (variable_table.variable_type (a_target).base_class, a_feature)
			a_target_not_void: a_target /= Void
			a_target_defined: variable_table.is_variable_defined (a_target)
			no_void_target: not variable_table.variable_type (a_target).is_none
			an_argument_list_not_void: an_argument_list /= Void
			an_argument_list_doesnt_have_void: not an_argument_list.has (Void)
		local
			l_invoke_request: AUT_INVOKE_FEATURE_REQUEST
			l_feature: FEATURE_I
			l_target_type: TYPE_A
			l_objects: DS_LINEAR [ITP_EXPRESSION]
			l_object_state: AUT_OBJECT_STATE
			l_normal_response: AUT_NORMAL_RESPONSE
			l_test_duration: INTEGER
		do
			is_last_test_case_executed := False
			l_target_type := variable_table.variable_type (a_target)
			l_feature := l_target_type.base_class.feature_of_rout_id (a_feature.rout_id_set.first)

log_time_stamp ("* TEST START *")
				-- Adjust feature according to the actual type of `a_target'.
				-- This is needed because of feature renaming. If we don't do this,
				-- in the replay mode, there will be a problem, either because some feature is not found,
				-- or the type of argument are not correct.
			create l_invoke_request.make (system, l_feature.feature_name, a_target, an_argument_list)
			if aut_feature /= Void then
				l_invoke_request.set_feature_id (aut_feature.id)
			end
			l_invoke_request.set_target_type (l_target_type)
			last_operands := l_invoke_request.operand_indexes
			set_test_case_index (l_invoke_request)

			if is_state_recording_enabled then
				record_operand_states (l_invoke_request, True)
			end

			last_request := l_invoke_request
			last_request.process (socket_data_printer)
			l_test_duration := test_duration
			proxy_log_printers.set_start_time (l_test_duration)
log_time_stamp ("* REQUEST SET *")

			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * invoke_feature")
log_time_stamp ("* EXTRA *")

			l_test_duration := test_duration
			proxy_log_printers.set_end_time (l_test_duration)
			proxy_log_printers.report_request (Current, last_request)
			online_statistics.report_test_case (last_request, l_test_duration, variable_table.variable_count)
			if not last_response.is_bad or last_response.is_error then
--				is_ready := True
			else
				is_ready := False
			end
			analyze_last_test_case_status (last_request)
			stop_process_on_problems (last_response)
			log_speed

				-- Precondition evaluation.
			evaluate_predicates_after_test_case (create {AUT_FEATURE_OF_TYPE}.make (a_feature, a_type), a_target, an_argument_list, Void)
		ensure
			last_request_not_void: last_request /= Void
		end

	invoke_and_assign_feature (a_receiver: ITP_VARIABLE; a_type: TYPE_A; a_query: FEATURE_I; a_target: ITP_VARIABLE; an_argument_list: DS_LINEAR [ITP_EXPRESSION]; a_feature: detachable AUT_FEATURE_OF_TYPE)
			-- Invoke query `a_query' from `a_type' with arguments `an_argument_list'.
			-- Store result in variable `a_receiver'.
		require
			is_running: is_launched
			is_ready: is_ready
			a_receiver_not_void: a_receiver /= Void
			a_query_not_void: a_query /= Void
			a_query_is_not_infix_or_prefix: not a_query.is_prefix and then not a_query.is_infix
			class_has_query: has_feature (variable_table.variable_type (a_target).base_class, a_query)
			a_target_not_void: a_target /= Void
			a_target_defined: variable_table.is_variable_defined (a_target)
			no_void_target: not variable_table.variable_type (a_target).is_none
			an_argument_list_not_void: an_argument_list /= Void
			an_argument_list_doesnt_have_void: not an_argument_list.has (Void)
		local
			normal_response: AUT_NORMAL_RESPONSE
			l_invoke_request: AUT_INVOKE_FEATURE_REQUEST
			l_test_duration: INTEGER
		do
			is_last_test_case_executed := False
log_time_stamp ("* TEST START *")
			create l_invoke_request.make_assign (system, a_receiver, a_query.feature_name, a_target, an_argument_list)
			if a_feature /= Void then
				l_invoke_request.set_feature_id (a_feature.id)
			end
			l_invoke_request.set_target_type (a_type)
			last_operands := l_invoke_request.operand_indexes
			set_test_case_index (l_invoke_request)

				-- Record operand states.
			if is_state_recording_enabled then
				record_operand_states (l_invoke_request, True)
			end

			last_request := l_invoke_request
			last_request.process (socket_data_printer)
			proxy_log_printers.set_start_time (test_duration)
log_time_stamp ("* REQUEST SET *")

			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * invoke_and_assign_feature")
log_time_stamp ("* EXTRA *")
			l_test_duration := test_duration
			proxy_log_printers.set_end_time (l_test_duration)
			proxy_log_printers.report_request (Current, last_request)
			online_statistics.report_test_case (last_request, l_test_duration, variable_table.variable_count)
			if not last_response.is_bad then
--				is_ready := True
				if not last_response.is_error then
					normal_response ?= last_response
					check
						normal_response_not_void: normal_response /= Void
					end
				end
			else
				is_ready := False
			end
			analyze_last_test_case_status (last_request)
			stop_process_on_problems (last_response)
			if is_ready and normal_response /= Void and then normal_response.exception = Void then
				if not is_replaying then
						-- If we are not in replay mode, we generate "type" request to get the
						-- dynamic type of the assignment target. If we are in replay mode,
						-- the "type" request will be already in the replay list, so we don't need to
						-- generate them automatically.					
					retrieve_type_of_variable (a_receiver)
				end
			end
			log_speed

				-- Predicate evaluation.
			evaluate_predicates_after_test_case (create {AUT_FEATURE_OF_TYPE}.make (a_query, a_type), a_target, an_argument_list, a_receiver)
		ensure
			last_request_not_void: last_request /= Void
		end

	assign_expression (a_receiver: ITP_VARIABLE; an_expression: ITP_EXPRESSION)
			-- Assign `a_constant' to `a_receiver'.
		require
			is_launched: is_launched
			is_ready: is_ready
			a_receiver_not_void: a_receiver /= Void
			a_constant_not_void: an_expression /= Void
		do
log_time_stamp ("* TEST START *")
			create {AUT_ASSIGN_EXPRESSION_REQUEST} last_request.make (system, a_receiver, an_expression)

			last_request.process (socket_data_printer)
log_time_stamp ("* REQUEST SET *")

			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * assign_expression")
log_time_stamp ("* EXTRA *")

			proxy_log_printers.report_request (Current, last_request)
			if not last_response.is_bad or last_response.is_error  then
--				is_ready := True
			else
				is_ready := False
			end
			stop_process_on_problems (last_response)
			if is_ready and then not is_replaying then
					-- If we are not in replay mode, we generate "type" request to get the
					-- dynamic type of the assignment target. If we are in replay mode,
					-- the "type" request will be already in the replay list, so we don't need to
					-- generate them automatically.
				retrieve_type_of_variable (a_receiver)
			end
		ensure
			last_request_not_void: last_request /= Void
		end

	batch_assign_variables (a_object_types: DS_ARRAYED_LIST [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A]]; a_serialized_objects: DS_HASH_TABLE[STRING,STRING])
			-- Assign multiple objects to variables.
			-- A `var' will receive object `a_serialized_objects'[`index'] of type `type'
		require
			is_launched: is_launched
			is_ready: is_ready
			object_types_not_empty: a_object_types /= VOid and then not a_object_types.is_empty
			serialized_objects_not_empty: a_serialized_objects /= Void and then not a_serialized_objects.is_empty
		local
			l_variable_type_list: DS_ARRAYED_LIST [TUPLE [var: ITP_VARIABLE; type: TYPE_A]]
			l_variable: ITP_VARIABLE
			l_variable_type: TYPE_A
			l_target_variable, l_result_variable: ITP_VARIABLE
			l_target_type, l_result_type: TYPE_A
			l_nbr_variables: INTEGER

			l_starting_index, l_ending_index: INTEGER
			l_argument_variables: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
log_time_stamp ("* TEST START *")
			create {AUT_BATCH_ASSIGNMENT_REQUEST} last_request.make (system, a_object_types, a_serialized_objects)

			last_request.process (socket_data_printer)
log_time_stamp ("* REQUEST SET *")
			flush_process
			parse_invoke_response
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * batch_assign_variables")
log_time_stamp ("* EXTRA *")
			proxy_log_printers.report_request (Current, last_request)

			if last_response.is_bad or last_response.is_error then
				is_ready := False
			else
					-- Define variables in the variable table.
				from a_object_types.start
				until a_object_types.after
				loop
					variable_table.define_variable (a_object_types.item_for_iteration.var, a_object_types.item_for_iteration.type)
					a_object_types.forth
				end
			end
			stop_process_on_problems (last_response)
		ensure
			last_request_not_void: last_request /= Void
		end

	retrieve_type_of_variable (a_variable: ITP_VARIABLE)
			-- Retrieve the type of variable `a_variable' and
			-- store the result in `variable_type_table'.
		require
			a_variable_not_void: a_variable /= Void
			is_running: is_launched
			is_ready: is_ready
		local
			normal_response: AUT_NORMAL_RESPONSE
			l_lines: LIST [STRING]
			l_type_str: STRING
			l_value_str: STRING
			l_type: TYPE_A
		do
log_time_stamp ("* TEST START *")
			create {AUT_TYPE_REQUEST} last_request.make (system, a_variable)
			last_request.process (socket_data_printer)
log_time_stamp ("* REQUEST SET *")
			flush_process
			is_waiting_for_type := True
			parse_type_of_variable_response
			is_waiting_for_type := False
			last_request.set_response (last_response)
log_time_stamp ("* RESPONSE SET * retrieve_type_of_variable")
log_time_stamp ("* EXTRA *")
			proxy_log_printers.report_request (Current, last_request)
			if not last_response.is_bad then
--				is_ready := True
				if not last_response.is_error then
					normal_response ?= last_response
					l_lines := normal_response.text.split ('%N')
					l_type_str := l_lines.first
					l_value_str := l_lines.i_th (2)
					check
						normal_response_not_void: normal_response /= Void
						no_exception: normal_response.exception = Void
						valid_type: base_type (l_type_str) /= Void
					end
					l_type := base_type (l_type_str)
					variable_table.define_variable (a_variable, l_type)

					if configuration.is_precondition_checking_enabled and then configuration.is_linear_constraint_solving_enabled then
						constant_pool.put_with_value_and_type (l_value_str, l_type, a_variable)
					end
				end
			else
				is_ready  := False
			end
			stop_process_on_problems (last_response)
		ensure
			last_request_not_void: last_request /= Void
		end

	retrieve_object_state_response
			-- Retrieve response from the interpreter,
			-- store it in `last_raw_response'.
		local
			l_data: TUPLE [values: detachable HASH_TABLE [STRING, STRING]; output: detachable STRING; error: detachable STRING]
			l_retried: BOOLEAN
			l_socket: like socket
			l_response_flag: NATURAL_32
			l_response: AUT_OBJECT_STATE_RESPONSE
			l_any: detachable ANY
		do
			if not l_retried then
				l_socket := socket
				l_socket.read_natural_32
				l_response_flag := l_socket.last_natural_32
				l_any ?= retrieved_from_medium (l_socket)
				l_data ?= l_any
				process.set_timeout (0)
				if l_data /= Void and then attached {AUT_OBJECT_STATE_REQUEST} last_request as l_request then
					create last_raw_response.make (l_data.output, l_data.error, l_response_flag)
						-- Fixme: This is a walk around for the issue that we cannot launch a process
						-- only with standard input redirected. Remove the following line when fixed,
						-- because everything that the interpreter output should come from `l_data.output'.
						-- Jason 2008.10.22
					replace_output_from_socket_by_pipe_data

					create l_response.make (l_data.values)
					last_response := l_response
				else
					last_raw_response := Void
				end
			end
		rescue
			is_ready := False
			l_retried := True
			last_raw_response := Void
			retry
		end

	is_state_recording_enabled: BOOLEAN
			-- Is object state recording enabled?
		do
			Result := configuration.is_object_state_retrieval_enabled
		ensure
			good_result: Result = configuration.is_object_state_retrieval_enabled
		end

feature -- Response parsing

	parse_response
			-- Parse response from interpreter, store it in `last_response'.
		local
			l_response: like last_response
		do
			Precursor

			l_response := last_response
			check l_response /= Void end
			report_event (l_response)

				-- Print `last_response' into log file when `is_logging_enabled'.
				--
				-- Note: this will be removed once logging is implemented as an observer
--			if is_logging_enabled then
--				last_response.process (response_printer)
--			end
		end

	parse_start_response
			-- Parse the response issued by the interpreter after it has been
			-- started.
		do
			parse_empty_response
		ensure then
			last_response_not_void: last_response /= Void
		end

	parse_stop_response
			-- Parse the response issued by the interpreter after it received a stop request.
		do
			parse_empty_response
		ensure then
			last_response_not_void: last_response /= Void
		end

	parse_invoke_response
			-- Parse the response issued by the interpreter after a
			-- create-object/create-object-default/invoke-feature/invoke-and-assign-feature
			-- request has been sent.
		do
			parse_response
		ensure then
			last_response_not_void: last_response /= Void
		end

	parse_assign_expression_response
			-- Parse response issued by interpreter after receiving an
			-- assign-expresion request.
		do
			parse_response
		ensure then
			last_response_not_void: last_response /= Void
		end

	parse_type_of_variable_response
			-- Parse response issued by interpreter after receiving a
			-- retrieve-type-of-variable request.
		do
			parse_response
		ensure then
			last_response_not_void: last_response /= Void
		end

	parse_empty_response
			-- Parse a response consisting of no characters.
		do
			raw_response_analyzer.set_raw_response (create {AUT_RAW_RESPONSE}.make ("", "", {ITP_SHARED_CONSTANTS}.normal_response_flag))
			last_response := raw_response_analyzer.response
		end

feature {NONE} -- Process scheduling

	process: AUT_PROCESS_CONTROLLER
			-- Process controller

	request_count: NATURAL_64
			-- Number of requests that have been sent to interpreter so far

feature{NONE} -- Process scheduling

	stdout_reader: AUT_THREAD_SAFE_LINE_READER
			-- Non blocking reader for client-stdout
			-- This is a walkaround for the problem that the process libarry
			-- cannot launch interpreter just with input redirected.

	is_waiting_for_type: BOOLEAN
			-- Are we waiting for repsone for a type request
			-- This is a walkaround for the problem that the process libarry
			-- cannot launch interpreter just with input redirected.

	launch_process
			-- Launch `process'.
		local
			l_arguments: ARRAYED_LIST [READABLE_STRING_GENERAL]
			l_body_id: INTEGER
			l_workdir: STRING_32
		do
				-- $MELT_PATH needs to be set here in only to allow debugging.
			put (melt_path.name, "MELT_PATH")
			create stdout_reader.make

				-- We need `injected_feature_body_id'-1 because the underlying C array is 0-based.
			l_body_id := injected_feature_body_id - 1
			if configuration.is_test_case_serialization_enabled then
				create l_arguments.make_from_array (
					<<"localhost",
					  port.out,
					  l_body_id.out,
					  injected_feature_pattern_id.out,
					  interpreter_log_filename,
					  configuration.is_interpreter_log_enabled.out ,
					  configuration.is_passing_test_case_serialization_enabled.out,
					  configuration.is_failing_test_case_serialization_enabled.out,
					  test_case_serialization_filename,
					  configuration.is_duplicated_test_case_serialized.out,
					  configuration.is_post_state_serialized.out,
					  configuration.is_test_case_serialization_retrieved_online.out,
					  "-eif_root", interpreter_root_class_name + "." + interpreter_root_feature_name>>)
			else
				create l_arguments.make_from_array (
					<<"localhost",
					  port.out,
					  l_body_id.out,
					  injected_feature_pattern_id.out,
					  interpreter_log_filename,
					  configuration.is_interpreter_log_enabled.out,
					  "-eif_root", interpreter_root_class_name + "." + interpreter_root_feature_name>>)
			end

			l_workdir := system.lace.directory_name
			create process.make (executable_file_name, l_arguments, l_workdir)
			process.set_timeout (0)
			process.launch (agent stdout_reader.put_string)
		end

	flush_process
			-- Send request data into interpreter through `socket'.
			-- If error occurs, close `socket'.
		local
			failed: BOOLEAN
			l_last_request: like last_request
			l_last_bc_request: TUPLE [flag: NATURAL_8; data: detachable ANY]
			l_socket_writer: SED_MEDIUM_READER_WRITER
		do
			if not failed then
					-- Log request
				l_last_request := last_request
				check l_last_request /= Void end
				report_event (l_last_request)

--				is_ready := False
				if process.input_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream then
					request_count := request_count + 1
					process.set_timeout (timeout)
					if socket /= Void and then socket.is_open_write and socket.extendible then
						l_last_bc_request := socket_data_printer.last_request
						socket.put_natural_32 (l_last_bc_request.flag)
						create l_socket_writer.make_for_writing (socket)
						store (l_last_bc_request.data, l_socket_writer)
					end
				else
					log_line ("-- Error: could not send instruction to interpreter due its input stream being closed.")
				end
			end
		rescue
			is_ready := False
			failed := True
			retry
		end

	stop_process_on_problems (a_response: AUT_RESPONSE)
			-- Stop `process' if a class invariant has occurred in the interpreter or
			-- a bad response has been received.
			-- The interpreter will shut down in case of a class invariant, because the
			-- system will be in an invalid state.
		require
			a_response_not_void: a_response /= Void
		local
			normal_response: AUT_NORMAL_RESPONSE
		do
			if is_running then
				if a_response.is_bad then
					if not process.force_terminated then
						stop
					end
					log_line ("-- Proxy has terminated interpreter due to bad behavior.")
				elseif a_response.is_error then
					-- Do nothing
				else
					normal_response ?= a_response
					check
						normal_response_not_void: normal_response /= Void
					end
					if normal_response.exception /= Void then
						if normal_response.is_class_invariant_violation_on_exit then
							mark_invalid_objects
						end
--							stop
--							log_line ("-- Proxy has terminated interpreter due to class invariant violation.")
--							failure_log_line (exception_thrown_message + error_handler.duration_to_now.second_count.out)
					end
				end
			else
				log_line ("-- Interpreter seems to have quit on its own.")
			end
		end

feature -- Socket IPC

	port: INTEGER
			-- Port number used for socket IPC

	min_port: INTEGER = 49152
			-- Minimal port number

	port_cell: CELL [INTEGER]
			-- Cell to contain port number.
		once
			create Result.put (min_port)
		ensure
			result_attached: Result /= Void
		end


	next_port_number: INTEGER
			-- Next port number to connect through socket
		do
			fixme ("Ideally, we should reuse the same port number.")
			Result := port_cell.item
			port_cell.put (Result + 1)
		end

	socket: NETWORK_STREAM_SOCKET
			-- Socked used to

	cleanup
			-- Clean up Current proxy.
		do
			observers.wipe_out
			if socket /= Void then
				cleanup_socket
			end
		end

	cleanup_socket
			-- Cleanup `socket'.
		require
			socket_attached: socket /= Void
		do
			if socket.exists and then not socket.is_closed then
				socket.close
			end
		end

	retrieve_response
			-- Retrieve response from the interpreter,
			-- store it in `last_raw_response'.
		local
			l_raw_data: attached ANY
			l_data: TUPLE [invariant_violating_object_index: INTEGER; predicate_evaluation: detachable TUPLE [feat_id: INTEGER; results: detachable ARRAY [NATURAL_8]]; serialization: detachable TUPLE [serialization: detachable STRING]; output: STRING; error: STRING]
			l_retried: BOOLEAN
			l_socket: like socket
			l_response_flag: NATURAL_32
		do
			if not l_retried then
				l_socket := socket
				l_socket.read_natural_32
				l_response_flag := l_socket.last_natural_32
				l_raw_data ?= retrieved_from_medium (l_socket)
				l_data ?= l_raw_data
				process.set_timeout (0)
				if l_data /= Void then
					create last_raw_response.make (create {STRING}.make_from_string (l_data.output), create {STRING}.make_from_string (l_data.error), l_response_flag)
						-- Fixme: This is a walk around for the issue that we cannot launch a process
						-- only with standard input redirected. Remove the following line when fixed,
						-- because everything that the interpreter output should come from `l_data.output'.
						-- Jason 2008.10.22
					replace_output_from_socket_by_pipe_data

						-- Mark object as invariant violating.
					if
						l_response_flag = {AUT_SHARED_CONSTANTS}.invariant_violation_on_entry_response_flag and then
						l_data.invariant_violating_object_index > 0
					then
--						variable_table.mark_invalid_object (l_data.invariant_violating_object_index)
						mark_invalid_object (l_data.invariant_violating_object_index)
					end

						-- Update predicate evaluations in predicate pool.
					update_predicates_in_pool (l_data.predicate_evaluation)

					if l_data.serialization /= Void then
						on_test_case_serialization_actions.call (l_data.serialization)
					end
				else
					last_raw_response := Void
				end
			end
		rescue
			is_ready := False
			l_retried := True
			last_raw_response := Void
			retry
		end

	replace_output_from_socket_by_pipe_data
			-- Replace output received from `socket' by output received from
			-- pipe reader `stdout_reader'.
			-- Fixme: This is a walk around for the issue that we cannot launch a process
			-- only with standard input redirected. Jason 2008.10.22
		do
			fixme ("Remove this feature when the bug described in header comment is fixed.")
			check last_raw_response_attached: last_raw_response /= Void end
			if not is_waiting_for_type then
				if stdout_reader.has_read_line then
						-- Because pipe reading is done in a separate thread,
						-- we cannot guarantee the compete output from interpreter
						-- has been read at this point.
					stdout_reader.try_read_all_lines
					if stdout_reader.last_string /= Void then
						last_raw_response.set_output (create {STRING}.make_from_string (stdout_reader.last_string))
					end
				end
			end
		end

feature -- Logging

	log_line (a_string: STRING)
			-- Log `a_string' followed by a new-line character to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log (a_string)
			log ("%N")
		end

	log_message_line (a_message: STRING; a_type: STRING)
			-- Log `a_message' of `a_type' with a new line character.
		do
			log_message (a_message, a_type)
			log_message (once "%N", a_type)
		end

feature {NONE} -- Logging

	log (a_string: STRING)
			-- Log `a_string' to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			if is_logging_enabled and then proxy_log_file.is_open_write then
				proxy_log_printers.report_comment_line (Current, a_string)
			end
		end

	log_message (a_message: STRING; a_type: STRING)
			-- Log `a_message' of `a_type'.
		do
			if is_logging_enabled and then proxy_log_file.is_open_write then
				proxy_log_printers.report_message (Current, a_message, a_type)
			end
		end

	log_time_stamp (a_tag: STRING)
			-- Log tag `a_tag' with timing information.
		obsolete
			"Should be removed in the future. Time logging is moved to AUT_PROXY_LOG_PROCESSOR."
		local
			time_now: DT_DATE_TIME
			duration: DT_DATE_TIME_DURATION
		do
			time_now := system_clock.date_time_now
			duration := time_now.duration (proxy_start_time)
			duration.set_time_canonical
			log ("-- time stamp: ")
			log (a_tag)
			log ("; ")
			log (duration.second_count.out)
			log ("; ")
			log_line (duration.millisecond_count.out)
		end

	test_duration: INTEGER
			-- Duration in millisecond until now, relative to
			-- the starting point of current test session
		local
			time_now: DT_DATE_TIME
			duration: DT_DATE_TIME_DURATION
		do
			time_now := system_clock.date_time_now
			duration := time_now.duration (proxy_start_time)
			duration.set_time_canonical
			Result := duration.millisecond_count
		end

	record_failure_time_stamp
			-- Record the timing information for `last_request'.
			-- Ilinca, "number of faults law" experiment
		local
			time_now: DT_DATE_TIME
			duration: DT_DATE_TIME_DURATION
		do
			time_now := system_clock.date_time_now
			duration := time_now.duration (proxy_start_time)
			duration.set_time_canonical
			last_request.set_time (duration)
		end

	set_test_case_index (a_request: like last_request)
			-- Set test case index into `a_request'.
		require
			a_request_attached: a_request /= Void
		do
			if is_test_case_index_logging_enabled then
	            test_case_count := test_case_count + 1
	            a_request.set_test_case_index (test_case_count)
			end
		ensure
			test_case_index_set:
				is_test_case_index_logging_enabled implies (
					test_case_count = old test_case_count + 1 and
					a_request.test_case_index = test_case_count)
		end

	proxy_log_printers: AUT_PROXY_LOG_PRINTERS
			-- Proxy log processor

feature {NONE} -- Implementation

	disable_catcall_warnings
			-- Disable catcall console and debugger warnings.
		external
			"C inline"
		alias
			"[
			extern int catcall_detection_mode;
			catcall_detection_mode = 0;

			]"
		end

	executable_file_name: READABLE_STRING_GENERAL
			-- File name of interpreter executable

	interpreter_log_filename: READABLE_STRING_GENERAL
			-- File name of the interpreters log

	test_case_serialization_filename: STRING
			-- Name of the file to store serialized test cases

	melt_path: PATH
			-- Path where melt file of test client resides

	socket_data_printer: AUT_REQUEST_PRINTER
			-- Request printer

	injected_feature_body_id: INTEGER
			-- Feature body ID of the feature whose byte-code is to be injected

	injected_feature_pattern_id: INTEGER
			-- Pattern ID of the feature whose byte-code is to be injected

	error_handler: AUT_ERROR_HANDLER
			-- Error handler

	proxy_start_time: DT_DATE_TIME
			-- Time when Current proxy started.

	proxy_log_file: KL_TEXT_OUTPUT_FILE_32
			-- Proxy log file

	proxy_failure_log_file: KL_TEXT_OUTPUT_FILE
			-- Proxy log file recording only the failing test cases
			-- (Ilinca, "Number of faults law" experiment)

	default_timeout: INTEGER = 5
			-- Default value in second for `timeout'

	test_case_count: INTEGER
			-- Number of executed test cases so far

feature{NONE} -- Speed logging

	is_speed_logging_enabled: BOOLEAN
			-- Is testing speed logging enabled?

	last_speed_check_time: DT_DATE_TIME
			-- Last time point when testing speed is checked

	test_case_log_count: INTEGER
			-- Test case count for speed logging

	set_is_speed_logging_enabled (b: BOOLEAN)
			-- Set `is_speed_logging_enabled' with `b'.
		do
			is_speed_logging_enabled := b
		ensure
			is_speed_logging_enabled_set: is_speed_logging_enabled = b
		end

	log_speed
			-- Log testing speed when `is_speed_logging_enabled' is True.
		local
			l_time_now: DT_DATE_TIME
			l_speed: INTEGER
			l_second_count: INTEGER
			l_duration: like duration_until_now
        do
			if is_speed_logging_enabled then
				l_time_now := system_clock.date_time_now
				if last_speed_check_time /= Void then
					l_second_count := l_time_now.duration (last_speed_check_time).second_count
					if l_second_count > 60 then
						l_speed := ((test_case_log_count.to_real / l_second_count) * 60).floor
						log_line ("-- testing speed: " + l_speed.out + " test cases per minute.")
						test_case_log_count := 0
						last_speed_check_time := l_time_now

						l_duration := duration_until_now
						log_pool_statistics (l_duration)
						log_precondition_evaluation_failure_rate (l_duration)
					else
						test_case_log_count := test_case_log_count + 1
					end
				else
					last_speed_check_time := l_time_now
				end
			end
		end

	failure_log_speed
			-- Log testing speed when `is_speed_logging_enabled' is True.
		local
			l_time_now: DT_DATE_TIME
			l_speed: INTEGER
			l_second_count: INTEGER
        do
			if is_speed_logging_enabled then
				l_time_now := system_clock.date_time_now
				if last_speed_check_time /= Void then
					l_second_count := l_time_now.duration (last_speed_check_time).second_count
					if l_second_count > 60 then
						l_speed := ((test_case_log_count.to_real / l_second_count) * 60).floor
						test_case_log_count := 0
						last_speed_check_time := l_time_now
					else
						test_case_log_count := test_case_log_count + 1
					end
				else
					last_speed_check_time := l_time_now
				end
			end
		end

feature -- Precondition satisfaction

	generate_typed_object_pool
			-- Generate `typed_object_pool' and
			-- initialize it with `a_types'.
		local
			l_pool: AUT_TYPED_OBJECT_POOL
		do
			create l_pool.make (system, configuration.types_under_test, interpreter_class)
			variable_table.set_defining_variable_action (agent l_pool.put_variable)
			variable_table.wipe_out_actions.extend (agent l_pool.wipe_out)
			typed_object_pool_cell.put (l_pool)
			variable_table.wipe_out_actions.extend (agent predicate_pool.wipe_out)
			variable_table.wipe_out_actions.extend (agent constant_pool.wipe_out)
			variable_table.wipe_out_actions.extend (agent used_integer_values.wipe_out)
		end

	log_types_under_test
			-- Log `types_under_test'.
		local
			l_types: DS_LINEAR [TYPE_A]
			i: INTEGER
			l_count: INTEGER
		do
			log ("-- classes under test: ")
			l_types := configuration.types_under_test
			from
				l_types.start
				l_count := l_types.count
				i := 1
			until
				l_types.after
			loop
				log (l_types.item_for_iteration.associated_class.name_in_upper)
				if i < l_count then
					log (", ")
				end
				i := i + 1
				l_types.forth
			end
			log_line ("")
		end

	duration_until_now: DT_DATE_TIME_DURATION
			-- Duration from the start of current AutoTest run until now
		local
			time_now: DT_DATE_TIME
		do
			to_implement ("log_time_stamp can be simplified with current feature.")
			time_now := system_clock.date_time_now
			Result := time_now.duration (proxy_start_time)
			Result.set_time_canonical
		end

	log_precondition_evaluation (a_type: TYPE_A; a_feature: FEATURE_I; a_tried_count: INTEGER; a_worst_case_count: INTEGER; a_start_time: INTEGER; a_end_time: INTEGER; a_succeed_level: INTEGER)
			-- Log precondition evaluation statistics.
			-- `a_feature' is the feature whose preconditions are evaluated.
			-- `a_type' is where `a_feature' is from.
			-- `a_tried_count' is the number of times that different object combinations are tried for that precondition.
			-- `a_worst_case_count' is the number of object combinations that need to be tried out in the worst case.
			-- `a_start_time' is the start time in millisecond when the precondition evaluation started.
			-- `a_end_time' is the end time in millisecond when the precondition evaluation ended.
			-- `a_succeed' is whether an object combination satisfying `a_feature''s precondition is found.
		require
			a_type_attached: a_type /= Void
			a_type_valid: a_type.has_associated_class
			a_feature_attached: a_feature /= Void
			a_tried_count_non_negative: a_tried_count >= 0
			a_worst_case_count_non_negative: a_worst_case_count >= 0
			a_worst_case_count_valid: a_tried_count <= a_worst_case_count
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_non_negative: a_end_time >= 0
			a_time_valid: a_end_time >= a_start_time
		local
			l_text: STRING
		do
			if configuration.is_precondition_satisfaction_logged then
				create l_text.make (128)
				l_text.append ("-- Precondition_evaluation: ")

				l_text.append ("tried_times: ")
				l_text.append (a_tried_count.out)
				l_text.append ("; ")

				l_text.append ("max_times: ")
				l_text.append (a_worst_case_count.out)
				l_text.append ("; ")

				l_text.append ("start time: ")
				l_text.append (a_start_time.out)
				l_text.append ("; ")

				l_text.append ("end time: ")
				l_text.append (a_end_time.out)
				l_text.append ("; ")

				l_text.append ("Succeeded: ")
				l_text.append (a_succeed_level.out)
				l_text.append ("; ")

				l_text.append (a_type.associated_class.name_in_upper)
				l_text.append (".")
				l_text.append (a_feature.feature_name.as_lower)

				log_message_line (l_text, precondition_satisfaction_message_type)
			end
		end

feature -- Predicate evaluation

	evaluate_predicates (a_predicates: LINKED_LIST [TUPLE [predicate: INTEGER; arguments: SPECIAL [INTEGER]]])
			-- Evaluate `a_predicates'.
		require
			a_predicates_attached: a_predicates /= Void
			a_predicates_valid: not a_predicates.has (Void)
		local
			l_request: AUT_PREDICATE_EVALUATION_REQUEST
		do
			create l_request.make (system, a_predicates)
			last_request := l_request
			last_request.process (socket_data_printer)
			flush_process
			parse_predicate_evaluation_response
			last_request.set_response (last_response)
			if last_response.is_bad then
				is_ready  := False
			end
			stop_process_on_problems (last_response)
		end

	parse_predicate_evaluation_response
			-- Parse the response of the last predicate evaluation request.
		do
			if attached {AUT_PREDICATE_EVALUATION_REQUEST} last_request as l_request then
				retrieve_predicate_evaluation_response
			end
		end

	retrieve_predicate_evaluation_response
			-- Retrieve response of the last predicate evaluation request.
		local
			l_data: TUPLE [evaluation_result: detachable LINKED_LIST [TUPLE [INTEGER, SPECIAL [NATURAL_8]]]; output: detachable STRING; error: detachable STRING]
			l_retried: BOOLEAN
			l_socket: like socket
			l_response_flag: NATURAL_32
			l_response: AUT_PREDICATE_EVALUATION_RESPONSE
			l_any: detachable ANY
		do
			if not l_retried then
				l_socket := socket
				l_socket.read_natural_32
				l_response_flag := l_socket.last_natural_32
				l_any ?= retrieved_from_medium (l_socket)
				l_data ?= l_any
				process.set_timeout (0)
				if l_data /= Void and then l_data.evaluation_result /= Void then
					create l_response.make (l_data.evaluation_result)
					last_response := l_response
				else
					last_raw_response := Void
				end
			end
		rescue
			is_ready := False
			l_retried := True
			last_raw_response := Void
			retry
		end

	update_predicate_pool_on_precondition_violation (a_feature: AUT_FEATURE_OF_TYPE; a_related_objects: ARRAY [ITP_VARIABLE])
			-- Update predicate pool if there is a precondition violation when `a_feature' was executed with `a_related_objects'.
		local
			l_bp_slot: INTEGER
			l_pattern_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
			l_access_patterns: DS_HASH_SET [AUT_PREDICATE_ACCESS_PATTERN]
			l_done: BOOLEAN
			l_pred_args: LINKED_LIST [INTEGER]
			l_pattern: DS_HASH_TABLE [INTEGER, INTEGER]
			l_ptn_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
			l_failed_predicate: AUT_PREDICATE
		do
			if configuration.is_precondition_checking_enabled then
					-- When there is a precondition violation, we first update the predicate pool.

				if attached {AUT_NORMAL_RESPONSE} last_response as l_normal_response then
					if l_normal_response.exception /= Void and then l_normal_response.exception.is_test_invalid then
						increase_failed_precondition_count
						l_bp_slot := l_normal_response.exception.break_point_slot
						precondition_access_pattern.search (a_feature)
						if precondition_access_pattern.found then
							l_access_patterns := precondition_access_pattern.found_item
							l_pattern_cursor := l_access_patterns.new_cursor
							from
								l_pattern_cursor.start
							until
								l_pattern_cursor.after or else l_done
							loop
								if l_pattern_cursor.item.break_point_slot = l_bp_slot then
									l_done := True
									l_failed_predicate := l_pattern_cursor.item.predicate
									create l_pred_args.make
									from
										l_pattern := l_pattern_cursor.item.access_pattern
										l_ptn_cursor := l_pattern.new_cursor
										l_ptn_cursor.start
									until
										l_ptn_cursor.after
									loop
										l_pred_args.extend (a_related_objects.item (l_ptn_cursor.item).index)
										l_ptn_cursor.forth
									end
								end
								l_pattern_cursor.forth
							end

								-- Update predicate: Set `l_failed_predicate' with `l_pred_args' with value False.
							if l_done then
								update_predicate (l_failed_predicate, l_pred_args, False)
								log_failed_precondition_satisfaction_proposal (a_feature, l_failed_predicate)
							end
						end
					end
				end
			end
		end

	log_failed_precondition_satisfaction_proposal (a_feature: AUT_FEATURE_OF_TYPE; a_failed_predicate: AUT_PREDICATE)
			-- Log a message saying that the precondition satisfaction propsal for `a_failed_predicate' in `a_feature' is wrong.
		require
			a_feature_attached: a_feature /= Void
			a_failed_predicate_attached: a_failed_predicate /= Void
		local
			l_message: STRING
		do
			if
				configuration.is_precondition_satisfaction_logged and then
				attached {AUT_PRECONDITION_SATISFACTION_TASK} precondition_evaluator as l_evaluator and then
				l_evaluator.is_precondition_satisfaction_performed and then
				l_evaluator.last_precondition_satisfaction_level /= {AUT_PRECONDITION_SATISFACTION_TASK}.precondition_satisfaction_not_satisfied
			then
				create l_message.make (128)
				l_message.append ("-- Failed predicate: ")
				l_message.append (a_feature.type.associated_class.name_in_upper)
				l_message.append_character ('.')
				l_message.append (a_feature.feature_name)
				l_message.append ("; ")
				l_message.append (a_failed_predicate.text)
				l_message.append ("; time(ms): ")
				l_message.append (duration_until_now.millisecond_count.out)
				log_message_line (l_message, precondition_satisfaction_message_type)
			end
		end

	calculate_feature_invalid_test_case_rate (a_feature: AUT_FEATURE_OF_TYPE; a_related_objects: ARRAY [ITP_VARIABLE])
			-- Calculate invalid test case rate for `a_feature' and store result in `feature_invalid_test_case_rate'.
		require
			a_feature_attached: a_feature /= Void
			a_related_objects_attached: a_related_objects /= Void
		local
			l_failure_rate: like feature_invalid_test_case_rate
			l_rate: TUPLE [failed_times: INTEGER; all_times: INTEGER; last_tested_time: INTEGER]
			l_table: like predicate_feature_table
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [AUT_FEATURE_OF_TYPE], AUT_PREDICATE]
			l_features: DS_HASH_SET [AUT_FEATURE_OF_TYPE]
			l_predicates: LINKED_LIST [AUT_PREDICATE]
		do
			l_failure_rate := feature_invalid_test_case_rate
			if not l_failure_rate.has (a_feature) then
				l_rate := [0, 0, 0]
				l_failure_rate.force_last (l_rate, a_feature)
			else
				l_rate := l_failure_rate.item (a_feature)
			end
			if last_response.is_precondition_violation then
				l_rate.put_integer (l_rate.failed_times + 1, 1)
				update_predicate_pool_on_precondition_violation (a_feature, a_related_objects)
			else
				l_rate.put_integer (duration_until_now.second_count, 3)
			end
			l_rate.put_integer (l_rate.all_times + 1, 2)
		end

	evaluate_predicates_after_test_case (a_feature: AUT_FEATURE_OF_TYPE; a_target: ITP_VARIABLE; a_arguments: DS_LINEAR [ITP_EXPRESSION]; a_result: detachable ITP_VARIABLE)
			-- Evaluate `relevant_predicates_of_feature' for `a_feature' with relevant objects consisting
			-- `a_target', `a_arguments' and `a_result'.
		require
			a_feature_attached: a_feature /= Void
		local
			l_related_objects: ARRAY [ITP_VARIABLE]
		do
			l_related_objects := relevant_objects (a_target, a_arguments, a_result)
			calculate_feature_invalid_test_case_rate (a_feature, l_related_objects)
		end

	relevant_objects (a_target: ITP_VARIABLE; a_arguments: DS_LINEAR [ITP_EXPRESSION]; a_result: detachable ITP_VARIABLE): ARRAY [ITP_VARIABLE]
			-- Relevant objects
		local
			l_cursor: DS_LINEAR_CURSOR [ITP_EXPRESSION]
			l_variable: ITP_VARIABLE
			i: INTEGER
		do
			if a_result /= 0 then
				create Result.make (0, a_arguments.count + 1)
			else
				create Result.make (0, a_arguments.count)
			end
			Result.put (a_target, 0)
			if not a_arguments.is_empty then
				from
					l_cursor := a_arguments.new_cursor
					i := 1
					l_cursor.start
				until
					l_cursor.after
				loop
					l_variable ?= l_cursor.item
					check l_variable /= Void end
					Result.put (l_variable, i)
					i := i + 1
					l_cursor.forth
				end
			end
			if a_result /= Void then
				Result.put (a_result, Result.upper)
			end
		ensure
			result_attached: Result /= Void
			result_valid: Result.lower = 0
		end

	update_predicate (a_predicate: AUT_PREDICATE; a_arguments: LINKED_LIST [INTEGER]; a_result: BOOLEAN)
			-- Update the value of `a_predicate' evaluated with `a_arguments' to `a_result' in predicate pool.
			-- `a_arguments' stored the object index of the corresponding argument for `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_arguments.count = a_predicate.arity
		local
			l_arguments: ARRAY [ITP_VARIABLE]
		do
			l_arguments := variables_from_indexes (a_arguments)
			predicate_pool.update_predicate_valuation (a_predicate, l_arguments, a_result)

		end

	variables_from_indexes (a_indexes: LIST [INTEGER]): ARRAY [ITP_VARIABLE]
			-- Variables from object indexes
		require
			a_indexes_attached: a_indexes /= Void
		local
			i: INTEGER
		do
			create Result.make (1, a_indexes.count)
			from
				i := 1
				a_indexes.start
			until
				a_indexes.after
			loop
				Result.put (create {ITP_VARIABLE}.make (a_indexes.item), i)
				i := i + 1
				a_indexes.forth
			end
		ensure
			result_attached: Result /= Void
		end

	log_seed
			-- Log seed.
		do
			log_line ("-- Seed: " + random.seed.out)
		end

	failed_precondition_count: INTEGER
			-- Number of times when precondition fails
			-- on feature whose target and arguments are suggensted
			-- by precondition satisfaction strategy

	failed_precondition_count_partial: INTEGER
			-- Number of times when precondition fails
			-- on feature whose target and arguments are partially suggested

	suggested_precondition_count: INTEGER
			-- Number of times when objects that seems to satisfy
			-- precodition of a feature is suggested.

	suggested_precondition_count_partial: INTEGER
			-- Number of times when objects that seems to satisfy
			-- precondition of a feautre is suggested.
			-- These objects candidates are partial, meaning according to
			-- the predicate pool, they only satisfy part of the feature's
			-- precondition, not all of them.

	increase_failed_precondition_count
			-- Increase the number of failed preconditions.
		local
			l_evaluator: like precondition_evaluator
		do
			l_evaluator := precondition_evaluator
			if l_evaluator /= Void and then l_evaluator.is_precondition_satisfaction_performed then
				if l_evaluator.last_precondition_satisfaction_level = {AUT_PRECONDITION_SATISFACTION_TASK}.precondition_satisfaction_satisfied then
					failed_precondition_count := failed_precondition_count + 1
				elseif l_evaluator.last_precondition_satisfaction_level = {AUT_PRECONDITION_SATISFACTION_TASK}.precondition_satisfaction_partially_satisfied then
					failed_precondition_count_partial := failed_precondition_count_partial + 1
				end
			end
		end

	increase_suggested_precondition_count
			-- Increase `suggested_precondition_count' by 1.
		do
			suggested_precondition_count := suggested_precondition_count + 1
		ensure
			suggested_precondition_count_increase: suggested_precondition_count = old suggested_precondition_count + 1
		end

	increase_suggested_precondition_count_partial
			-- Increase `suggested_precondition_count_partial' by 1.
		do
			suggested_precondition_count_partial := suggested_precondition_count_partial + 1
		ensure
			suggested_precondition_count_partial_increase: suggested_precondition_count_partial = old suggested_precondition_count_partial + 1
		end

	precondition_satisfaction_failure_rate_header: STRING = "-- Precondition satisfactoin failure rate:"
			-- Header for precondition satisfaction failure rate logging

	log_precondition_evaluation_failure_rate (a_duration: DT_DATE_TIME_DURATION)
			-- Log failure rate of precondition satisfaction.
			-- `a_duration' is the duration relative to the starting of current test run.
		require
			a_duration_attached: a_duration /= Void
		do
			if configuration.is_precondition_checking_enabled and then configuration.is_precondition_satisfaction_logged then
				log_message_line (
					precondition_satisfaction_failure_rate_header +
					" second: " + a_duration.second_count.out +
					"; full_suggested: " + suggested_precondition_count.out +
					"; full_failed: " + failed_precondition_count.out +
					"; partial_suggested: " + suggested_precondition_count_partial.out +
					"; partial_failed: " + failed_precondition_count_partial.out, precondition_satisfaction_message_type)
			end
		end

	log_precondition_evaluation_overhead (a_precondition_evaluatior: AUT_PRECONDITION_SATISFACTION_TASK; a_type: TYPE_A; a_feature_to_call: FEATURE_I)
			-- Log overhead of current precondition evaluation task.
		require
			a_preconditior_evaluation_attached: a_precondition_evaluatior /= Void
			a_type_attached: a_type /= Void
			a_feature_to_call_attached: a_feature_to_call /= Void
		do
			if
				configuration.is_precondition_checking_enabled and then
				a_precondition_evaluatior.has_precondition and then
				a_precondition_evaluatior.is_precondition_satisfaction_performed and then
				configuration.is_precondition_satisfaction_logged
			then
				log_precondition_evaluation (
					a_type,
					a_feature_to_call,
					a_precondition_evaluatior.tried_count,
					a_precondition_evaluatior.worst_case_search_count,
					a_precondition_evaluatior.start_time,
					a_precondition_evaluatior.end_time,
					a_precondition_evaluatior.last_precondition_satisfaction_level)

						-- If there is an incorrect lpsolve input file, log it.
				if not a_precondition_evaluatior.is_lp_linear_solvable_model_correct then
					log_lpsolve_input_file_error (a_precondition_evaluatior, a_type, a_feature_to_call)
				end
			end
		end

	log_lpsolve_input_file_error (a_precondition_evaluatior: AUT_PRECONDITION_SATISFACTION_TASK; a_type: TYPE_A; a_feature: FEATURE_I)
			-- Log that there is an incorrect lpsolve input file generated for `a_feature' in `a_type'.
		require
			a_precondition_evaluatior_attached: a_precondition_evaluatior /= Void
			a_type_attached: a_type /= Void
			a_type_valid: a_type.has_associated_class
			a_feature_attached: a_feature /= Void
		local
			l_message: STRING
		do
			create l_message.make (64)
			l_message.append ("-- Incorrect lpsolve file: ")
			l_message.append (a_type.associated_class.name_in_upper)
			l_message.append_character ('.')
			l_message.append (a_feature.feature_name)
			l_message.append ("; time: ")
			l_message.append (duration_until_now.millisecond_count.out)
			log_message_line (l_message, precondition_satisfaction_message_type)
		end

	log_pool_statistics (a_duration: DT_DATE_TIME_DURATION)
			-- Log statistics about predicate pool.
			-- `a_duration' is the time duration relative to the starting of current test run
		local
			l_context_class: CLASS_C
			l_var_table_cursor: DS_HASH_TABLE_CURSOR [DS_ARRAYED_LIST [ITP_VARIABLE], TYPE_A]
			l_pred_table_cursor: DS_HASH_TABLE_CURSOR [AUT_PREDICATE_VALUATION, AUT_PREDICATE]
			l_stat_object_pool: STRING
			l_stat_predicate_pool: STRING
		do
			if configuration.is_pool_statistics_logged then
				l_context_class := interpreter_class
				check l_context_class /= Void end

					-- Log statistics of object pool: which is the number of objects of each type.
				log_message_line ("-- Pool statistics: " + a_duration.millisecond_count.out, pool_statistics_message_type)
				if typed_object_pool /= Void then
					l_stat_object_pool := "-- object_pool: "
					from
						l_var_table_cursor := typed_object_pool.variable_table.new_cursor
						l_var_table_cursor.start
					until
						l_var_table_cursor.after
					loop
						log_message_line (l_stat_object_pool + type_name_with_context (l_var_table_cursor.key, l_context_class, Void) + ": " + l_var_table_cursor.item.count.out, pool_statistics_message_type)
						l_var_table_cursor.forth
					end
				end

					-- Log statistics of predicate pool: which is the number of valuations for each predicate.
				l_stat_predicate_pool := "-- predicate_pool: "
				from
					l_pred_table_cursor := predicate_pool.valuation_table.new_cursor
					l_pred_table_cursor.start
				until
					l_pred_table_cursor.after
				loop
					log_message_line (l_stat_predicate_pool + l_pred_table_cursor.key.text_with_type_name + ": " + l_pred_table_cursor.item.count.out, pool_statistics_message_type)
					l_pred_table_cursor.forth
				end
			end
		end

	mark_invalid_object (a_index: INTEGER)
			-- Mark object with `a_index' as invalid, because its class invariants are violated.
		require
			a_index_valid: a_index > 0
		local
			l_class: CLASS_C
		do
			l_class := interpreter_root_class
			typed_object_pool.mark_invalid_object (a_index, l_class)
			if configuration.is_precondition_checking_enabled then
				predicate_pool.remove_variable (create {ITP_VARIABLE}.make (a_index))
			end
		end

	mark_invalid_objects
			-- Mark objects from `last_request' as invalid because there is a class invariant violation.
		do
			if attached {AUT_CALL_BASED_REQUEST} last_request as l_request then
				mark_invalid_object (l_request.target.index)
				if l_request.argument_list /= Void then
					l_request.argument_list.do_all (
						agent (a_expr: ITP_EXPRESSION)
							do
								if attached {ITP_VARIABLE} a_expr as l_variable then
									mark_invalid_object (l_variable.index)
								end
							end)
				end
			end
		end

	precondition_evaluator: detachable AUT_PRECONDITION_SATISFACTION_TASK
			-- Last used precondition evaluator

	set_precondition_evaluator (a_evaluator: like precondition_evaluator)
			-- Set `precondition_evaluator' with `a_evaluator'.
		do
			precondition_evaluator := a_evaluator
		ensure
			precondition_evaluator_set: precondition_evaluator = a_evaluator
		end

	update_predicates_in_pool (a_results: detachable TUPLE [feature_id: INTEGER; results: detachable ARRAY [NATURAL_8]])
			-- Update `predicate_pool' with `a_results'.
		local
			l_predicates: detachable ARRAY [TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]]
			l_results: ARRAY [NATURAL_8]
			i, j: INTEGER
			l_count: INTEGER
			l_predicate: AUT_PREDICATE
			l_operands: LINKED_LIST [INTEGER]
			l_data: TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]
			l_ind_count: INTEGER
			l_operand_indexes: SPECIAL [INTEGER]
			l_last_operands: like last_operands
		do
			if
				a_results /= Void and then
				a_results.results /= Void and then
				configuration.is_precondition_checking_enabled
			then
				l_results := a_results.results
				l_predicates := relevant_predicate_with_operand_table.item (a_results.feature_id)
				if l_predicates /= Void then
					check
						l_predicates.count = l_results.count
						l_predicates.lower = 1
						l_results.lower = 1
					end

						-- Update predicate valuations.
					create l_operands.make
					l_last_operands := last_operands
					from
						i := 1
						l_count := l_predicates.count
					until
						i > l_count
					loop
						l_data := l_predicates.item (i)
						l_predicate := predicate_table.item (l_data.predicate_id)
						from
							l_operand_indexes := l_data.operand_indexes
							j := 0
							l_ind_count := l_operand_indexes.count
						until
							j = l_ind_count
						loop
							l_operands.extend (last_operands.item (l_operand_indexes.item (j)))
							j := j + 1
						end
						update_predicate (l_predicate, l_operands, (l_results.item (i) = 1))
						i := i + 1
						l_operands.wipe_out
					end
				end
			end
		end

	last_operands: SPECIAL [INTEGER]
			-- Operands used in last test case

feature -- Object State Exploration

	object_state_table: AUT_OBJECT_STATE_TABLE
			-- Table with information about encountered object states

feature{NONE} -- Logging

	pool_statistics_message_type: STRING = "pool_statistics"
			-- Message type for pool statistics logging

	precondition_satisfaction_message_type: STRING = "precondition_satisfaction"
			-- Message type for precondition satisfaction

	precondition_reduction_message_type: STRING = "precondition_reduction"
			-- Message type for precondition reduction.

feature -- Object state retrieval

	record_operand_states (a_request: AUT_CALL_BASED_REQUEST; a_before_execution: BOOLEAN)
			-- Record states of operands defined in `a_request'.
			-- `a_before_execution' indicates if the recording happens before the execution of `a_request'.
		local
			l_request: AUT_OBJECT_STATE_FEATURE_REQUEST
		do
				-- Send state acquiring request and parse response.			
			create l_request.make_with_request (a_request, a_before_execution, configuration.object_state_config)
			last_request := l_request
			last_request.process (socket_data_printer)
			flush_process
			parse_object_state_response
			last_request.set_response (last_response)
			proxy_log_printers.report_request (Current, last_request)

				-- Populate `object_state_table'.
			if configuration.is_object_state_exploration_enabled and then attached {AUT_OBJECT_STATE_RESPONSE} last_response as l_object_state_response then
				populate_object_state_table (l_object_state_response)
			end

			if last_response.is_bad then
				is_ready  := False
			end
			stop_process_on_problems (last_response)
		end

	populate_object_state_table (a_object_state_response: AUT_OBJECT_STATE_RESPONSE)
			-- Use information inside `a_object_state_response' to populate `object_state_table'.
		local
			l_values: HASH_TABLE [STRING, STRING]
			l_values_by_target: HASH_TABLE [HASH_TABLE [STRING, STRING], STRING]
			l_tbl: HASH_TABLE [STRING, STRING]
			l_target: STRING
			l_query: STRING
			l_index: INTEGER
			l_var_table: like variable_table
			l_variable: ITP_VARIABLE
			l_state_table: like object_state_table
		do
			l_values := a_object_state_response.query_results
			if not l_values.is_empty then
				create l_values_by_target.make (3)
				l_values_by_target.compare_objects

					-- Collect queries by their target.
				from
					l_values.start
				until
					l_values.after
				loop
					l_query := l_values.key_for_iteration.twin
					l_index := l_query.index_of ('.', 1)
					fixme ("We don't handle queries with arguments for the moment. 14.5.2010 Jasonw")
					if l_index > 0 and then l_query.index_of ('(', 1) = 0 then
						l_target := l_query.substring (1, l_index - 1)
						l_query	:= l_query.substring (l_index + 1, l_query.count)
						l_values_by_target.search (l_target)
						if l_values_by_target.found then
							l_tbl := l_values_by_target.found_item
						else
							create l_tbl.make (10)
							l_tbl.compare_objects
							l_values_by_target.put (l_tbl, l_target)
						end
						l_tbl.put (l_values.item_for_iteration, l_query)
					end
					l_values.forth
				end

					-- Report states for all collected targets.
				l_var_table := variable_table
				l_state_table := object_state_table
				from
					l_values_by_target.start
				until
					l_values_by_target.after
				loop
					l_target := l_values_by_target.key_for_iteration
					create l_variable.make (l_target.substring (3, l_target.count).to_integer)
					if attached {TYPE_A} variable_table.variable_type (l_variable) as l_type then
						l_state_table.put_variable (l_variable, create {AUT_OBJECT_STATE}.make (l_values_by_target.item_for_iteration), l_type)
					end
					l_values_by_target.forth
				end
			end
		end

	object_state (a_variable: ITP_VARIABLE): HASH_TABLE [detachable STRING, STRING]
			-- State of `a_variable'
			-- Value is in the form [query value, query name].
		local
			l_request: AUT_OBJECT_STATE_OBJECT_REQUEST
			l_objects: HASH_TABLE [TYPE_A, INTEGER]
			s: STRING
			l_state: HASH_TABLE [STRING, STRING]
			l_expr: STRING
			l_index: INTEGER
		do
			create l_objects.make (1)
			l_objects.put (variable_table.variable_type (a_variable), a_variable.index)
			create l_request.make_with_objects (l_objects, configuration.object_state_config)
			last_request := l_request
			last_request.process (socket_data_printer)
			flush_process
			retrieve_object_state_response
			last_request.set_response (last_response)

			if is_ready then
				if attached {AUT_OBJECT_STATE_RESPONSE} last_response as l_response then
					l_state := l_response.query_results
					create Result.make (l_state.count)
					Result.compare_objects
					from
						l_state.start
					until
						l_state.after
					loop
						l_expr := l_state.key_for_iteration
						if not l_expr.has ('(') then
							l_index := l_expr.index_of ('.', 1)
							l_expr := l_expr.substring (l_index + 1, l_expr.count)
							Result.put (l_state.item_for_iteration, l_expr)
						end
						l_state.forth
					end
				end
			end
			if Result = Void then
				create Result.make (0)
				Result.compare_objects
			end
		end

	parse_object_state_response
		do
			retrieve_object_state_response
			report_event (last_response)
		end

	evaluate_expressions (a_class: CLASS_C; a_feature: FEATURE_I; a_operand_map: HASH_TABLE [INTEGER, INTEGER]; a_expressions: LINKED_LIST [EPA_EXPRESSION]; a_receiver: detachable PROCEDURE [ANY, TUPLE [HASH_TABLE [STRING, STRING]]])
			-- Evaluate `a_expressions' in the context of `a_feature' from `a_class'.
			-- `a_operand_map' is a mapping from opreand index to object index in the object pool.
			-- Key is 0-based operand index.
			-- Value is object id (used in the object pool) for that operand.
			-- `a_expressions' are in operand-format, for example, "Current.has (v)".
			-- If `a_receiver' is not Void, call it with the expression-value pairs after the evaluation.
			-- The argument to `a_receiver' is a hash-table, keys are the expression texts and values are
			-- the evaluated values of those expressions.
		local
			l_request: AUT_EXPRESSION_EVALUATION_REQUEST
		do
			create l_request.make (a_class, a_feature, a_expressions, a_operand_map)
			last_request := l_request
			last_request.process (socket_data_printer)
			flush_process
			retrieve_object_state_response
			if attached {AUT_OBJECT_STATE_RESPONSE} last_response as l_response then
				if a_receiver /= Void then
					a_receiver.call ([l_response.query_results])
				end
			end
			if last_response.is_bad then
				is_ready  := False
			end
		end

	is_last_test_case_executed_internal (a_request: AUT_REQUEST): BOOLEAN
			-- Is last test case executed?
		local
			l_exception: AUT_EXCEPTION
		do
			if attached {AUT_CALL_BASED_REQUEST} a_request as l_request then
				if l_request.response.is_normal then
					if l_request.response.is_exception then
						if
							attached {AUT_NORMAL_RESPONSE} l_request.response as l_normal_response and then
							l_normal_response.exception /= Void and then
							not l_normal_response.exception.is_test_invalid
						then
							l_exception := l_normal_response.exception
							if not l_exception.is_invariant_violation_on_feature_entry then
								Result := True
							end
						end
					else
						Result := True
					end
				end
			end
		end

	is_last_test_case_passing_internal (a_request: AUT_REQUEST): BOOLEAN
			-- Is last test passing?
		local
			l_exception: AUT_EXCEPTION
		do
			if attached {AUT_CALL_BASED_REQUEST} a_request as l_request then
				if l_request.response.is_normal then
					if l_request.response.is_exception then
						Result := False
					else
						Result := True
					end
				end
			end
		end

	set_is_last_test_case_passing (b: BOOLEAN)
			-- Set `is_test_case_passing' with `b'.
		do
			is_last_test_case_passing := b
		ensure
			is_last_test_case_passing_set: is_last_test_case_passing = b
		end

	log_precondition_reduction (a_string: STRING)
			-- Log precondition-reduction message `a_string'.
		local
			l_text: STRING
		do
			if configuration.is_precondition_reduction_enabled then
				create l_text.make (128)
				l_text.append ("-- Precondition_reduction: ")
				l_text.append (a_string)
				log_line (l_text)
			end
		end

	setup_online_statistics
			-- Setup `online_statistics'.
		local
			l_file: FILE_NAME
		do
			create l_file.make_from_string (configuration.output_dirname)
			l_file.extend ("log")
			l_file.set_file_name ("online_statistics.txt")
			online_statistics.set_log_file_path (l_file.out)
			online_statistics.set_output_frequency (configuration.online_statistics_frequency)
		end

	online_test_case_directory: STRING
			-- Absolute path to the directory to store online test cases

	output_test_case_online_filter: STRING


	setup_online_test_case_directory
			-- Setup the directory to store online test cases (test cases that are output during testing).
		local
			l_dir: DIRECTORY
		do
			create l_dir.make (online_test_case_directory)
			if l_dir.exists then
				if configuration.should_clear_online_test_case_dir then
					l_dir.delete_content
				end
			else
				l_dir.create_dir
			end
		end

	on_test_case_serialization_actions_internal: detachable like on_test_case_serialization_actions

	output_test_case (a_serialization: detachable STRING)
			-- Output test case represented by `a_serialization' in `online_test_case_dir'.
		local
			l_test_deserializer: AUT_DESERIALIZATION_STRING_PROCESSOR
		do
			create l_test_deserializer.make
			l_test_deserializer.test_case_deserialized_event.subscribe (
				agent (a_test: AUT_DESERIALIZED_TEST_CASE)
					local
						l_test_categorizer: AUT_TEST_CASE_CATEGORIZER_BY_FEATURE_UNDER_TEST
					do
						if output_test_case_online_filter = Void or else output_test_case_online_filter.same_string_general (a_test.class_and_feature_under_test) then
							create l_test_categorizer.make (configuration, online_test_case_directory)
							l_test_categorizer.write_test_case_to_file (a_test)
							if l_test_categorizer.last_test_case_path /= Void then
								error_handler.report_info_message (Msg_tc_generated + l_test_categorizer.last_test_case_path.out)
							end
						end
					end)
			l_test_deserializer.process_test_case (a_serialization)
		end

	Msg_tc_generated: STRING = "<[- TC generated -]>"

invariant
	is_running_implies_reader: is_running implies (stdout_reader /= Void)
	request_printer_not_void: socket_data_printer /= Void
	executable_file_name_not_void: executable_file_name /= Void
	melt_path_not_void: melt_path /= Void
--	not_running_implies_not_ready: not is_running implies not is_ready
--	is_ready_implies_is_running: is_ready implies is_running
	proxy_log_file_not_void: proxy_log_file /= Void
	interpreter_log_file_name_not_void: interpreter_log_filename /= Void
	error_handler_not_void: error_handler /= Void
	variable_table_attached: variable_table /= Void
	raw_response_analyzer_attached: raw_response_analyzer /= Void


note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
