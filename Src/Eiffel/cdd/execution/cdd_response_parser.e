indexing
	description:

		"Abstract parser for interpreter responses"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class CDD_RESPONSE_PARSER

inherit

	EXCEP_CONST
		export {NONE} all end
create

	make

feature {NONE} -- Initialization

	make is
			-- Create new parser
		do
			create last_response_text.make (Default_response_length)
		end

feature -- Access

	last_response: CDD_TEST_EXECUTION_RESPONSE
			-- Last response parsed

feature -- Parsing

	parse (a_response_stream: KI_TEXT_INPUT_STREAM) is
			-- Parse response issued by the interpreter after it has been
			-- started.
		local
			setup_response: CDD_ROUTINE_INVOCATION_RESPONSE
			test_response: CDD_ROUTINE_INVOCATION_RESPONSE
			teardown_response: CDD_ROUTINE_INVOCATION_RESPONSE
		do
			input_stream := a_response_stream
			last_response_text.wipe_out
			parse_routine_invocation_response
			setup_response := last_routine_response
			if setup_response.is_normal then
				parse_routine_invocation_response
				test_response := last_routine_response
				if not test_response.is_bad then
					parse_routine_invocation_response
					teardown_response := last_routine_response
				end
			end
			create last_response.make (setup_response, test_response, teardown_response)
			parse_done
		ensure
			last_response_not_void: last_response /= Void
		end

feature {NONE} -- Implmenentation

	input_stream: KI_TEXT_INPUT_STREAM
			-- Input stream

	last_routine_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Last response as parsed by `parse_routine_invocation_reponse'

	parse_routine_invocation_response is
			-- Parse response to a routine invocation.
		local
			output: STRING
		do
			parse_multi_line_value
			if last_string /= Void then
				output := last_string.twin
				parse_line
				if last_string /= Void and then is_status_success_message (last_string) then
					create last_routine_response.make_normal (last_response_text.twin, output)
				elseif last_string /= Void and then is_status_exception_message (last_string) then
					parse_exception
					if last_exception = Void then
						create last_routine_response.make_bad (last_response_text.twin)
					else
						create last_routine_response.make_exceptional (last_response_text.twin, output, last_exception)
					end

				else
					create last_routine_response.make_bad (last_response_text.twin)
				end
			else
				create last_routine_response.make_bad (last_response_text.twin)
			end
		ensure
			last_routine_response_not_void: last_routine_response /= Void
		end

	parse_exception is
			-- Parse an exception and make it available via `last_exception'.
			-- Set it to Void if there was an error parsing the exception.
		require
			last_response_text_not_void: last_response_text /= Void
		local
			exception_code: INTEGER
			exception_recipient_name: STRING
			exception_class_name: STRING
			exception_tag_name: STRING
			exception_trace: STRING
		do
			last_exception := Void
			parse_line
			if last_string /= Void and then last_string.is_integer then
				exception_code := last_string.to_integer
				parse_line
				if last_string /= Void then
					exception_recipient_name := last_string.twin
					parse_line
					if last_string /= Void then
						exception_class_name := last_string.twin
						parse_multi_line_value
						if last_string /= Void then
							exception_tag_name := last_string.twin
							parse_multi_line_value
							if last_string /= Void then
								exception_trace := last_string.twin
								create last_exception.make (exception_code,
															exception_recipient_name,
															exception_class_name,
															exception_tag_name,
															exception_trace)
							end
						end
					end
				end
			end
		end

	parse_done is
			-- Parse a done line.
		do
			parse_line
		end

	parse_multi_line_value is
			-- Parse a multi line value. A multi line value starts
			-- with `multi_line_value_start_tag' and end with
			-- `multi_line_value_start_tag'. The content in between those
			-- tags is made available via `last_string'. If no multi line
			-- value could be read `last_string' is set to `Void'.
		local
			content: STRING
		do
			parse_line
			if last_string /= Void then
				if last_string.is_equal (multi_line_value_start_tag) then
					from
						parse_line
						create content.make (1024)
					until
						last_string = Void or else
						((last_string.count >= multi_line_value_end_tag.count and then
						 last_string.substring (last_string.count - multi_line_value_end_tag.count + 1,
															  last_string.count).is_equal (multi_line_value_end_tag)) or
							-- Do not even try to continue reading past a seg fault message, because
							-- in some cases the output can be infinte (loop).
						last_string.is_equal ("interpreter: PANIC: Unexpected harmful signal (Segmentation fault) ..."))
					loop
						content.append_string (last_string)
						content.append_character ('%N')
						parse_line
					end
					if last_string /= Void and then last_string.count > multi_line_value_end_tag.count then
						content.append_string (last_string.substring (1, last_string.count - multi_line_value_end_tag.count))
					end
				end
			end
			last_string := content
		end

	parse_line is
			-- Parse line and make it available via `last_string'.
			-- If no line could be read, `last_string' will be set to
			-- `Void'.
		do
			last_string := Void
			if not input_stream.end_of_input then
				input_stream.read_line
				last_string := input_stream.last_string
			end
			if last_string /= Void then
				last_response_text.append_string (last_string)
				last_response_text.append_character ('%N')
			end
		end

--	parse_stop_response is
--			-- Parse the response issued by the interpreter after it received a stop request.
--		do
--			create last_response_text.make (default_response_length)
--			create {AUT_NORMAL_RESPONSE} last_response.make (last_response_text, "")
--			last_response_text := Void
--		ensure
--			last_response_not_void: last_response /= Void
--		end

--	parse_invoke_response is
--			-- Parse the response issued by the interpreter after a
--			-- create-object/create-object-default/invoke-feature/invoke-and-assign-feature
--			-- request has been sent.
--		local
--			output: STRING
--		do
--			create last_response_text.make (default_response_length)
--			try_parse_multi_line_value
--			if last_string = Void then
--				parse_error
--				if last_string = Void then
--					create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--				else
--					create {AUT_ERROR_RESPONSE} last_response.make (last_response_text, last_string.twin)
--				end
--			else
--				output := last_string.twin
--				parse_status
--				if last_string = Void then
--					create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--				else
--					if is_status_success_message (last_string) then
--						create {AUT_NORMAL_RESPONSE} last_response.make (last_response_text, output)
--					else
--						parse_exception
--						if last_exception = Void then
--							create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--						else
--							create {AUT_NORMAL_RESPONSE} last_response.make_exception (last_response_text,
--																						output,
--																						last_exception)
--						end
--					end
--				end
--				if not last_response.is_bad then
--					parse_done
--					if last_string = Void then
--						create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--					end
--				end
--			end
--			last_response_text := Void
--		ensure
--			last_response_not_void: last_response /= Void
--		end


--	parse_assign_expression_response  is
--			-- Parse response issued by interpreter after receiving an
--			-- assign-expresion request.
--		do
--			create last_response_text.make (default_response_length)
--			parse_done
--			if last_string = Void then
--				create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--			else
--				create {AUT_NORMAL_RESPONSE} last_response.make (last_response_text, "")
--			end
--			last_response_text := Void
--		ensure
--			last_response_not_void: last_response /= Void
--		end

--	parse_type_of_variable_response is
--			-- Parse response issued by interpreter after receiving a
--			-- retrieve-type-of-variable request.
--		local
--			output: STRING
--		do
--			create last_response_text.make (default_response_length)
--			parse_type_name
--			if last_string = Void then
--				create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--			else
--				output := last_string.twin
--				parse_done
--				if last_string = Void then
--					create {AUT_BAD_RESPONSE} last_response.make (last_response_text)
--				else
--					create {AUT_NORMAL_RESPONSE} last_response.make (last_response_text, output)
--				end
--			end
--			last_response_text := Void
--		ensure
--			last_response_not_void: last_response /= Void
--		end

--feature {NONE} -- Implementation

--	parse_type_name is
--			-- Parse type name and make it available via `las_string'.
--			-- Set `last_string' to `Void' in case of error.
--		require
--			last_response_text_not_void: last_response_text /= Void
--		do
--			try_read_line
--			if last_string /= Void then
--				if base_type (last_string, universe) = Void then
--					last_string := Void
--				end
--			end
--		ensure
--			result_or_error: last_string = Void or else base_type (last_string, universe) /= Void
--		end


--	ignore_lines (a_count: INTEGER) is
--			-- Read `a_count' lines from input and
--			-- ignore content.
--		require
--			last_response_text_not_void: last_response_text /= Void
--			a_count_valid: a_count >= 1
--		local
--			i: INTEGER
--		do
--			from
--				try_read_line
--				i := 2
--			until
--				i > a_count or last_string = Void
--			loop
--				try_read_line
--				if last_string /= Void then
--					i := i + 1
--				end
--			end
--		end


--	try_read_line is
--			-- Try to read a line from the input. Make resulting string
--			-- available via `last_string' or set it to `Void' if no complete
--			-- line could be read. Append  parsed text to `last_response_text'
--		require
--			last_response_text_not_void: last_response_text /= Void
--		do
--			try_read_line_internal
--			if last_string /= Void then
--				last_response_text.append_string (last_string)
--				last_response_text.append_character ('%N')
--			end
--		end


feature {NONE} -- Constants

	multi_line_value_start_tag: STRING is "---multi-line-value-start---"
			-- Multi line start tag

	multi_line_value_end_tag: STRING is "---multi-line-value-end---"
			-- Multi line end tag

feature {NONE} -- Implementation

	last_string: STRING
			-- Last string parsed

	last_exception: AUT_EXCEPTION
			-- Last exception parsed

	last_response_text: STRING
			-- Complete unparsed text of last response

	is_status_success_message (a_string: STRING): BOOLEAN is
			-- Is `a_string' a valid status message indicating success?
		require
			a_string_not_void: a_string /= Void
		do
			Result := a_string.is_equal ("status: success")
		ensure
			definition: Result = a_string.is_equal ("status: success")
		end

	is_status_exception_message (a_string: STRING): BOOLEAN is
			-- Is `a_string' a valid status message indicating that an
			-- exception was thrown?
		require
			a_string_not_void: a_string /= Void
		do
			Result := a_string.is_equal ("status: exception")
		ensure
			definition: Result = a_string.is_equal ("status: exception")
		end

	default_response_length: INTEGER is 1024

end
