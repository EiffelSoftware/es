indexing
	description: "Proxy object that communicates with CDD interpreter. Abstracts IPC away."
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class CDD_INTERPRETER_PROXY

inherit

	THREAD_CONTROL
		export {NONE} all end

	PROCESS_FACTORY
		export {NONE} all end

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

	KL_SHARED_OPERATING_SYSTEM
		export {NONE} all end

	UNIX_SIGNALS
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (an_executable_file_name: STRING;
			a_proxy_log_filename: STRING) is
			-- Create a new proxy for the interpreter found at `an_executable_file_name'.
			-- Log communication between proxy and interpreter into a file
			-- named `a_proxy_log_filename'.
		require
			an_executable_file_name_not_void: an_executable_file_name /= Void
			a_proxy_log_filename_not_void: a_proxy_log_filename /= Void
		do
			create output_stream.make_empty
			executable_file_name := an_executable_file_name
			melt_path := file_system.dirname (executable_file_name)
			create proxy_log_file.make (a_proxy_log_filename)
			proxy_log_file.open_append
			log_line ("-- A new proxy has been created.")
			create parser.make
			create response_buffer.make (1024 * 50)
		ensure
			executable_file_name_set: executable_file_name = an_executable_file_name
			proxy_log_file_created: proxy_log_file /= Void
		end

feature -- Status

	is_running: BOOLEAN is
			-- Is the client currently running? Note that the value of
			-- `is_running' changes to `False' as soon as the interpreter
			-- quits. In particular this means that nobody can guarantee
			-- `is_running' (i.e. as part of a precondtion), because the
			-- interpreter can always just crash. See `is_launched' for a
			-- weaker alternative that can be guaranteed.
		do
			Result := process /= Void and then process.is_running
		end

	is_launched: BOOLEAN is
			-- Has the client been launched?
			-- Note that `is_launched' will be True also when the child has
			-- terminated in the meanwhile. This is a weaker alternative to
			-- `is_running'.
		do
			Result := process /= Void and then process.launched
		end

	is_ready: BOOLEAN is
			-- Is interpreter ready for a new request? The interpreter processes
			-- one request after the next.
		do
			Result := is_launched and not is_executing_request and (last_response /= Void implies not last_response.has_bad_communication)
		end

	is_executing_request: BOOLEAN
			-- Is the interpreter currently executing a request?

feature -- Access

	last_response: CDD_TEST_EXECUTION_RESPONSE
			-- Last response received from interpreter

	proxy_log_filename: STRING is
			-- File name of proxy log
		do
			Result := proxy_log_file.name
		ensure
			filename_not_void: Result /= Void
			valid_filename: Result.is_equal (proxy_log_file.name)
		end

feature -- Settings

	set_proxy_log_filename (a_filename: like proxy_log_filename) is
			-- Make `a_filename' the new proxy filename.
		require
			a_filename_not_void: a_filename /= Void
		do
			if proxy_log_file.is_open_write then
				proxy_log_file.close
			end
			create proxy_log_file.make (a_filename)
			proxy_log_file.open_write
			log_line ("-- An existing proxy has switched to this log file.")
		end

feature -- Execution

	start is
			-- Start the client.
		require
			not_running: not is_running
		do
			last_response := Void
				-- $MELT_PATH needs to be set here in only to allow debugging.
			execution_environment.set_variable_value ("MELT_PATH", file_system.dirname (executable_file_name))
			launch_process
			if is_running then
				output_stream.string.wipe_out
				log_line (proxy_has_started_and_connected_message)
			else
				process := Void
				log_line ("-- Error: Could not start and connect to interpreter.")
			end
		end

	stop is
			-- Close connection to client and terminate it.
			-- If the client is not responsive to a regular shutdown,
			-- its process will be forced to shut down
		require
			is_running: is_launched
		do
			output_stream.put_line (":quit")
			flush_process
			-- Give the `process' 50 milliseconds to terminate itself
			process.wait_for_exit_with_timeout (50)
			if not process.has_exited then
				-- Force shutdown of `process' because it has not terminated regularly
				log_line ("-- Warning: proxy was not able to terminate interpreter.")
				process.terminate_tree
				process.wait_for_exit -- ensures `process.has_exited'
				log_line ("-- Warning: proxy forced termination of interpreter.")
			else
				log_line ("-- Proxy has terminated interpreter.")
			end
			process := Void
			is_executing_request := False
		end

	execute_test (a_class_name: STRING; a_routine_name: STRING) is
			-- Execute test routine `a_routine_name' from class
			-- `a_class_name' in interpreter. This routine blocks.
		require
			is_launched: is_launched
			is_ready: is_ready
			not_executing_request: not is_executing_request
			a_class_name_not_void: a_class_name /= Void
			a_routine_name_not_void: a_routine_name /= Void
		local
			end_time: DATE_TIME
			current_time: DATE_TIME
			stream: KL_STRING_INPUT_STREAM
		do
			execute_test_async (a_class_name, a_routine_name)
			from
				create end_time.make_now
				end_time.second_add (timeout)
				create current_time.make_now
			until
				current_time > end_time or last_response /= Void
			loop
				process_response
				sleep (3000)
				current_time.make_now
			end
			-- TODO: this and the timeout bit must be moved to `process_response'
			-- otherwise async test case execution doesn't abort via a time-out.
			if last_response = Void then
				-- This means a timeout occured, so let's take what we have anyways ...
					create stream.make (response_buffer)
					parser.parse (stream)
					last_response := parser.last_response
					is_executing_request := False
			end
		ensure
			last_response_is_not_void: last_response /= Void
		end

	execute_test_async (a_class_name: STRING; a_routine_name: STRING) is
			-- Triggers the execution of test routine `a_routine_name' from class
			-- `a_class_name' in interpreter. This routine does not block. In particular
			-- it does not wait to parse the result of the interpreter. In order to
			-- create the response `process_response' needs to be called until
			-- `last_response /= Void'.
		require
			is_launched: is_launched
			is_ready: is_ready
			not_executing_request: not is_executing_request
			a_class_name_not_void: a_class_name /= Void
			a_routine_name_not_void: a_routine_name /= Void
		do
			last_response := Void
			output_stream.put_string (a_class_name)
			output_stream.put_character ('.')
			output_stream.put_line (a_routine_name)
			flush_process
			is_executing_request := True
			response_buffer.wipe_out
		end

	process_response is
			-- Process the response of the interpreter. If the response is complete
			-- parse it and make it available via `last_response'.
		require
			is_executing_request: is_executing_request
		local
			stream: KL_STRING_INPUT_STREAM
		do
			try_read_line_internal
			if last_string /= Void then
				response_buffer.append_string (last_string)
				response_buffer.append_character ('%N')
				if last_string.is_equal ("done:") then
					create stream.make (response_buffer)
					parser.parse (stream)
					last_response := parser.last_response
					is_executing_request := False
				end
			end
		end

feature {NONE} -- Implementation

	parser: CDD_RESPONSE_PARSER
			-- Response parser

	response_buffer: STRING
			-- Buffer for interpreter response

	process: PROCESS
			-- Client process

	stdout_reader: AUT_THREAD_SAFE_LINE_READER
			-- Non blocking reader for client-stdout

	stderr_reader: AUT_THREAD_SAFE_LINE_READER
			-- Non blocking reader for client-stderr

	timeout: INTEGER is 2
			-- Client timeout in seconds

	flush_process is
			-- Send content of `process_buffer' to process stdin.
		local
			failed: BOOLEAN
		do
			if not failed then
				if process.input_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream then
					process.put_string (output_stream.string)
					log (output_stream.string)
				else
					log ("Error: could not send instruction to interpreter due its input stream being closed.")
				end
				output_stream.string.wipe_out
			end
		rescue
			failed := True
			retry
		end

	last_string: STRING
			-- Last string parsed via `try_read_line_internal'

	try_read_line_internal is
			-- Try to read a line from the interpreter (if something is available).
		do
			if is_launched then
				check
					not_ready: not is_ready
				end
				stderr_reader.reset_last_line
				stdout_reader.try_read_line
				if not stdout_reader.has_read_line then
					stderr_reader.try_read_line
				end
				check
					stdout_or_stderr_read: not (stdout_reader.has_read_line and stderr_reader.has_read_line)
				end
				if stdout_reader.has_read_line then
					log_line (interpreter_log_prefix + stdout_reader.last_line)
					last_string := stdout_reader.last_line
				elseif stderr_reader.has_read_line then
					log_line (interpreter_log_prefix + stderr_reader.last_line)
					last_string := stderr_reader.last_line
				else
					last_string := Void
				end
			else
				last_string := Void
			end
		end

feature {NONE} -- Implementation

	melt_path: STRING
			-- Path where melt file resides. Needed because
			-- EiffelStudio debugger doesn't allow recursive debugging
			-- of EiffelStudio at the moment. Should be soleved with 6.2.

	executable_file_name: STRING
			-- File name of interpreter executable

	output_stream: KL_STRING_OUTPUT_STREAM
			-- Output stream used by `request_printer'

	launch_process is
			-- Launch `process'.
		do
			create stdout_reader.make
			create stderr_reader.make
				-- $MELT_PATH needs to be set here in only to allow debugging.
			execution_environment.set_variable_value ("MELT_PATH", melt_path)
			process := process_launcher (executable_file_name, Void, ".")
			process.enable_launch_in_new_process_group
			process.redirect_input_to_stream
			process.redirect_output_to_agent (agent stdout_reader.put_string)
			process.redirect_error_to_agent (agent stderr_reader.put_string)
			process.launch
			-- TODO: both process.launch and process.is_running must be true, otherwise report error.
		end

feature {NONE} -- Logging

	proxy_log_file: KL_TEXT_OUTPUT_FILE
			-- Proxy log file

	log (a_string: STRING) is
			-- Log `a_string' to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			if proxy_log_file.is_open_write then
				proxy_log_file.put_string (a_string)
				proxy_log_file.flush
			end
		end

	log_line (a_string: STRING) is
			-- Log `a_string' followed by a new-line character to `log_file'.
		require
			a_string_not_void: a_string /= Void
		do
			log (a_string)
			log ("%N")
		end

feature {NONE} -- Constants

	interpreter_log_prefix: STRING is "%T-- > "
			-- Prefix of messages sent from interpreter in log file

	proxy_has_started_and_connected_message: STRING is "-- Proxy has started and connected to interpreter."
			-- Message printed to the log when a new interpreter is started

invariant

	process_not_void: is_running implies process /= Void
	melt_path_not_void: melt_path /= Void
	is_running_implies_reader: is_running implies (stdout_reader /= Void and stderr_reader /= Void)
	executable_file_name_not_void: executable_file_name /= Void
	not_launched_implies_not_ready: not is_launched implies not is_ready
	not_launched_implies_not_executing_request: not is_launched implies not is_executing_request
	executing_request_implies_running: is_executing_request implies is_launched
	is_executing_request_implies_not_ready: is_executing_request implies not is_ready
	proxy_log_file_not_void: proxy_log_file /= Void
	response_buffer_not_void: response_buffer /= Void

end
