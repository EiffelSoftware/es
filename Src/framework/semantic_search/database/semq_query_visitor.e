note
	description: "Visitor for {SEMQ_QUERY}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_QUERY_VISITOR [G -> SEM_QUERYABLE]

feature -- Process

	process_queryable_query (a_query: SEMQ_QUERYABLE_QUERY [G])
			-- Process `a_query'.
		deferred
		end

	process_whole_document_query (a_query: SEMQ_WHOLE_DOCUMENT_QUERY [G])
			-- Process `a_query'.
		deferred
		end

end
