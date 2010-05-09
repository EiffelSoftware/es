note
	description: "Console logger"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONSOLE_LOGGER

inherit
	EPA_LOGGER

feature -- Access

	put_string (a_string: STRING)
			-- Log `a_string'.
		do
			io.put_string (a_string)
		end

end
