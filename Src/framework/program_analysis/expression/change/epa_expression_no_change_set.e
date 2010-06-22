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
	make_with_original_value

feature{NONE} -- Initialization

	make_with_original_value (a_value: like original_value)
			-- Initialize `original_value' with `a_value'.
		do
			make (0)
			set_original_value (a_value)
		end

feature -- Status

	original_value: EPA_EXPRESSION_VALUE
			-- Original value

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

feature -- Setting

	set_original_value (a_value: like original_value)
			-- Set `original_value' with `a_value'.
		do
			original_value := a_value
		end

end
