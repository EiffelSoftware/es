note
	description: "A sample use of the visitor pattern."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "client.logic"
	js_abstraction: "client.abs"

class
	CLIENT

feature -- Miscellaneous

	visitor_fun: INTEGER
		require
			--SL-- True
		local
			c1, c2, c3, c4: CONST_NODE
			p1, p2, p3: PLUS_NODE
			sv: SUM_VISITOR
		do
			create c1.init (30)
			create c2.init (40)
			create p1.init (c1, c2)

			create c3.init (50)
			create c4.init (60)
			create p2.init (c3, c4)

			create p3.init (p1, p2)

			create sv.init
			p3.accept (sv)
			Result := sv.sum
		ensure
			--SL-- Result = 180
		end

end
