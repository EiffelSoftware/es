indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_CALLER

inherit
		CALLER
		
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

	call (target: ANY; feature_name: STRING; arguments: LIST[ANY]) is
		local
			bank: BANK
			bank_account: BANK_ACCOUNT
		do
			-- Discriminate by target type first, to speed things up.
			if target.generating_type.is_equal("BANK") then
				bank ?= target
				call_bank(bank, feature_name, arguments)
			elseif target.generating_type.is_equal("BANK_ACCOUNT") then
				bank_account ?= target
				call_bank_account(bank_account, feature_name, arguments)
			else
				check False end
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	call_bank(bank: BANK; feature_name: STRING; arguments: LIST[ANY]) is
			--
		local
			ignored_result: ANY
			account_for_name_arg1: STRING
			withdraw_arg1: BANK_ACCOUNT
			withdraw_arg2: REAL_REF
			deposit_arg1: BANK_ACCOUNT
			deposit_arg2: REAL_REF
		do
			if feature_name.is_equal ("make") then
				bank.make --no arguments
			elseif feature_name.is_equal ("account_for_name") then
				account_for_name_arg1 ?= arguments @ 1
				ignored_result := bank.account_for_name (account_for_name_arg1)
			elseif feature_name.is_equal ("atm") then
				ignored_result := bank.atm
			elseif feature_name.is_equal ("withdraw") then
				withdraw_arg1 ?= arguments @ 1
				withdraw_arg2 ?= arguments @ 2
				bank.withdraw (withdraw_arg1, withdraw_arg2)
			elseif feature_name.is_equal ("deposit") then
				deposit_arg1 ?= arguments @ 1
				deposit_arg2 ?= arguments @ 2
				bank.deposit (deposit_arg1, deposit_arg2)
			else
				check False end
			end
		end

	call_bank_account(bank_account: BANK_ACCOUNT; feature_name: STRING; arguments: LIST[ANY]) is
		local
			ignored_result: ANY
			make_arg1: STRING
		do
			if feature_name.is_equal("make") then
				make_arg1 ?= arguments @ 1
				bank_account.make (make_arg1)
			elseif feature_name.is_equal("name") then
				ignored_result := bank_account.name
			elseif feature_name.is_equal ("balance") then
				ignored_result := bank_account.balance
			else
				check False end
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
