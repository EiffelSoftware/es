note
	description: "Summary description for {GREATER_THAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GREATER_THAN

inherit

	QUERY_PART

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := " > "
		end

end
