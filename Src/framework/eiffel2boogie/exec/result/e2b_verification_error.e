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

	location: TUPLE [filename: STRING; line, column: INTEGER]
			-- Location of error.

	code: STRING
			-- Error code.

	message: STRING
			-- Error message.

	execution_trace: LINKED_LIST [TUPLE [filename: STRING; line, column: INTEGER; label: STRING]]
			-- Execution trace of symbolic execution.

	error_model: E2B_ERROR_MODEL
			-- Error model from Z3.

	related_location: detachable TUPLE [filename: STRING; line, column: INTEGER; label: STRING]
			-- Related location.

feature -- Status report

	has_related_location: BOOLEAN
			-- Does a related location exist?
		do
			Result := related_location /= Void
		end

feature {E2B_OUTPUT_PARSER} -- Element change

	set_location (a_location: like location)
			-- Set `location' to `a_location'.
		do
			location := a_location
		ensure
			location_set: location = a_location
		end

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

	set_related_location (a_location: like related_location)
			-- Set `related_location' to `a_location'.
		do
			related_location := a_location
		ensure
			related_location_set: related_location = a_location
		end

end
