indexing
	description: "Objects that represent a textual user interface to an ATM"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ATM_UI_TEXTUAL

inherit
	ATM_UI

create
	make

feature -- Access



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

	run
			-- Run the UI.
		local
			exit: BOOLEAN
		do
			from
				exit := False
			until
				exit
			loop
				print("ATM Main Menu. Your options: %N")
				print("d deposit %N")
				print("w withdraw %N")
				print("q quit %N")

				io.read_character

				inspect
					io.last_character
				when 'd' then
					deposit
				when 'w' then
					withdraw
				when 'q' then
					print ("exiting application")
					exit := True
				else
					print("command not recognized")
				end
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	deposit
			-- Go to the deposit menu	
		local
			account_name: STRING
			amount: REAL
		do
			print ("Deposit - Menu %N")
			account_name := prompt_account_name
			amount := prompt_amount
			atm.deposit (account_name, amount)
			if atm.last_operation_succeeded then
				print ("operation succeded!%N")
				print_balance_for_account_name (account_name)
			else
				print ("operation failed! %N")
			end
		end

	withdraw
			-- Go to the withdraw menu
		local
			account_name: STRING
			amount: REAL
		do
			print ("withdraw-Menu %N")
			account_name := prompt_account_name
			amount := prompt_amount
			atm.withdraw (account_name,amount)
			if atm.last_operation_succeeded then
				print ("operation succeded!%N")
				print_balance_for_account_name (account_name)
			else
				print ("operation failed! %N")
			end
		end

	prompt_account_name: STRING
		-- Ask the user for the account name,
		-- only accept a valid account
		do
			from
				Result := ""
			until
				atm.account_exists (Result)
			loop
				print ("please enter the name of your account %N")
				io.readline
				Result := io.last_string
				Result.get_area.note_direct_manipulation (Result.area)
				if not atm.account_exists (Result) then
					print ("unknown account. hint: 'test' %N")
				end
			end
		end

	prompt_amount:REAL
			-- Prompt the user for the Amount
		do
			print ("please enter amount")
			io.read_real
			Result := io.last_real
		end

	print_balance_for_account_name (account_name: STRING)
			-- Print the balance for the Account with name 'account_name'.
		do
			print ("Account ")
			print(account_name)
			print("%N")
			print ("balance: ")
			print(atm.balance_for_account_name (account_name).out)
			print("%N")
		end

invariant
	invariant_clause: True -- Your invariant here

end
