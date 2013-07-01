class SETS

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
		end
		
	bad (s: MML_SET[INTEGER])
		local
			s1: MML_SET[INTEGER]
		do
			s1 := s1 & 1;
			check bad_disjoint: s.is_disjoint (s1) end
			check bad_empty: s.is_empty end
			check bad_has: s.has (1)  end
		end

end
