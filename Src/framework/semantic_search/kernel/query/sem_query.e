note
	description: "Class represents queries to search engine."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERY

feature -- Process

	process (a_visitor: SEM_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
