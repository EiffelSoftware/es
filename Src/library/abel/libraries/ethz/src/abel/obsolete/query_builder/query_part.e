note
	description: "Summary description for {QUERY_PART}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	QUERY_PART

feature -- Access



feature -- Basic operations

	output: detachable STRING
			-- String representation of `Current'.
		deferred
		end

invariant
	invariant_clause: True -- Your invariant here

end
