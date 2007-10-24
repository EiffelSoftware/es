indexing
	description: "Objects that represents an ATM"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ATM

inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- creation
	make (a_bank: BANK)
			-- Create a new ATM that is connected to
			--'a_bank'.
		require
			a_bank_not_void: a_bank /= Void
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="make" args="[a_bank]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [a_bank])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				the_bank := a_bank
				create the_ui.make (Current)
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

	is_observed: BOOLEAN is False

	ui: ATM_UI
			-- UI of the ATM
		do
			-- <methodbody_start name="ui" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("ui", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result := the_ui
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		ensure
			result_not_void: ui /= Void
		end

	last_operation_succeeded: BOOLEAN
			-- Did the last operation succeed?
		do
		-- <methodbody_start name="last_operation_succeeded" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("last_operation_succeeded", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result := success
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end


feature -- Element change

	deposit (account_name: STRING; amount: REAL)
			-- Deposit 'amount' on the account with name 'account_name'
		require
			account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT
			ignore_result: ANY
		do
			-- <methodbody_start name="deposit" args="[account_name,amount]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("deposit", Current, [account_name,amount])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account := the_bank.account_for_name (account_name)

				if an_account /= Void then
					the_bank.deposit (an_account, amount)
					success := true
				else
					success := false
				end
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	withdraw (account_name: STRING; amount:REAL)
			-- Withdraw 'amount' on the account with name 'account_name'
		require
			account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT

			ignore_result: ANY
		do
			-- <methodbody_start name="withdraw" args="[account_name, amount]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("withdraw", Current, [account_name, amount])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				an_account := the_bank.account_for_name (account_name)

				if an_account /= Void then
					the_bank.withdraw (an_account, amount)
					success := True
				else
					success := False
				end
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	account_exists (account_name:STRING): BOOLEAN
			-- Is there an account with name 'account_name'?
		require
				account_name_not_void: account_name /= Void
		do
			-- <methodbody_start name="account_exists" args="[account_name]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("account_exists", Current, [account_name])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result := (the_bank.account_for_name (account_name) /= Void)
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	balance_for_account_name (account_name: STRING): REAL
			-- balance of the account with name 'account_name'
		require
		 	account_exists: account_exists (account_name)
		local
			an_account: BANK_ACCOUNT
		do
			-- <methodbody_start name="balance_for_account_name" args="[account_name]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("balance_for_account_name", Current, [account_name])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				ui.ping
				an_account:=the_bank.account_for_name (account_name)
				Result := an_account.balance
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	authorization_key: STRING
			--the (fake) authorization key
		do
			-- <methodbody_start name="authorization_key" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("authorization_key", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				Result:= "100%% trustworthy%N"
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	set_ui(a_ui: ATM_UI) is
			-- replace the ATM's UI.
		require
			a_ui_not_void: a_ui /= Void
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="set_ui" args="[a_ui]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("set_ui", Current, [a_ui])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				the_ui := a_ui
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

	the_bank: BANK
	the_ui: ATM_UI

	success: BOOLEAN
invariant
	invariant_clause: True -- Your invariant here

end
