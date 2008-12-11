indexing
	description: "Summary description for {CHILD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHILD

inherit
	PARENT
		redefine
			f
		end

feature

	f (a: INTEGER)
		require else
			a > 0
		do

		end

end
