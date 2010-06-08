note
	description: "A simple bank account."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "BA(x, {bal=b}) = x.<BANK_ACCOUNT.my_balance> |-> b"
	js_logic: "bank_account.logic"
	js_abstraction: "bank_account.abs"

class
	BANK_ACCOUNT

create
	init

feature {NONE} -- Creation

	init (b: INTEGER)
		require
			--SL-- b > 0
		do
			my_balance := b
		ensure
			--SL-- BA$(Current, {bal=b})
		end

feature -- Access

	balance: INTEGER
		require
			--SL-- BA$(Current, {bal=_b})
		do
			Result := my_balance
		ensure
			--SL-- BA$(Current, {bal=_b}) * Result = _b
		end

feature -- Status setting

	deposit (a: INTEGER)
		require
			--SL-- BA$(Current, {bal=_b}) * a > 0
		do
			my_balance := my_balance + a
		ensure
			--SL-- BA$(Current, {bal=builtin_plus(_b, a)})
		end

	withdraw (a: INTEGER)
        require
        	--SL-- BA$(Current, {bal=_b}) * a < _b
        do
            my_balance := my_balance - a
        ensure
        	--SL-- BA$(Current, {bal=builtin_minus(_b, a)})
        end

feature {NONE} -- Implementation

	my_balance: INTEGER

end
