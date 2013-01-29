note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_PRECONDITION_VIOLATION

inherit

	E2B_VERIFICATION_ERROR
		redefine
			multi_line_message
		end

create
	make

feature -- Access

	called_feature: FEATURE_I
			-- Called feature that triggered precondition violation.

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

feature -- Element change

	set_called_feature (a_feature: FEATURE_I)
			-- Set `called_feature' to `a_feature'.
		do
			called_feature := a_feature
		ensure
			called_feature_set: called_feature = a_feature
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if is_attached_check then
				if attached tag then
					a_formatter.add ("Possible Void call in precondition ")
					a_formatter.add_manifest_string (tag)
				else
					a_formatter.add ("Possible Void call in precondition (unnamed assertion)")
				end
			elseif is_overflow_check then
				if attached tag then
					a_formatter.add ("Possible overflow in precondition ")
					a_formatter.add_manifest_string (tag)
				else
					a_formatter.add ("Possible overflow in precondition (unnamed assertion)")
				end
			else
				if attached tag then
					a_formatter.add ("Precondition ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" may fail")
				else
					a_formatter.add ("Precondition may fail (unnamed assertion)")
				end
			end
			if attached called_feature then
				a_formatter.add (" on call to ")
				a_formatter.add_feature (called_feature.e_feature, called_feature.feature_name_32)
			end
			a_formatter.add (".")
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			single_line_message (a_formatter)
			a_formatter.add_new_line
			a_formatter.add_new_line

			a_formatter.add ("Location: ")
--			a_formatter.add (eiffel_class.file_name)
			a_formatter.add_class (eiffel_class.original_class)
			a_formatter.add (".")
			a_formatter.add_feature (eiffel_feature.e_feature, eiffel_feature.feature_name_32)
			a_formatter.add (":")
			a_formatter.add_int (eiffel_line_number)
			a_formatter.add_new_line
			if attached called_feature then
				a_formatter.add ("Feature called: ")
				a_formatter.add_class (called_feature.written_class.original_class)
				a_formatter.add (".")
				a_formatter.add_feature (called_feature.e_feature, called_feature.feature_name_32)
				a_formatter.add_new_line
			end
			a_formatter.add ("Tag: ")
			if attached tag then
				a_formatter.add_manifest_string (tag)
			else
				a_formatter.add ("unnamed assertion")
			end
		end

end
