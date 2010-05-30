note
	description: "Logger to record messages"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_LOGGER

feature -- Access

	put_string (a_string: STRING)
			-- Log `a_string'.
		deferred
		end

end
