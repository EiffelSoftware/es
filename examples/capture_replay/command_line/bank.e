indexing
	description: "Objects that represents a bank"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK

create
	make

--artificial example where withdrawal happens through the bank and not directly on the account.

feature --creation
	make
		-- Create a bank
		local
			test_string: STRING
		do
			test_string := "test_string"
			create the_account.make ("test")
			create the_atm.make (Current)
		end

feature -- Access

	account_for_name (name: STRING): BANK_ACCOUNT
			-- The account with 'name'
			-- or Void if the account does not exist
		require
			name_not_void: name /= Void
		do
			if name.is_equal ("test") then
				Result := the_account
			end
		end

	atm:ATM
			-- ATM that is connected to this
			-- bank
		do
			Result := the_atm
		ensure
			result_not_void: Result /= Void
		end

feature -- Basic Operations

	withdraw (an_account: BANK_ACCOUNT; amount: REAL)
			-- Withdraw 'amount' from 'an_account'
		require
			an_account_not_void: an_account /= Void
			amount_not_negative: amount >= 0
		do
			an_account.withdraw (amount)
--			print (the_atm.authorization_key) -- to test outcalls ;)
		end

	deposit(an_account: BANK_ACCOUNT; amount: REAL)
			-- Deposit 'amount' on 'an_account'
		require
			an_account_not_void: an_account /= Void
			amount_not_negative: amount >= 0
		do
			an_account.deposit (amount)
--			print (the_atm.authorization_key) -- test outcalls...
		end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
