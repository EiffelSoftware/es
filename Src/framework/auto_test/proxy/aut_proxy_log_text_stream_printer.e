note
	description: "Summary description for {AUT_PROXY_LOG_PROCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PROXY_LOG_TEXT_STREAM_PRINTER

inherit
	AUT_PROXY_LOG_PRINTER

	AUT_SHARED_CONSTANTS

	AUT_REQUEST_PROCESSOR

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_config: like configuration; a_output_stream: like output_stream)
			-- Initialize Current.
		do
			system := a_system
			configuration := a_config
			output_stream := a_output_stream

			create request_printer.make (system, output_stream, configuration)
			create response_printer.make_with_prefix (output_stream, interpreter_log_prefix)
			response_printer.set_configuration (configuration)

			set_is_passing_test_case_logged (True)
			set_is_failing_test_case_logged (True)
			set_is_invalid_test_case_logged (True)
			set_is_bad_test_case_logged (True)
			set_is_error_test_case_logged (True)
			set_is_object_state_logged (False)
			set_is_operand_type_logged (False)
			set_is_bad_test_case_logged (True)
			set_is_error_test_case_logged (True)
			set_is_assign_expression_logged (True)
			set_is_type_request_logged (True)
		ensure
			system_set: system = a_system
			configuration_set: configuration = a_config
			output_stream_set: output_stream = a_output_stream
		end

feature -- Access

	system: SYSTEM_I
			-- system

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Stream that printer writes to

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration			

feature -- Access

	start_time: INTEGER
			-- Start time in millisecond of a request or an action,
			-- relative to the starting point of current test session.

	end_time: INTEGER
			-- End time in millisecond of a request or an action,
			-- relative to the starting point of current test session.

feature -- Status report

	is_passing_test_case_logged: BOOLEAN
			-- Should passing test cases be logged?
			-- Default: True

	is_failing_test_case_logged: BOOLEAN
			-- Should failing test cases be logged?
			-- Default: True

	is_invalid_test_case_logged: BOOLEAN
			-- Should invalid test cases be logged?
			-- Default: True

	is_object_state_logged: BOOLEAN
			-- Should object state information be logged?
			-- Default: False

	is_operand_type_logged: BOOLEAN
			-- Should type of operands to routines under test
			-- be logged explicitly?

	is_bad_test_case_logged: BOOLEAN
			-- Should test case with a bad response be logged?
			-- Default: True

	is_error_test_case_logged: BOOLEAN
			-- Should test case with an error response be logged?
			-- Default: True

	is_assign_expression_logged: BOOLEAN
			-- Should assignment to expressions be logged?
			-- Default: True

	is_type_request_logged: BOOLEAN
			-- Should type request be logged?
			-- Default: True

feature -- Setting

	set_is_passing_test_case_logged (b: BOOLEAN)
			-- Set `is_passing_test_case_logged' with `b'?
		do
			is_passing_test_case_logged := b
		ensure
			is_passing_test_case_logged_set: is_passing_test_case_logged = b
		end

	set_is_failing_test_case_logged (b: BOOLEAN)
			-- Set `is_failing_test_case_logged' with `b'?
		do
			is_failing_test_case_logged := b
		ensure
			is_failing_test_case_logged_set: is_failing_test_case_logged = b
		end

	set_is_object_state_logged (b: BOOLEAN)
			-- Set `is_object_state_logged' with `b'?
		do
			is_object_state_logged := b
		ensure
			is_object_state_logged_set: is_object_state_logged = b
		end

	set_is_invalid_test_case_logged (b: BOOLEAN)
			-- Set `is_invalid_test_case_logged' with `b'?
		do
			is_invalid_test_case_logged := b
		ensure
			is_invalid_test_case_logged_set: is_invalid_test_case_logged = b
		end

	set_is_operand_type_logged (b: BOOLEAN)
			-- Set `is_operand_type_logged' with `b'?
		do
			is_operand_type_logged := b
		ensure
			is_operand_type_logged_set: is_operand_type_logged = b
		end

	set_is_bad_test_case_logged (b: BOOLEAN)
			-- Set `is_bad_test_case_logged' with `b'?
		do
			is_bad_test_case_logged := b
		ensure
			is_bad_test_case_logged_set: is_bad_test_case_logged = b
		end

	set_is_error_test_case_logged (b: BOOLEAN)
			-- Set `is_error_test_case_logged' with `b'?
		do
			is_error_test_case_logged := b
		ensure
			is_error_test_case_logged_set: is_error_test_case_logged = b
		end

	set_is_assign_expression_logged (b: BOOLEAN)
			-- Set `is_gassign_expression_logged' with `b'?
		do
			is_assign_expression_logged := b
		ensure
			is_assign_expression_logged_set: is_assign_expression_logged = b
		end

	set_is_type_request_logged (b: BOOLEAN)
			-- Set `is_type_request_logged' with `b'?
		do
			is_type_request_logged := b
		ensure
			is_type_request_logged_set: is_type_request_logged = b
		end

	set_start_time (a_time: INTEGER)
			-- Set `start_time' with `a_time'.
		do
			start_time := a_time
		ensure then
			start_time_set: start_time = a_time
		end

	set_end_time (a_time: INTEGER)
			-- Set `end_time' with `a_time'.
		do
			end_time := a_time
		ensure then
			end_time_set: end_time = a_time
		end

	set_with_config_string (a_string: STRING)
			-- Set log options using `a_string'.
			-- `a_string' consists of comma separated keywords.
			-- Valid keywords are: off, passing, failing, invalid, bad, error, type, expr-assign, operand-type, state
			-- `a_string' is case insensitive.
		local
			l_keywords: LIST [STRING]
			l_word: STRING
		do
			set_is_passing_test_case_logged (False)
			set_is_failing_test_case_logged (False)
			set_is_invalid_test_case_logged (False)
			set_is_bad_test_case_logged (False)
			set_is_error_test_case_logged (False)
			set_is_object_state_logged (False)
			set_is_operand_type_logged (False)
			set_is_bad_test_case_logged (False)
			set_is_error_test_case_logged (False)
			set_is_assign_expression_logged (False)
			set_is_type_request_logged (False)

			l_keywords := a_string.as_lower.split (',')
			from
				l_keywords.start
			until
				l_keywords.after
			loop
				l_word := l_keywords.item_for_iteration
				if l_word.is_equal ("off") then
					-- Do nothing.
				elseif l_word.is_equal ("passing") then
					set_is_passing_test_case_logged (True)
				elseif l_word.is_equal ("failing") then
					set_is_failing_test_case_logged (True)
				elseif l_word.is_equal ("invalid") then
					set_is_invalid_test_case_logged (True)
				elseif l_word.is_equal ("bad") then
					set_is_bad_test_case_logged (True)
				elseif l_word.is_equal ("error") then
					set_is_error_test_case_logged (True)
				elseif l_word.is_equal ("state") then
					set_is_object_state_logged (True)
				elseif l_word.is_equal ("operand-type") then
					set_is_operand_type_logged (True)
				elseif l_word.is_equal ("expr-assign") then
					set_is_assign_expression_logged (True)
				elseif l_word.is_equal ("type") then
					set_is_type_request_logged (True)
				end
				l_keywords.forth
			end
		end

feature -- Basic operations

	report_request (a_producer: AUT_PROXY_EVENT_PRODUCER; a_request: AUT_REQUEST)
			-- Process new request.
			--
			-- `a_producer' Producer that triggered `a_request'.
			-- `a_request': Last request sent to interpreter.
		do
			a_request.process (Current)
		end

	report_response (a_producer: AUT_PROXY_EVENT_PRODUCER; a_response: AUT_RESPONSE)
			-- Process new response.
			--
			-- `a_producer' Producer that triggered `a_response'.
			-- `a_response': Last response reveiced from interpreter.
		do
			a_response.process (response_printer)
		end

	report_comment_line (a_producer: AUT_PROXY_EVENT_PRODUCER; a_line: STRING) is
			-- Report comment line `a_line'.
		do
			output_stream.put_string (a_line)
			output_stream.flush
		end

feature{AUT_REQUEST} -- Processing requests

	safe_process_request (a_request: AUT_REQUEST)
			-- Process `a_request'.
		do
			a_request.process (request_printer)
			if a_request.response /= Void then
				a_request.response.process (response_printer)
			end
			output_stream.flush
		end

	process_call_based_request (a_request: AUT_CALL_BASED_REQUEST)
			-- Process `a_request'.
		local
			l_should_log: BOOLEAN
			l_operand_type: SPECIAL [STRING]
			l_operand_index: SPECIAL [INTEGER]
			i: INTEGER
			c: INTEGER
			l_type_str: STRING
		do
			l_should_log := True
			if attached {AUT_NORMAL_RESPONSE} a_request.response as l_response then
				if attached {AUT_EXCEPTION} l_response.exception as l_exception then
					if l_exception.is_test_invalid then
						l_should_log := is_invalid_test_case_logged
					else
						l_should_log := is_failing_test_case_logged
					end
				else
					l_should_log := is_passing_test_case_logged
				end
			else
				if a_request.response /= Void then
					l_should_log :=
						(is_bad_test_case_logged implies a_request.response.is_bad) or
						(is_error_test_case_logged implies a_request.response.is_error)
				end
			end

			if l_should_log then
					-- Output operand indexes and types as comments.
					-- Useful as context information when only part of the test cases are logged.
				if is_operand_type_logged then
					l_operand_index := a_request.operand_indexes
					l_operand_type := a_request.operand_types
					check l_operand_index.count = l_operand_type.count end
					from
						i := 0
						c := l_operand_index.count
						create l_type_str.make (64)
						l_type_str.append (interpreter_type_message_prefix)
						l_type_str.append (a_request.test_case_index.out)
						l_type_str.append (once ": ")
					until
						i = c
					loop
						l_type_str.append (once "v_")
						l_type_str.append (l_operand_index.item (i).out)
						l_type_str.append (once ": ")
						l_type_str.append (l_operand_type.item (i))
						if i < c - 1 then
							l_type_str.append (once "; ")
						end
						i := i + 1
					end
					log_line (l_type_str)
				end
				log_time_stamp (test_case_start_tag, start_time)
				log_line (test_case_index_header + a_request.test_case_index.out)
				safe_process_request (a_request)
				log_time_stamp (test_case_end_tag, end_time)
			end
		end

	process_start_request (a_request: AUT_START_REQUEST)
			-- Process `a_request'.
		do
			log_time_stamp (start_request_tag, start_time)
			safe_process_request (a_request)
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
			-- Process `a_request'.
		do
			safe_process_request (a_request)
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
			-- Process `a_request'.
		do
			process_call_based_request (a_request)
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- Process `a_request'.
		do
			process_call_based_request (a_request)
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
			-- Process `a_request'.
		do
			if is_assign_expression_logged then
				safe_process_request (a_request)
			end
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
			-- Process `a_request'.
		do
			if is_type_request_logged then
				safe_process_request (a_request)
			end
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
			if is_object_state_logged then
				safe_process_request (a_request)
			end
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			fixme ("Implement.")
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			fixme ("Implement.")
		end

feature{NONE} -- Implementation

	request_printer: AUT_REQUEST_TEXT_PRINTER
			-- Printer to output requests.

	response_printer: AUT_RESPONSE_LOG_PRINTER;
			-- Printer to output reponse;

	log_time_stamp (a_tag: STRING; a_time: INTEGER)
			-- Log tag `a_tag' with timing information.
			-- `a_time' is the time.
		local
			l_output: STRING
		do
			create l_output.make (48)
			l_output.append (time_stamp_header)
			l_output.append (a_tag)
			l_output.append (once "; ")
			l_output.append ((a_time // 1000).out)
			l_output.append (once "; ")
			l_output.append (a_time.out)
			log_line (l_output)
		end

	log_line (a_text: STRING)
			-- Log `a_text' in its own line.
		do
			report_comment_line (Void, a_text)
			report_comment_line (Void, "%N")
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
