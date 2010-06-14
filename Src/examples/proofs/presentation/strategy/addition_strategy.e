indexing
	description: "Summary description for {ADDITION_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADDITION_STRATEGY

inherit
	OPERATOR_STRATEGY

feature

	execute (a, b: INTEGER)
		do
			last_result := a + b
		ensure then
			last_result = a + b
		end

end
