indexing
	description: "Test class for account example."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT_TEST

feature {NONE} -- Initialization


	test
		local
			a: ACCOUNT
		do
			create a.make (100)

			a.withdraw (50)

			check
				a.balance = -50
				a.credit_limit = 100
			end

		end























--	test
--		local
--			a: ACCOUNT
--		do
--			create a.make (100)

--			a.withdraw (10)

--			check
--				a.credit_limit = 100
--			end

--		end



























--	test
--		local
--			a1: ACCOUNT
--		do
--			create a1.make (100)

--			a1.withdraw (10)

--			check
--				c1: a1.balance = -10
--				c2: a1.credit_limit = 100
--			end

--			a1.deposit (50)

--			check
--				c3: a1.balance = 40
--				c4: a1.credit_limit = 100
--			end

--		end


end
