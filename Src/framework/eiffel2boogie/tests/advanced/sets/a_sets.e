class A_SETS

feature

	good (s: MML_SET[INTEGER])
		local
			s1, s2: MML_SET[INTEGER]
		do
			check s1.is_empty end
			s1 := s & 1 & 2
			check s1.has (1) end
			s2 := s1 / 2
			check s2 <= s1 end
			check s1 >= s2 end
			check (s1 * s2).has(1) end
			check (s1 - s2).is_disjoint(s2 - s1) end
			check s1 <= s1 + s2 end
			s2 := {MML_SET[INTEGER]}.empty_set & 1
			check s2.any_item = 1 end
			check s2.count = 1 end
			create s1.singleton (1)
			check s1.count = 1 end
			check across s1 as i all i.item = 1 end end

			s1 := create {MML_SET[INTEGER]}.singleton (5)
			check s1 ~ create {MML_SET[INTEGER]}.singleton (5) end
			check not s1.is_empty end
		end

	good1 (s: MML_SET [A_SETS])
		require
			not s.is_empty
			across s as x all x.item /= Void  end
		do
			check attached {A_SETS} s.any_item end
		end

	bad (s: MML_SET[INTEGER])
		local
			s1: MML_SET[INTEGER]
			x: INTEGER
		do
			s1 := s1 & 1
			x := s.any_item
			check bad_disjoint: s.is_disjoint (s1) end
			check bad_empty: s.is_empty end
			check bad_has: s.has (1)  end
			check s1.any_item = 2 end
		end

	interval
		local
			in1: MML_INTERVAL
			s1: MML_SET [INTEGER]
		do
			create in1.from_range (1, 10)
			check in1 [5] end
			check in1.lower = 1 end
			check in1.upper = 10 end

			s1 := in1 + create {MML_INTERVAL}.from_range (21, 30)
			check s1 [5] end
			check s1 [25] end
			check not s1 [15] end

			check in1 <= in1 & 11 end
			check in1 >= in1.removed (5) end

			in1 := in1 |+| create {MML_INTERVAL}.from_range (21, 30)
			check in1.lower = 1 end
			check in1.upper = 30 end
			check in1 [15] end

			create in1.singleton (1)
			check in1 [1] end
			check in1.lower = 1 end
			check in1.upper = 1 end

			create in1
			check not in1 [1] end

		end

end
