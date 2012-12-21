class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			y := z
			if Current = out then
				c := b
				x := b
			else
				g := f
				x := f
			end
			z := f
		end

feature -- State

	b, c, f, g, x, y, z: ANY
		attribute
			create Result
		end

end