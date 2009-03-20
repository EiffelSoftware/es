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

	foo (a: !EXPRESSION)
		local
			i: INTEGER
		do
			i := a.sum
			check
				i > 0
			end
		end

	make
		local
			c: CONSTANT
			e: EXPRESSION
			p: PLUS
		do
			create c.make (7)
			create p.make (2, 3)

--			create p.make (create {CONSTANT}.make (4), create {CONSTANT}.make (5))

			e := c
			check
				constant: e.sum = 7
			end

			e := p
			check
				plus: e.sum = 5
			end
		end

	stack_test
		local
			stack: EXP_STACK
			e1, e2, e3: EXPRESSION
			e4: EXPRESSION
		do
			create {CONSTANT}e1.make (4)
			create {PLUS}e2.make (1, 2)
			create {CONSTANT}e3.make (6)

			create stack
			stack.put (e1, 1)
			stack.put (e2, 2)
			stack.put (e3, 3)

			check
				e1: stack.item1.sum = 4
				e2: stack.item2.sum = 3
				e3: stack.item3.sum = 6
			end

			e4 := stack.item1

			check
				e4.sum = 4
			end

		end

end
