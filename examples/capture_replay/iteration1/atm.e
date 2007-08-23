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
			the_bank := a_bank

			create {ATM_UI_TEXTUAL}the_ui.make (Current)
			create the_log.make
		end

feature -- Access

	is_observed: BOOLEAN is False

	ui: ATM_UI
			-- UI of the ATM
		do
			Result := the_ui
		ensure
			result_not_void: ui /= Void
		end

	last_operation_succeeded: BOOLEAN
			-- Did the last operation succeed?
		do
			Result := success
		end

	log: ATM_LOG is
			-- The log of the ATM
		do
			Result := the_log
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
			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.deposit (an_account, amount)
				success := true
			else
				success := false
			end
		end

	withdraw (account_name: STRING; amount:REAL)
			-- Withdraw 'amount' on the account with name 'account_name'
		require
			account_exists: account_exists(account_name)
		local
			an_account: BANK_ACCOUNT

			ignore_result: ANY
		do
			an_account := the_bank.account_for_name (account_name)

			if an_account /= Void then
				the_bank.withdraw (an_account, amount)
				success := True
			else
				success := False
			end
		end

	account_exists (account_name:STRING): BOOLEAN
			-- Is there an account with name 'account_name'?
		require
				account_name_not_void: account_name /= Void
		do
			Result := (the_bank.account_for_name (account_name) /= Void)
		end

	balance_for_account_name (account_name: STRING): REAL
			-- balance of the account with name 'account_name'
		require
		 	account_exists: account_exists (account_name)
		local
			an_account: BANK_ACCOUNT
		do
			an_account:=the_bank.account_for_name (account_name)
			Result := an_account.balance
		end

	set_ui(a_ui: ATM_UI) is
			-- replace the ATM's UI.
		require
			a_ui_not_void: a_ui /= Void
		local
			ignore_result: ANY
		do
			the_ui := a_ui
		end


feature {NONE} -- Implementation

	the_bank: BANK

	the_ui: ATM_UI

	the_log: ATM_LOG

	success: BOOLEAN
invariant
	ui_not_void: the_ui /= Void
	log_not_void: the_log /= Void
end
