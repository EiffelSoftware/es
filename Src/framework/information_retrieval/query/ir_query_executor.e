note
	description: "Class to execute a query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IR_QUERY_EXECUTOR

feature -- Access

	last_result: detachable IR_QUERY_RESULT
			-- Result of the last executed query

feature -- Basic operations

	execute (a_query: IR_QUERY)
			-- Execute `a_query', make result available in `last_result'.
		deferred
		end

end
