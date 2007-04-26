indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK

inherit
	OBSERVABLE
		redefine
			is_observed
		end

create
	make

--artificial example where withdrawal happens through the bank and not directly on the account.

feature --creation
	make
		-- Create a bank
		do
			recorder.capture_methodbody_start ("make", Current, [])
			create the_account.make ("test")
			create the_atm.make (Current)
			recorder.capture_methodbody_end (Void)
		end

	is_observed: BOOLEAN is True

feature -- Access

account_for_name (name: STRING): BANK_ACCOUNT
		-- The account with 'name'
		-- or Void if the account does not exist
	require
		name_not_void: name /= Void
	do
		recorder.capture_methodbody_start ("account_for_name", Current, [name])
		if name.is_equal ("test") then
			Result := the_account
		end
		recorder.capture_methodbody_end (Result)
	end

atm:ATM
		-- ATM that is connected to this
		-- bank
	do
		recorder.capture_methodbody_start ("atm", Current, [])
		Result := the_atm
		recorder.capture_methodbody_end (Result)
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
		recorder.capture_methodbody_start ("withdraw", Current, [an_account, amount])
		an_account.withdraw (amount)
		print (the_atm.authorization_key) -- to test outcalls ;)
		recorder.capture_methodbody_end (Void)
	end

deposit(an_account: BANK_ACCOUNT; amount: REAL)
		-- Deposit 'amount' on 'an_account'
	require
		an_account_not_void: an_account /= Void
		amount_not_negative: amount >= 0
	do
		recorder.capture_methodbody_start ("deposit", Current, [an_account, amount])
		an_account.deposit (amount)
		print (the_atm.authorization_key) -- test outcalls...
		recorder.capture_methodbody_end (Void)
	end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
