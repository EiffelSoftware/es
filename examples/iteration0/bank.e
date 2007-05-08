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
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("make", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
				create the_account.make ("test")
				create the_atm.make (Current)
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
			end
		end

	is_observed: BOOLEAN is True

feature -- Access

	account_for_name (name: STRING): BANK_ACCOUNT
			-- The account with 'name'
			-- or Void if the account does not exist
		require
			name_not_void: name /= Void
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("account_for_name", Current, [name])
			end
			if (not controller.is_replay_phase) or is_observed then
				if name.is_equal ("test") then
					Result := the_account
				end
			end
			if controller.is_capture_replay_enabled then
				Result ?= controller.methodbody_end (Result)
			end

		end

	atm:ATM
			-- ATM that is connected to this
			-- bank
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("atm", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
				Result := the_atm
			end
			if controller.is_capture_replay_enabled then
				Result ?= controller.methodbody_end (Result)
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
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("withdraw", Current, [an_account, amount])
			end
			if (not controller.is_replay_phase) or is_observed then
				an_account.withdraw (amount)
				print (the_atm.authorization_key) -- to test outcalls ;)
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
			end
		end

	deposit(an_account: BANK_ACCOUNT; amount: REAL)
			-- Deposit 'amount' on 'an_account'
		require
			an_account_not_void: an_account /= Void
			amount_not_negative: amount >= 0
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("deposit", Current, [an_account, amount])
			end
			if (not controller.is_replay_phase) or is_observed then
				an_account.deposit (amount)
				print (the_atm.authorization_key) -- test outcalls...
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
			end
		end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
