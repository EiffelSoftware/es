indexing
	description: "Summary description for {ACCOUNT}."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

create
	make

feature {NONE} -- Initialization

	make (a_credit_limit: INTEGER)
			-- Initialize empty bank account.
		require
			a_credit_limit_not_negative: a_credit_limit >= 0
		do
			credit_limit := a_credit_limit
			balance := 0
		ensure
			credit_limit_set: credit_limit = a_credit_limit
			balance_set: balance = 0
		end

feature -- Access

	balance: INTEGER
			-- Balance of account

	credit_limit: INTEGER
			-- Credit limit of account

feature -- Element change

	deposit (amount: INTEGER)
			-- Deposit `amount' on account.
		require
			amount_not_negative: amount >= 0
		do
			balance := balance + amount
		ensure
			balance_increased: balance = old balance + amount
		end

	withdraw (amount: INTEGER)
			-- Withdraw `amount' from account.
		require
			amount_not_too_large: amount <= balance + credit_limit
		do
			balance := balance - amount
		ensure
			balance_decreased: balance = old balance - amount
		end

invariant
	balance_not_lower_than_credit: balance + credit_limit >= 0

end
