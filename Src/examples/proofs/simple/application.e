indexing
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
--			a: ARRAY [ANY]
--			b, c: ANY
		do
--			create a.make (1, 2)
--			create b
--			create c

--			a.put (b, 1)
--			a.put (c, 2)

--			check
--				a.lower = 1
--				a.upper = 2
--			end
		end

	fibonacci (n: INTEGER): INTEGER
			-- n-th Fibonacci number
		indexing
			pure: True
		require
			n >= 0
		do
			if n <= 1 then
				Result := 1
			else
				Result := fibonacci (n - 1) + fibonacci (n - 2)
			end
		ensure
			n <= 1 implies Result = 1
			n > 1 implies Result = fibonacci (n - 1) + fibonacci (n - 2)
		end

end
