note
	description: "Summary description for {AFX_INTERPRETER}."
	author: ""
	date: ""
	revision: ""

deferred class
	AFX_INTERPRETER

inherit
	ARGUMENTS

	EXCEPTIONS

	THREAD_CONTROL

	AFX_INTERPRETER_CONSTANTS

feature{NONE} -- Implementation

	make
			-- Initialize.
		do
				-- Command line options:
				-- In fixing mode: --analyze-tc <log_file_path> <is_append>
				-- In validating mode: --validate-tc <log_file_path> <is_append> <port_number>
				-- In checking mode: --check-tc <log_file_path> <is_append> [test_case_uuid[,test_case_uuid]]
				--
				-- Modes:
				-- fixing mode: In this mode, AutoFix will execute all test cases, extracts state invariants and generate fix candidates.
				-- validating mode: In this mode, AutoFix will execute all test cases against every fix candidate to find out valid fixes.
				-- checking mode: In this mode, only one
				-- Arguments:
				-- log_file_path: full path log file
				-- is_append: if true, the existing log file is appended with new data; otherwise, overwrite the original log file
				-- port_number: port number used for socket communication.
				-- test_case_uuid: Comma separated universal IDs of test cases to be executed. If not present, the first failing test case will be executed.

			if argument_count >= 3 then
				create_log_file (argument (2), argument (3).to_boolean)
				if argument (1).is_case_insensitive_equal ("--analyze-tc") then
						-- Analyze test cases to construct fixes.										
					execute_test_cases
				elseif argument (1).is_case_insensitive_equal ("--validate-fix") then
						-- Validate fix candidates.
					port := argument (4).to_integer
					exception_count := 0
					is_validating_fixes := True
					validate_fixes
				elseif argument (1).is_case_insensitive_equal ("--check-fault") then

				end
				close_log_file
			end
		end

feature{NONE} -- Implementation

	test_cases: HASH_TABLE [PROCEDURE [ANY, TUPLE], STRING]
			-- Agents to test cases to be invoked.
			-- Key is the universal ID for test cases,
			-- value is the agent to invoke that test case.

	execute_test_cases
			-- Run test cases and do analysis to support fix generation.
		deferred
		end


	validate_fixes
			-- Validate generated candidate fixes
		local
			l_section: INTEGER
		do
			initialize_test_cases
			log_message ("-- Start validating fixes.%N")
			create socket.make_client_by_address_and_port ((create {INET_ADDRESS_FACTORY}).create_loopback, port)
			socket.connect
			log_message ("-- Socket connection established at port " + port.out + "%N")
			main_validation_loop
			l_section := 1
		rescue
			if l_section = 0 then
				log_message ("-- Failed to establish socket connection with port " + port.out + "%N")
			end

			if attached {STRING} exception_trace as l_trace then
				log_message (l_trace)
			end
			die (1)
		end

	check_test_cases (a_uuids: STRING)
			-- Check test cases whose uuid are specified by a comma separated string `a_uuids'.
			-- If `a_uuids' is empty, the first failing test case is executed.
		local
			l_agent: detachable PROCEDURE [ANY, TUPLE]
			l_uuids: LIST [STRING]
			l_id: STRING
		do
			if a_uuids.is_empty then
				create {LINKED_LIST [STRING]} l_uuids.make
				l_uuids.extend (first_failing_test_case_uuid)
			else
				l_uuids := a_uuids.split (',')
				from
					l_uuids.start
				until
					l_uuids.after
				loop
					l_id := l_uuids.item_for_iteration
					l_id.left_adjust
					l_id.right_adjust
					l_agent := test_cases.item (l_id)
					if l_agent /= Void then
						l_agent.call (Void)
					else
						log_message ("Test case with uuid %"" + l_id + "%" is not defined.")
					end
					l_uuids.forth
				end
			end
		end

feature{NONE} -- Stats retrieval

	last_pre_state: detachable like state_type
			-- Last retrieved pre state

	last_post_state: detachable like state_type
			-- Last retrieved post state

	is_validating_fixes: BOOLEAN
			-- Is validating fixes?

	retrieve_pre_state (a_operands: SPECIAL [detachable ANY])
			-- Retrieve prestate of `a_operands'.
		do
			-- Not needed for the moment.
		end

	retrieve_post_state (a_operands: SPECIAL [detachable ANY])
			-- Retrieve post of `a_operands'.
		local
			l_retried: BOOLEAN
		do
			last_post_state := Void
			if is_validating_fixes and then not l_retried then
				if should_retrieve_post_state then
					last_post_state := operand_states (a_operands)
				end
			end
		rescue
			l_retried := True
			retry
		end

	operand_states (a_operands: SPECIAL [detachable ANY]): like state_type
			-- Operand states of `a_operands'
		deferred
		end

feature{NONE} -- Implementation

	initialize_test_cases
			-- Initialize `test_cases'.
		deferred
		end

	main_validation_loop
			-- Main loop for fix validation
		do
			from
			until
				should_quit or else socket.is_closed
			loop
				retrieve_request
				execute_last_request
			end
		end

	execute_last_request
			-- Execute last request
		do
			if last_request_type = request_exit_type then
				exit_validation
			elseif last_request_type = request_execute_test_case_type then
				execute_test_case_for_validation
			elseif last_request_type = request_melt_feature_type then
				execute_melting_request
			else
				check should_not_happen: False end
			end
		end

	execute_test_case_for_validation
			-- Execute test case specified by `last_request' for validation.
		local
			l_agent: PROCEDURE [ANY, TUPLE]
			l_except_count: NATURAL_32
			l_passing: BOOLEAN
		do
			last_pre_state := Void
			last_post_state := Void
			if attached {AFX_EXECUTE_TEST_CASE_REQUEST} last_request as l_exec_request then
				log_message ("-- Received UUID: " + l_exec_request.test_case_uuid + "%N")
				should_retrieve_post_state := l_exec_request.should_retrieve_post_state
				if l_exec_request.test_case_uuid.is_empty then
						-- Execute all registered test cases.
					from
						test_cases.start
					until
						test_cases.after
					loop
						l_except_count := exception_count
						l_agent := test_cases.item (l_exec_request.test_case_uuid)
						l_agent.call (Void)
						test_cases.forth
					end
				else
						-- Execute a single test case.
					if test_cases.has (l_exec_request.test_case_uuid) then
						l_agent := test_cases.item (l_exec_request.test_case_uuid)
						l_except_count := exception_count
						l_agent.call (Void)
						l_passing := (l_except_count = exception_count)
						log_message ("-- Finished test case UUID: " + l_exec_request.test_case_uuid + ", status= " + l_passing.out + "%N")
						if not l_passing and then attached {STRING} last_trace as l_trace then
							log_message (l_trace)
							log_message ("%N")
							last_trace := Void
						end
					else
						log_message ("-- Cannot find test case with UUID: " + l_exec_request.test_case_uuid + "%N")
					end
				end
			end
			socket.put_natural_32 (exception_count)

				-- If post execution state is retrieved, send it back.
			if should_retrieve_post_state then
				if attached {like state_type} last_post_state as l_post then
					socket.independent_store (l_post)
				else
					socket.independent_store (void_state)
				end
			end
		end

	last_trace: STRING

	execute_melting_request
			-- Execute melting request.
		do
			if attached {AFX_MELT_FEATURE_REQUEST} last_request as l_request then
				log_message ("-- Melt feature with body_id = " + l_request.body_id.out + ", pattern_id = " + l_request.pattern_id.out + ", byte_code length = " + l_request.byte_code.count.out + " Fix: " + l_request.fix_signature  + "%N")
				eif_override_byte_code_of_body (l_request.body_id, l_request.pattern_id, pointer_for_byte_code (l_request.byte_code), l_request.byte_code.count)
			else
				log_message ("-- Cannot interpreter melt feature request.%N")
			end
			socket.put_natural_32 (0)
		end

	exit_validation
			-- Exit validation
		local
			l: STRING
		do
			should_quit := True
			log_message ("-- Exit validation.%N")
			socket.close
		end

	exception_count: NATURAL_32

feature{NONE} -- Implementation

	should_quit: BOOLEAN
			-- Should quit from `main_validation_loop'?

	last_request_type: NATURAL_32
			-- Last request type

	last_request: detachable AFX_INTERPRETER_REQUEST
			-- Last request

	request_type_name (a_type: NATURAL_32): STRING
			-- Name for request of type `a_type'
		do
			inspect
				a_type
			when request_exit_type then
				Result := once "Exit"
			when request_execute_test_case_type then
				Result := once "Execute test case"
			when request_melt_feature_type then
				Result := once "Melt feature"
			end
		end

feature{NONE} -- Interprocess communication

	socket: NETWORK_STREAM_SOCKET
			-- Socket used for communitation between proxy and current interpreter

	port: INTEGER
			-- Port used by `socket'

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
					log_message ("-- Received request type: " + request_type_name (last_request_type) + "%N")
					if attached {like last_request} socket.retrieved as l_request then
						last_request := l_request
					else
						log_message ("Cannot interpreter request.%N")
					end
				end
			end
		rescue
			l_retried := True
			last_request := Void
			socket.close
			retry
		end

feature{NONE} -- Logging

	log_file: PLAIN_TEXT_FILE
			-- File tot output logs

	create_log_file (a_path: STRING; a_append: BOOLEAN)
			-- Create `log_file' to point to `a_path'.
			-- If `a_append' is True, append to an existing file,
			-- otherwise, create a new one.
		require
			a_path_attached: a_path /= Void
		do
			create log_file.make (a_path)
			if log_file.exists and then a_append then
				log_file.open_append
			else
				log_file.create_read_write
			end
		end

	close_log_file
			-- Close `log_file'.
		do
			if attached {PLAIN_TEXT_FILE} log_file as l_file then
				if not l_file.is_closed then
					log_file.close
				end
			end
		end

	log_message (a_text: STRING)
			-- Log `a_text' in `log_file'.
		do
			if attached {PLAIN_TEXT_FILE} log_file as l_log and then l_log.is_open_write then
				l_log.put_string (a_text)
				l_log.flush
			end
		end

feature{NONE} -- Melting

	pointer_for_byte_code (a_byte_code_string: STRING): POINTER
			-- pointer representation for `a_byte_code_string'
			-- TODO: Copied from {ITP_INTERPRETER}, refactoring needed.
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

	eif_override_byte_code_of_body (a_body_id: INTEGER; a_pattern_id: INTEGER; a_byte_code: POINTER; a_length: INTEGER)
			-- Store `a_byte_code' of `a_length' byte long for feature with `a_body_id'.
			-- TODO: Copied from {ITP_INTERPRETER}, refactoring needed.
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

feature{NONE} -- State retrieval

	object_states (a_queries: HASH_TABLE [HASH_TABLE [FUNCTION [ANY, TUPLE, ANY], STRING], INTEGER]): like state_type
			-- States evaluated from `a_queries'
		require
			a_queries_attached: a_queries /= Void
		local
			l_queries: HASH_TABLE [FUNCTION [ANY, TUPLE, ANY], STRING]
			l_values: HASH_TABLE [STRING, STRING]
		do
			create Result.make (a_queries.count)
			from
				a_queries.start
			until
				a_queries.after
			loop
				l_queries := a_queries.item_for_iteration
				create l_values.make (l_queries.count)
				l_values.compare_objects
				Result.put (l_values, a_queries.key_for_iteration)

				from
					l_queries.start
				until
					l_queries.after
				loop
					l_values.put (value_of_query (l_queries.item_for_iteration), l_queries.key_for_iteration)
					l_queries.forth
				end
				a_queries.forth
			end
		end

	value_of_query (a_query: FUNCTION [ANY, TUPLE, ANY]): STRING
			-- Evaluated value of `a_query'
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				if attached {ANY} a_query.item (Void) as l_value then
					Result := l_value.out
				else
					Result := once "Void"
				end
			end
		rescue
			l_retried := True
			Result := nonsensical
			retry
		end

	state_type: HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER]
			-- Type anchor for state
			-- Inner table: key is query name, value is its evaluation value, "nonsensical" if an exception
			-- happend during evaluation.
			-- Outer table: key is operand index, 0 is the target, followed by arguments.

	should_retrieve_post_state: BOOLEAN
			-- Should post state be retrieved?

	first_failing_test_case_uuid: STRING
			-- UUID of the first failing test case
		deferred
		end

end

