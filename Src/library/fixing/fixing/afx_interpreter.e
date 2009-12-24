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
			if argument_count >= 3 then
				create_log_file (argument (2), argument (3).to_boolean)
				if argument (1).is_case_insensitive_equal ("--analyze-tc") then
						-- Analyze test cases to construct fixes.										
					execute_test_cases
				elseif argument (1).is_case_insensitive_equal ("--validate-fix") then
						-- Validate fix candidates.
					port := argument (4).to_integer
					exception_count := 0
					validate_fixes
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

	retrieve_pre_state (a_operands: SPECIAL [detachable ANY])
			-- Retrieve prestate of `a_operands'.
		deferred
		end

	retrieve_post_state (a_operands: SPECIAL [detachable ANY])
			-- Retrieve post of `a_operands'.
		deferred
		end

feature{NONE} -- Implementation

	initialize_test_cases
			-- Initialize `test_cases'.
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
		do
			if attached {AFX_EXECUTE_TEST_CASE_REQUEST} last_request as l_exec_request then
				log_message ("-- Received UUID: " + l_exec_request.test_case_uuid + "%N")
				if l_exec_request.test_case_uuid.is_empty then
						-- Execute all registered test cases.
					from
						test_cases.start
					until
						test_cases.after
					loop
						l_agent := test_cases.item (l_exec_request.test_case_uuid)
						l_agent.call (Void)
						test_cases.forth
					end
				else
						-- Execute a single test case.
					if test_cases.has (l_exec_request.test_case_uuid) then
						l_agent := test_cases.item (l_exec_request.test_case_uuid)
						l_agent.call (Void)
					else
						log_message ("-- Cannot find test case with UUID: " + l_exec_request.test_case_uuid + "%N")
					end
				end
			end
			socket.put_natural_32 (exception_count)
		end

	execute_melting_request
			-- Execute melting request.
		do
			if attached {AFX_MELT_FEATURE_REQUEST} last_request as l_request then
				log_message ("-- Melt feature with body_id = " + l_request.body_id.out + ", pattern_id = " + l_request.pattern_id.out + ", byte_code length = " + l_request.byte_code.count.out + "%N")
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


end

