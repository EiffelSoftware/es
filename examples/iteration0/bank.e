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
			if recorder.capture_replay then
			end
			recorder.capture_methodbody_start ("make", Current, [])
			create the_account.make ("test")
			create the_atm.make (Current)
			if recorder.capture_replay then
			end
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
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("account_for_name", Current, [name])
			end

			if name.is_equal ("test") then
				Result := the_account
			end

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end

		end

	atm:ATM
			-- ATM that is connected to this
			-- bank
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("atm", Current, [])
			end

			Result := the_atm

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
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
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("withdraw", Current, [an_account, amount])
			end

			an_account.withdraw (amount)
			print (the_atm.authorization_key) -- to test outcalls ;)
			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

	deposit(an_account: BANK_ACCOUNT; amount: REAL)
			-- Deposit 'amount' on 'an_account'
		require
			an_account_not_void: an_account /= Void
			amount_not_negative: amount >= 0
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("deposit", Current, [an_account, amount])
			end

			an_account.deposit (amount)
			print (the_atm.authorization_key) -- test outcalls...
			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
