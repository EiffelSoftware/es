note
	description: "Individual error of verifying a Boogie procedure."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BOOGIE_PROCEDURE_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_error_code: STRING)
			-- Make error with `a_error_code'.
		do
			error_code := a_error_code.twin
		ensure
			error_code_set: error_code ~ a_error_code
		end

feature -- Access

	error_code: STRING
			-- Boogie error code

	line: INTEGER
			-- Line where error occured.

	line_text: STRING
			-- Text of line where error occured.

	related_line: INTEGER
			-- Line of related location (if any).

	related_line_text: STRING
			-- Text of line of related location (if any).

feature -- Status report

	is_assert_error: BOOLEAN
			-- Is this an assertion error?
		do
			Result := error_code ~ "BP5001"
		end

	is_precondition_violation: BOOLEAN
			-- Is this a precondition violation?
		do
			Result := error_code ~ "BP5002"
		end

	is_postcondition_violation: BOOLEAN
			-- Is this a postcondition violation?
		do
			Result := error_code ~ "BP5003"
		end

	is_loop_inv_violated_on_entry: BOOLEAN
			-- Is this a loop invariant failed on entry error?
		do
			Result := error_code ~ "BP5004"
		end

	is_loop_inv_not_maintained: BOOLEAN
			-- Is this a loop invariant not maintained error?
		do
			Result := error_code ~ "BP5005"
		end

	has_related_location: BOOLEAN
			-- Does this error have a related location?
		do
			Result := is_precondition_violation or is_postcondition_violation
		end

feature -- Element change

	set_line (a_line: INTEGER; a_line_text: STRING)
			-- Set `line' to `a_line' and `line_text' to `a_line_text'.
		do
			line := a_line
			line_text := a_line_text.twin
		ensure
			line_set: line = a_line
			line_text_set: line_text ~ a_line_text
		end

	set_related_line (a_line: INTEGER; a_line_text: STRING)
			-- Set `related_line' to `a_line' and `related_line_text' to `a_line_text'.
		do
			related_line := a_line
			related_line_text := a_line_text.twin
		ensure
			related_line_set: related_line = a_line
			related_line_text_set: related_line_text ~ a_line_text
		end

end
