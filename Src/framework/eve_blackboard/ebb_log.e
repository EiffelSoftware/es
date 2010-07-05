note
	description: "Summary description for {EBB_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_LOG

feature -- Basic operations

	put_line (a_line: STRING)
			-- Put `a_line' into log.
		do
			io.put_string (a_line)
			io.put_new_line
		end

end
