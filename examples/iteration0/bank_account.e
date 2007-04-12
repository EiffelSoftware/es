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
			name:=a_name
		end


feature -- Access

	get_name:STRING is
			--returns the name of the account
		do
			get_recorder.methodbodystart ("get_name", Current, 1)
			Result:= name
			get_recorder.methodbodyend (Result)
		end

	get_balance:REAL is
			--returns the balance of the account
		do
			get_recorder.methodbodystart ("get_balance", Current, 1)
			Result:=balance
			get_recorder.methodbodyend (Result)
		end

	is_observed: BOOLEAN is
			--
		once
			Result:=True
		end

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

feature -- Obsolete

feature {BANK} -- Restricted
withdraw(an_amount: REAL) is
		-- withdraw 'an_amount' from the account
	do
		get_recorder.methodbodystart ("withdraw", Current, 2)
		balance:= balance - an_amount
		get_recorder.methodbodyend (Void)
	end


deposit(an_amount: REAL) is
		--deposit an_amount to the account
	do
		get_recorder.methodbodystart ("deposit", Current, 2)
		balance:= balance + an_amount
		get_recorder.methodbodyend (Void)
	end

feature {NONE} -- Implementation
	balance: REAL

	name: STRING
invariant
	invariant_clause: True -- Your invariant here

end
