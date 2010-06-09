note
	description: "A set representing no change"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_NO_CHANGE_SET

inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET
		redefine
			is_unknown,
			is_no_change,
			is_valid
		end

create
	make

feature -- Status report

	is_valid: BOOLEAN
			-- Is Current value set valid?
		do
			Result := is_empty
		end

	is_unknown: BOOLEAN = False
			-- Does Current represent the notion of a "unknown" change?

	is_no_change: BOOLEAN = True
			-- Does Current represent a change set that contains no change?

end
