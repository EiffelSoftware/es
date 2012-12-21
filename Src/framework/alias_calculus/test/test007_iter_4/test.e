class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			y := c
			z := d
				-- 1
			x := y
			y := z
			z := x
				-- 2
			x := y
			y := z
			z := x
				-- 3
			x := y
			y := z
			z := x
				-- 4
			x := y
			y := z
			z := x
		end

feature -- State

	b, c, d, x, y, z: ANY
		attribute
			create Result
		end

end