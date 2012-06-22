note
	description: "Summary description for {FROM_CLAUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FROM_CLAUSE

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := " FROM "
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
