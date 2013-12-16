note
	description: "Test harness."
	explicit: "all"

class F_PIP_CLIENT

feature -- Test

	test
			-- Using composites.
		local
			c1, c2, c3: F_PIP_NODE
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)

			c1.acquire (c2)
			check c1.value = 2 end

			c2.acquire (c3)
			check c1.value = 2 end
			check c2.value = 2 end
			check c3.value = 0 end

			-- Todo: this assume is here because we do not have an exact definition of descendants yet:
			check assume: c1.descendants = {MML_SET [F_PIP_NODE]}.empty_set & c3 & c2 & c1 end
			c3.acquire (c1)
			check c1.value = c2.value end
			check c2.value = c3.value end
			check c3.value = 2 end
		end

	test_d
			-- Using composites.
		local
			c1, c2, c3: F_PIP_NODE_D
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)

			c1.acquire (c2)
			check c1.value = 2 end

			c2.acquire (c3)
			check c1.value = 2 end
			check c2.value = 2 end
			check c3.value = 0 end

			-- Todo: this assume is here because we do not have an exact definition of descendants yet:
			check assume: c1.descendants = {MML_SET [F_PIP_NODE_D]}.empty_set & c3 & c2 & c1 end
			c3.acquire (c1)
			check c1.value = c2.value end
			check c2.value = c3.value end
			check c3.value = 2 end
		end

invariant
	default_owns: owns.is_empty
	default_subjects: subjects.is_empty
	default_observers: observers.is_empty
end
