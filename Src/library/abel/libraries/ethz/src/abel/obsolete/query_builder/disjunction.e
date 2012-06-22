note
	description: "Summary description for {DISJUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DISJUNCTION

inherit

	QUERY_PART

feature -- Access

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			Result := " OR "
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
