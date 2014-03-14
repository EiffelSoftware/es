note
	description: "Test harness."
	explicit: "all"

class F_COM_CLIENT

feature -- Test

	test
			-- Using composites.
		local
			c1, c2, c3: F_COM_COMPOSITE
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)
			check c1.inv and c2.inv and c3.inv end

			c1.add_child (c2)
			check c1.inv and c2.inv end
			check c1.value >= c2.value end
			c2.add_child (c3)
			check c2.inv and c3.inv end
			check c2.value >= c3.value end
		end

	test_d
			-- Using composites.
		local
			c1, c2, c3: F_COM_COMPOSITE_D
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)
			check c1.inv and c2.inv and c3.inv end

			c1.add_child (c2)
			check c1.inv and c2.inv end
			check c1.value >= c2.value end
			c2.add_child (c3)
			check c2.inv and c3.inv end
			check c2.value >= c3.value end
		end

invariant
	default_owns: owns.is_empty
	default_subjects: subjects.is_empty
	default_observers: observers.is_empty
end
