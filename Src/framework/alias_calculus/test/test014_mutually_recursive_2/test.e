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
			if Current = Current then
				q
			else
				g := h
			end
			x := y
			z := a
			b := x
			from
			until
				Current = Current
			loop
				e := f
				if Current = Current then
					a := e
				end
			end
			if Current = Current then
				c := b
				a := f
				g := x
			else
				from
				until
					Current = Current
				loop
					c := a
					a := g
				end
				make
			end
			f := x
			b := z
			create b
			a := e
			create z
			a := h
			check a /= g then end
			create x
		end

feature {NONE} -- Access
	
	q
		do
			if Current = Current then
				m := n
			else
				m := h
				make
			end
		end

feature -- State

	a, b, c, e, f, g, h, m, n, x, y, z: ANY
		attribute
			create Result
		end

end