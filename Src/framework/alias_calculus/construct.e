note
	description: "Displayable (but not necessarily executable) language unit."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONSTRUCT

inherit
	ANY
		undefine out
		redefine out end

feature -- Status report

	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
		deferred
		end

feature -- Access

	outer: detachable CONSTRUCT assign set_outer
			-- Enclosing block.

	level: INTEGER
			-- Level of indentation.
		do
			if attached outer as o then
				Result := o.level
				if o.is_indenting then
					Result := Result + 1
				end
			end
		ensure
			non_negative: Result >= 0
			non_decreasing: attached outer as o implies (Result >= o.level)
			like_outer_or_just_above: attached outer as o implies ((Result = o.level) or (Result = o.level + 1))
			zero_at_outermost: (outer = Void) implies (Result = 0)
		end

feature -- Input and output

	display
			-- Produce printable representation of construct specimen,
			-- indented at `level', followed by return to next line.
		do
			print (out)
		end

	out: STRING
			-- Printable representation of construct specimen,
			-- indented at `level', followed by return to next line.
		deferred
		end

feature {CONSTRUCT, APPLICATION} -- Implementation

	set_outer (c: like outer)
			-- Make `c' the outer block of current construct specimen.
		require
			exists: c /= Void
		do
			outer := c
		ensure
			outer = c
		end

feature {NONE} -- Implementation

	tabs: STRING
			-- Print out tabs at appropriate level of indentation.
		do
			create Result.make_empty
			across 1 |..| level as ic loop
				Result := Result + Tab
			end
		end

	Tab: STRING = "    "
			-- Tab character, or simulation.

	New_line: STRING = "%N"
			-- New_line.

invariant
	non_negative_level: level >= 0

end
