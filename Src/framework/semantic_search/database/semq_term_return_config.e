note
	description: "Class to specify how and where a term should be returned from a SQL query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_TERM_RETURN_CONFIG

create{SEMQ_QUERYABLE_QUERY}
	make

feature{NONE} -- Initialization

	make (a_position: INTEGER)
			-- Initialize Current with `a_position'.
		require
			a_position_positive: a_position > 0
		do
			position := a_position
		ensure
			position_set: position = a_position
		end

feature -- Access

	position: INTEGER
			-- 1-based Position of term to appear in the result table
			-- This position is the position for a term as a whole.
			-- If a term is to be returned, it may occupy more than
			-- one column of the results table.

invariant
	position_positive: position > 0
end
