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
			--creates a new ATM that is connected to
			--'a_bank'.
		do
			the_bank:=a_bank
			create the_ui.make (Current)
		end

feature -- Access

	ui:ATM_UI is
			--create a new ui to the ATM.
		do
			get_recorder.methodbodystart ("ui", $Current, 1)
			Result:=the_ui
			get_recorder.methodbodyend (Result)
		end

	last_operation_succeeded:BOOLEAN is
			--
		do
			get_recorder.methodbodystart("last_operation_succeeded", $Current,1)
			Result:=success
			get_recorder.methodbodyend (Result)
		end

	is_observed: BOOLEAN is
			--
		once
			Result:=False
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	deposit(account_name: STRING; amount: REAL) is
			--deposit 'amount' on the account with name 'account_name'
		local
			an_account: BANK_ACCOUNT
		do
			get_recorder.methodbodystart ("deposit", $Current, 3)
			an_account := the_bank.get_account (account_name)

			if an_account /= Void then
				the_bank.deposit (an_account, amount)
				success:= true
			else
				success:=false
			end
			get_recorder.methodbodyend (Void)
		end

	withdraw(account_name:STRING;amount:REAL) is
			--withdraw 'amount' on the account with name 'account_name'
			--the Result signals if the operation was successful
			--('code_success' or 'code_failure')
		local
			an_account: BANK_ACCOUNT
		do
			get_recorder.methodbodystart ("withdraw", $Current, 3)
			an_account := the_bank.get_account (account_name)

			if an_account /= Void then
				the_bank.withdraw (an_account, amount)
				success := true
			else
				success := false
			end
			get_recorder.methodbodyend (Void)
		end

	account_exists(account_name:STRING):BOOLEAN is
			-- is there an account with name 'account_name'?
		do
			get_recorder.methodbodystart ("account_exists", $Current, 2)
			Result:=(the_bank.get_account (account_name)/= Void)
			get_recorder.methodbodyend (Result)
		end

	get_balance(account_name: STRING): REAL is
			--
		--require
		-- account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT
		do
			get_recorder.methodbodystart ("get_balance", $Current, 2)
			ui.ping
			an_account:=the_bank.get_account (account_name)
			Result:=an_account.get_balance
			get_recorder.methodbodyend (Result)
		end

	authorization_key: STRING is
			--
		do
			get_recorder.methodbodystart ("account_exists", $Current, 1)
			Result:= "100%% trustworthy"
			get_recorder.methodbodyend (Result)
		end

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

	the_bank: BANK
	the_ui: ATM_UI

	success:BOOLEAN
invariant
	invariant_clause: True -- Your invariant here

end
