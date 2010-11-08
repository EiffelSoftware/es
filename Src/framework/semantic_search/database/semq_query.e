note
	description: "Semantic search query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_QUERY [G -> SEM_QUERYABLE]

feature -- Process

	process (a_visitor: SEMQ_QUERY_VISITOR [G])
			-- Process Current using `a_visitor'.
		deferred
		end

end
