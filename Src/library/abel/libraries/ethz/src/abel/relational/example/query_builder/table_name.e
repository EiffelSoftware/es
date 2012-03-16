note
	description: "Summary description for {TABLE_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TABLE_NAME

inherit

	QUERY_PART

create
	make_from_string

feature -- Initialization

	make_from_string (s: STRING)
			-- 	create table name as `s'.
		require
			s_not_empty: not s.is_empty
		do
			output := s
		ensure
			representation_set: output = s
		end

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
