note
	description: "Semantic query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERY_EXECUTOR

feature -- Access

	last_results: detachable SEM_QUERY_RESULT
			-- Results returned by last `execute'.

feature -- Basic operations

	execute (a_query: SEM_QUERY)
			-- Executor `a_query', make result available in `last_results'.
		deferred
		end

end
