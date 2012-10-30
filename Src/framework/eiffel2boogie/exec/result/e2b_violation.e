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

feature {NONE} -- Initialization

	make (a_error: E2B_VERIFICATION_ERROR)
			-- Initialize.
		do
			set_class (a_error.eiffel_class)
			set_feature (a_error.eiffel_feature)
--			set_location (a_error.eiffel_line_number, 0)
			tag := a_error.tag
		end

feature -- Access

	tag: STRING
			-- Tag associated with violation (if any).

end
