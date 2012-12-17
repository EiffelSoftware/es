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

	eiffel_file_name: STRING
			-- Eiffel file name.

	eiffel_line_number: INTEGER
			-- Location of error in Eiffel file.

	tag: STRING
			-- Assertion tag (if any)

feature -- Status report

	has_tag: BOOLEAN
			-- Is a tag associated with this error?
		do
			Result := tag /= Void
		end

feature {E2B_OUTPUT_PARSER} -- Element change

	set_procedure_result (a_proc_result: like procedure_result)
			-- Set `procedure_result' to `a_proc_result'.
		do
			procedure_result := a_proc_result
		ensure
			procedure_result = a_proc_result
		end

	set_error_model (a_error_model: like error_model)
			-- Set `error_model' to `a_error_model'.
		do
			error_model := a_error_model
		ensure
			error_model_set: error_model = a_error_model
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

	set_eiffel_file_name (a_file: STRING)
			-- Set `eiffel_filename' to `a_file'.
		do
			eiffel_file_name := a_file.twin
		ensure
			eiffel_file_name ~ a_file
		end

	set_eiffel_line_number (a_line: INTEGER)
			-- Set `eiffel_line_number' to `a_line'.
		do
			eiffel_line_number := a_line
		ensure
			eiffel_line_number_set: eiffel_line_number = a_line
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
