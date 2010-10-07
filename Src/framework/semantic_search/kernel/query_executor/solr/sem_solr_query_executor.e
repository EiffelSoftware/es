note
	description: "Query executor using Solr"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SOLR_QUERY_EXECUTOR

inherit
	SEM_QUERY_EXECUTOR

	REFACTORING_HELPER

feature -- Basic operations

	execute (a_query: SEM_QUERY)
			-- Executor `a_query', make result available in `last_results'.
		do
			to_implement ("Please implement me.")
		end

end
