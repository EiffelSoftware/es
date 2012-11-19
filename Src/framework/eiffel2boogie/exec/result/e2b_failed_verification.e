note
	description: "Summary description for {E2B_FAILED_VERIFICATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FAILED_VERIFICATION

inherit

	E2B_PROCEDURE_RESULT

create
	make

feature {NONE} -- Initialization

	make (a_procedure_name: STRING)
			-- Initialize.
		do
			set_procedure_name (a_procedure_name)
			create errors.make
		end

feature -- Access

	errors: LINKED_LIST [E2B_VERIFICATION_ERROR]
			-- List of verification errors.

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			errors.first.single_line_message (a_formatter)
			if errors.count > 1 then
				a_formatter.add_space
				if errors.count = 2 then
					a_formatter.add ("(+1 more error)")
				else
					a_formatter.add ("(+" + (errors.count-1).out + " more errors)")
				end
			end
		end

end
