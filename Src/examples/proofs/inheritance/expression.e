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
		ensure
--			dummy = old dummy
--			Result > 0
		end

--	dummy: BOOLEAN

	accept
		deferred
		ensure
			top = top	-- modifies top
		end

	top: INTEGER

	set_top (a_value: INTEGER)
		do
			top := a_value
		ensure
			top = a_value
		end

	visit (a: !EXP_VISITOR)
		deferred
		ensure
			a.sum = a.sum
		end

end
