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
			check o.inv and s.inv end
			s.update (5)
			check o.inv end
			check o.cache = 5 end
		end

	test_d
		local
			s: F_OOO_SUBJECT_D
			o: F_OOO_OBSERVER_D
		do
			create s
			create o.make (s)
			check o.inv and s.inv end
			s.update (5)
			check o.inv end
			check o.inv end
			check o.cache = 5 end
		end

invariant
	default_owns: owns.is_empty
	default_subjects: subjects.is_empty
	default_observers: observers.is_empty

end
