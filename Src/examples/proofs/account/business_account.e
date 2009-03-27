class
	BUSINESS_ACCOUNT
inherit
	ACCOUNT
		redefine
			withdraw
		end

--create
--	make

feature

	foo: INTEGER

	withdraw (amount: INTEGER)
			-- Withdraw `amount' from account.
		do
			balance := balance - amount
			foo := amount
		ensure then
			foo = amount
		end

end
