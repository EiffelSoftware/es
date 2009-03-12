indexing
	description: "Summary description for {INHERITANCE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INHERITANCE_TEST

create
	make

feature

	make
		local
			c: CONSTANT
			e: EXPRESSION
			p: PLUS
		do
			create c.make (7)
			create p.make (2, 3)

			e := c
			check
				e.sum = 7
			end

			e := p
			check
				e.sum = 5
			end
		end

end
