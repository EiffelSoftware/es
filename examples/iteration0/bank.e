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
			ignore_result: ANY
			test_string: STRING
		do
			-- <methodbody_start name="make" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				test_string := "test_string"
				create the_account.make ("test")
				create the_atm.make (Current)
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Access

	account_for_name (name: STRING): BANK_ACCOUNT
			-- The account with 'name'
			-- or Void if the account does not exist
		require
			name_not_void: name /= Void
		do
			-- <methodbody_start name="account_for_name" args="[name]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("account_for_name", Current, [name])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				if name.is_equal ("test") then
					Result := the_account
				end
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	atm:ATM
			-- ATM that is connected to this
			-- bank
		do
			-- <methodbody_start name="atm" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("atm", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result := the_atm
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
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
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("withdraw", Current, [an_account, amount])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account.withdraw (amount)
				--XXX breaks replay
				print (the_atm.authorization_key) -- to test outcalls ;)
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
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
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("deposit", Current, [an_account, amount])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account.deposit (amount)
				--XXX breaks replay?
				print (the_atm.authorization_key) -- test outcalls...
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature {NONE} -- Implementation

	the_account: BANK_ACCOUNT

	the_atm: ATM

invariant
	invariant_clause: True -- Your invariant here
end
