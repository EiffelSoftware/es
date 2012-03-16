note
	description: "Summary description for {SEPARATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEPARATOR

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := ","
		end

end
