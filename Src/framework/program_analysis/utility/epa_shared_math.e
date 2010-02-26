note
	description: "Summary description for {EPA_SHARED_MATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SHARED_MATH

feature -- Math operations

	factorial (k: INTEGER): INTEGER
			-- Factorial of `k'
		local
			i: INTEGER
		do
			from
				Result := 1
				i := 1
			until
				i > k
			loop
				Result := Result * i
				i := i + 1
			end
		end

	permute (a_sequence: ARRAY [detachable ANY]; k: INTEGER)
			-- Permute `a_sequence' according to k'.
		require
			k_valid: k >= 0 and k <= factorial (a_sequence.count)
		local
			i, j, t: INTEGER
			l_count: INTEGER
			l_lower: INTEGER
			l_item: detachable ANY
		do
			from
				l_count := a_sequence.count
				l_lower := a_sequence.lower
				j := 2
			until
				j > l_count
			loop
				i := k \\ j + l_lower
				t := j - 1 + l_lower
				l_item := a_sequence.item (i)
				a_sequence.put (a_sequence.item (t), i)
				a_sequence.put (l_item, t)
				j := j + 1
			end
		end

end
