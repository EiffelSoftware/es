note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VIOLATION

inherit

	E2B_FEATURE_RESULT
		rename
			data as verification_error
		redefine
			verification_error
		end

feature {NONE} -- Initialization

	make (a_error: E2B_VERIFICATION_ERROR)
			-- Initialize.
		do
			initialize (a_error.eiffel_class, a_error.eiffel_feature)
			set_class (a_error.eiffel_class)
			set_feature (a_error.eiffel_feature)
--			set_location (a_error.eiffel_line_number, 0)
			tag := a_error.tag
		end

feature -- Access

	verification_error: E2B_PROCEDURE_RESULT
			-- Verification error associated with this event.

	description: STRING_32
			-- <Precursor>
		do
			Result := "Verification of {" + context_class.name_in_upper + "}." + context_feature.feature_name_32.as_lower + " failed."
		end

feature -- Access

	tag: STRING
			-- Tag associated with violation (if any).

end
