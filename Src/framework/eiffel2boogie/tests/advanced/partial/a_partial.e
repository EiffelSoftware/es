note
	explicit: "all"

class
	A_PARTIAL

feature

	field: INTEGER

	nasty (x: INTEGER): BOOLEAN
		note
			status: functional
		require
			x >= 0
		do
			Result := x \\ 5 = 0
		end

	client1
		local
			x: INTEGER
		do
			x := 5
			check nasty (x) end -- OK: nasty has a pre, it's checked here

			x := -5
			check nasty (x) end -- Bad: pre doesn't hold
		end

	client2
		local
			x: INTEGER
		do
			check assume: nasty (x) end -- OK: pre is assumed
			check x \\ 5 = 0 end -- OK: definition of nasty is applicable, because its pre is assumed
			check x >= 0 end -- OK: we get the pre for free
		end

	p1 (x: INTEGER)
		require
			nasty (x) -- OK to have partial preconditions
		do
			check x \\ 5 = 0 end -- OK: definition of nasty is applicable, because its pre is also required
			check x >= 0 end -- OK: we get the pre for free
		end

	client_p1
		local
			x: INTEGER
		do
			x := 5
			p1 (x) -- OK: definition of nasty is applicable, because we require it under the implication of its pre
		end

	p2: INTEGER
		note
			status: impure
		do
			Result := 5 -- OK: definition of nasty is applicable, because we assert it under the implication of its pre
		ensure
			nasty (Result)
		end

	client_p2
		local
			x: INTEGER
		do
			x := p2
			check x \\ 5 = 0 end -- OK: definition of nasty is applicable, because its pre is also ensured
			check x >= 0 end -- OK: we get the pre for free
		end

	client_loop
		local
			x: INTEGER
		do
			from
				x := 0
			invariant
				nasty (x)
			until
				x > 100
			loop
				x := x + 5
			end
			check x \\ 5 = 0 end
			check x >= 0 end
		end

	nasty2 (x: INTEGER): BOOLEAN
		note
			status: functional
		require
			x > 0
		do
			Result := nasty (x)
		end

	client3
		local
			x: INTEGER
		do
			x := 5
			check nasty2 (x) end -- OK: nasty has a pre, it's checked here

			x := -5
			check nasty2 (x) end -- Bad: pre doesn't hold
		end

	method
		require
			is_wrapped
		do
			unwrap
			check field \\ 5 = 0 end
			check field >= 0 end
			wrap
		ensure
			is_wrapped
		end

invariant
	bad: nasty (field)
	default_subjects: subjects = []
end
