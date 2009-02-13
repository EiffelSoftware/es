indexing
	description: "Summary description for {IF_CLIENT}."
	date: "$Date$"
	revision: "$Revision$"

class
	IF_CLIENT

create
	make

feature

	make
		local
			p: IF_PARENT
			c: IF_CHILD
		do
			create p.make
			create c.make

			check
				p.field1 = 1
				p.field2 = 2
				c.field1 = 1
				c.field2 = 2
			end

			p.foo (4)

			check
				p.field1 = 4
				p.field2 = 2
				c.field1 = 1
				c.field2 = 2
			end

			p := c

			check
				p.field1 = 1
				p.field2 = 2
			end

			p.foo (4)

			check
				p.field1 = 4
				wrong: p.field2 = 2		-- p.field2 is actually 5
			end

		end

end
