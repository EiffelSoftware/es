note
	description: "Visitor for {IR_QUERY}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IR_QUERY_VISITOR

feature -- Process

	process_boolean_query (a_query: IR_BOOLEAN_QUERY)
			-- Process `a_query'.
		deferred
		end

end
