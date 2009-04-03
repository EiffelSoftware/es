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
			c1, c2: COMMAND
			u1: UNDO_COMMAND
			b: ACCOUNT
			ca: CREDIT_ACCOUNT
		do
			create b.make
			create ca.make (200)

			create u1.make_undo (agent ca.deposit, agent ca.withdraw, 50)
			create c1.make (agent b.withdraw, 10)

			check
				ca.balance = 0
			end

			u1.execute_undo (50)

			check
				ca.balance = -50
				ca.credit_limit = 200
			end

			u1.execute_undo (50)

			check
				ca.balance = -100
			end


		end

end
