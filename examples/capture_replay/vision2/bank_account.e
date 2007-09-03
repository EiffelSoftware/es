indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT

create
	make

feature -- creation

	make (a_name: STRING)
			-- Make a Bank account with name `a_name'.
		require
			a_name_not_void: a_name /= Void
		do
			the_name := a_name
		ensure
			name_set: name = a_name
		end

feature -- Access

	name: STRING is
			-- Name of the account
		do
			Result := the_name
		end

	balance: REAL is
			-- Balance of the account
		do
			Result := the_balance
		end

feature {BANK} -- Restricted

	withdraw (an_amount: REAL) is
			-- Withdraw 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		do
			the_balance := the_balance - an_amount
		ensure
			amount_withdrawn: balance = old balance - an_amount
		end


	deposit (an_amount: REAL) is
			--Deposit 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		do
			the_balance := the_balance + an_amount
		ensure
			an_amount_deposited: balance = old balance + an_amount
		end

feature {NONE} -- Implementation
	the_balance: REAL

	the_name: STRING

invariant
	a_name_not_void: the_name /= Void
end
