note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CHECK_VIOLATION

inherit

	E2B_VERIFICATION_ERROR

create
	make

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if attached tag then
				a_formatter.add ("Check of tag ")
				a_formatter.add_comment_text (tag)
				a_formatter.add (" may fail.")
			else
				a_formatter.add ("Check instruction may fail (unnamed assertion).")
			end
		end

end
