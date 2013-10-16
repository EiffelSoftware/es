class
	VSTTE2008

feature -- VSTTE 2008: Adding and Multiplying Numbers

	add (a, b: INTEGER): INTEGER
		require
			a > 0
			b > 0
		local
			i: INTEGER
		do
			from
				Result := a
				i := b
			invariant
				Result = a + (b - i)
				0 <= i and i <= b
			until
				i = 0
			loop
				Result := Result + 1
				i := i - 1
			variant
				i
			end
		ensure
			Result = a + b
		end

	multiply (a, b: INTEGER): INTEGER
		require
			a > 0
			b > 0
		do
			if b = 1 then
				Result := a
			else
				Result := add (a, multiply (a, b-1))
			end
		ensure
			Result = a * b
		end

end
