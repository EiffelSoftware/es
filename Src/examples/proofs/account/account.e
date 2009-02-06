indexing
	description: "Summary description for {ACCOUNT}."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty bank account.
		do
			balance := 0
		ensure
			balance_set: balance = 0
		end

feature -- Access

	balance: INTEGER
			-- Balance of account

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
			amount_not_too_large: amount <= balance
		do
			balance := balance - amount
		ensure
			balance_decreased: balance = old balance - amount
		end

	transfer (amount: INTEGER; other: ACCOUNT) is
			-- Transfer `amount' from `Current' to `other'.
		require
			other_not_void: other /= Void
			amount_not_negative: amount >= 0
			amount_not_too_large: amount <= balance
		do
			withdraw (amount)
			other.deposit (amount)
		ensure
			balance_decreased: balance = old balance - amount
			other_balance_increased: other.balance = old other.balance + amount
		end

invariant
	balance_not_negative: balance >= 0

end
