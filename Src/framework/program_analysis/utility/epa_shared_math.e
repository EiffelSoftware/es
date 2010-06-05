note
	description: "Summary description for {EPA_SHARED_MATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SHARED_MATH

feature -- Math operations

	factorial (k: INTEGER): INTEGER
			-- Factorial of `k'
		local
			i: INTEGER
		do
			from
				Result := 1
				i := 1
			until
				i > k
			loop
				Result := Result * i
				i := i + 1
			end
		end

	integer_interval (a_min, a_max: INTEGER): INTEGER_INTERVAL
			-- Integer interval [`a_min', `a_max']
		do
			create Result.make (a_min, a_max)
		end

end
