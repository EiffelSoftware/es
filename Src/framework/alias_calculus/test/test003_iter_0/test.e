class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			y := c
			z := d
			-- x := y
			-- y := z
			-- z := x
		end

feature -- State

	b, c, d, x, y, z: ANY
		attribute
			create Result
		end

end