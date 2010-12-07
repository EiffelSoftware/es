note
	description: "Query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERY_EXECUTOR

inherit
	SEMQ_QUERY_VISITOR

	REFACTORING_HELPER

feature -- Access

	last_results: detachable LINKED_LIST [SEMQ_RESULT]
			-- Last results retrieved by `execute'
			-- The order of the elements is meaningful of one of the
			-- query term has ordering configuration specified.

feature -- Basic operations

	execute (a_query: SEMQ_QUERY)
			-- Execute `a_query', and make result available in `last_results'.
		do
			create last_results.make
			a_query.process (Current)
		end

feature{NONE} -- Process

	process_queryable_query (a_query: SEMQ_QUERYABLE_QUERY)
			-- Process `a_query'.
		do
			to_implement ("Introduce a separate class to handle this type of query. 8.11.2010 Jasonw")
		end

	process_whole_document_query (a_query: SEMQ_WHOLE_DOCUMENT_QUERY)
			-- Process `a_query'.
		do
			to_implement ("Introduce a separate class to handle this type of query. 8.11.2010 Jasonw")
		end

end
