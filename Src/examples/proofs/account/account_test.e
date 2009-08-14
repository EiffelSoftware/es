indexing
	description: "Test class for account example."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT_TEST

create
	make

feature {NONE} -- Initialization

--	invariant_problem (b: !ACCOUNT)
--		do
--			b.deposit (100)
--			check
--				-- Violated because the invariant of `b' is not assumed to hold before `b.deposit'
--				violated: b.balance >= 100
--			end
--		ensure
--			b.balance = b.balance
--		end

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

	business_test (b: !BUSINESS_ACCOUNT)
		require
			b.balance = 100
		local
			a: ACCOUNT
		do
--			create {BUSINESS_ACCOUNT}b.make
			a := b
--			a.deposit (100)
			call_agent (agent a.withdraw, 10)
			check
				a: b.foo = 10
			end
		end


	call_agent (proc: !PROCEDURE [ANY, TUPLE[INTEGER]]; i: INTEGER)
		require
			proc.precondition ([i])
		do
			proc.call ([i])
		ensure
			proc.postcondition ([i])
		end

end
