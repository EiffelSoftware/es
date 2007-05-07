indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ATM_UI

inherit
	OBSERVABLE
create
	make

feature -- Access

	make (an_atm: ATM)
			-- Create a new ATM_UI for 'an_atm'.
		require
			an_atm_not_void: an_atm /= Void
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("make", Current, [an_atm])
			end


			atm := an_atm
			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

feature --Basic Operations

	run
			-- Run the UI.
		local
			exit: BOOLEAN
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("run", Current, [])
			end


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

			if recorder.capture_replay then
			recorder.capture_methodbody_end (Void)
			end
		end

feature -- Basic operations

	ping
			-- Dummy feature without arguments and results (testing).
		do
			if recorder.capture_replay then
				recorder.capture_methodbody_start ("ping", Current, [])
			end


			if recorder.capture_replay then
				recorder.capture_methodbody_end (Void)
			end
		end

feature {NONE} -- Implementation
	-- These features won't be captured, as they can't be
	-- executed from other classes.

	atm: ATM  -- ATM the UI is connected to

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
			print ("Account " + account_name + "%N")
			print ("balance: " + atm.balance_for_account_name (account_name).out + "%N")
		end

invariant
	invariant_clause: True -- Your invariant here
end
