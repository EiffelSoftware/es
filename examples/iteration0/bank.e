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
		do
			create the_account.make("test")
			create the_atm.make(Current)
		end

	is_observed: BOOLEAN is
			--
		once
			Result:=True
		end

feature -- Access
get_Account(account_name: STRING):BANK_ACCOUNT is
		--returns the account with name 'account_name
		--or Void if the account does not exist
	do
		get_recorder.methodbodystart ("get_Account", Current, 2)
		if account_name.is_equal("test") then
			Result:=the_account
		end
		get_recorder.methodbodyend (Result)

	end

atm():ATM is
		--returns a new ATM that is connected to this
		--bank
	do
		get_recorder.methodbodystart ("atm", Current, 1)
		Result := the_atm
		get_recorder.methodbodyend (Result)
	end

withdraw(an_account: BANK_ACCOUNT; amount: REAL) is
		--withdraw 'amount' from 'an_account'
	do
		get_recorder.methodbodystart ("withdraw", Current, 2)
		an_account.withdraw(amount)
		print (the_atm.authorization_key) -- to test outcalls ;)
		get_recorder.methodbodyend (Void)
	end

deposit(an_account: BANK_ACCOUNT; amount: REAL) is
		-- deposit 'amount' on 'an_account'
	do
		get_recorder.methodbodystart ("deposit", Current, 3)
		an_account.deposit (amount)
		print(the_atm.authorization_key) -- test outcalls...
		get_recorder.methodbodyend (Void)
	end


feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	the_account: BANK_ACCOUNT
	the_atm: ATM
invariant
	invariant_clause: True -- Your invariant here

end
