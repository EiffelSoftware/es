note
	description: "Subset of the interface of V_LIST needed for the example."
	explicit: "all"

class F_OOM_LIST [G]

create
	make

feature {NONE} -- Initialization

	make
		require
			is_open -- default: creator
			modify (Current) -- default: creator
		do
		ensure
			is_wrapped -- default: creator
			is_empty
		end

feature -- Specification

	sequence: MML_SET [G]
		note
			status: specification
		attribute
		end

feature -- Access

	is_empty: BOOLEAN
		require
			modify ([])
		do
		ensure
			Result = sequence.is_empty
		end

	count: INTEGER
		require
			modify ([])
		do
		ensure
--			Result = sequence.count
		end

	item alias "[]" (i: INTEGER): G
		require
			1 <= i and i < count

			modify ([])
		do
		ensure
--			Result = sequence [i]
		end

	has (x: G) : BOOLEAN
		require
			modify ([])
		do
		ensure
			Result = sequence.has (x)
		end

feature -- Extension

	extend_back (v: G)
		require
			is_wrapped
			modify (Current)
		do
		ensure
			sequence = old (sequence & v)
			is_wrapped
		end

end
