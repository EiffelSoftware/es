class TEST

create
	make,
	make_self

feature {NONE}

	make
			-- Create expanded objects that need to initialize their attributes.
		local
			t: TEST
		do
			create t.make_self
			create a
		end

feature {NONE} -- Initialization

	make_self
			-- Fulfil targeted conditions for `Current' before initializing all the attributes.
		do
			if Current ~ Void then end -- VEVI
			make
		end

feature {NONE} -- Access

	a: ANY
			-- Storage.

end
