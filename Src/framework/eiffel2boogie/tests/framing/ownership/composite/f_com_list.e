note
	description: "Subset of the interface of V_LIST needed for the example."
	explicit: "all"

class F_COM_LIST [G]

create
	make

feature {NONE} -- Initialization

	make
		note
			skip: True
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
			skip: True
			status: specification
		attribute
		end

feature -- Access

	is_empty: BOOLEAN
		note
			skip: True
		require
			modify ([])
		do
		ensure
			Result = sequence.is_empty
		end

	count: INTEGER
		note
			skip: True
		require
			modify ([])
		do
		ensure
--			Result = sequence.count
		end

	item alias "[]" (i: INTEGER): G
		note
			skip: True
		require
			1 <= i and i < count

			modify ([])
		do
		ensure
			sequence.has (Result)
--			Result = sequence [i]
		end

	has (x: G) : BOOLEAN
		note
			skip: True
		require
			modify ([])
		do
		ensure
			Result = sequence.has (x)
		end

feature -- Extension

	extend_back (v: G)
		note
			skip: True
		require
			is_wrapped
			modify (Current)
		do
		ensure
			sequence = old (sequence & v)
			is_wrapped
		end

invariant
	owns = [] -- default
	observers = [] -- default
	subjects = [] -- default
	across subjects as sc all sc.item.observers.has (Current) end -- default

end
