note
  description: "Subset of the interface of V_LIST needed for the example."

class F_OOM_LIST [G]

feature -- Specification

	sequence: MML_SEQUENCE [G]
		note
			status: specification
		attribute
		end

feature -- Access      

	is_empty: BOOLEAN
		do
		ensure
			Result = sequence.is_empty
		end

	count: INTEGER
		do
		ensure
			Result = sequence.count
		end

	item (i: INTEGER): G
		require
			1 <= i and i < count
		do
		ensure
			Result = sequence [i]
		end

	has (x: G) : BOOLEAN
		do
		ensure
			Result = sequence.has (x)
		end

feature -- Extension

	extend_back (v: G)
		do
		ensure
--			sequence |=| old (sequence & v)
		end

end
