note
	description: "Instruction iterating a certain compound a set number of times."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITER

inherit
	REPETITION

create
	make

feature -- Initialization
	make (c: INTEGER)
			-- Use `c' as count.
		require
			count_non_negative: c >= 0
		do
			count := c
		end

feature -- Access

	count: INTEGER
			-- Number of iterations of `body'.


feature -- Input and output
	out: STRING
			-- Printable representation of iteration.
		do
			Result :=
					tabs + "iterate (" + count.out + ")" + New_line +
					body.out +
					tabs + "end"+ New_line
		end

		feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by iteration.
		local
			i: INTEGER
			itertext: STRING
		do
					-- FIXME  The "from" form is actually clearer in this example.
			across 1 |..| count as ic loop
				debug ("ITERATE") a.printout ("before iterations") end
				i := ic.cursor_index
				iterate_silent (a, i)
			 	debug itertext := " iterations"; if i = 1 then itertext := " iteration" end end
			 	debug ("ITERATE") a.printout ("not cumulated, after " + i.out + itertext) end
			end
			debug ("ITERATE") a.printout ("for repetition construct, not cumulated, after " + count.out + itertext) end
		end


end
