note
	description: "Closed integer intervals."
	author: "Nadia Polikarpova"
	theory: "set.bpl"
	maps_to: "Interval"
	where: "Interval#IsValid"	

class
	MML_INTERVAL

inherit
	MML_SET [INTEGER]

create
	default_create,
	singleton,
	from_range

feature {NONE} -- Initialization

	from_range (l, u: INTEGER)
			-- Create interval [l, u].
		do
		end

feature -- Access

	lower: INTEGER
			-- Lower bound.
		require
			not_empty: not is_empty
		do
		end

	upper: INTEGER
			-- Upper bound.
		require
			not_empty: not is_empty
		do
		end

feature -- Modification

	interval_union alias "|+|" (other: MML_INTERVAL): MML_INTERVAL
			-- Minimal interval that includes this interval and `other'.
		note
			maps_to: "Interval#Union"
		do
		end
end
