class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			if Current = Current then
				x := y
			else
				x := a
				q
			end
		end

feature {NONE} -- Access
	
	q
		do
			x := b
			if Current = Current then
				make
			else
				a := c
			end
		end

feature -- State

	a, b, c, x, y: ANY
		attribute
			create Result
		end

end