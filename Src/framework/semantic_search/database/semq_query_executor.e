note
	description: "Query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERY_EXECUTOR [G -> SEM_QUERYABLE]

inherit
	SEMQ_QUERY_VISITOR [G]

	REFACTORING_HELPER

feature -- Access

	last_results: detachable SEMQ_RESULT [G]
			-- Last results retrieved by `execute'

feature -- Basic operations

	execute (a_query: SEMQ_QUERY [G])
			-- Execute `a_query', and make result available in `last_results'.
		do
			last_results := Void
			a_query.process (Current)
		end

feature{NONE} -- Process

	process_queryable_query (a_query: SEMQ_QUERYABLE_QUERY [G])
			-- Process `a_query'.
		do
			to_implement ("Introduce a separate class to handle this type of query. 8.11.2010 Jasonw")
		end

	process_whole_document_query (a_query: SEMQ_WHOLE_DOCUMENT_QUERY [G])
			-- Process `a_query'.
		do
			to_implement ("Introduce a separate class to handle this type of query. 8.11.2010 Jasonw")
		end

end
