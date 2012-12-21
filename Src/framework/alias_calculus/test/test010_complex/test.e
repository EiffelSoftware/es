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
			end
			if Current = Current then
				check x /= y then end
				z := x
			end
			g := h
			x := y
			z := a
			b := x
			from
			until
				Current = Current
			loop
				e := f
				a := e
			end
			from
			until
				Current = Current
			loop
				if Current = Current then
					c := b
					a := f
					g := x
				else
					c := a
					a := g
				end
				f := x
			end
			b := z
			create b
			a := e
			create z
			a := h
			check a /= g then end
			create x
		end

feature -- State

	a, d, e, f, g, h, x, y, z: ANY
		attribute
			create Result
		end

	b, c: detachable ANY

end
