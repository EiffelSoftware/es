indexing
	description: "Summary description for {INHERITANCE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INHERITANCE_TEST

feature

----	foo (a: !EXPRESSION)
----		local
----			i: INTEGER
----		do
----			i := a.sum
----			check
----				i > 0
----			end
----		end

--	make
--		local
--			c: CONSTANT
--			e: EXPRESSION
--			p: PLUS
--		do
--			create c.make (7)
----			create p.make (2, 3)

--			create p.make (create {CONSTANT}.make (2), create {CONSTANT}.make (3))

--			check
--				p.left.sum = 2
--				p.right.sum = 3
--			end


--			e := c
--			check
--				constant: e.sum = 7
--			end

--			e := p
--			check
--				plus: e.sum = 5
--			end
--		end

--	stack_test
--		local
--			stack: EXP_STACK
--			e1, e2, e3: EXPRESSION
--			e4: EXPRESSION
--		do
--			create {CONSTANT}e1.make (4)
----			create {PLUS}e2.make (1, 2)
--			create {PLUS}e2.make (create {CONSTANT}.make (1), create {CONSTANT}.make (2))
--			create {CONSTANT}e3.make (6)

--			create stack
--			stack.put (e1, 1)
--			stack.put (e2, 2)
--			stack.put (e3, 3)

--			check
--				e1: stack.item1.sum = 4
--				e2: stack.item2.sum = 3
--				e3: stack.item3.sum = 6
--			end

--			e4 := stack.item1

--			check
--				e4.sum = 4
--			end

--		end

--	g
--		local
--			x, y: INTEGER
--			e: EXPRESSION
--		do
--			create {CONSTANT}e.make (1)
--			e.accept
--			x := e.top
--			e.accept
--			y := e.top
--			check
--				x = y
--			end
--		end

	h
		local
			c1, c2, c3, c4: !CONSTANT
			p1, p2: PLUS
			i: INTEGER
			p: PLUS
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (3)
			create c4.make (4)

			create p1.make (c1, c2)
			create p2.make (c3, c4)
			create p.make (p1, p2)

			p.accept

			check
				c1.top = 1
				c2.top = 2
				c3.top = 3
				c4.top = 4
				p1.top = 3
				p2.top = 7
				p.top = 10
			end

			check
--				fail: false
			end

			c1.accept	-- mentioned, so it is referenced
		end

	k
		local
			c1, c2: !CONSTANT
			p1: !PLUS
			v: !EXP_VISITOR
			e: !EXPRESSION
			s: !SUM_VISITOR
		do
			create c1.make (1)
			create c2.make (2)
			create s.make

			v := s
			e := c1

			check
				a: s.sum = 0
				b: c1.value = 1
				c: c2.value = 2
			end

			e.visit (v)

			check
				d: s.sum = 1
			end

			check
				fail: false
			end

				-- referencing
			c1.visit (s)
			s.process_constant (c1)
			s.process_plus (p1)
		end

	l
		local
			c1, c2: !CONSTANT
			m: !MINUS
			v: !EXP_VISITOR
			e: !EXPRESSION
			inc: !INCREASE_VISITOR
		do
			create c1.make (1)
			create c2.make (2)
			create m.make (c1)
			create inc.make

			v := inc
			e := c1

			check
				b: c1.value = 1
				c: c2.value = 2
			end

			c1.visit (inc)

			check
				d: c1.value = 2
			end

			check
				fail: false
			end

				-- referencing
			c1.visit (inc)
			inc.process_constant (c1)
			inc.process_minus (m)
		end

end
