indexing
	description: "Objects that represents a bank"
	author: "Stefan Sieber"
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
			test_string: STRING
		do
			-- <methodbody_start name="make" args="[]">
			if controller.is_capture_replay_enabled then
				controller.enter
				controller.methodbody_start("make", Current, [])
				controller.leave
			end
			if (not controller.is_replay_phase) or is_observed then
			-- </methodbody_start>
				test_string := "test_string"
				create the_account.make ("test")
				create the_atm.make (Current)
			-- <methodbody_end return_value="False">
			end
			if controller.is_capture_replay_enabled then
				controller.enter
				ignore_result ?= controller.methodbody_end(Void)
				controller.leave
			end
			-- </methodbody_end>
		end

	is_observed: BOOLEAN is True

feature -- Access

	account_for_name (name: STRING): BANK_ACCOUNT
			-- The account with 'name'
			-- or Void if the account does not exist
		require
			name_not_void: name /= Void
		do
			-- <methodbody_start name="account_for_name" args="[name]">
			if controller.is_capture_replay_enabled then
				controller.enter
				controller.methodbody_start("account_for_name", Current, [name])
				controller.leave
			end
			if (not controller.is_replay_phase) or is_observed then
			-- </methodbody_start>
				if name.is_equal ("test") then
					Result := the_account
				end
			-- <methodbody_end return_value="True">
			end
			if controller.is_capture_replay_enabled then
				controller.enter
				Result ?= controller.methodbody_end(Result)
				controller.leave
			end
			-- </methodbody_end>
		end

	atm:ATM
			-- ATM that is connected to this
			-- bank
		do
			-- <methodbody_start name="atm" args="[]">
			if controller.is_capture_replay_enabled then
				controller.enter
				controller.methodbody_start("atm", Current, [])
				controller.leave
			end
			if (not controller.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result := the_atm
			-- <methodbody_end return_value="True">
			end
			if controller.is_capture_replay_enabled then
				controller.enter
				Result ?= controller.methodbody_end(Result)
				controller.leave
			end
			-- </methodbody_end>
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
			-- <methodbody_start name="withdraw" args="[an_account, amount]">
			if controller.is_capture_replay_enabled then
				controller.enter
				controller.methodbody_start("withdraw", Current, [an_account, amount])
				controller.leave
			end
			if (not controller.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account.withdraw (amount)
				--XXX breaks replay	print (the_atm.authorization_key) -- to test outcalls ;)
			-- <methodbody_end return_value="False">
			end
			if controller.is_capture_replay_enabled then
				controller.enter
				ignore_result ?= controller.methodbody_end(Void)
				controller.leave
			end
			-- </methodbody_end>
		end

	deposit(an_account: BANK_ACCOUNT; amount: REAL)
			-- Deposit 'amount' on 'an_account'
		require
			an_account_not_void: an_account /= Void
			amount_not_negative: amount >= 0
		local
			ignore_result: ANY
		do

			-- <methodbody_start name="deposit" args="[an_account, amount]">
			if controller.is_capture_replay_enabled then
				controller.enter
				controller.methodbody_start("deposit", Current, [an_account, amount])
				controller.leave
			end
			if (not controller.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account.deposit (amount)
				--XXX breaks replay? print (the_atm.authorization_key) -- test outcalls...
			-- <methodbody_end return_value="False">
			end
			if controller.is_capture_replay_enabled then
				controller.enter
				ignore_result ?= controller.methodbody_end(Void)
				controller.leave
			end
			-- </methodbody_end>
		end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
