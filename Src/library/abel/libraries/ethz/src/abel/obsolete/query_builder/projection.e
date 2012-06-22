note
	description: "Summary description for {PROJECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTION

inherit

	QUERY_PART

create
	make_with_attribute

feature -- Initialization

	make_with_attribute (s: STRING)
			-- Create Current with `s' as an attribute name.
		require
			s_is_attribute: True -- Fixme
		do
			output := s
		ensure
			rep_set: output = s
		end

feature -- Basic operations

	output: STRING

end
