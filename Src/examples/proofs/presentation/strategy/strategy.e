indexing
	description: "Summary description for {STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATOR_STRATEGY

feature

	execute (a, b: INTEGER)
		deferred
		ensure
			last_result = last_result -- modifies
		end

	last_result: INTEGER

end
