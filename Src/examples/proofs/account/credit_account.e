indexing
	description: "Summary description for {CREDIT_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CREDIT_ACCOUNT

inherit
	ACCOUNT
		rename
			make as make_old
		redefine
			withdraw
		end

create
	make

feature {NONE} -- Initialization

	make (a_credit_limit: INTEGER)
			-- Initialize empty account with a credit limit of `a_credit_limit'.
		do
			credit_limit := a_credit_limit
			balance := 0
		ensure
			credit_limit = a_credit_limit
			balance = 0
		end

feature -- Access

	credit_limit: INTEGER
			-- Credit limit of account

feature -- Element change

	withdraw (amount: INTEGER)
			-- Withdraw `amount' from account.
		require else
			amount_not_too_large: amount <= balance + credit_limit
		do
			balance := balance - amount
		end

end
