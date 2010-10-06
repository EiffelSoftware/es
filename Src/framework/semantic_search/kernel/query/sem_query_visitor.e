note
	description: "Visitor for {SEM_QUERY}s"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERY_VISITOR

feature -- Process

	process_boolean_query (a_query: SEM_BOOLEAN_QUERY)
			-- Process `a_query'.
		deferred
		end

end
