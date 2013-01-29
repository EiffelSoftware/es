note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_POSTCONDITION_VIOLATION

inherit
	E2B_VERIFICATION_ERROR
		redefine
			multi_line_message
		end

create
	make

feature -- Status report

	is_attached_check: BOOLEAN
			-- Is this violation an attachment check?

	is_overflow_check: BOOLEAN
			-- Is this violation an arithmetic overflow?

feature -- Status setting

	set_is_attached_check
			-- Set `is_attached_check'.
		do
			is_attached_check := True
		ensure
			is_attached_check: is_attached_check
		end

	set_is_overflow_check
			-- Set `is_overflow_check'.
		do
			is_overflow_check := True
		ensure
			is_overflow_check: is_overflow_check
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if is_attached_check then
				if attached tag then
					a_formatter.add ("Possible Void call in postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (".")
				else
					a_formatter.add ("Possible Void call in postcondition (unnamed assertion).")
				end
			elseif is_overflow_check then
				if attached tag then
					a_formatter.add ("Possible overflow in postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (".")
				else
					a_formatter.add ("Possible overflow in postcondition (unnamed assertion).")
				end
			else
				if attached tag then
					a_formatter.add ("Postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" may fail.")
				else
					a_formatter.add ("Postcondition may fail (unnamed assertion).")
				end
			end
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if is_attached_check then
				if attached tag then
					a_formatter.add ("Possible Void call in postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (".")
				else
					a_formatter.add ("Possible Void call in postcondition (unnamed assertion).")
				end
			elseif is_overflow_check then
				if attached tag then
					a_formatter.add ("Possible overflow in postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (".")
				else
					a_formatter.add ("Possible overflow in postcondition (unnamed assertion).")
				end
			else
				if attached tag then
					a_formatter.add ("Postcondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" may fail.")
				else
					a_formatter.add ("Postcondition may fail (unnamed assertion).")
				end
			end
		end

end
