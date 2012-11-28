note
	description: "Verification error of a procedure."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_VERIFICATION_ERROR

feature {NONE} -- Initialization

	make (a_code: STRING; a_boogie_message: STRING)
			-- Initialize verification error.
		do
			create execution_trace.make
			code := a_code.twin
			boogie_message := a_boogie_message.twin
		end

feature -- Access

	procedure_result: E2B_PROCEDURE_RESULT
			-- Related procedure result.

	eiffel_feature: FEATURE_I
			-- Related Eiffel feature.
		do
			Result := procedure_result.eiffel_feature
		end

	eiffel_class: CLASS_C
			-- Related Eiffel class.
		do
			Result := procedure_result.eiffel_class
		end

	code: STRING
			-- Boogie error code.

	boogie_message: STRING
			-- Boogie error message.

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

feature {E2B_OUTPUT_PARSER} -- Element change

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
			boogie_source_text := line_of_file (boogie_location.filename, boogie_location.line)
		ensure
			boogie_location_set: boogie_location = a_location
		end

	set_boogie_related_location (a_location: like boogie_related_location)
			-- Set `boogie_related_location' to `a_location'.
		do
			boogie_related_location := a_location
			boogie_related_text := line_of_file (boogie_related_location.filename, boogie_related_location.line)
		ensure
			boogie_related_location_set: boogie_related_location = a_location
		end

	set_tag (a_tag: like tag)
			-- Set `tag' to `a_tag'.
		do
			if attached a_tag and not a_tag.is_empty then
				tag := a_tag.twin
			else
				tag := Void
			end
		ensure
			tag_set: tag ~ a_tag or a_tag.is_empty
		end

	set_eiffel_line_number (a_line: INTEGER)
			-- Set `eiffel_line_number' to `a_line'.
		do
			eiffel_line_number := a_line
		ensure
			eiffel_line_number_set: eiffel_line_number = a_line
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

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this error.
		deferred
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- Multi line description of this error.
		do
			single_line_message (a_formatter)
		end

end
