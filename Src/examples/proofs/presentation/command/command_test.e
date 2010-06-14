indexing
	description: "Summary description for {COMMAND_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_TEST

feature

	make
		local
			a1: CREDIT_ACCOUNT
			c1, c2: COMMAND
		do


--			create a1.make (100)
--			create c1.make (agent a1.deposit (?))
--			create c2.make (agent a1.withdraw (?))

--			a1.deposit (amount: INTEGER_32)
--			a1.withdraw (amount: INTEGER_32)






			create a1.make (100)

			check check1: a1.balance = 0 end

--			c1.execute (100)

			c2.execute (50)

			check check2: a1.balance = -50 end
			check check3: a1.credit_limit = 100 end

			c2.execute (50)

			check check4: a1.balance = -100 end
		end


--	make
--		local
--			c1: COMMAND
--			ac: ACCOUNT_COMMAND
--			u1: UNDO_COMMAND
--			b: ACCOUNT
--			ca: CREDIT_ACCOUNT


--		do
--			create b.make
--			create ca.make (200)

--			create u1.make_undo (agent ca.deposit, agent ca.withdraw, 50)
--			create c1.make (agent b.withdraw, 10)

--			create ac.make (agent {ACCOUNT}.withdraw)

--			b.deposit (100)

--			ac.execute (b, 10)

--			u1.execute_undo (250)

--			check
--				
--			end


----			check
----				ca.balance = 0
----			end

----			u1.execute_undo (50)

----			check
----				ca.balance = -50
----				ca.credit_limit = 200
----			end

----			u1.execute_undo (50)

----			check
----				ca.balance = -100
----			end


--		end

end
