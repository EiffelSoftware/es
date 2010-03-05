note
	description: "Objects represent the set of values that a change can bare"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_CHANGE_VALUE_SET

inherit
	EPA_HASH_SET [EPA_EXPRESSION]

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			copy
		end

create
	make

feature -- Status report

	is_valid: BOOLEAN
			-- Is Current value set valid?
		do
			Result := True
		end

	is_integer_range: BOOLEAN
			-- Does Current represent an integer range?
		do
		end

	is_unknown: BOOLEAN
			-- Does Current represent the notion of a "unknown" change?
		do
			Result := is_empty
		end

end
