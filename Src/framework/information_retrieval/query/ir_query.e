note
	description: "Class represents queries to the information retrieval system"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IR_QUERY

feature -- Process

	process (a_visitor: IR_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
