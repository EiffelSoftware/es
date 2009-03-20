indexing
	description: "Summary description for {EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPRESSION

feature

	sum: INTEGER
--		indexing
--			pure: True
		deferred
		ensure
			dummy = old dummy
			Result > 0
		end

	dummy: BOOLEAN

--	accept
--		deferred
--		end

end
