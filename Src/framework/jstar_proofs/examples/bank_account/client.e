note
	description: "A client which uses the BANK_ACCOUNT class."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "client.logic"
	js_abstraction: "client.abs"

class
	CLIENT

create
	init

feature

	init
		require
			--SL-- True
		local
			ba1, ba2: BANK_ACCOUNT
		do
			-- True
			create ba1.init (50)
			-- BA(ba1, {bal=50})
			create ba2.init (100)
			-- BA(ba1, {bal=50}) * BA(ba2, {bal=100})
			ba1.deposit (200)
			-- BA(ba1, {bal=250}) * BA(ba2, {bal=100})
			ba2.withdraw (50)
			-- BA(ba1, {bal=250}) * BA(ba2, {bal=50})
		ensure
			--SL-- True
		end

end
