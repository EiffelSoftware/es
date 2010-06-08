note
	description: "A simple bank account."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate_export: "BA(x, {bal:b}) = x.<BANK_ACCOUNT.balance> |-> b"
	js_logic: "bank_account.logic"
	js_abstraction: "bank_account.abs"

class
	BANK_ACCOUNT

create
	init

feature

	init (b: INTEGER)
		require
			--SL-- b > 0
		do
			balance := b
		ensure
			--SL-- BA$(Current, {bal:b})
		end

	balance: INTEGER

	deposit (a: INTEGER)
		require
			--SL-- BA$(Current, {bal:_b}) * a > 0
		do
			balance := balance + a
		ensure
			--SL-- BA$(Current, {bal:builtin_plus(_b, a)})
		end

	withdraw (a: INTEGER)
        require
        	--SL-- BA$(Current, {bal:_b}) * a < _b
        do
            balance := balance - a
        ensure
        	--SL-- BA$(Current, {bal:builtin_minus(_b, a)})
        end

end
