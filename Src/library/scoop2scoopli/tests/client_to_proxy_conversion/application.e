class
	A[F,G]

inherit 
	X[F,G]
	

feature

end
class
	APPLICATION


create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			a: separate A[INTEGER,INTEGER]
			b: separate B[STRING]
			c: separate C[INTEGER]
			d: separate D[STRING]
		do
			create	a.make
			create 	b.make
			create	c.make
			create	d.make

		end

end
