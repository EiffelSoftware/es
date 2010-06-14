indexing
	description: "Summary description for {TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEQUENCE_TEST

feature

	test (use_fib: BOOLEAN)
		local
			s: INTEGER_SEQUENCE
			f: FIBONACCI_SEQUENCE
			a: ARITHMETIC_SEQUENCE
		do
			create f.make -- 1
			f.forth -- 1
			f.forth -- 2
			f.forth -- 3

			create a.make (14, -3) -- 14

			if use_fib then
				s := f
			else
				s := a
			end

			s.forth	-- 5 / 11
			s.forth -- 8 / 8

			check
				seq: s.item = 8
			end

			if use_fib then
				check arith: a.item = 14 end
			else
				check fib: f.item = 3 end
			end

		end
--		
--	test (use_fib: BOOLEAN)
--		local
--			s: INTEGER_SEQUENCE
--			f: FIBONACCI_SEQUENCE
--			a: ARITHMETIC_SEQUENCE
--			proc: !PROCEDURE [ANY, TUPLE []]
--		do
--			create f.make -- 1
--			f.forth -- 1
--			f.forth -- 2
--			f.forth -- 3

--			create a.make (14, -3) -- 14

--			if use_fib then
--				s := f
--				proc := agent f.forth
--			else
--				s := a
--				proc := agent a.forth
--			end
--			-- proc := s.forth	-- problem with framing and inheritance

--			s.forth	-- 5 / 11
--			s.forth -- 8 / 8

----			call_agent (proc) -- 5 / 11
----			call_agent (proc) -- 8 / 8


--			check
--				seq: s.item = 8
--			end

--			if use_fib then
--				check arith: a.item = 14 end
--			else
--				check fib: f.item = 3 end
--			end

--		end

--	call_agent (a_agent: !PROCEDURE [ANY, TUPLE []])
--		require
--			a_agent.precondition ([])
--		do
--			a_agent.call ([])
--		ensure
--			a_agent.postcondition ([])
--		end

end
