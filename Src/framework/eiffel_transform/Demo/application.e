class
	APPLICATION
create
	make
feature {NONE} -- Initialization
	make
			-- Run application
		local
			a1: A1
			a2: A2[C2]
			c1: C1
			c2: C2
		do
			create a1
			create a2
			create c1
			create c2
		
			a1.test(1,c1)
			a1.test(-1,c1)
			a2.test(1,c2)
			a2.test(-1,c2)
			
			io.read_line
		end
end
