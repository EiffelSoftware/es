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
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="make" args="[a_name]"> 
			-- </methodbody_start>
				the_name := a_name
			-- <methodbody_end return_value="False">
			-- </methodbody_end>
		end

feature -- Access

	name: STRING is
			--Name of the account
		do
			-- <methodbody_start name="name" args="[]"> 
			-- </methodbody_start>
				Result := the_name
			-- <methodbody_end return_value="True">
			-- </methodbody_end>
		end

	balance: REAL is
			--Balance of the account
		do
			-- <methodbody_start name="balance" args="[]"> 
			-- </methodbody_start>
				Result := the_balance
			-- <methodbody_end return_value="True">
			-- </methodbody_end>
		end

	is_observed: BOOLEAN is True

feature {BANK} -- Restricted
	withdraw (an_amount: REAL) is
			-- Withdraw 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="withdraw" args="[an_amount]"> 
			-- </methodbody_start>
				the_balance := the_balance - an_amount
			-- <methodbody_end return_value="False">
			-- </methodbody_end>

		ensure
			amount_withdrawn: balance = old balance - an_amount
		end


	deposit (an_amount: REAL) is
			--Deposit 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="deposit" args="[an_amount]"> 
			-- </methodbody_start>
				the_balance := the_balance + an_amount
			-- <methodbody_end return_value="False">
			-- </methodbody_end>
		ensure
			an_amount_deposited: balance = old balance + an_amount
		end

feature {NONE} -- Implementation
	the_balance: REAL

	the_name: STRING
invariant
	a_name_not_void: the_name /= Void
end
