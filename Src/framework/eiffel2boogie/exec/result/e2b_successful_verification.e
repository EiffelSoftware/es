note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SUCCESSFUL_VERIFICATION

inherit

	E2B_PROCEDURE_RESULT

create
	set_procedure_name

feature -- Access

	original_errors: detachable LINKED_LIST [E2B_VERIFICATION_ERROR]
			-- Original errors (if any)

	suggestion: STRING
			-- Suggestion for user.

feature {E2B_MERGE_RESULTS_TASK} -- Element change

	add_original_error (a_error: E2B_VERIFICATION_ERROR)
			-- Add `a_error' to `original_errors'.
		do
			if not attached original_errors then
				create original_errors.make
			end
			original_errors.extend (a_error)
			if attached {E2B_PRECONDITION_VIOLATION} a_error then
				set_suggestion ("You might need to weaken the precondition.")
			elseif attached {E2B_CHECK_VIOLATION} a_error or attached {E2B_POSTCONDITION_VIOLATION} a_error then
				set_suggestion ("You might need to strenghten the loop invariant of postcondition of called features.")
			end
		end

	set_suggestion (a_string: STRING)
			-- Set `suggestion' to `a_string'.
		do
			suggestion := a_string.twin
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if attached original_errors and then not original_errors.is_empty then
				a_formatter.add ("Verification successful after inlining.")
				a_formatter.add_space
				if original_errors.count = 1 then
					a_formatter.add ("(see original error)")
				else
					a_formatter.add ("(see original errors)")
				end
			else
				a_formatter.add ("Verification successful.")
			end
		end

end
