class
	VSTTE2008

feature -- VSTTE 2008: Adding and Multiplying Numbers

	add (a, b: INTEGER): INTEGER
			-- Add two numbers by repeated increment.
			-- Iterative version.
		require
			a_not_negative: a >= 0
			b_not_negative: b >= 0
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
			result_correct: Result = a + b
		end

	add_recursive (a, b: INTEGER): INTEGER
			-- Add two numbers by repeated increment.
			-- Recursive version.
		require
			a_not_negative: a >= 0
			b_not_negative: b >= 0
		do
			if b = 0 then
				Result := a
			else
				Result := add_recursive (a, b - 1) + 1
			end
		ensure
			result_correct: Result = a + b
		end

	multiply (a, b: INTEGER): INTEGER
			-- Multiply two numbers by repeated addition.
			-- Iterative version.
		require
			a_not_negative: a >= 0
			b_not_negative: b >= 0
		local
			i: INTEGER
		do
			if a = 0 or b = 0 then
				Result := 0
			else
				from
					Result := a
					i := b
				invariant
					Result = a * (b - i + 1)
					1 <= i and i <= b
				until
					i = 1
				loop
					Result := Result + a
					i := i - 1
				variant
					i
				end
			end
		ensure
			result_correct: Result = a * b
		end

	multiply_recursive (a, b: INTEGER): INTEGER
			-- Multiply two numbers by repeated addition.
			-- Recursive version.
		require
			a_not_negative: a >= 0
			b_not_negative: b >= 0
		do
			if a = 0 or b = 0 then
				Result := 0
			else
				if b = 1 then
					Result := a
				else
					Result := a + multiply (a, b-1)
				end
			end
		ensure
			result_correct: Result = a * b
		end

end
