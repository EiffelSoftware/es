class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			if Current = out then
				c := b
			else
				f := g
			end
			if Current = out then
				x := b
			else
				x := f
				z := y
			end
		end

feature -- State

	b, c, f, g, x, y, z: ANY
		attribute
			create Result
		end

end