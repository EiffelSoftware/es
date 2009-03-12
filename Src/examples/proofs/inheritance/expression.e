indexing
	description: "Summary description for {EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPRESSION

feature

	sum: INTEGER
		indexing
			pure: True
		deferred
		end

end
