note
	description: "Summary description for {E2B_FAILED_VERIFICATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INCONCLUSIVE_RESULT

inherit

	E2B_VERIFICATION_RESULT

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_formatter.add (messages.inconclusive_result)
		end

end
