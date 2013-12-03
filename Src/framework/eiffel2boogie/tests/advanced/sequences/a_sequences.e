class A_SEQUENCES

feature

	good (s: MML_SEQUENCE[INTEGER])
		local
			s1, s2: MML_SEQUENCE[INTEGER]
		do
			check s1.is_empty end
			s1 := s & 1 & 2
			check s1.has (1) end
			check s1.item (s.count + 1) = 1 end
			check s1.item (s.count + 2) = 2 end
		end

	seq_to_set (arg: MML_SEQUENCE[INTEGER])
		require
			arg.count >= 3
			arg.has (0)
		local
			set: MML_SET [INTEGER]
			seq: MML_SEQUENCE [INTEGER]
		do
			seq := arg & 1 & 2

			set := seq.range

			check seq.count >= 5 end
			check set.has (0) end
			check set.has (1) end
			check set.has (2) end

			set := set & 3
			seq := seq & 3

			check set = seq end
		end

end
