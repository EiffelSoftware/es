note
	description: "Summary description for {SELECT_CLAUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SELECT_CLAUSE

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := "SELECT "
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
