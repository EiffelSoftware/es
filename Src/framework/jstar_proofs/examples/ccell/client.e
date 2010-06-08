note
	description: "Summary description for {CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "client.logic"
	js_abstraction: "client.abs"

class
	CLIENT

feature

	code (l: LIBRARY): CCELL
		require
			--SL-- True
		do
			create Result.init (5)
			l.use_counter (Result)
		ensure
			--SL-- Cc(Result,{val:5;cnt:10})
		end

end
