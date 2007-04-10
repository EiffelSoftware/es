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
	make(an_atm: ATM) is
			--creates a new ATM_UI for 'an_atm'
		do
			atm := an_atm
		end

	is_observed: BOOLEAN is
			--
		once
			Result:=False
		end
feature
	run is

		local
			exit: BOOLEAN
		do
			get_recorder.methodbodystart ("run", $Current, 1)

			from
				exit := False
			until
				exit
			loop
				print("ATM Main Menu. Your options: %N")
				print("d deposit %N")
				print("w withdraw %N")
				print("q quit %N")

				io.
				io.read_character

				inspect
					io.last_character
				when 'd' then
					deposit
				when 'w' then
					withdraw
				when 'q' then
					print("exiting application")
					exit := True
				else
					print("command not recognized")
				end
			end

			get_recorder.methodbodyend (Void)
		end

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
	ref (p: POINTER;): POINTER is
			-- returns the reference (i.e. Address) of 'p'
		external
			"C [macro %"recorder.h%"]" -- (EIF_POINTER): EIF_POINTER"
		alias
			"reference"
		end


feature -- Basic operations

	ping is
			-- dummy operation.
		do

		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	atm: ATM


	deposit is
			--deposit menu	
		local
			account_name: STRING
			amount: REAL
		do
			print("Deposit - Menu %N")
			account_name:=get_account_name
			amount:=get_amount
			atm.deposit (account_name, amount)
			if atm.last_operation_succeeded then
				print("operation succeded!%N")
				print_balance(account_name)
			else
				print("operation failed! %N")
			end
		end

	withdraw is
			--withdraw menu
		local
			account_name: STRING
			amount: REAL
		do
			print("withdraw-Menu %N")
			account_name:=get_account_name
			amount:=get_amount
			atm.withdraw(account_name,amount)
			if atm.last_operation_succeeded then
				print("operation succeded!%N")
				print_balance(account_name)
			else
				print("operation failed! %N")
			end
		end

	get_account_name: STRING
		--asks the user for the account name.
		--only accepts a valid account
		do

			from
				Result := ""
			until
				atm.account_exists (Result)
			loop
				print("please enter the name of your account %N")
				io.readline
				Result:= io.last_string

				if not atm.account_exists (Result) then
					print("unknown account. hint: 'test' %N")
				end
			end
		end

	get_amount:REAL
			--
		do
			print("please enter amount")
			io.read_real
			Result:=io.last_real
		end

	print_balance(account_name: STRING) is
			--
		do
			print ("Account " + account_name + "%N")
			print ("balance: " + atm.get_balance (account_name).out + "%N")
		end
invariant
	invariant_clause: True -- Your invariant here

end
