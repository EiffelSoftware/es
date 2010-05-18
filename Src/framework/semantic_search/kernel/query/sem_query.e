note
	description: "Class represents a semantic search query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERY

feature -- Access

	text: STRING
			-- String representation
			-- as used in the communication protocol
		deferred
		end

	boost: DOUBLE
			-- Boost value of current query
			-- Default: 1.0
		deferred
		end

	boost_string: STRING
			-- String representation of `boost'
		do
			Result := boost.out
		end

end
