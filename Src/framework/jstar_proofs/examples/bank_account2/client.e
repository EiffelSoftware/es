note
	description: "A client which uses the BANK_ACCOUNT class."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "client.logic"
	js_abstraction: "client.abs"

class
	CLIENT

feature

	bank_account_fun: INTEGER
		require
			--SL-- True
		local
			ba1, ba2: BANK_ACCOUNT
		do
			create ba1.init (50)
			create ba2.init (100)
			ba1.deposit (200)
			ba2.withdraw (50)
			Result := ba1.balance
		ensure
			--SL-- Result = 250
		end

end























--				-- True
--			create ba1.init (50)
--				-- BA(ba1, {bal=50})
--			create ba2.init (100)
--				-- BA(ba1, {bal=50}) * BA(ba2, {bal=100})
--			ba1.deposit (200)
--				-- BA(ba1, {bal=250}) * BA(ba2, {bal=100})
--			ba2.withdraw (50)
--				-- BA(ba1, {bal=250}) * BA(ba2, {bal=50})
--			Result := ba1.balance
--				-- BA(ba1, {bal=250}) * BA(ba2, {bal=50}) * Result = 250
