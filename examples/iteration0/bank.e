indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK
inherit
	OBSERVABLE

create
	make

--artificial example where withdrawal happens through the bank and not directly on the account.

feature --creation
	make is
		-- create a bank
		do
			create the_account.make("test")
			create the_atm.make(Current)
		end

	is_observed: BOOLEAN is
		once
			Result:=True
		end

feature -- Access
account_for_name(name: STRING):BANK_ACCOUNT is
		-- the account with 'name'
		-- or Void if the account does not exist
	do
		the_recorder.capture_methodbody_start ("get_Account", Current, 1)
		if name.is_equal("test") then
			Result:=the_account
		end
		the_recorder.capture_methodbody_end (Result)

	end

atm:ATM is
		--the ATM that is connected to this
		--bank
	do
		the_recorder.capture_methodbody_start ("atm", Current, 0)
		Result := the_atm
		the_recorder.capture_methodbody_end (Result)
	end

feature -- Basic Operations

withdraw(an_account: BANK_ACCOUNT; amount: REAL) is
		-- withdraw 'amount' from 'an_account'
	do
		the_recorder.capture_methodbody_start ("withdraw", Current, 2)
		an_account.withdraw(amount)
		print (the_atm.authorization_key) -- to test outcalls ;)
		the_recorder.capture_methodbody_end (Void)
	end

deposit(an_account: BANK_ACCOUNT; amount: REAL) is
		-- deposit 'amount' on 'an_account'
	do
		the_recorder.capture_methodbody_start ("deposit", Current, 2)
		an_account.deposit (amount)
		print(the_atm.authorization_key) -- test outcalls...
		the_recorder.capture_methodbody_end (Void)
	end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
