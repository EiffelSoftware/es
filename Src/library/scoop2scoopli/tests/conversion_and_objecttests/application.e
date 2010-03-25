class
	APPLICATION


create
	make

feature {NONE} -- Initialization

	make
			--Used to test conversion and object tests
		local
			c: C[STRING]
			sp_a: separate A[INTEGER]
		do

			create c.make
			sp_a := c

			if sp_a /= Void and then {l1: separate B[STRING]} sp_a then
				io.put_string ("first object test: ok")
			end
			io.put_new_line
			if {l2: separate C[STRING]} sp_a then
				io.put_string ("second object test: ok")
			end

		end

end
