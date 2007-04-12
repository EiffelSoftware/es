indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT
inherit
	OBSERVABLE
create
	make

feature -- creation
	make(a_name: STRING)
			--
		do
			the_name:=a_name
		end

feature -- Access

	name:STRING is
			--Name of the account
		do
			the_recorder.capture_methodbody_start ("name", Current, 0)
			Result:= the_name
			the_recorder.capture_methodbody_end (Result)
		end

	balance:REAL is
			--Balance of the account
		do
			the_recorder.capture_methodbody_start ("balance", Current, 0)
			Result:=the_balance
			the_recorder.capture_methodbody_end (Result)
		end

	is_observed: BOOLEAN is
		once
			Result:=True
		end

feature {BANK} -- Restricted
	withdraw(an_amount: REAL) is
			-- withdraw 'an_amount'
		do
			the_recorder.capture_methodbody_start ("withdraw", Current, 1)
			the_balance:= the_balance - an_amount
			the_recorder.capture_methodbody_end (Void)
		end


	deposit(an_amount: REAL) is
			--deposit 'an_amount'
		do
			the_recorder.capture_methodbody_start ("deposit", Current, 1)
			the_balance:= the_balance + an_amount
			the_recorder.capture_methodbody_end (Void)
		end

feature {NONE} -- Implementation
	the_balance: REAL

	the_name: STRING
invariant
	invariant_clause: True -- Your invariant here

end
