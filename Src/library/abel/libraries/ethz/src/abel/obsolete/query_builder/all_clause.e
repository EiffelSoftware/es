note
	description: "Summary description for {ALL_CLAUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ALL_CLAUSE

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := "* "
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
