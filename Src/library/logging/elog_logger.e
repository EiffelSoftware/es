note
	description: "Message logger."
	author: "Yi Wei"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ELOG_LOGGER

feature -- Basic Operations

	put_string (a_string: STRING)
			-- Log `a_string'.
		deferred
		end
end
