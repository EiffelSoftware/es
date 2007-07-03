indexing
	description: "Caller implementation for the example application"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_CALLER

inherit
	BASE_CALLER

feature -- Basic operations

	call (target: ANY; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features on BANK or BANK_ACCOUNT
		local
			bank: BANK
			bank_account: BANK_ACCOUNT
			string: STRING_8
		do
			-- Discriminate by target type first, to speed things up.
			if target.generating_type.is_equal("BANK") then
				bank ?= target
				call_bank(bank, feature_name, arguments)
			elseif target.generating_type.is_equal("BANK_ACCOUNT") then
				bank_account ?= target
				call_bank_account(bank_account, feature_name, arguments)
			elseif target.generating_type.is_equal("STRING_8") then
				string ?= target
				call_string_8 (string, feature_name, arguments)
			else
				report_and_set_type_error(target)
			end
		end

feature {NONE} -- Implementation
	call_bank(bank: BANK; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of BANK
		local
			ignored_result: ANY
			account_for_name_arg1: STRING
			withdraw_arg1: BANK_ACCOUNT
			withdraw_arg2: REAL_REF
			deposit_arg1: BANK_ACCOUNT
			deposit_arg2: REAL_REF
		do
			if feature_name.is_equal ("make") then
				program_flow_sink.leave
				bank.make --no arguments
				program_flow_sink.enter
			elseif feature_name.is_equal ("account_for_name") then
				account_for_name_arg1 ?= arguments @ 1
				program_flow_sink.leave
				ignored_result := bank.account_for_name (account_for_name_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal ("atm") then
				program_flow_sink.leave
				ignored_result := bank.atm
				program_flow_sink.enter
			elseif feature_name.is_equal ("withdraw") then
				withdraw_arg1 ?= arguments @ 1
				withdraw_arg2 ?= arguments @ 2
				program_flow_sink.leave
				bank.withdraw (withdraw_arg1, withdraw_arg2)
				program_flow_sink.enter
			elseif feature_name.is_equal ("deposit") then
				deposit_arg1 ?= arguments @ 1
				deposit_arg2 ?= arguments @ 2
				program_flow_sink.leave
				bank.deposit (deposit_arg1, deposit_arg2)
				program_flow_sink.enter
			else
				report_and_set_feature_error(bank, feature_name)
			end
		end

	call_bank_account(bank_account: BANK_ACCOUNT; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features on BANK_ACCOUNT
		local
			ignored_result: ANY
			make_arg1: STRING
		do
			if feature_name.is_equal("make") then
				make_arg1 ?= arguments @ 1
				program_flow_sink.leave
				bank_account.make (make_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("name") then
				program_flow_sink.leave
				ignored_result := bank_account.name
				program_flow_sink.enter
			elseif feature_name.is_equal ("balance") then
				program_flow_sink.leave
				ignored_result := bank_account.balance
				program_flow_sink.enter
			else
				report_and_set_feature_error(bank_account, feature_name)
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
