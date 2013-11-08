note
	explicit: "all"

class F_OOO_CLIENT

feature

	test
		local
			s: F_OOO_SUBJECT
			o: F_OOO_OBSERVER
		do
			create s
			create o.make (s)
			s.update (5)
			check o.cache = 5 end
		end

	test_d
		local
			s: F_OOO_SUBJECT_D
			o: F_OOO_OBSERVER_D
		do
			create s
			create o.make (s)
			s.update (5)
			check o.cache = 5 end
		end

end
