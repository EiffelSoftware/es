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
		do
			s1 := s1 & 1;
			check bad_disjoint: s.is_disjoint (s1) end
			check bad_empty: s.is_empty end
			check bad_has: s.has (1)  end
			check s1.any_item = 2 end
		end

end
