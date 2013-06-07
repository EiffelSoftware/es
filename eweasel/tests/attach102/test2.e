class TEST

inherit
	A

create
	make,
	make_self_qualified,
	make_self_unqualified

feature {NONE}

	make
			-- Create objects that need to initialize their attributes.
		local
			t: TEST
		do
			create t.make_self_qualified
			create t.make_self_unqualified
			create a
		end

feature {NONE} -- Initialization

	make_self_unqualified
			-- Fulfil targeted conditions for `Current' before initializing all the attributes.
		do
			access (Current) -- VEVI
			make
		end

	make_self_qualified
			-- Fulfil targeted conditions for `Current' before initializing all the attributes.
		local
			t: TEST
		do
			create t.make
			t.access (Current) -- VEVI
			make
		end

feature -- Access

	access (x: ANY)
			-- Make sure `x' is targeted.
		do
			x.do_nothing
		end

feature {NONE} -- Access

	a: ANY
			-- Storage.

end
