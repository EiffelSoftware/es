note
	description: "Shared query context"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SHARED_QUERY_CONTEXT

feature -- Access

	value_pool: SEM_VALUE_POOL
			-- Pool of values
		once
			create Result.make (100)
		end

end
