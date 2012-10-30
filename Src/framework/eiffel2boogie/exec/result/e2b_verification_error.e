note
	description: "Verification error of a procedure."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFICATION_ERROR

inherit

	E2B_PROCEDURE_RESULT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize verification error.
		do
			create execution_trace.make
		end

feature -- Access

	code: STRING
			-- Error code.

	message: STRING
			-- Error message.

	execution_trace: LINKED_LIST [TUPLE [filename: STRING; line, column: INTEGER; label: STRING]]
			-- Execution trace of symbolic execution.

	error_model: E2B_ERROR_MODEL
			-- Error model from Z3.

	boogie_location: TUPLE [filename: STRING; line, column: INTEGER]
			-- Location of error in Boogie file.

	boogie_related_location: detachable TUPLE [filename: STRING; line, column: INTEGER; message: STRING]
			-- Related location of error in Boogie file.

	boogie_source_text: STRING
			-- Text of Boogie file at `location'.

	boogie_related_text: STRING
			-- Text of Boogie file at `related_location'.

	eiffel_line_number: INTEGER
			-- Location of error in Eiffel file.

	related_eiffel_location: TUPLE [filename: STRING; line: INTEGER]
			-- Location of related information (pre- or postcondition).
		require
			has_related_text: has_boogie_related_location
		do
			assert_regexp.match (boogie_related_text)

		end

	tag: STRING
			-- Assertion tag (if any)

	associated_error: E2B_VIOLATION
			-- Associated error.

feature -- Status report

	has_tag: BOOLEAN
			-- Is a tag associated with this error?
		do
			Result := tag /= Void
		end

	has_boogie_related_location: BOOLEAN
			-- Does a related location exist?
		do
			Result := boogie_related_location /= Void
		end

	is_check_violation: BOOLEAN
			-- Is this a check violation?

	is_precondition_violation: BOOLEAN
			-- Is this a precondition violation?

	is_postcondition_violation: BOOLEAN
			-- Is this a postcondition violation?

	is_invariant_violation: BOOLEAN
			-- Is this a invariant violation?

	is_loop_invariant_violation: BOOLEAN
			-- Is this a loop invariant violation?

	is_loop_variant_violation: BOOLEAN
			-- Is this a loop variant violation?

	is_attached_violation: BOOLEAN
			-- Is this a call on void violation?

	is_overflow_violation: BOOLEAN
			-- Is this an arithmetic overflow violation?

	is_frame_condition_violation: BOOLEAN
			-- Is this a frame condition violation?

feature {E2B_OUTPUT_PARSER} -- Element change

	set_code (a_code: like code)
			-- Set `code' to `a_code'.
		do
			code := a_code
		ensure
			code_set: code = a_code
		end

	set_message (a_message: like message)
			-- set `message' to `a_message'.
		do
			message := a_message
		ensure
			message_set: message = a_message
		end

	set_error_model (a_error_model: like error_model)
			-- Set `error_model' to `a_error_model'.
		do
			error_model := a_error_model
		ensure
			error_model_set: error_model = a_error_model
		end

	set_boogie_location (a_location: like boogie_location)
			-- Set `boogie_location' to `a_location'.
		do
			boogie_location := a_location
		ensure
			boogie_location_set: boogie_location = a_location
		end

	set_boogie_related_location (a_location: like boogie_related_location)
			-- Set `boogie_related_location' to `a_location'.
		do
			boogie_related_location := a_location
		ensure
			boogie_related_location_set: boogie_related_location = a_location
		end

	process
			-- Process error information.
		local
			l_is_pre, l_is_post, l_is_assert: BOOLEAN
			l_is_loop_inv_on_entry, l_is_loop_inv_maintained: BOOLEAN
			l_type: STRING
		do
			l_is_assert := code ~ "BP5001"
			l_is_pre := code ~ "BP5002"
			l_is_post := code ~ "BP5003"
			l_is_loop_inv_on_entry := code ~ "BP5004"
			l_is_loop_inv_maintained := code ~ "BP5005"

				-- Boogie source
			boogie_source_text := line_of_file (boogie_location.filename, boogie_location.line)
			if has_boogie_related_location then
				boogie_related_text := line_of_file (boogie_related_location.filename, boogie_related_location.line)
			end

			if l_is_assert then
					-- check, attached, loop-var
				assert_regexp.match (boogie_source_text)
				check assert_regexp.has_matched end
				is_check_violation := assert_regexp.captured_substring (2) ~ "check"
				is_attached_violation := assert_regexp.captured_substring (2) ~ "attached"
				is_overflow_violation := assert_regexp.captured_substring (2) ~ "overflow"
				check is_check_violation or is_attached_violation or is_overflow_violation end

			elseif l_is_pre then
					-- pre
				assert_regexp.match (boogie_related_text)
				check assert_regexp.has_matched end
				check assert_regexp.captured_substring (2) ~ "pre" or assert_regexp.captured_substring (2) ~ "overflow" end
				is_precondition_violation := True

			elseif l_is_post then
					-- post, inv, frame
				assert_regexp.match (boogie_related_text)
				check assert_regexp.has_matched end
				is_postcondition_violation := assert_regexp.captured_substring (2) ~ "post"
				is_invariant_violation := assert_regexp.captured_substring (2) ~ "inv"
				is_frame_condition_violation := assert_regexp.captured_substring (2) ~ "frame"
				if assert_regexp.captured_substring (2) ~ "attached" or assert_regexp.captured_substring (2) ~ "overflow" then
					is_postcondition_violation := True
				end
				check is_postcondition_violation or is_invariant_violation or is_frame_condition_violation end

			elseif l_is_loop_inv_on_entry then
					-- loop-inv

			elseif l_is_loop_inv_maintained then
					-- loop-inv

			else
				check False end
			end

			if assert_regexp.match_count >= 5 then
				parse_info (assert_regexp.captured_substring (4), assert_regexp.captured_substring (5))
			end
			if assert_regexp.match_count >= 8 then
				parse_info (assert_regexp.captured_substring (7), assert_regexp.captured_substring (8))
			end

			if is_check_violation then
				create {E2B_CHECK_VIOLATION} associated_error.make (Current)
			elseif is_precondition_violation then
				
			end


--				-- Eiffel source
--			if l_is_assert or l_is_pre then
--				eiffel_line_number := instruction_location (boogie_location.filename, boogie_location.line)
--			else
--					-- ?
--			end
--				-- Assertion tag
--			if l_is_assert then
--				assert_regexp.match (boogie_source_text)
--			elseif l_is_pre or l_is_post then
--				check has_boogie_related_location end
--				assert_regexp.match (boogie_related_text)
--			else
--					-- ?
--			end
--			l_type := assert_regexp.captured_substring (2)
--			if assert_regexp.match_count > 5 then
--				tag := assert_regexp.captured_substring (6)
--			end

				-- Classification
--			is_check_violation := l_type ~ "check"
--			is_precondition_violation := l_type ~ "pre"
--			is_postcondition_violation := l_type ~ "post"
--			is_invariant_violation := l_type ~ "inv"
--			is_loop_invariant_violation := l_type ~ "loop-inv"
--			is_loop_variant_violation := l_type ~ "loop-var"
--			is_attached_violation := l_type ~ "attached"
--			is_frame_condition_violation := l_type ~ "frame"
		end



feature {NONE} -- Implementation

	parse_info (a_type: STRING; a_info: STRING)
			-- Parse info (if any).
		do
			if a_type ~ "tag" then
				tag := a_info
			elseif a_type ~ "line" then
				eiffel_line_number := a_info.to_integer
			end
		end

	line_of_file (a_filename: STRING; a_line: INTEGER): STRING
			-- Line `a_line' of file `a_filename'.
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
		do
			create l_file.make (a_filename)
			l_file.open_read
			from
				i := 0
			until
				l_file.end_of_file or i = a_line
			loop
				l_file.read_line
				i := i + 1
			end
			Result := l_file.last_string
			l_file.close
		end

	instruction_location (a_filename: STRING; a_line: INTEGER): INTEGER
			-- Instruction location information on previous line of `a_line' in file `a_filename'.
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
		do
			create l_file.make (a_filename)
			l_file.open_read
			from
				i := 0
			until
				l_file.end_of_file or i = a_line
			loop
				if instruction_location_regexp.matches (l_file.last_string) then
					Result := instruction_location_regexp.captured_substring (3).to_integer
				end
				l_file.read_line
				i := i + 1
			end
			l_file.close
		end

	assert_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion information in Boogie source.
		once
			create Result.make
			Result.compile ("^(.*)// (\w+)(\s*(tag):(\w*))?(\s*(line):(\w*))?$")
		end

	instruction_location_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^\s*// (.*) --- (.*):(\d+)$")
		end

end
