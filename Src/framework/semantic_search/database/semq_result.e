note
	description: "Class that represents a result item of a semantic query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_RESULT

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create queryables.make
			create meta.make (10)
			meta.compare_objects
			create variable_mapping.make (10)
			variable_mapping.compare_objects
		end

feature -- Access

	queryables: LINKED_LIST [SEM_QUERYABLE]
			-- List of querables that matched the original query
			-- This is a list because multiple documents can
			-- match a single object-query.

	meta: HASH_TABLE [HASH_TABLE [STRING, STRING], STRING]
			-- Meta information that are returned by the query,
			-- and which cannot be put into queriables.
			-- Key of the outer hash table is the UUID of a queryable,
			-- Key of the inner table is the meta data name, value of the inner
			-- table is the value of that meta data.
			-- For example, the exception trace of a transition.
			-- Key is data name, value is data value.

	variable_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			-- Mappings from variable names to the actual variables in the returned queryables
			-- Key is names of variable in the original query, value is the variable names
			-- as written in the retrieved queryables. 		

end
