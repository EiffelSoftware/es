note
	description: "Summary description for {ASSERTIONS_B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASSERTIONS_B
inherit
	ASSERTIONS_A

feature

	foo (x: INTEGER): INTEGER
		require else
			ge: x = 0
		do
			Result := x + 2
		ensure then
			thenpost:  Result = x + 2
		end

end
