note
	description: "Class that represents a change set, whose elements are specified by enumerating all possible values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_ENUMERATION_CHANGE_SET

inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET
		redefine
			is_enumeration
		end

create
	make

feature -- Status report

	is_enumeration: BOOLEAN = True
			-- Does Current represent an enumeration of values?

end
