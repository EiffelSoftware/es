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

feature --creation
	make(a_bank: BANK) is
			-- create a new ATM that is connected to
			--'a_bank'.
		do
			the_bank:=a_bank
			create the_ui.make (Current)
		end

feature -- Access

	ui:ATM_UI is
			--the UI of the ATM.
		do
			the_recorder.capture_methodbody_start ("ui", Current, 0)
			Result:=the_ui
			the_recorder.capture_methodbody_end (Result)
		end

	last_operation_succeeded:BOOLEAN is
			-- Did the last operation succeed?
		do
			the_recorder.capture_methodbody_start("last_operation_succeeded", Current,0)
			Result:=success
			the_recorder.capture_methodbody_end (Result)
		end

	is_observed: BOOLEAN is
		once
			Result:=False
		end


feature -- Element change

	deposit(account_name: STRING; amount: REAL) is
			-- deposit 'amount' on the account with name 'account_name'
		local
			an_account: BANK_ACCOUNT
		do
			the_recorder.capture_methodbody_start ("deposit", Current, 2)
			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.deposit (an_account, amount)
				success:= true
			else
				success:=false
			end
			the_recorder.capture_methodbody_end (Void)
		end

	withdraw(account_name:STRING; amount:REAL) is
			-- Withdraw 'amount' on the account with name 'account_name'
		local
			an_account: BANK_ACCOUNT
		do
			the_recorder.capture_methodbody_start ("withdraw", Current, 2)
			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.withdraw (an_account, amount)
				success := True
			else
				success := False
			end
			the_recorder.capture_methodbody_end (Void)
		end

	account_exists(account_name:STRING):BOOLEAN is
			-- Is there an account with name 'account_name'?
		do
			the_recorder.capture_methodbody_start ("account_exists", Current, 1)
			Result:=(the_bank.account_for_name (account_name)/= Void)
			the_recorder.capture_methodbody_end (Result)
		end

	balance_for_account_name(account_name: STRING): REAL is
			-- balance of the account with name 'account_name'
		require
		 account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT
		do
			the_recorder.capture_methodbody_start ("balance_for_account_name", Current, 1)
			ui.ping
			an_account:=the_bank.account_for_name (account_name)
			Result:=an_account.balance
			the_recorder.capture_methodbody_end (Result)
		end

	authorization_key: STRING is
			--the (fake) authorization key
		do
			the_recorder.capture_methodbody_start ("account_exists", Current, 0)
			Result:= "100%% trustworthy%N"
			the_recorder.capture_methodbody_end (Result)
		end

feature {NONE} -- Implementation

	the_bank: BANK
	the_ui: ATM_UI

	success:BOOLEAN
invariant
	invariant_clause: True -- Your invariant here

end
