note
	description: "Console logger"
	author: "Jason Yi Wei"
	date: "$Date$"
	revision: "$Revision$"

class
	ELOG_CONSOLE_LOGGER

inherit
	ELOG_LOGGER

feature -- Access

	put_string (a_string: STRING)
			-- Log `a_string'.		
		do
			print (a_string)
		end
end
