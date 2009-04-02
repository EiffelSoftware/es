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
		do
			create b.make
			create u1.make_undo (agent b.deposit, agent b.withdraw, 50)
			create c1.make (agent b.withdraw, 10)

			check
				b.balance = 0
			end

			u1.execute

			check
				b.balance = 50
			end

			c1.execute

			u1.execute_undo

			check
				b.balance = 0
			end


		end

end
