note
	description: "Summary description for {ASSERTIONS_A}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ASSERTIONS_A

feature

	foo (x: INTEGER): INTEGER
		require
			g: x > 0
		deferred
		ensure
			post: Result >= 1
		end

end

