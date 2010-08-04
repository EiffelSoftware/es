class
	APPLICATION


create
	make

feature {NONE} -- Initialization

	make
			-- Used to test client to proxy conversion in a non trivial setup
		local
			a: separate A[INTEGER,INTEGER]
			b: separate B[STRING]
			c: separate C[INTEGER]
			d: separate D[STRING]
		do
			create	a
			create 	b.make
			create	c.make
			create	d.make

		end

end
