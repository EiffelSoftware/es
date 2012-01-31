note
	description: "Summary description for {CURRENT_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CURRENT_EXPRESSION

inherit
	SIMPLE_EXPRESSION

feature
	name: STRING
			-- Name of expression, here "Current".
		do
			Result := "Current"
		end

feature -- Access

	dot_count: INTEGER
			-- Number of dots (here 1).
		do
			Result := 1
		end


	prepended (x: VARIABLE): MULTIDOT
			-- `x.Current': yields x.
		do
			Result := x.as_multidot
		end

end
