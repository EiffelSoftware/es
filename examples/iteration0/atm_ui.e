indexing
	description: "Object that represents the user interface of an atm"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ATM_UI

inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- Access

	is_observed: BOOLEAN is False

	make (an_atm: ATM)
			-- Create a new ATM_UI for 'an_atm'.
		require
			an_atm_not_void: an_atm /= Void
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="make" args="[an_atm]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [an_atm])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				atm := an_atm
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature --Basic Operations

	run
			-- Run the UI.
		local
			exit: BOOLEAN
			ignore_result: ANY
		do
			-- <methodbody_start name="run" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("run", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
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
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Basic operations

	ping
			-- Dummy feature without arguments and results (testing).
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="ping" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("ping", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>

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
