note
	description: "Summary description for {WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER

feature
	run
		do
			fib (40).do_nothing
		end

	fib (n: INTEGER): INTEGER
		do
			if n < 2 then
				Result := 1
			else
				Result := fib (n-1) + fib (n-2)
			end
		end

end
