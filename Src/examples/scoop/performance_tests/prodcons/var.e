note
	description: "Summary description for {VAR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VAR

feature
	i: INTEGER

	update_var
		do
			i := i + 1 -- fib (30)
		end

	fib (x:INTEGER): INTEGER
		do
			if x < 2 then
				Result := 1
			else
				Result := fib (x - 1) + fib (x-2)
			end
		end
end
