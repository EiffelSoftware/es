note
	description: "Summary description for {EXT_END_TOKEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_END_TOKEN

inherit
	EXT_TOKEN

feature -- Access

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := "SNIPPET_END"
		end

end
