note
	description: "Summary description for {TERMINATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TERMINATOR

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := ";%N"
		end

feature {NONE} -- Implementation

end
