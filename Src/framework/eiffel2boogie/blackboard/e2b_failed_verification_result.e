note
	description: "Summary description for {E2B_FAILED_VERIFICATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FAILED_VERIFICATION_RESULT

inherit

	EBB_VERIFICATION_RESULT
		redefine
			single_line_message
		end

create
	make

feature -- Access

	error: E2B_VERIFICATION_ERROR
			-- Error information

	message: STRING
			-- <Precursor>
		do
			if error.is_postcondition_violation then
				Result := "Postcondition may be violated"
			elseif error.is_precondition_violation then
				Result := "Precondition may be violated"
			elseif error.is_invariant_violation then
				Result := "Class invariant may be violated"
			elseif error.is_frame_condition_violation then
				Result := "Frame condition may be violated"
			elseif error.is_check_violation then
				Result := "Check instruction may be violated"
			elseif error.is_loop_invariant_violation then
				Result := "Loop invariant may be violated"
			elseif error.is_attached_violation then
				Result := "Target of call may not be attached"
			else
				check False end
			end
		end

feature -- Element change

	set_error (a_error: like error)
			-- Set `error' to `a_error'.
		do
			error := a_error
		ensure
			error_set: error = a_error
		end

feature

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_formatter.add (message)
			if error.tag /= Void then
				a_formatter.add (" (tag: " + error.tag + ")")
			end
		end

end
