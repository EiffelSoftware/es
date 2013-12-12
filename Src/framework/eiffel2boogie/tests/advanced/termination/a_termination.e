class
	A_TERMINATION

feature

	fibonacci (n: INTEGER): INTEGER
		require
			n >= 0
			decreases (n, 0, -n)
		do
			if n <= 1 then
				Result := n
			else
				Result := fibonacci (n - 1) + fibonacci (n - 2)
			end
		end

	fibonacci_bad (n: INTEGER): INTEGER
		require
			decreases (n)
		do
			Result := fibonacci_bad (n - 1) + fibonacci_bad (n - 2)
		end

	fibonacci_function (n: INTEGER): INTEGER
		note
			status: functional
		require
			n >= 0
			decreases (n)
		do
			Result := if n <= 1 then n else fibonacci_function (n - 1) + fibonacci_function (n - 2) end
		end

	fibonacci_function_bad (n: INTEGER): INTEGER
		note
			status: functional
		require
			decreases (n)
		do
			Result := fibonacci_function_bad (n - 1) + fibonacci_function_bad (n - 2)
		end

	sequence_sum_bad (s: MML_SEQUENCE [INTEGER]): INTEGER
		require
			decreases (s)
		do
			if s.is_empty then
				Result := 0
			else
				Result := s [1] + sequence_sum_bad (s)
			end
		end


end
