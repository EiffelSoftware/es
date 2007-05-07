indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ATM

inherit
	OBSERVABLE

create
	make

feature -- creation
	make (a_bank: BANK)
			-- Create a new ATM that is connected to
			--'a_bank'.
		require
			a_bank_not_void: a_bank /= Void
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("make", Current, [a_bank])
			end

			the_bank := a_bank
			create the_ui.make (Current)

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

feature -- Access

	ui: ATM_UI
			-- UI of the ATM
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("ui", Current, [])
			end

			Result := the_ui

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
		ensure
			result_not_void: ui /= Void
		end

	last_operation_succeeded: BOOLEAN
			-- Did the last operation succeed?
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("last_operation_succeeded", Current,[])
			end

			Result := success

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
		end


feature -- Element change

	deposit (account_name: STRING; amount: REAL)
			-- Deposit 'amount' on the account with name 'account_name'
		require
			account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("deposit", Current, [account_name,amount])
			end

			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.deposit (an_account, amount)
				success := true
			else
				success := false
			end

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

	withdraw (account_name:STRING; amount:REAL)
			-- Withdraw 'amount' on the account with name 'account_name'
		require
			account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("withdraw", Current, [account_name, amount])
			end

			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.withdraw (an_account, amount)
				success := True
			else
				success := False
			end

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

	account_exists (account_name:STRING): BOOLEAN
			-- Is there an account with name 'account_name'?
		require
				account_name_not_void: account_name /= Void
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("account_exists", Current, [account_name])
			end

			Result := (the_bank.account_for_name (account_name) /= Void)

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
		end

	balance_for_account_name (account_name: STRING): REAL
			-- balance of the account with name 'account_name'
		require
		 	account_exists: account_exists (account_name)
		local
			an_account: BANK_ACCOUNT
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("balance_for_account_name", Current, [account_name])
			end

			ui.ping
			an_account:=the_bank.account_for_name (account_name)
			Result := an_account.balance

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
		end

	authorization_key: STRING
			--the (fake) authorization key
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("authorization_key", Current, [])
			end

			Result:= "100%% trustworthy%N"

			if recorder.capture_replay then
				recorder.capture_methodbody_end (Result)
			end
		end

	set_ui(a_ui: ATM_UI) is
			-- replace the ATM's UI.
		require
			a_ui_not_void: a_ui /= Void
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("set_ui", Current, [a_ui])
			end

			the_ui := a_ui
			
			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end


feature {NONE} -- Implementation

	the_bank: BANK
	the_ui: ATM_UI

	success: BOOLEAN
invariant
	invariant_clause: True -- Your invariant here

end
