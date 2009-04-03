indexing
	description: "Summary description for {SUBTRACTION_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUBTRACTION_STRATEGY

inherit
	OPERATOR_STRATEGY

feature

	execute (a, b: INTEGER)
		do
			last_result := a - b
		ensure then
			last_result = a - b
		end

end
