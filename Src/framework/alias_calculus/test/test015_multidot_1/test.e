class TEST

create
	default_create,
	make

feature {NONE} -- Creation

	make
		do
			x := y
			a := b
			z := x.a
			x := x.a
			x := x
			y := y
		end

feature -- State

	a, b, x, y, z: TEST
		attribute
			create Result
		end

end
