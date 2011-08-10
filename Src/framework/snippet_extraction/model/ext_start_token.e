note
	description: "Summary description for {EXT_START_TOKEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_START_TOKEN

inherit
	EXT_TOKEN

feature -- Access

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := "SNIPPET_START"
		end

end
