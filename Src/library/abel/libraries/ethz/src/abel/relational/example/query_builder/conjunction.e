note
	description: "Summary description for {CONJUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONJUNCTION

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := " AND "
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
