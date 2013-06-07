class TEST

create
	make,
	make_self_local

feature {NONE}

	make
			-- Create objects that need to initialize their attributes.
		local
			t: TEST
		do
			create t.make_self_local
			create a
		end

feature {NONE} -- Initialization

	make_self_local
			-- Fulfil targeted conditions for `Current' before initializing all the attributes.
		local
			x: ANY
		do
			x := Current -- VEVI
			if Void ~ x then end
			make
		end

feature {NONE} -- Access

	a: ANY
			-- Storage.

end
