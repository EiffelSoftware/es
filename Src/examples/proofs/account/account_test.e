indexing
	description: "Test class for account example."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT_TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			a1, a2: ACCOUNT
		do
			create a1.make
			create a2.make

			check
				a1.balance = 0
				a2.balance = 0
			end

			a1.deposit (10)
			a2.deposit (20)

			check
				a1.balance = 10
				a2.balance = 20
			end

			a1.withdraw (5)
			a2.withdraw (10)

			check
				a1.balance = 5
				a2.balance = 10
			end

			a1.transfer (3, a2)

			check
				a1.balance = 2
				a2.balance = 13
			end

		end

end
