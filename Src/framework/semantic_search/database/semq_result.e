note
	description: "Class that represents a result item of a semantic query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_RESULT [G -> SEM_QUERYABLE]

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create queryables.make
			create meta.make (10)
			meta.compare_objects
		end

feature -- Access

	queryables: LINKED_LIST [G]
			-- List of querables that matched the original query
			-- This is a list because multiple documents can
			-- match a single object-query.

	meta: HASH_TABLE [STRING, STRING]
			-- Meta information that are returned by the query,
			-- and which cannot be put into queriables.
			-- For example, the exception trace of a transition.
			-- Key is data name, value is data value.

end
