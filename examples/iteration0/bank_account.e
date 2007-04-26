indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT
	
inherit
	OBSERVABLE
		redefine
			is_observed
		end
create
	make

feature -- creation
	make (a_name: STRING)
			--
		require
			a_name_not_void: a_name /= Void
		do
			recorder.capture_methodbody_start ("make", Current, [a_name])
			the_name := a_name
			recorder.capture_methodbody_end (Void)
		end

feature -- Access

	name: STRING is
			--Name of the account
		do
			recorder.capture_methodbody_start ("name", Current, [])
			Result := the_name
			recorder.capture_methodbody_end (Result)
		end

	balance: REAL is
			--Balance of the account
		do
			recorder.capture_methodbody_start ("balance", Current, [])
			Result := the_balance
			recorder.capture_methodbody_end (Result)
		end

	is_observed: BOOLEAN is True

feature {BANK} -- Restricted
	withdraw (an_amount: REAL) is
			-- Withdraw 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		do
			recorder.capture_methodbody_start ("withdraw", Current, [an_amount])
			the_balance := the_balance - an_amount
			recorder.capture_methodbody_end (Void)
		ensure
			amount_withdrawn: balance = old balance - an_amount
		end


	deposit (an_amount: REAL) is
			--Deposit 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		do
			recorder.capture_methodbody_start ("deposit", Current, [an_amount])
			the_balance := the_balance + an_amount
			recorder.capture_methodbody_end (Void)
		ensure
			an_amount_deposited: balance = old balance + an_amount
		end

feature {NONE} -- Implementation
	the_balance: REAL

	the_name: STRING
invariant
	a_name_not_void: the_name /= Void
end
