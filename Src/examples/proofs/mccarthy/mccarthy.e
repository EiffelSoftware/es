indexing
	description: "Test class for McCarthy example."
	date: "$Date$"
	revision: "$Revision$"

class
	MCCARTHY

create
	make

feature {NONE} -- Initialization

	make is
			-- Creation procedure.
		local
			l: INTEGER
		do
			l := mc_91 (10)
			check
				good: l = 91
			end
		end

feature -- Basic operations

	mc_91 (n: INTEGER): INTEGER is
		do
			if n > 100 then
				Result := n - 10
			else
				Result := mc_91 (mc_91 (n + 11))
			end
		ensure
			result_91: n <= 100 implies Result = 91
			big_n: n > 100 implies Result = n - 10
		end

end
