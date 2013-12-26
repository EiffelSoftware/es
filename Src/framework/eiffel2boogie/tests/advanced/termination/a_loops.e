class
	A_LOOPS

feature

	loop_variant (n: INTEGER)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > n
			loop
				i := i + 1
			variant
				n - i
			end
		end

	loop_decreases (s: MML_SEQUENCE [INTEGER])
		local
			ss: like s
		do
			from
				ss := s
			invariant
				decreases ([1, ss])
			until
				ss.is_empty
			loop
				ss := ss.but_first
			variant
				1
			end
		end

--	loop_decreases_bad_type
--		local
--			x: REAL
--		do
--			from
--				x := 1.0
--			invariant
--				decreases (x)
--			until
--				x = 0.0
--			loop
--				x := x / 2
--			end
--		end

	loop_variant_bad1 (n: INTEGER)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > n
			loop
				i := i + 1
			variant
				i
			end
		end

	loop_variant_bad2 (n: INTEGER)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > n
			loop
				i := i + 1
			variant
				-i
			end
		end


	loop_decreases_bad (s: MML_SEQUENCE [INTEGER])
		local
			ss: like s
		do
			from
				ss := s
			invariant
				decreases (ss)
			until
				ss.is_empty
			loop
			end
		end

	loop_defaults (n: INTEGER; s: MML_SEQUENCE [INTEGER]; set: MML_SET [INTEGER])
		require
			n >= 0
		local
			i: INTEGER
			ss: like s
			sset: like set
		do
			from
				i := 1
			until
				i > n -- default variant: n - i
			loop
				i := i + 1
			end

			from
				i := n
			until
				i < 1 -- default variant: i - 1
			loop
				i := i - 1
			end

			from
				i := n
			invariant
				i >= 0
			until
				i = 0 -- default variant: if 0 <= i then i else -i			
			loop
				i := i - 1
			end

			from
				ss := s
			until
				ss.is_empty
			loop
				ss := ss.but_first -- default variant: if |[]| <= |ss| then |ss| - |[]| else |[]| - |ss|
			end

			from
				sset := set
			until
				sset.is_empty
			loop
				sset := sset / sset.any_item -- default variant: if [] <= sset then sset - [] else [] - sset
			end
		end

	nonterminating_bad
		do
			from
			until
				false
			loop
			end
		end

	nonterminating
		do
			from
			invariant
				decreases ([]) -- skip termination check
			until
				false
			loop
			end
		end

end
